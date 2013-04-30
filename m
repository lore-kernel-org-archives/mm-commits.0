From: akpm@linux-foundation.org
Subject: [merged] fs-fix-fsync-error-reporting.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:49:54 -0700
Message-ID: <20130430184954.7D0F431C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:44812 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247Ab3D3Stz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:49:55 -0400
Received: by mail-qe0-f73.google.com with SMTP id 9so85522qea.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:49:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmonakhov@openvz.org, jack@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: fix fsync() error reporting
has been removed from the -mm tree.  Its filename was
     fs-fix-fsync-error-reporting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: fs: fix fsync() error reporting

There are two convenient ways to report errors to userspace

1) retun error to original syscall for example write(2)
2) mark mapping with error flag and return it on later fsync(2)

Second one is broken if (mapping->nrpages == 0) This is real-life
situation because after error pages are likey to be truncated or
invalidated.

We have to return an error regardless to number of pages in the mapping.

#Original testcase: git@github.com:dmonakhov/xfstests.git
MOUNT_OPTIONS="-b1024"
./check shared/305

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff -puN mm/filemap.c~fs-fix-fsync-error-reporting mm/filemap.c
--- a/mm/filemap.c~fs-fix-fsync-error-reporting
+++ a/mm/filemap.c
@@ -188,6 +188,17 @@ static int sleep_on_page_killable(void *
 	return fatal_signal_pending(current) ? -EINTR : 0;
 }
 
+static int filemap_check_errors(struct address_space *mapping)
+{
+	int ret = 0;
+	/* Check for outstanding write errors */
+	if (test_and_clear_bit(AS_ENOSPC, &mapping->flags))
+		ret = -ENOSPC;
+	if (test_and_clear_bit(AS_EIO, &mapping->flags))
+		ret = -EIO;
+	return ret;
+}
+
 /**
  * __filemap_fdatawrite_range - start writeback on mapping dirty pages in range
  * @mapping:	address space structure to write
@@ -269,10 +280,10 @@ int filemap_fdatawait_range(struct addre
 	pgoff_t end = end_byte >> PAGE_CACHE_SHIFT;
 	struct pagevec pvec;
 	int nr_pages;
-	int ret = 0;
+	int ret2, ret = 0;
 
 	if (end_byte < start_byte)
-		return 0;
+		goto out;
 
 	pagevec_init(&pvec, 0);
 	while ((index <= end) &&
@@ -295,12 +306,10 @@ int filemap_fdatawait_range(struct addre
 		pagevec_release(&pvec);
 		cond_resched();
 	}
-
-	/* Check for outstanding write errors */
-	if (test_and_clear_bit(AS_ENOSPC, &mapping->flags))
-		ret = -ENOSPC;
-	if (test_and_clear_bit(AS_EIO, &mapping->flags))
-		ret = -EIO;
+out:
+	ret2 = filemap_check_errors(mapping);
+	if (!ret)
+		ret = ret2;
 
 	return ret;
 }
@@ -341,6 +350,8 @@ int filemap_write_and_wait(struct addres
 			if (!err)
 				err = err2;
 		}
+	} else {
+		err = filemap_check_errors(mapping);
 	}
 	return err;
 }
@@ -372,6 +383,8 @@ int filemap_write_and_wait_range(struct
 			if (!err)
 				err = err2;
 		}
+	} else {
+		err = filemap_check_errors(mapping);
 	}
 	return err;
 }
_

Patches currently in -mm which might be from dmonakhov@openvz.org are

origin.patch
linux-next.patch
kernel-relayc-move-remove_buf_file-inside-relay_close_buf.patch


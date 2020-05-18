From: Andrew Morton <akpm@linux-foundation.org>
Subject: + orangefs-use-attach-detach_page_private.patch added to
 -mm tree
Date: Mon, 18 May 2020 14:46:26 -0700
Message-ID: <20200518214626.XchxBJom_%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727819AbgERVq1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 May 2020 17:46:27 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guoqing.jiang@cloud.ionos.com, hubcap@omnibond.com, martin@omnibond.com, mm-commits@vger.kernel.org


The patch titled
     Subject: orangefs: use attach/detach_page_private
has been added to the -mm tree.  Its filename is
     orangefs-use-attach-detach_page_private.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/orangefs-use-attach-detach_page_private.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/orangefs-use-attach-detach_page_private.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: orangefs: use attach/detach_page_private

Since the new pair function is introduced, we can call them to clean the
code in orangefs.

Link: http://lkml.kernel.org/r/20200517214718.468-9-guoqing.jiang@cloud.ionos.com
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc: Mike Marshall <hubcap@omnibond.com>
Cc: Martin Brandenburg <martin@omnibond.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/orangefs/inode.c |   32 ++++++--------------------------
 1 file changed, 6 insertions(+), 26 deletions(-)

--- a/fs/orangefs/inode.c~orangefs-use-attach-detach_page_private
+++ a/fs/orangefs/inode.c
@@ -62,12 +62,7 @@ static int orangefs_writepage_locked(str
 	} else {
 		ret = 0;
 	}
-	if (wr) {
-		kfree(wr);
-		set_page_private(page, 0);
-		ClearPagePrivate(page);
-		put_page(page);
-	}
+	kfree(detach_page_private(page));
 	return ret;
 }
 
@@ -409,9 +404,7 @@ static int orangefs_write_begin(struct f
 	wr->len = len;
 	wr->uid = current_fsuid();
 	wr->gid = current_fsgid();
-	SetPagePrivate(page);
-	set_page_private(page, (unsigned long)wr);
-	get_page(page);
+	attach_page_private(page, wr);
 okay:
 	return 0;
 }
@@ -459,18 +452,12 @@ static void orangefs_invalidatepage(stru
 	wr = (struct orangefs_write_range *)page_private(page);
 
 	if (offset == 0 && length == PAGE_SIZE) {
-		kfree((struct orangefs_write_range *)page_private(page));
-		set_page_private(page, 0);
-		ClearPagePrivate(page);
-		put_page(page);
+		kfree(detach_page_private(page));
 		return;
 	/* write range entirely within invalidate range (or equal) */
 	} else if (page_offset(page) + offset <= wr->pos &&
 	    wr->pos + wr->len <= page_offset(page) + offset + length) {
-		kfree((struct orangefs_write_range *)page_private(page));
-		set_page_private(page, 0);
-		ClearPagePrivate(page);
-		put_page(page);
+		kfree(detach_page_private(page));
 		/* XXX is this right? only caller in fs */
 		cancel_dirty_page(page);
 		return;
@@ -535,12 +522,7 @@ static int orangefs_releasepage(struct p
 
 static void orangefs_freepage(struct page *page)
 {
-	if (PagePrivate(page)) {
-		kfree((struct orangefs_write_range *)page_private(page));
-		set_page_private(page, 0);
-		ClearPagePrivate(page);
-		put_page(page);
-	}
+	kfree(detach_page_private(page));
 }
 
 static int orangefs_launder_page(struct page *page)
@@ -740,9 +722,7 @@ vm_fault_t orangefs_page_mkwrite(struct
 	wr->len = PAGE_SIZE;
 	wr->uid = current_fsuid();
 	wr->gid = current_fsgid();
-	SetPagePrivate(page);
-	set_page_private(page, (unsigned long)wr);
-	get_page(page);
+	attach_page_private(page, wr);
 okay:
 
 	file_update_time(vmf->vma->vm_file);
_

Patches currently in -mm which might be from guoqing.jiang@cloud.ionos.com are

include-linux-pagemaph-introduce-attach-detach_page_private.patch
md-remove-__clear_page_buffers-and-use-attach-detach_page_private.patch
btrfs-use-attach-detach_page_private.patch
fs-bufferc-use-attach-detach_page_private.patch
f2fs-use-attach-detach_page_private.patch
iomap-use-attach-detach_page_private.patch
ntfs-replace-attach_page_buffers-with-attach_page_private.patch
orangefs-use-attach-detach_page_private.patch
buffer_headh-remove-attach_page_buffers.patch
mm-migratec-call-detach_page_private-to-cleanup-code.patch

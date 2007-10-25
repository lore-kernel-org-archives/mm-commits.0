From: akpm@linux-foundation.org
Subject: + fuse-fuse_file_alloc-fix-null-dereferences.patch added to -mm tree
Date: Wed, 24 Oct 2007 20:22:20 -0700
Message-ID: <200710250322.l9P3MKA1029289@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56115 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755510AbXJYDXK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 23:23:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, mszeredi@suse.cz


The patch titled
     fuse: fuse_file_alloc(): fix NULL dereferences
has been added to the -mm tree.  Its filename is
     fuse-fuse_file_alloc-fix-null-dereferences.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fuse: fuse_file_alloc(): fix NULL dereferences
From: Adrian Bunk <bunk@kernel.org>

This patch fixes obvious NULL dereferences spotted by the Coverity
checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/file.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/fuse/file.c~fuse-fuse_file_alloc-fix-null-dereferences fs/fuse/file.c
--- a/fs/fuse/file.c~fuse-fuse_file_alloc-fix-null-dereferences
+++ a/fs/fuse/file.c
@@ -55,9 +55,10 @@ struct fuse_file *fuse_file_alloc(void)
 		if (!ff->reserved_req) {
 			kfree(ff);
 			ff = NULL;
+		} else {
+			INIT_LIST_HEAD(&ff->write_entry);
+			atomic_set(&ff->count, 0);
 		}
-		INIT_LIST_HEAD(&ff->write_entry);
-		atomic_set(&ff->count, 0);
 	}
 	return ff;
 }
_

Patches currently in -mm which might be from bunk@kernel.org are

ipmi-fix-comparison-in-demangle_device_id.patch
git-dvb.patch
git-hwmon.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-sh64.patch
fuse-fuse_file_alloc-fix-null-dereferences.patch
ext4-return-after-ext4_error-in-case-of-failures.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
reiser4.patch

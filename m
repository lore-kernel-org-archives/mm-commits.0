From: akpm@linux-foundation.org
Subject: + use-page_cache_xxx-in-fs-libfsc.patch added to -mm tree
Date: Mon, 18 Feb 2008 02:09:18 -0800
Message-ID: <200802181010.m1IAAGJ1019415@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38073 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753566AbYBRKKt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 05:10:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, dgc@sgi.com


The patch titled
     Use page_cache_xxx in fs/libfs.c
has been added to the -mm tree.  Its filename is
     use-page_cache_xxx-in-fs-libfsc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Use page_cache_xxx in fs/libfs.c
From: Christoph Lameter <clameter@sgi.com>

Use page_cache_xxx in fs/libfs.c

Reviewed-by: Dave Chinner <dgc@sgi.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/libfs.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN fs/libfs.c~use-page_cache_xxx-in-fs-libfsc fs/libfs.c
--- a/fs/libfs.c~use-page_cache_xxx-in-fs-libfsc
+++ a/fs/libfs.c
@@ -17,7 +17,8 @@ int simple_getattr(struct vfsmount *mnt,
 {
 	struct inode *inode = dentry->d_inode;
 	generic_fillattr(inode, stat);
-	stat->blocks = inode->i_mapping->nrpages << (PAGE_CACHE_SHIFT - 9);
+	stat->blocks = inode->i_mapping->nrpages <<
+				(page_cache_shift(inode->i_mapping) - 9);
 	return 0;
 }
 
@@ -341,10 +342,10 @@ int simple_prepare_write(struct file *fi
 			unsigned from, unsigned to)
 {
 	if (!PageUptodate(page)) {
-		if (to - from != PAGE_CACHE_SIZE)
+		if (to - from != page_cache_size(file->f_mapping))
 			zero_user_segments(page,
 				0, from,
-				to, PAGE_CACHE_SIZE);
+				to, page_cache_size(file->f_mapping));
 	}
 	return 0;
 }
@@ -372,8 +373,9 @@ int simple_write_begin(struct file *file
 static int simple_commit_write(struct file *file, struct page *page,
 			       unsigned from, unsigned to)
 {
-	struct inode *inode = page->mapping->host;
-	loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
+	struct address_space *mapping = page->mapping;
+	struct inode *inode = mapping->host;
+	loff_t pos = page_cache_pos(mapping, page->index, to);
 
 	if (!PageUptodate(page))
 		SetPageUptodate(page);
_

Patches currently in -mm which might be from clameter@sgi.com are

define-functions-for-page-cache-handling.patch
gregkh-driver-kset-move-sys-slab-to-sys-kernel-slab-slabinfo-fallback-from-sys-kernel-slab-to-sys-slab.patch
use-page_cache_xxx-in-fs-splicec.patch
git-unionfs.patch
use-page_cache_xxx-for-fs-xfs.patch
git-slub.patch
x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
remove-set_migrateflags.patch
use-page_cache_xxx-functions-in-mm-filemapc.patch
use-page_cache_xxx-in-mm-page-writebackc.patch
use-page_cache_xxx-in-mm-truncatec.patch
use-page_cache_xxx-in-mm-rmapc.patch
use-page_cache_xxx-in-mm-filemap_xipc.patch
use-page_cache_xxx-in-mm-migratec.patch
use-page_cache_xxx-in-fs-libfsc.patch
use-page_cache_xxx-in-fs-sync.patch
use-page_cache_xxx-in-fs-bufferc.patch
use-page_cache_xxx-in-mm-mpagec.patch
use-page_cache_xxx-in-mm-fadvisec.patch
use-page_cache_xxx-in-ext2.patch
use-page_cache_xxx-in-fs-ext3.patch
use-page_cache_xxx-in-fs-reiserfs.patch
use-page_cache_xxx-in-fs-ext4.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch

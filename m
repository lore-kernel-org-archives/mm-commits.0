From: akpm@linux-foundation.org
Subject: + ext4-add-ext4_get_block_dax.patch added to -mm tree
Date: Tue, 04 Aug 2015 14:34:31 -0700
Message-ID: <55c12fe7.N+8JOJAvPzR7FBQJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56623 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873AbbHDVec (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2015 17:34:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: ext4: add ext4_get_block_dax()
has been added to the -mm tree.  Its filename is
     ext4-add-ext4_get_block_dax.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ext4-add-ext4_get_block_dax.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ext4-add-ext4_get_block_dax.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: ext4: add ext4_get_block_dax()

DAX wants different semantics from any currently-existing ext4 get_block
callback.  Unlike ext4_get_block_write(), it needs to honour the 'create'
flag, and unlike ext4_get_block(), it needs to be able to return unwritten
extents.  So introduce a new ext4_get_block_dax() which has those
semantics.  We could also change ext4_get_block_write() to honour the
'create' flag, but that might have consequences on other users that I do
not currently understand.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/ext4.h  |    2 ++
 fs/ext4/file.c  |    6 +++---
 fs/ext4/inode.c |   11 +++++++++++
 3 files changed, 16 insertions(+), 3 deletions(-)

diff -puN fs/ext4/ext4.h~ext4-add-ext4_get_block_dax fs/ext4/ext4.h
--- a/fs/ext4/ext4.h~ext4-add-ext4_get_block_dax
+++ a/fs/ext4/ext4.h
@@ -2272,6 +2272,8 @@ struct buffer_head *ext4_getblk(handle_t
 struct buffer_head *ext4_bread(handle_t *, struct inode *, ext4_lblk_t, int);
 int ext4_get_block_write(struct inode *inode, sector_t iblock,
 			 struct buffer_head *bh_result, int create);
+int ext4_get_block_dax(struct inode *inode, sector_t iblock,
+			 struct buffer_head *bh_result, int create);
 int ext4_get_block(struct inode *inode, sector_t iblock,
 				struct buffer_head *bh_result, int create);
 int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
diff -puN fs/ext4/file.c~ext4-add-ext4_get_block_dax fs/ext4/file.c
--- a/fs/ext4/file.c~ext4-add-ext4_get_block_dax
+++ a/fs/ext4/file.c
@@ -207,19 +207,19 @@ static void ext4_end_io_unwritten(struct
 
 static int ext4_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	return dax_fault(vma, vmf, ext4_get_block_write, ext4_end_io_unwritten);
+	return dax_fault(vma, vmf, ext4_get_block_dax, ext4_end_io_unwritten);
 }
 
 static int ext4_dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
 						pmd_t *pmd, unsigned int flags)
 {
-	return dax_pmd_fault(vma, addr, pmd, flags, ext4_get_block_write,
+	return dax_pmd_fault(vma, addr, pmd, flags, ext4_get_block_dax,
 				ext4_end_io_unwritten);
 }
 
 static int ext4_dax_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	return dax_mkwrite(vma, vmf, ext4_get_block_write,
+	return dax_mkwrite(vma, vmf, ext4_get_block_dax,
 				ext4_end_io_unwritten);
 }
 
diff -puN fs/ext4/inode.c~ext4-add-ext4_get_block_dax fs/ext4/inode.c
--- a/fs/ext4/inode.c~ext4-add-ext4_get_block_dax
+++ a/fs/ext4/inode.c
@@ -3021,6 +3021,17 @@ static int ext4_get_block_write_nolock(s
 			       EXT4_GET_BLOCKS_NO_LOCK);
 }
 
+int ext4_get_block_dax(struct inode *inode, sector_t iblock,
+		   struct buffer_head *bh_result, int create)
+{
+	int flags = EXT4_GET_BLOCKS_PRE_IO | EXT4_GET_BLOCKS_UNWRIT_EXT;
+	if (create)
+		flags |= EXT4_GET_BLOCKS_CREATE;
+	ext4_debug("ext4_get_block_dax: inode %lu, create flag %d\n",
+		   inode->i_ino, create);
+	return _ext4_get_block(inode, iblock, bh_result, flags);
+}
+
 static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
 			    ssize_t size, void *private)
 {
_

Patches currently in -mm which might be from willy@linux.intel.com are

mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch
dax-move-dax-related-functions-to-a-new-header.patch
dax-revert-userfaultfd-change.patch
thp-prepare-for-dax-huge-pages.patch
thp-prepare-for-dax-huge-pages-fix.patch
mm-add-a-pmd_fault-handler.patch
mm-export-various-functions-for-the-benefit-of-dax.patch
mm-add-vmf_insert_pfn_pmd.patch
dax-add-huge-page-fault-support.patch
ext2-huge-page-fault-support.patch
ext4-huge-page-fault-support.patch
xfs-huge-page-fault-support.patch
ext4-use-ext4_get_block_write-for-dax.patch
thp-change-insert_pfns-return-type-to-void.patch
dax-improve-comment-about-truncate-race.patch
ext4-add-ext4_get_block_dax.patch
ext4-start-transaction-before-calling-into-dax.patch
dax-fix-race-between-simultaneous-faults.patch
thp-decrement-refcount-on-huge-zero-page-if-it-is-split.patch
thp-fix-zap_huge_pmd-for-dax.patch
dax-dont-use-set_huge_zero_page.patch
dax-ensure-that-zero-pages-are-removed-from-other-processes.patch
dax-use-linear_page_index.patch


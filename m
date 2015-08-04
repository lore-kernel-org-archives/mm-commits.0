From: akpm@linux-foundation.org
Subject: + ext4-use-ext4_get_block_write-for-dax.patch added to -mm tree
Date: Tue, 04 Aug 2015 14:34:25 -0700
Message-ID: <55c12fe1.yPriQkybzLP/UA1t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56613 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbbHDVe0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2015 17:34:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, andy.rudoff@intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: ext4: use ext4_get_block_write() for DAX
has been added to the -mm tree.  Its filename is
     ext4-use-ext4_get_block_write-for-dax.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ext4-use-ext4_get_block_write-for-dax.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ext4-use-ext4_get_block_write-for-dax.patch

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
Subject: ext4: use ext4_get_block_write() for DAX

DAX relies on the get_block function either zeroing newly allocated blocks
before they're findable by subsequent calls to get_block, or marking newly
allocated blocks as unwritten.  ext4_get_block() cannot create unwritten
extents, but ext4_get_block_write() can.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Reported-by: Andy Rudoff <andy.rudoff@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/file.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/ext4/file.c~ext4-use-ext4_get_block_write-for-dax fs/ext4/file.c
--- a/fs/ext4/file.c~ext4-use-ext4_get_block_write-for-dax
+++ a/fs/ext4/file.c
@@ -196,7 +196,7 @@ out:
 static void ext4_end_io_unwritten(struct buffer_head *bh, int uptodate)
 {
 	struct inode *inode = bh->b_assoc_map->host;
-	/* XXX: breaks on 32-bit > 16GB. Is that even supported? */
+	/* XXX: breaks on 32-bit > 16TB. Is that even supported? */
 	loff_t offset = (loff_t)(uintptr_t)bh->b_private << inode->i_blkbits;
 	int err;
 	if (!uptodate)
@@ -207,8 +207,7 @@ static void ext4_end_io_unwritten(struct
 
 static int ext4_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	return dax_fault(vma, vmf, ext4_get_block, ext4_end_io_unwritten);
-					/* Is this the right get_block? */
+	return dax_fault(vma, vmf, ext4_get_block_write, ext4_end_io_unwritten);
 }
 
 static int ext4_dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
@@ -220,7 +219,8 @@ static int ext4_dax_pmd_fault(struct vm_
 
 static int ext4_dax_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	return dax_mkwrite(vma, vmf, ext4_get_block, ext4_end_io_unwritten);
+	return dax_mkwrite(vma, vmf, ext4_get_block_write,
+				ext4_end_io_unwritten);
 }
 
 static const struct vm_operations_struct ext4_dax_vm_ops = {
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


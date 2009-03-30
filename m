From: akpm@linux-foundation.org
Subject: + nilfs2-segment-constructor-insert-checks-and-hole-block-allocation-in-page_mkwrite-follow-page_mkwrite-prototype-change-for-matching-fault.patch added to -mm tree
Date: Mon, 30 Mar 2009 15:59:11 -0700
Message-ID: <200903302259.n2UMxBkW015556@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32887 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754269AbZC3XBe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 19:01:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konishi.ryusuke@lab.ntt.co.jp, npiggin@suse.de


The patch titled
     nilfs2: follow page_mkwrite prototype change for matching fault
has been added to the -mm tree.  Its filename is
     nilfs2-segment-constructor-insert-checks-and-hole-block-allocation-in-page_mkwrite-follow-page_mkwrite-prototype-change-for-matching-fault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2: follow page_mkwrite prototype change for matching fault
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

This follows the change of page_mkwrite prototype brought by the patch
("mm: page_mkwrite change prototype to match fault") and fixes the
following compilation errors:

  CC      fs/nilfs2/inode.o
  CC      fs/nilfs2/file.o
fs/nilfs2/file.c: In function 'nilfs_page_mkwrite':
fs/nilfs2/file.c:105: warning: passing argument 2 of 'block_page_mkwrite' from incompatible pointer type
fs/nilfs2/file.c: At top level:
fs/nilfs2/file.c:120: warning: initialization from incompatible pointer type

A few detail error codes are rounded to VM_FAULT_SIGBUS to follow the
change.  A subsequent fix is required to improve them as shown in the
additional patch ("fs: fix page_mkwrite error cases in core code and
btrfs").

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/file.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN fs/nilfs2/file.c~nilfs2-segment-constructor-insert-checks-and-hole-block-allocation-in-page_mkwrite-follow-page_mkwrite-prototype-change-for-matching-fault fs/nilfs2/file.c
--- a/fs/nilfs2/file.c~nilfs2-segment-constructor-insert-checks-and-hole-block-allocation-in-page_mkwrite-follow-page_mkwrite-prototype-change-for-matching-fault
+++ a/fs/nilfs2/file.c
@@ -73,20 +73,21 @@ nilfs_file_aio_write(struct kiocb *iocb,
 	return ret;
 }
 
-static int nilfs_page_mkwrite(struct vm_area_struct *vma, struct page *page)
+static int nilfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
+	struct page *page = vmf->page;
 	struct inode *inode = vma->vm_file->f_dentry->d_inode;
 	struct nilfs_transaction_info ti;
 	int ret;
 
 	if (unlikely(nilfs_near_disk_full(NILFS_SB(inode->i_sb)->s_nilfs)))
-		return -ENOSPC;
+		return VM_FAULT_SIGBUS; /* -ENOSPC */
 
 	lock_page(page);
 	if (page->mapping != inode->i_mapping ||
 	    page_offset(page) >= i_size_read(inode) || !PageUptodate(page)) {
 		unlock_page(page);
-		return -EINVAL;
+		return VM_FAULT_SIGBUS; /* -EINVAL */
 	}
 
 	/*
@@ -120,10 +121,11 @@ static int nilfs_page_mkwrite(struct vm_
 	 * fill hole blocks
 	 */
 	ret = nilfs_transaction_begin(inode->i_sb, &ti, 1);
+	/* never returns -ENOMEM, but may return -ENOSPC */
 	if (unlikely(ret))
-		return ret;
+		return VM_FAULT_SIGBUS;
 
-	ret = block_page_mkwrite(vma, page, nilfs_get_block);
+	ret = block_page_mkwrite(vma, vmf, nilfs_get_block);
 	if (unlikely(ret)) {
 		nilfs_transaction_abort(inode->i_sb);
 		return ret;
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-add-document.patch
nilfs2-disk-format-and-userland-interface.patch
nilfs2-add-inode-and-other-major-structures.patch
nilfs2-integrated-block-mapping.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-b-tree-based-block-mapping.patch
nilfs2-direct-block-mapping.patch
nilfs2-b-tree-node-cache.patch
nilfs2-buffer-and-page-operations.patch
nilfs2-meta-data-file.patch
nilfs2-persistent-object-allocator.patch
nilfs2-disk-address-translator.patch
nilfs2-inode-map-file.patch
nilfs2-checkpoint-file.patch
nilfs2-segment-usage-file.patch
nilfs2-segment-usage-file-fix-wrong-counting-of-checkpoints-and-dirty-segments.patch
nilfs2-inode-operations.patch
nilfs2-inode-operations-fix.patch
nilfs2-file-operations.patch
nilfs2-directory-entry-operations.patch
nilfs2-pathname-operations.patch
nilfs2-pathname-operations-fix.patch
nilfs2-operations-for-the_nilfs-core-object.patch
nilfs2-super-block-operations.patch
nilfs2-super-block-operations-fix.patch
nilfs2-segment-buffer.patch
nilfs2-segment-buffer-fix.patch
nilfs2-segment-constructor.patch
nilfs2-segment-constructor-insert-checks-and-hole-block-allocation-in-page_mkwrite.patch
nilfs2-segment-constructor-insert-checks-and-hole-block-allocation-in-page_mkwrite-follow-page_mkwrite-prototype-change-for-matching-fault.patch
nilfs2-fix-miss-sync-issue-for-do_sync_mapping_range.patch
nilfs2-fix-miss-sync-issue-for-do_sync_mapping_range-fix.patch
nilfs2-recovery-functions.patch
nilfs2-another-dat-for-garbage-collection.patch
nilfs2-block-cache-for-garbage-collection.patch
nilfs2-ioctl-operations.patch
nilfs2-update-makefile-and-kconfig.patch
nilfs2-fix-problems-of-memory-allocation-in-ioctl.patch
nilfs2-cleanup-nilfs_clear_inode.patch
nilfs2-avoid-double-error-caused-by-nilfs_transaction_end.patch
nilfs2-insert-explanations-in-gcinode-file.patch
nilfs2-add-maintainer.patch
nilfs2-fix-gc-failure-on-volumes-keeping-numerous-snapshots.patch
nilfs2-clean-up-indirect-function-calling-conventions.patch
nilfs2-fix-buggy-behavior-seen-in-enumerating-checkpoints.patch
nilfs2-remove-timedwait-ioctl-command.patch
nilfs2-use-fixed-sized-types-for-ioctl-structures.patch
nilfs2-remove-compat-ioctl-code.patch
nilfs2-use-unlocked_ioctl.patch
nilfs2-extend-nilfs_sustat-ioctl-struct.patch
nilfs2-replace-bug_on-and-bug-calls-triggerable-from-ioctl.patch
nilfs2-super-block-operations-fix-endian-bug.patch
nilfs2-clean-up-sketch-file.patch
nilfs2-mark-minor-flag-for-checkpoint-created-by-internal-operation.patch
nilfs2-simplify-handling-of-active-state-of-segments.patch
nilfs2-introduce-secondary-super-block.patch
nilfs2-introduce-secondary-super-block-fix.patch
nilfs2-support-nanosecond-timestamp.patch
nilfs2-fix-page_mkwrite-error-cases.patch
nilfs2-fix-improper-return-values-of-nilfs_get_cpinfo-ioctl.patch


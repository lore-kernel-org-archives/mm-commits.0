From: akpm@linux-foundation.org
Subject: [folded] nilfs2-segment-constructor-insert-checks-and-hole-block-allocation-in-page_mkwrite-follow-page_mkwrite-prototype-change-for-matching-fault-fix-page_mkwrite-error-cases.patch removed from -mm tree
Date: Mon, 06 Apr 2009 15:36:27 -0700
Message-ID: <200904062236.n36MaRcX018520@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54617 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756451AbZDFWin (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 18:38:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     nilfs2: fix page_mkwrite error cases
has been removed from the -mm tree.  Its filename was
     nilfs2-segment-constructor-insert-checks-and-hole-block-allocation-in-page_mkwrite-follow-page_mkwrite-prototype-change-for-matching-fault-fix-page_mkwrite-error-cases.patch

This patch was dropped because it was folded into nilfs2-segment-constructor.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2: fix page_mkwrite error cases
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

will follow the correction shown by ("fs: fix page_mkwrite error cases
in core code and btrfs") patch to return sane error values.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nilfs2/file.c~nilfs2-segment-constructor-insert-checks-and-hole-block-allocation-in-page_mkwrite-follow-page_mkwrite-prototype-change-for-matching-fault-fix-page_mkwrite-error-cases fs/nilfs2/file.c
--- a/fs/nilfs2/file.c~nilfs2-segment-constructor-insert-checks-and-hole-block-allocation-in-page_mkwrite-follow-page_mkwrite-prototype-change-for-matching-fault-fix-page_mkwrite-error-cases
+++ a/fs/nilfs2/file.c
@@ -87,7 +87,7 @@ static int nilfs_page_mkwrite(struct vm_
 	if (page->mapping != inode->i_mapping ||
 	    page_offset(page) >= i_size_read(inode) || !PageUptodate(page)) {
 		unlock_page(page);
-		return VM_FAULT_SIGBUS; /* -EINVAL */
+		return VM_FAULT_NOPAGE; /* make the VM retry the fault */
 	}
 
 	/*
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-add-document.patch
nilfs2-disk-format-and-userland-interface.patch
nilfs2-add-inode-and-other-major-structures.patch
nilfs2-integrated-block-mapping.patch
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
nilfs2-inode-operations.patch
nilfs2-file-operations.patch
nilfs2-directory-entry-operations.patch
nilfs2-pathname-operations.patch
nilfs2-operations-for-the_nilfs-core-object.patch
nilfs2-super-block-operations.patch
nilfs2-segment-buffer.patch
nilfs2-segment-constructor.patch
nilfs2-segment-constructor-insert-checks-and-hole-block-allocation-in-page_mkwrite-follow-page_mkwrite-prototype-change-for-matching-fault-fix-page_mkwrite-error-cases.patch
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
nilfs2-fix-improper-return-values-of-nilfs_get_cpinfo-ioctl.patch
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


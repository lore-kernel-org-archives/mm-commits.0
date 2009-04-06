From: akpm@linux-foundation.org
Subject: [folded] nilfs2-segment-usage-file-fix-wrong-counting-of-checkpoints-and-dirty-segments.patch removed from -mm tree
Date: Mon, 06 Apr 2009 15:33:23 -0700
Message-ID: <200904062233.n36MXNRK017271@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40542 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756151AbZDFWfs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 18:35:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, sato.koji@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     nilfs2: fix wrong counting of checkpoints and dirty segments
has been removed from the -mm tree.  Its filename was
     nilfs2-segment-usage-file-fix-wrong-counting-of-checkpoints-and-dirty-segments.patch

This patch was dropped because it was folded into nilfs2-segment-usage-file.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2: fix wrong counting of checkpoints and dirty segments
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Reinoud Zandijk found that counters for the number of checkpoints and
the number of dirty segments go wrong after a garbage collection.

This problem turns out to be a bug of counter operations using
le64_cpu_add() with a negative variable like:

  le64_cpu_add(&counter, -n);

where the variable n was not u64.

This fixes the problem by casting the delta to (u64).

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Koji Sato <sato.koji@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/cpfile.c |    2 +-
 fs/nilfs2/sufile.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/nilfs2/cpfile.c~nilfs2-segment-usage-file-fix-wrong-counting-of-checkpoints-and-dirty-segments fs/nilfs2/cpfile.c
--- a/fs/nilfs2/cpfile.c~nilfs2-segment-usage-file-fix-wrong-counting-of-checkpoints-and-dirty-segments
+++ a/fs/nilfs2/cpfile.c
@@ -357,7 +357,7 @@ int nilfs_cpfile_delete_checkpoints(stru
 		kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
 		header = nilfs_cpfile_block_get_header(cpfile, header_bh,
 						       kaddr);
-		le64_add_cpu(&header->ch_ncheckpoints, -tnicps);
+		le64_add_cpu(&header->ch_ncheckpoints, -(u64)tnicps);
 		nilfs_mdt_mark_buffer_dirty(header_bh);
 		nilfs_mdt_mark_dirty(cpfile);
 		kunmap_atomic(kaddr, KM_USER0);
diff -puN fs/nilfs2/sufile.c~nilfs2-segment-usage-file-fix-wrong-counting-of-checkpoints-and-dirty-segments fs/nilfs2/sufile.c
--- a/fs/nilfs2/sufile.c~nilfs2-segment-usage-file-fix-wrong-counting-of-checkpoints-and-dirty-segments
+++ a/fs/nilfs2/sufile.c
@@ -325,7 +325,7 @@ int nilfs_sufile_freev(struct inode *suf
 	kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
 	header = nilfs_sufile_block_get_header(sufile, header_bh, kaddr);
 	le64_add_cpu(&header->sh_ncleansegs, nsegs);
-	le64_add_cpu(&header->sh_ndirtysegs, -nsegs);
+	le64_add_cpu(&header->sh_ndirtysegs, -(u64)nsegs);
 	kunmap_atomic(kaddr, KM_USER0);
 	nilfs_mdt_mark_buffer_dirty(header_bh);
 	nilfs_mdt_mark_dirty(sufile);
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


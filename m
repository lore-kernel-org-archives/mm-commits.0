From: akpm@linux-foundation.org
Subject: + nilfs2-super-block-operations-fix-endian-bug.patch added to -mm tree
Date: Thu, 05 Mar 2009 14:34:18 -0800
Message-ID: <200903052234.n25MYIiQ009170@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753484AbZCEWew (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Mar 2009 17:34:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konishi.ryusuke@lab.ntt.co.jp


The patch titled
     nilfs2: super block operations fix endian bug
has been added to the -mm tree.  Its filename is
     nilfs2-super-block-operations-fix-endian-bug.patch

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
Subject: nilfs2: super block operations fix endian bug
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

This adds a missing endian conversion of checksum field in the super
block.  This fixes compatibility issue on big endian machines which will
come to surface after supporting recovery of super block.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/super.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/nilfs2/super.c~nilfs2-super-block-operations-fix-endian-bug fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~nilfs2-super-block-operations-fix-endian-bug
+++ a/fs/nilfs2/super.c
@@ -287,9 +287,9 @@ int nilfs_commit_super(struct nilfs_sb_i
 	sbp->s_free_blocks_count = cpu_to_le64(nfreeblocks);
 	sbp->s_wtime = cpu_to_le64(get_seconds());
 	sbp->s_sum = 0;
-	sbp->s_sum = crc32_le(nilfs->ns_crc_seed, (unsigned char *)sbp,
-			      le16_to_cpu(sbp->s_bytes));
-
+	sbp->s_sum = cpu_to_le32(crc32_le(nilfs->ns_crc_seed,
+					  (unsigned char *)sbp,
+					  le16_to_cpu(sbp->s_bytes)));
 	sbi->s_super->s_dirt = 0;
 	return nilfs_sync_super(sbi);
 }
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


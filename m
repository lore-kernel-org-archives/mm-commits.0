From: akpm@linux-foundation.org
Subject: + nilfs2-mark-minor-flag-for-checkpoint-created-by-internal-operation.patch added to -mm tree
Date: Thu, 05 Mar 2009 14:34:22 -0800
Message-ID: <200903052234.n25MYNqF009185@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55003 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753708AbZCEWe5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Mar 2009 17:34:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konishi.ryusuke@lab.ntt.co.jp


The patch titled
     nilfs2: mark minor flag for checkpoint created by internal operation
has been added to the -mm tree.  Its filename is
     nilfs2-mark-minor-flag-for-checkpoint-created-by-internal-operation.patch

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
Subject: nilfs2: mark minor flag for checkpoint created by internal operation
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Nilfs creates checkpoints even for garbage collection or metadata updates
such as checkpoint mode change.  So, user often sees checkpoints created
only by such internal operations.

This is inconvenient in some situations.  For example, application that
monitors checkpoints and changes them to snapshots, will fall into an
infinite loop because it cannot distinguish internally created
checkpoints.

This patch solves this sort of problem by adding a flag to checkpoint for
identification.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c       |    9 +++++++++
 fs/nilfs2/segment.h       |    3 +++
 include/linux/nilfs2_fs.h |    3 +++
 3 files changed, 15 insertions(+)

diff -puN fs/nilfs2/segment.c~nilfs2-mark-minor-flag-for-checkpoint-created-by-internal-operation fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~nilfs2-mark-minor-flag-for-checkpoint-created-by-internal-operation
+++ a/fs/nilfs2/segment.c
@@ -462,6 +462,9 @@ static void nilfs_segctor_begin_finfo(st
 	sci->sc_binfo_ptr = sci->sc_finfo_ptr;
 	nilfs_segctor_map_segsum_entry(
 		sci, &sci->sc_binfo_ptr, sizeof(struct nilfs_finfo));
+
+	if (inode->i_sb && !test_bit(NILFS_SC_HAVE_DELTA, &sci->sc_flags))
+		set_bit(NILFS_SC_HAVE_DELTA, &sci->sc_flags);
 	/* skip finfo */
 }
 
@@ -887,6 +890,11 @@ static int nilfs_segctor_fill_in_checkpo
 	raw_cp->cp_create = cpu_to_le64(sci->sc_seg_ctime);
 	raw_cp->cp_cno = cpu_to_le64(nilfs->ns_cno);
 
+	if (test_bit(NILFS_SC_HAVE_DELTA, &sci->sc_flags))
+		nilfs_checkpoint_clear_minor(raw_cp);
+	else
+		nilfs_checkpoint_set_minor(raw_cp);
+
 	nilfs_write_inode_common(sbi->s_ifile, &raw_cp->cp_ifile_inode, 1);
 	nilfs_cpfile_put_checkpoint(nilfs->ns_cpfile, nilfs->ns_cno, bh_cp);
 	return 0;
@@ -2091,6 +2099,7 @@ static void nilfs_segctor_complete_write
 		nilfs_set_last_segment(nilfs, segbuf->sb_pseg_start,
 				       segbuf->sb_sum.seg_seq, nilfs->ns_cno);
 
+		clear_bit(NILFS_SC_HAVE_DELTA, &sci->sc_flags);
 		clear_bit(NILFS_SC_DIRTY, &sci->sc_flags);
 		set_bit(NILFS_SC_SUPER_ROOT, &sci->sc_flags);
 	} else
diff -puN fs/nilfs2/segment.h~nilfs2-mark-minor-flag-for-checkpoint-created-by-internal-operation fs/nilfs2/segment.h
--- a/fs/nilfs2/segment.h~nilfs2-mark-minor-flag-for-checkpoint-created-by-internal-operation
+++ a/fs/nilfs2/segment.h
@@ -185,6 +185,9 @@ enum {
 	NILFS_SC_SUPER_ROOT,	/* The latest segment has a super root */
 	NILFS_SC_PRIOR_FLUSH,	/* Requesting immediate flush without making a
 				   checkpoint */
+	NILFS_SC_HAVE_DELTA,	/* Next checkpoint will have update of files
+				   other than DAT, cpfile, sufile, or files
+				   moved by GC */
 };
 
 /* sc_state */
diff -puN include/linux/nilfs2_fs.h~nilfs2-mark-minor-flag-for-checkpoint-created-by-internal-operation include/linux/nilfs2_fs.h
--- a/include/linux/nilfs2_fs.h~nilfs2-mark-minor-flag-for-checkpoint-created-by-internal-operation
+++ a/include/linux/nilfs2_fs.h
@@ -470,6 +470,7 @@ enum {
 	NILFS_CHECKPOINT_SNAPSHOT,
 	NILFS_CHECKPOINT_INVALID,
 	NILFS_CHECKPOINT_SKETCH,
+	NILFS_CHECKPOINT_MINOR,
 };
 
 #define NILFS_CHECKPOINT_FNS(flag, name)				\
@@ -494,6 +495,7 @@ nilfs_checkpoint_##name(const struct nil
 
 NILFS_CHECKPOINT_FNS(SNAPSHOT, snapshot)
 NILFS_CHECKPOINT_FNS(INVALID, invalid)
+NILFS_CHECKPOINT_FNS(MINOR, minor)
 
 /**
  * struct nilfs_cpinfo - checkpoint information
@@ -526,6 +528,7 @@ nilfs_cpinfo_##name(const struct nilfs_c
 
 NILFS_CPINFO_FNS(SNAPSHOT, snapshot)
 NILFS_CPINFO_FNS(INVALID, invalid)
+NILFS_CPINFO_FNS(MINOR, minor)
 
 
 /**
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


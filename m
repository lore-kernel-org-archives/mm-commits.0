From: akpm@linux-foundation.org
Subject: [merged] nilfs2-mark-minor-flag-for-checkpoint-created-by-internal-operation.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:09:47 -0700
Message-ID: <200904071909.n37J9lbq012506@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760122AbZDGTLk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:11:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     nilfs2: mark minor flag for checkpoint created by internal operation
has been removed from the -mm tree.  Its filename was
     nilfs2-mark-minor-flag-for-checkpoint-created-by-internal-operation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch


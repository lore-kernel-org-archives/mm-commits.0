Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACC31EB3D;
	Sat, 15 Jun 2024 17:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718473426; cv=none; b=k+eQgpPJHH8TW2rx1I7/HwezPIIAfLGz1kdsbOGI0EYdpP3nvt60e3Mo3jWSJrAGhRLBao2i+oIStHkIDjfA6RfVxOZC2Cxdb1F7f0SqfkroQM2tOmPZkYNju14RJAcQ9biN3jhpp6BDOHuk/oEO5SZFJ6Dqj6I823YPZa38bos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718473426; c=relaxed/simple;
	bh=UNZ4hBwEh1FL1vAkBz4CPPxwcaj9Cq6QUsfZ/7xfbf0=;
	h=Date:To:From:Subject:Message-Id; b=cwxOf1tXlm4LIcY1gxCSqUH8BZHdNHUlZyMMP7K/AKldLzbyI09SZrNKCgjVSQocPhI5gWtrl2uu8dcpAkq2+nknl6K5JQl08R7JoP4NcaXAcXgAEIuvPDwFl/ftmTNZXjSpZP2W7daR4k/V2mnTCfZ0wG21405rj/z1TzxzDuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AEX1xXHr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AEX1xXHr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5548C4AF1D;
	Sat, 15 Jun 2024 17:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718473425;
	bh=UNZ4hBwEh1FL1vAkBz4CPPxwcaj9Cq6QUsfZ/7xfbf0=;
	h=Date:To:From:Subject:From;
	b=AEX1xXHrRQtM3ppbl/rZFsCINrcF2mzti0WZwLlKTqg0eYWiNbqaRzYgTwEDQZZM0
	 SPfp9GD2hGrGXA9jQ5xa/jbYSO5DhntaUr9olF+CD7YLooMz6oXSQeBJEd8M3tZUd1
	 9DIt4pGdbilWBfjmLErnWdACGrN7zyg+RLQQMT+U=
Date: Sat, 15 Jun 2024 10:43:45 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,ghe@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] ocfs2-fix-null-pointer-dereference-in-ocfs2_abort_trigger.patch removed from -mm tree
Message-Id: <20240615174345.C5548C4AF1D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix NULL pointer dereference in ocfs2_abort_trigger()
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-null-pointer-dereference-in-ocfs2_abort_trigger.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: fix NULL pointer dereference in ocfs2_abort_trigger()
Date: Thu, 30 May 2024 19:06:30 +0800

bdev->bd_super has been removed and commit 8887b94d9322 change the usage
from bdev->bd_super to b_assoc_map->host->i_sb.  Since ocfs2 hasn't set
bh->b_assoc_map, it will trigger NULL pointer dereference when calling
into ocfs2_abort_trigger().

Actually this was pointed out in history, see commit 74e364ad1b13.  But
I've made a mistake when reviewing commit 8887b94d9322 and then
re-introduce this regression.

Since we cannot revive bdev in buffer head, so fix this issue by
initializing all types of ocfs2 triggers when fill super, and then get the
specific ocfs2 trigger from ocfs2_caching_info when access journal.

[joseph.qi@linux.alibaba.com: v2]
  Link: https://lkml.kernel.org/r/20240602112045.1112708-1-joseph.qi@linux.alibaba.com
Link: https://lkml.kernel.org/r/20240530110630.3933832-2-joseph.qi@linux.alibaba.com
Fixes: 8887b94d9322 ("ocfs2: stop using bdev->bd_super for journal error logging")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>	[6.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c |  190 +++++++++++++++++++++++--------------------
 fs/ocfs2/ocfs2.h   |   27 ++++++
 fs/ocfs2/super.c   |    4 
 3 files changed, 135 insertions(+), 86 deletions(-)

--- a/fs/ocfs2/journal.c~ocfs2-fix-null-pointer-dereference-in-ocfs2_abort_trigger
+++ a/fs/ocfs2/journal.c
@@ -479,12 +479,6 @@ bail:
 	return status;
 }
 
-
-struct ocfs2_triggers {
-	struct jbd2_buffer_trigger_type	ot_triggers;
-	int				ot_offset;
-};
-
 static inline struct ocfs2_triggers *to_ocfs2_trigger(struct jbd2_buffer_trigger_type *triggers)
 {
 	return container_of(triggers, struct ocfs2_triggers, ot_triggers);
@@ -548,85 +542,76 @@ static void ocfs2_db_frozen_trigger(stru
 static void ocfs2_abort_trigger(struct jbd2_buffer_trigger_type *triggers,
 				struct buffer_head *bh)
 {
+	struct ocfs2_triggers *ot = to_ocfs2_trigger(triggers);
+
 	mlog(ML_ERROR,
 	     "ocfs2_abort_trigger called by JBD2.  bh = 0x%lx, "
 	     "bh->b_blocknr = %llu\n",
 	     (unsigned long)bh,
 	     (unsigned long long)bh->b_blocknr);
 
-	ocfs2_error(bh->b_assoc_map->host->i_sb,
+	ocfs2_error(ot->sb,
 		    "JBD2 has aborted our journal, ocfs2 cannot continue\n");
 }
 
-static struct ocfs2_triggers di_triggers = {
-	.ot_triggers = {
-		.t_frozen = ocfs2_frozen_trigger,
-		.t_abort = ocfs2_abort_trigger,
-	},
-	.ot_offset	= offsetof(struct ocfs2_dinode, i_check),
-};
-
-static struct ocfs2_triggers eb_triggers = {
-	.ot_triggers = {
-		.t_frozen = ocfs2_frozen_trigger,
-		.t_abort = ocfs2_abort_trigger,
-	},
-	.ot_offset	= offsetof(struct ocfs2_extent_block, h_check),
-};
-
-static struct ocfs2_triggers rb_triggers = {
-	.ot_triggers = {
-		.t_frozen = ocfs2_frozen_trigger,
-		.t_abort = ocfs2_abort_trigger,
-	},
-	.ot_offset	= offsetof(struct ocfs2_refcount_block, rf_check),
-};
-
-static struct ocfs2_triggers gd_triggers = {
-	.ot_triggers = {
-		.t_frozen = ocfs2_frozen_trigger,
-		.t_abort = ocfs2_abort_trigger,
-	},
-	.ot_offset	= offsetof(struct ocfs2_group_desc, bg_check),
-};
-
-static struct ocfs2_triggers db_triggers = {
-	.ot_triggers = {
-		.t_frozen = ocfs2_db_frozen_trigger,
-		.t_abort = ocfs2_abort_trigger,
-	},
-};
-
-static struct ocfs2_triggers xb_triggers = {
-	.ot_triggers = {
-		.t_frozen = ocfs2_frozen_trigger,
-		.t_abort = ocfs2_abort_trigger,
-	},
-	.ot_offset	= offsetof(struct ocfs2_xattr_block, xb_check),
-};
-
-static struct ocfs2_triggers dq_triggers = {
-	.ot_triggers = {
-		.t_frozen = ocfs2_dq_frozen_trigger,
-		.t_abort = ocfs2_abort_trigger,
-	},
-};
-
-static struct ocfs2_triggers dr_triggers = {
-	.ot_triggers = {
-		.t_frozen = ocfs2_frozen_trigger,
-		.t_abort = ocfs2_abort_trigger,
-	},
-	.ot_offset	= offsetof(struct ocfs2_dx_root_block, dr_check),
-};
-
-static struct ocfs2_triggers dl_triggers = {
-	.ot_triggers = {
-		.t_frozen = ocfs2_frozen_trigger,
-		.t_abort = ocfs2_abort_trigger,
-	},
-	.ot_offset	= offsetof(struct ocfs2_dx_leaf, dl_check),
-};
+static void ocfs2_setup_csum_triggers(struct super_block *sb,
+				      enum ocfs2_journal_trigger_type type,
+				      struct ocfs2_triggers *ot)
+{
+	BUG_ON(type >= OCFS2_JOURNAL_TRIGGER_COUNT);
+
+	switch (type) {
+	case OCFS2_JTR_DI:
+		ot->ot_triggers.t_frozen = ocfs2_frozen_trigger;
+		ot->ot_offset = offsetof(struct ocfs2_dinode, i_check);
+		break;
+	case OCFS2_JTR_EB:
+		ot->ot_triggers.t_frozen = ocfs2_frozen_trigger;
+		ot->ot_offset = offsetof(struct ocfs2_extent_block, h_check);
+		break;
+	case OCFS2_JTR_RB:
+		ot->ot_triggers.t_frozen = ocfs2_frozen_trigger;
+		ot->ot_offset = offsetof(struct ocfs2_refcount_block, rf_check);
+		break;
+	case OCFS2_JTR_GD:
+		ot->ot_triggers.t_frozen = ocfs2_frozen_trigger;
+		ot->ot_offset = offsetof(struct ocfs2_group_desc, bg_check);
+		break;
+	case OCFS2_JTR_DB:
+		ot->ot_triggers.t_frozen = ocfs2_db_frozen_trigger;
+		break;
+	case OCFS2_JTR_XB:
+		ot->ot_triggers.t_frozen = ocfs2_frozen_trigger;
+		ot->ot_offset = offsetof(struct ocfs2_xattr_block, xb_check);
+		break;
+	case OCFS2_JTR_DQ:
+		ot->ot_triggers.t_frozen = ocfs2_dq_frozen_trigger;
+		break;
+	case OCFS2_JTR_DR:
+		ot->ot_triggers.t_frozen = ocfs2_frozen_trigger;
+		ot->ot_offset = offsetof(struct ocfs2_dx_root_block, dr_check);
+		break;
+	case OCFS2_JTR_DL:
+		ot->ot_triggers.t_frozen = ocfs2_frozen_trigger;
+		ot->ot_offset = offsetof(struct ocfs2_dx_leaf, dl_check);
+		break;
+	case OCFS2_JTR_NONE:
+		/* To make compiler happy... */
+		return;
+	}
+
+	ot->ot_triggers.t_abort = ocfs2_abort_trigger;
+	ot->sb = sb;
+}
+
+void ocfs2_initialize_journal_triggers(struct super_block *sb,
+				       struct ocfs2_triggers triggers[])
+{
+	enum ocfs2_journal_trigger_type type;
+
+	for (type = OCFS2_JTR_DI; type < OCFS2_JOURNAL_TRIGGER_COUNT; type++)
+		ocfs2_setup_csum_triggers(sb, type, &triggers[type]);
+}
 
 static int __ocfs2_journal_access(handle_t *handle,
 				  struct ocfs2_caching_info *ci,
@@ -708,56 +693,91 @@ static int __ocfs2_journal_access(handle
 int ocfs2_journal_access_di(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
-	return __ocfs2_journal_access(handle, ci, bh, &di_triggers, type);
+	struct ocfs2_super *osb = OCFS2_SB(ocfs2_metadata_cache_get_super(ci));
+
+	return __ocfs2_journal_access(handle, ci, bh,
+				      &osb->s_journal_triggers[OCFS2_JTR_DI],
+				      type);
 }
 
 int ocfs2_journal_access_eb(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
-	return __ocfs2_journal_access(handle, ci, bh, &eb_triggers, type);
+	struct ocfs2_super *osb = OCFS2_SB(ocfs2_metadata_cache_get_super(ci));
+
+	return __ocfs2_journal_access(handle, ci, bh,
+				      &osb->s_journal_triggers[OCFS2_JTR_EB],
+				      type);
 }
 
 int ocfs2_journal_access_rb(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
-	return __ocfs2_journal_access(handle, ci, bh, &rb_triggers,
+	struct ocfs2_super *osb = OCFS2_SB(ocfs2_metadata_cache_get_super(ci));
+
+	return __ocfs2_journal_access(handle, ci, bh,
+				      &osb->s_journal_triggers[OCFS2_JTR_RB],
 				      type);
 }
 
 int ocfs2_journal_access_gd(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
-	return __ocfs2_journal_access(handle, ci, bh, &gd_triggers, type);
+	struct ocfs2_super *osb = OCFS2_SB(ocfs2_metadata_cache_get_super(ci));
+
+	return __ocfs2_journal_access(handle, ci, bh,
+				     &osb->s_journal_triggers[OCFS2_JTR_GD],
+				     type);
 }
 
 int ocfs2_journal_access_db(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
-	return __ocfs2_journal_access(handle, ci, bh, &db_triggers, type);
+	struct ocfs2_super *osb = OCFS2_SB(ocfs2_metadata_cache_get_super(ci));
+
+	return __ocfs2_journal_access(handle, ci, bh,
+				     &osb->s_journal_triggers[OCFS2_JTR_DB],
+				     type);
 }
 
 int ocfs2_journal_access_xb(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
-	return __ocfs2_journal_access(handle, ci, bh, &xb_triggers, type);
+	struct ocfs2_super *osb = OCFS2_SB(ocfs2_metadata_cache_get_super(ci));
+
+	return __ocfs2_journal_access(handle, ci, bh,
+				     &osb->s_journal_triggers[OCFS2_JTR_XB],
+				     type);
 }
 
 int ocfs2_journal_access_dq(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
-	return __ocfs2_journal_access(handle, ci, bh, &dq_triggers, type);
+	struct ocfs2_super *osb = OCFS2_SB(ocfs2_metadata_cache_get_super(ci));
+
+	return __ocfs2_journal_access(handle, ci, bh,
+				     &osb->s_journal_triggers[OCFS2_JTR_DQ],
+				     type);
 }
 
 int ocfs2_journal_access_dr(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
-	return __ocfs2_journal_access(handle, ci, bh, &dr_triggers, type);
+	struct ocfs2_super *osb = OCFS2_SB(ocfs2_metadata_cache_get_super(ci));
+
+	return __ocfs2_journal_access(handle, ci, bh,
+				     &osb->s_journal_triggers[OCFS2_JTR_DR],
+				     type);
 }
 
 int ocfs2_journal_access_dl(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
-	return __ocfs2_journal_access(handle, ci, bh, &dl_triggers, type);
+	struct ocfs2_super *osb = OCFS2_SB(ocfs2_metadata_cache_get_super(ci));
+
+	return __ocfs2_journal_access(handle, ci, bh,
+				     &osb->s_journal_triggers[OCFS2_JTR_DL],
+				     type);
 }
 
 int ocfs2_journal_access(handle_t *handle, struct ocfs2_caching_info *ci,
--- a/fs/ocfs2/ocfs2.h~ocfs2-fix-null-pointer-dereference-in-ocfs2_abort_trigger
+++ a/fs/ocfs2/ocfs2.h
@@ -284,6 +284,30 @@ enum ocfs2_mount_options
 #define OCFS2_OSB_ERROR_FS	0x0004
 #define OCFS2_DEFAULT_ATIME_QUANTUM	60
 
+struct ocfs2_triggers {
+	struct jbd2_buffer_trigger_type	ot_triggers;
+	int				ot_offset;
+	struct super_block		*sb;
+};
+
+enum ocfs2_journal_trigger_type {
+	OCFS2_JTR_DI,
+	OCFS2_JTR_EB,
+	OCFS2_JTR_RB,
+	OCFS2_JTR_GD,
+	OCFS2_JTR_DB,
+	OCFS2_JTR_XB,
+	OCFS2_JTR_DQ,
+	OCFS2_JTR_DR,
+	OCFS2_JTR_DL,
+	OCFS2_JTR_NONE  /* This must be the last entry */
+};
+
+#define OCFS2_JOURNAL_TRIGGER_COUNT OCFS2_JTR_NONE
+
+void ocfs2_initialize_journal_triggers(struct super_block *sb,
+				       struct ocfs2_triggers triggers[]);
+
 struct ocfs2_journal;
 struct ocfs2_slot_info;
 struct ocfs2_recovery_map;
@@ -351,6 +375,9 @@ struct ocfs2_super
 	struct ocfs2_journal *journal;
 	unsigned long osb_commit_interval;
 
+	/* Journal triggers for checksum */
+	struct ocfs2_triggers s_journal_triggers[OCFS2_JOURNAL_TRIGGER_COUNT];
+
 	struct delayed_work		la_enable_wq;
 
 	/*
--- a/fs/ocfs2/super.c~ocfs2-fix-null-pointer-dereference-in-ocfs2_abort_trigger
+++ a/fs/ocfs2/super.c
@@ -1075,9 +1075,11 @@ static int ocfs2_fill_super(struct super
 	debugfs_create_file("fs_state", S_IFREG|S_IRUSR, osb->osb_debug_root,
 			    osb, &ocfs2_osb_debug_fops);
 
-	if (ocfs2_meta_ecc(osb))
+	if (ocfs2_meta_ecc(osb)) {
+		ocfs2_initialize_journal_triggers(sb, osb->s_journal_triggers);
 		ocfs2_blockcheck_stats_debugfs_install( &osb->osb_ecc_stats,
 							osb->osb_debug_root);
+	}
 
 	status = ocfs2_mount_volume(sb);
 	if (status < 0)
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are



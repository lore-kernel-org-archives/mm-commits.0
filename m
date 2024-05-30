Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92918433CA;
	Thu, 30 May 2024 19:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717098691; cv=none; b=pEQxZui0UFyfCpqQyPIoByfUveNZiVHyomE5Qf0LGJPQTMsUeZEle717V6klEUVcnL3l7IwfQ66QkzQyl1bnf2na9gVUBw7mNe0F2LBOFcfscfV+3XYstXcgas4+vgSrnGifiVVcusPJtNgdBdxxGbS2t+oRgRp2TLl3LTvb8E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717098691; c=relaxed/simple;
	bh=GWhDmzCxHq9WfMf1/uhl5bQCPi8Uo70C87nx3pXO42M=;
	h=Date:To:From:Subject:Message-Id; b=BpqyyIzumUaIMIPDl537mM0KMCSh5Z8lKur2HNU3WEyrOLimH2kkmczR2hR2LJnUt7HJjaGkC0QO3E22BStKAC4pcBH9vOe3P1bNBOXWwTXHw6nqy44ZdpCVtjaprCNwn5HvgW4/DwEbGhq70UoMy6OS/Dlje244FJMAuLlKkNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aBdH9Mft; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aBdH9Mft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6FCC2BBFC;
	Thu, 30 May 2024 19:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717098691;
	bh=GWhDmzCxHq9WfMf1/uhl5bQCPi8Uo70C87nx3pXO42M=;
	h=Date:To:From:Subject:From;
	b=aBdH9MftF1ZztfG+tauzlvzwRRMuYF7PvEiFss9n0MG6SvA17JsU2k3//COtbOpb3
	 b2bWmEithDFjygwhkN2FlX5NfYoWmL9iQZapZFcDV4pWwOGKRPu16ZXyyO/dvp3yjL
	 JB4eBoztLV3w8ymet2/sWN87WdUAbBFTUVS5AvqI=
Date: Thu, 30 May 2024 12:51:30 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-null-pointer-dereference-in-ocfs2_abort_trigger.patch added to mm-hotfixes-unstable branch
Message-Id: <20240530195131.5F6FCC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix NULL pointer dereference in ocfs2_abort_trigger()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ocfs2-fix-null-pointer-dereference-in-ocfs2_abort_trigger.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-null-pointer-dereference-in-ocfs2_abort_trigger.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
reintroduce this regression.

Since we cannot revive bdev in buffer head, we can get super block from
ocfs2_caching_info first and then associate it with ocfs2_triggers to fix
this issue.

Link: https://lkml.kernel.org/r/20240530110630.3933832-2-joseph.qi@linux.alibaba.com
Fixes: 8887b94d9322 ("ocfs2: stop using bdev->bd_super for journal error logging")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>	[6.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c |  179 ++++++++++++++++++++++++++-----------------
 1 file changed, 111 insertions(+), 68 deletions(-)

--- a/fs/ocfs2/journal.c~ocfs2-fix-null-pointer-dereference-in-ocfs2_abort_trigger
+++ a/fs/ocfs2/journal.c
@@ -483,8 +483,24 @@ bail:
 struct ocfs2_triggers {
 	struct jbd2_buffer_trigger_type	ot_triggers;
 	int				ot_offset;
+	struct super_block		*sb;
 };
 
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
 static inline struct ocfs2_triggers *to_ocfs2_trigger(struct jbd2_buffer_trigger_type *triggers)
 {
 	return container_of(triggers, struct ocfs2_triggers, ot_triggers);
@@ -548,85 +564,67 @@ static void ocfs2_db_frozen_trigger(stru
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
+static void ocfs2_setup_csum_triggers(struct super_block *sb,
+				      enum ocfs2_journal_trigger_type type,
+				      struct ocfs2_triggers *ot)
+{
+	BUG_ON(type >= OCFS2_JOURNAL_TRIGGER_COUNT);
 
-static struct ocfs2_triggers dr_triggers = {
-	.ot_triggers = {
-		.t_frozen = ocfs2_frozen_trigger,
-		.t_abort = ocfs2_abort_trigger,
-	},
-	.ot_offset	= offsetof(struct ocfs2_dx_root_block, dr_check),
-};
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
 
-static struct ocfs2_triggers dl_triggers = {
-	.ot_triggers = {
-		.t_frozen = ocfs2_frozen_trigger,
-		.t_abort = ocfs2_abort_trigger,
-	},
-	.ot_offset	= offsetof(struct ocfs2_dx_leaf, dl_check),
-};
+	ot->ot_triggers.t_abort = ocfs2_abort_trigger;
+	ot->sb = sb;
+}
 
 static int __ocfs2_journal_access(handle_t *handle,
 				  struct ocfs2_caching_info *ci,
@@ -708,18 +706,33 @@ static int __ocfs2_journal_access(handle
 int ocfs2_journal_access_di(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
+	struct ocfs2_triggers di_triggers;
+
+	ocfs2_setup_csum_triggers(ocfs2_metadata_cache_get_super(ci),
+				 OCFS2_JTR_DI, &di_triggers);
+
 	return __ocfs2_journal_access(handle, ci, bh, &di_triggers, type);
 }
 
 int ocfs2_journal_access_eb(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
+	struct ocfs2_triggers eb_triggers;
+
+	ocfs2_setup_csum_triggers(ocfs2_metadata_cache_get_super(ci),
+				 OCFS2_JTR_EB, &eb_triggers);
+
 	return __ocfs2_journal_access(handle, ci, bh, &eb_triggers, type);
 }
 
 int ocfs2_journal_access_rb(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
+	struct ocfs2_triggers rb_triggers;
+
+	ocfs2_setup_csum_triggers(ocfs2_metadata_cache_get_super(ci),
+				 OCFS2_JTR_RB, &rb_triggers);
+
 	return __ocfs2_journal_access(handle, ci, bh, &rb_triggers,
 				      type);
 }
@@ -727,36 +740,66 @@ int ocfs2_journal_access_rb(handle_t *ha
 int ocfs2_journal_access_gd(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
+	struct ocfs2_triggers gd_triggers;
+
+	ocfs2_setup_csum_triggers(ocfs2_metadata_cache_get_super(ci),
+				 OCFS2_JTR_GD, &gd_triggers);
+
 	return __ocfs2_journal_access(handle, ci, bh, &gd_triggers, type);
 }
 
 int ocfs2_journal_access_db(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
+	struct ocfs2_triggers db_triggers;
+
+	ocfs2_setup_csum_triggers(ocfs2_metadata_cache_get_super(ci),
+				 OCFS2_JTR_DB, &db_triggers);
+
 	return __ocfs2_journal_access(handle, ci, bh, &db_triggers, type);
 }
 
 int ocfs2_journal_access_xb(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
+	struct ocfs2_triggers xb_triggers;
+
+	ocfs2_setup_csum_triggers(ocfs2_metadata_cache_get_super(ci),
+				 OCFS2_JTR_XB, &xb_triggers);
+
 	return __ocfs2_journal_access(handle, ci, bh, &xb_triggers, type);
 }
 
 int ocfs2_journal_access_dq(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
+	struct ocfs2_triggers dq_triggers;
+
+	ocfs2_setup_csum_triggers(ocfs2_metadata_cache_get_super(ci),
+				 OCFS2_JTR_DQ, &dq_triggers);
+
 	return __ocfs2_journal_access(handle, ci, bh, &dq_triggers, type);
 }
 
 int ocfs2_journal_access_dr(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
+	struct ocfs2_triggers dr_triggers;
+
+	ocfs2_setup_csum_triggers(ocfs2_metadata_cache_get_super(ci),
+				 OCFS2_JTR_DR, &dr_triggers);
+
 	return __ocfs2_journal_access(handle, ci, bh, &dr_triggers, type);
 }
 
 int ocfs2_journal_access_dl(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
+	struct ocfs2_triggers dl_triggers;
+
+	ocfs2_setup_csum_triggers(ocfs2_metadata_cache_get_super(ci),
+				 OCFS2_JTR_DL, &dl_triggers);
+
 	return __ocfs2_journal_access(handle, ci, bh, &dl_triggers, type);
 }
 
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-fix-null-pointer-dereference-in-ocfs2_journal_dirty.patch
ocfs2-fix-null-pointer-dereference-in-ocfs2_abort_trigger.patch


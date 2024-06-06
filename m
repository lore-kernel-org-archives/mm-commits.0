Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4DC179A7;
	Thu,  6 Jun 2024 02:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717640239; cv=none; b=eY0MGgXLYBjxfzSBLvz4ost31nS8/KZscTEp8BRWI7ZJmcX7ovFEku5+6rRcFiQqQxyEUexhARbuEoDCgB8UEyDtWe1TKt6bVakLYREjyjgwg5FaEhd38aDVrxUk/m6kEXk9vBRRXo/dArpdvdvEVwi04b8mvLAMHUtQEEstmWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717640239; c=relaxed/simple;
	bh=8T5lplvemHv2ktDWDHZOSYiQnQQhhBFKWHMtoKSeFA0=;
	h=Date:To:From:Subject:Message-Id; b=vGq7Dz863UOLN8BIoX8XDYjVr/pNMY/SfyNzdd47pIVINhQqGwB49RquNEN3BLZqMe9Yg3ZNNZ3qzZOotbtYJcSo+WuGR5JEKO4/FDNnfHoWkg61wRR7BC8Iw0oXIIudgJvBpnh3n+cVxKG/Xvx2tOYrHpeKNKj+iha3juHh+LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=glx4BWXU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="glx4BWXU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C97C4AF13;
	Thu,  6 Jun 2024 02:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717640239;
	bh=8T5lplvemHv2ktDWDHZOSYiQnQQhhBFKWHMtoKSeFA0=;
	h=Date:To:From:Subject:From;
	b=glx4BWXU54wsOL4EYkvDwpQWYw+cJW+ECEjyXagHOWLjAx+065Ozg0NC5n2Rw7RwW
	 XyiNh2gf3RoI42Zus21iRT6tqe0D9fU6TP0wNIO4K0KABHXEdbDbNufWF7k7MIWEj0
	 qRzBohEb5kMCo6/YQ0vMoYkEarbft7iDK2FAuTyU=
Date: Wed, 05 Jun 2024 19:17:18 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,ghe@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] ocfs2-fix-null-pointer-dereference-in-ocfs2_abort_trigger-v2.patch removed from -mm tree
Message-Id: <20240606021719.04C97C4AF13@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix NULL pointer dereference in ocfs2_abort_trigger()
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-null-pointer-dereference-in-ocfs2_abort_trigger-v2.patch

This patch was dropped because it was folded into ocfs2-fix-null-pointer-dereference-in-ocfs2_abort_trigger.patch

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: fix NULL pointer dereference in ocfs2_abort_trigger()
Date: Sun, 2 Jun 2024 19:20:45 +0800

Link: https://lkml.kernel.org/r/20240602112045.1112708-1-joseph.qi@linux.alibaba.com
Fixes: 8887b94d9322 ("ocfs2: stop using bdev->bd_super for journal error logging")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>	[6.6+]
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c |  111 +++++++++++++++++--------------------------
 fs/ocfs2/ocfs2.h   |   27 ++++++++++
 fs/ocfs2/super.c   |    4 +
 3 files changed, 74 insertions(+), 68 deletions(-)

--- a/fs/ocfs2/journal.c~ocfs2-fix-null-pointer-dereference-in-ocfs2_abort_trigger-v2
+++ a/fs/ocfs2/journal.c
@@ -479,28 +479,6 @@ bail:
 	return status;
 }
 
-
-struct ocfs2_triggers {
-	struct jbd2_buffer_trigger_type	ot_triggers;
-	int				ot_offset;
-	struct super_block		*sb;
-};
-
-enum ocfs2_journal_trigger_type {
-	OCFS2_JTR_DI,
-	OCFS2_JTR_EB,
-	OCFS2_JTR_RB,
-	OCFS2_JTR_GD,
-	OCFS2_JTR_DB,
-	OCFS2_JTR_XB,
-	OCFS2_JTR_DQ,
-	OCFS2_JTR_DR,
-	OCFS2_JTR_DL,
-	OCFS2_JTR_NONE  /* This must be the last entry */
-};
-
-#define OCFS2_JOURNAL_TRIGGER_COUNT OCFS2_JTR_NONE
-
 static inline struct ocfs2_triggers *to_ocfs2_trigger(struct jbd2_buffer_trigger_type *triggers)
 {
 	return container_of(triggers, struct ocfs2_triggers, ot_triggers);
@@ -626,6 +604,15 @@ static void ocfs2_setup_csum_triggers(st
 	ot->sb = sb;
 }
 
+void ocfs2_initialize_journal_triggers(struct super_block *sb,
+				       struct ocfs2_triggers triggers[])
+{
+	enum ocfs2_journal_trigger_type type;
+
+	for (type = OCFS2_JTR_DI; type < OCFS2_JOURNAL_TRIGGER_COUNT; type++)
+		ocfs2_setup_csum_triggers(sb, type, &triggers[type]);
+}
+
 static int __ocfs2_journal_access(handle_t *handle,
 				  struct ocfs2_caching_info *ci,
 				  struct buffer_head *bh,
@@ -706,101 +693,91 @@ static int __ocfs2_journal_access(handle
 int ocfs2_journal_access_di(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
-	struct ocfs2_triggers di_triggers;
+	struct ocfs2_super *osb = OCFS2_SB(ocfs2_metadata_cache_get_super(ci));
 
-	ocfs2_setup_csum_triggers(ocfs2_metadata_cache_get_super(ci),
-				 OCFS2_JTR_DI, &di_triggers);
-
-	return __ocfs2_journal_access(handle, ci, bh, &di_triggers, type);
+	return __ocfs2_journal_access(handle, ci, bh,
+				      &osb->s_journal_triggers[OCFS2_JTR_DI],
+				      type);
 }
 
 int ocfs2_journal_access_eb(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
-	struct ocfs2_triggers eb_triggers;
+	struct ocfs2_super *osb = OCFS2_SB(ocfs2_metadata_cache_get_super(ci));
 
-	ocfs2_setup_csum_triggers(ocfs2_metadata_cache_get_super(ci),
-				 OCFS2_JTR_EB, &eb_triggers);
-
-	return __ocfs2_journal_access(handle, ci, bh, &eb_triggers, type);
+	return __ocfs2_journal_access(handle, ci, bh,
+				      &osb->s_journal_triggers[OCFS2_JTR_EB],
+				      type);
 }
 
 int ocfs2_journal_access_rb(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
-	struct ocfs2_triggers rb_triggers;
-
-	ocfs2_setup_csum_triggers(ocfs2_metadata_cache_get_super(ci),
-				 OCFS2_JTR_RB, &rb_triggers);
+	struct ocfs2_super *osb = OCFS2_SB(ocfs2_metadata_cache_get_super(ci));
 
-	return __ocfs2_journal_access(handle, ci, bh, &rb_triggers,
+	return __ocfs2_journal_access(handle, ci, bh,
+				      &osb->s_journal_triggers[OCFS2_JTR_RB],
 				      type);
 }
 
 int ocfs2_journal_access_gd(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
-	struct ocfs2_triggers gd_triggers;
+	struct ocfs2_super *osb = OCFS2_SB(ocfs2_metadata_cache_get_super(ci));
 
-	ocfs2_setup_csum_triggers(ocfs2_metadata_cache_get_super(ci),
-				 OCFS2_JTR_GD, &gd_triggers);
-
-	return __ocfs2_journal_access(handle, ci, bh, &gd_triggers, type);
+	return __ocfs2_journal_access(handle, ci, bh,
+				     &osb->s_journal_triggers[OCFS2_JTR_GD],
+				     type);
 }
 
 int ocfs2_journal_access_db(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
-	struct ocfs2_triggers db_triggers;
-
-	ocfs2_setup_csum_triggers(ocfs2_metadata_cache_get_super(ci),
-				 OCFS2_JTR_DB, &db_triggers);
+	struct ocfs2_super *osb = OCFS2_SB(ocfs2_metadata_cache_get_super(ci));
 
-	return __ocfs2_journal_access(handle, ci, bh, &db_triggers, type);
+	return __ocfs2_journal_access(handle, ci, bh,
+				     &osb->s_journal_triggers[OCFS2_JTR_DB],
+				     type);
 }
 
 int ocfs2_journal_access_xb(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
-	struct ocfs2_triggers xb_triggers;
+	struct ocfs2_super *osb = OCFS2_SB(ocfs2_metadata_cache_get_super(ci));
 
-	ocfs2_setup_csum_triggers(ocfs2_metadata_cache_get_super(ci),
-				 OCFS2_JTR_XB, &xb_triggers);
-
-	return __ocfs2_journal_access(handle, ci, bh, &xb_triggers, type);
+	return __ocfs2_journal_access(handle, ci, bh,
+				     &osb->s_journal_triggers[OCFS2_JTR_XB],
+				     type);
 }
 
 int ocfs2_journal_access_dq(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
-	struct ocfs2_triggers dq_triggers;
-
-	ocfs2_setup_csum_triggers(ocfs2_metadata_cache_get_super(ci),
-				 OCFS2_JTR_DQ, &dq_triggers);
+	struct ocfs2_super *osb = OCFS2_SB(ocfs2_metadata_cache_get_super(ci));
 
-	return __ocfs2_journal_access(handle, ci, bh, &dq_triggers, type);
+	return __ocfs2_journal_access(handle, ci, bh,
+				     &osb->s_journal_triggers[OCFS2_JTR_DQ],
+				     type);
 }
 
 int ocfs2_journal_access_dr(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
-	struct ocfs2_triggers dr_triggers;
+	struct ocfs2_super *osb = OCFS2_SB(ocfs2_metadata_cache_get_super(ci));
 
-	ocfs2_setup_csum_triggers(ocfs2_metadata_cache_get_super(ci),
-				 OCFS2_JTR_DR, &dr_triggers);
-
-	return __ocfs2_journal_access(handle, ci, bh, &dr_triggers, type);
+	return __ocfs2_journal_access(handle, ci, bh,
+				     &osb->s_journal_triggers[OCFS2_JTR_DR],
+				     type);
 }
 
 int ocfs2_journal_access_dl(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
-	struct ocfs2_triggers dl_triggers;
-
-	ocfs2_setup_csum_triggers(ocfs2_metadata_cache_get_super(ci),
-				 OCFS2_JTR_DL, &dl_triggers);
+	struct ocfs2_super *osb = OCFS2_SB(ocfs2_metadata_cache_get_super(ci));
 
-	return __ocfs2_journal_access(handle, ci, bh, &dl_triggers, type);
+	return __ocfs2_journal_access(handle, ci, bh,
+				     &osb->s_journal_triggers[OCFS2_JTR_DL],
+				     type);
 }
 
 int ocfs2_journal_access(handle_t *handle, struct ocfs2_caching_info *ci,
--- a/fs/ocfs2/ocfs2.h~ocfs2-fix-null-pointer-dereference-in-ocfs2_abort_trigger-v2
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
--- a/fs/ocfs2/super.c~ocfs2-fix-null-pointer-dereference-in-ocfs2_abort_trigger-v2
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

ocfs2-fix-null-pointer-dereference-in-ocfs2_journal_dirty.patch
ocfs2-fix-null-pointer-dereference-in-ocfs2_abort_trigger.patch


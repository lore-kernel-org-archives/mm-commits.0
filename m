Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51C36C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:19:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236302AbiEJEX3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236250AbiEJEVy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:21:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03FF1B1F60
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:17:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 737F6B81B05
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2709BC385A6;
        Tue, 10 May 2022 04:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156250;
        bh=SIxAJAW+I0aca6ctLYrG98vIl4veIqyF36JyxZQCqc8=;
        h=Date:To:From:Subject:From;
        b=YWMUlnB7zRMIY1Mkq2R86DppLGf3GSLJ3//Fag7/6mdbTG0dc0wkYJJPwjGAo7+2F
         RzPL7o69/V1mjkD57YH8U8UWN7tdKF2TtmGHiFtYN4/qhwO4Ks9B8InXR5/XydXpK4
         +B/r2eYGd7gIwXuW9ofx8fsB4YUo6G2OB+SJqd4E=
Date:   Mon, 09 May 2022 21:17:29 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, heming.zhao@suse.com, ghe@suse.com,
        gechangwei@live.cn, ocfs2-devel@oss.oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-ocfs2_initialize_super-does-cleanup-job-before-return-error.patch removed from -mm tree
Message-Id: <20220510041730.2709BC385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ocfs2: ocfs2_initialize_super does cleanup job before return error
has been removed from the -mm tree.  Its filename was
     ocfs2-ocfs2_initialize_super-does-cleanup-job-before-return-error.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: ocfs2: ocfs2_initialize_super does cleanup job before return error

After this patch, when error, ocfs2_fill_super doesn't take care to
release resources which are allocated in ocfs2_initialize_super.

Link: https://lkml.kernel.org/r/20220424130952.2436-4-heming.zhao@suse.com
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |   59 +++++++++++++++++++++++++++++++--------------
 1 file changed, 41 insertions(+), 18 deletions(-)

--- a/fs/ocfs2/super.c~ocfs2-ocfs2_initialize_super-does-cleanup-job-before-return-error
+++ a/fs/ocfs2/super.c
@@ -2022,7 +2022,7 @@ static int ocfs2_initialize_super(struct
 	if (!osb) {
 		status = -ENOMEM;
 		mlog_errno(status);
-		goto bail;
+		goto out;
 	}
 
 	sb->s_fs_info = osb;
@@ -2083,7 +2083,7 @@ static int ocfs2_initialize_super(struct
 		mlog(ML_ERROR, "Invalid number of node slots (%u)\n",
 		     osb->max_slots);
 		status = -EINVAL;
-		goto bail;
+		goto out;
 	}
 
 	ocfs2_orphan_scan_init(osb);
@@ -2092,7 +2092,7 @@ static int ocfs2_initialize_super(struct
 	if (status) {
 		mlog(ML_ERROR, "Unable to initialize recovery state\n");
 		mlog_errno(status);
-		goto bail;
+		goto out;
 	}
 
 	init_waitqueue_head(&osb->checkpoint_event);
@@ -2116,7 +2116,7 @@ static int ocfs2_initialize_super(struct
 	if (!osb->vol_label) {
 		mlog(ML_ERROR, "unable to alloc vol label\n");
 		status = -ENOMEM;
-		goto bail;
+		goto out_recovery_map;
 	}
 
 	osb->slot_recovery_generations =
@@ -2125,7 +2125,7 @@ static int ocfs2_initialize_super(struct
 	if (!osb->slot_recovery_generations) {
 		status = -ENOMEM;
 		mlog_errno(status);
-		goto bail;
+		goto out_vol_label;
 	}
 
 	init_waitqueue_head(&osb->osb_wipe_event);
@@ -2135,7 +2135,7 @@ static int ocfs2_initialize_super(struct
 	if (!osb->osb_orphan_wipes) {
 		status = -ENOMEM;
 		mlog_errno(status);
-		goto bail;
+		goto out_slot_recovery_gen;
 	}
 
 	osb->osb_rf_lock_tree = RB_ROOT;
@@ -2151,13 +2151,13 @@ static int ocfs2_initialize_super(struct
 		mlog(ML_ERROR, "couldn't mount because of unsupported "
 		     "optional features (%x).\n", i);
 		status = -EINVAL;
-		goto bail;
+		goto out_orphan_wipes;
 	}
 	if (!sb_rdonly(osb->sb) && (i = OCFS2_HAS_RO_COMPAT_FEATURE(osb->sb, ~OCFS2_FEATURE_RO_COMPAT_SUPP))) {
 		mlog(ML_ERROR, "couldn't mount RDWR because of "
 		     "unsupported optional features (%x).\n", i);
 		status = -EINVAL;
-		goto bail;
+		goto out_orphan_wipes;
 	}
 
 	if (ocfs2_clusterinfo_valid(osb)) {
@@ -2178,7 +2178,7 @@ static int ocfs2_initialize_super(struct
 			     "cluster stack label (%s) \n",
 			     osb->osb_cluster_stack);
 			status = -EINVAL;
-			goto bail;
+			goto out_orphan_wipes;
 		}
 		memcpy(osb->osb_cluster_name,
 			OCFS2_RAW_SB(di)->s_cluster_info.ci_cluster,
@@ -2198,7 +2198,7 @@ static int ocfs2_initialize_super(struct
 	 */
 	status = ocfs2_journal_alloc(osb);
 	if (status < 0)
-		goto bail;
+		goto out_orphan_wipes;
 
 	INIT_WORK(&osb->dquot_drop_work, ocfs2_drop_dquot_refs);
 	init_llist_head(&osb->dquot_drop_list);
@@ -2213,7 +2213,7 @@ static int ocfs2_initialize_super(struct
 		mlog(ML_ERROR, "Volume has invalid cluster size (%d)\n",
 		     osb->s_clustersize);
 		status = -EINVAL;
-		goto bail;
+		goto out_journal;
 	}
 
 	total_blocks = ocfs2_clusters_to_blocks(osb->sb,
@@ -2225,14 +2225,14 @@ static int ocfs2_initialize_super(struct
 		mlog(ML_ERROR, "Volume too large "
 		     "to mount safely on this system");
 		status = -EFBIG;
-		goto bail;
+		goto out_journal;
 	}
 
 	if (ocfs2_setup_osb_uuid(osb, di->id2.i_super.s_uuid,
 				 sizeof(di->id2.i_super.s_uuid))) {
 		mlog(ML_ERROR, "Out of memory trying to setup our uuid.\n");
 		status = -ENOMEM;
-		goto bail;
+		goto out_journal;
 	}
 
 	strlcpy(osb->vol_label, di->id2.i_super.s_label,
@@ -2252,7 +2252,7 @@ static int ocfs2_initialize_super(struct
 	if (!osb->osb_dlm_debug) {
 		status = -ENOMEM;
 		mlog_errno(status);
-		goto bail;
+		goto out_uuid_str;
 	}
 
 	atomic_set(&osb->vol_state, VOLUME_INIT);
@@ -2261,7 +2261,7 @@ static int ocfs2_initialize_super(struct
 	status = ocfs2_init_global_system_inodes(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto bail;
+		goto out_dlm_out;
 	}
 
 	/*
@@ -2272,7 +2272,7 @@ static int ocfs2_initialize_super(struct
 	if (!inode) {
 		status = -EINVAL;
 		mlog_errno(status);
-		goto bail;
+		goto out_system_inodes;
 	}
 
 	osb->bitmap_blkno = OCFS2_I(inode)->ip_blkno;
@@ -2285,16 +2285,39 @@ static int ocfs2_initialize_super(struct
 	status = ocfs2_init_slot_info(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto bail;
+		goto out_system_inodes;
 	}
 
 	osb->ocfs2_wq = alloc_ordered_workqueue("ocfs2_wq", WQ_MEM_RECLAIM);
 	if (!osb->ocfs2_wq) {
 		status = -ENOMEM;
 		mlog_errno(status);
+		goto out_slot_info;
 	}
 
-bail:
+	return status;
+
+out_slot_info:
+	ocfs2_free_slot_info(osb);
+out_system_inodes:
+	ocfs2_release_system_inodes(osb);
+out_dlm_out:
+	ocfs2_put_dlm_debug(osb->osb_dlm_debug);
+out_uuid_str:
+	kfree(osb->uuid_str);
+out_journal:
+	kfree(osb->journal);
+out_orphan_wipes:
+	kfree(osb->osb_orphan_wipes);
+out_slot_recovery_gen:
+	kfree(osb->slot_recovery_generations);
+out_vol_label:
+	kfree(osb->vol_label);
+out_recovery_map:
+	kfree(osb->recovery_map);
+out:
+	kfree(osb);
+	sb->s_fs_info = NULL;
 	return status;
 }
 
_

Patches currently in -mm which might be from ocfs2-devel@oss.oracle.com are



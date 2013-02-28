From: akpm@linux-foundation.org
Subject: [merged] target-iscsi-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:15:15 -0800
Message-ID: <20130228201515.A4F725A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:65229 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758179Ab3B1UPS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:15:18 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so244902vcd.5
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:15:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, mm-commits@vger.kernel.org


The patch titled
     Subject: target/iscsi: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     target-iscsi-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: target/iscsi: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Nicholas A. Bellinger <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/target/iscsi/iscsi_target.c       |   15 ++++++++-------
 drivers/target/iscsi/iscsi_target_login.c |   15 ++++++---------
 2 files changed, 14 insertions(+), 16 deletions(-)

diff -puN drivers/target/iscsi/iscsi_target.c~target-iscsi-convert-to-idr_alloc drivers/target/iscsi/iscsi_target.c
--- a/drivers/target/iscsi/iscsi_target.c~target-iscsi-convert-to-idr_alloc
+++ a/drivers/target/iscsi/iscsi_target.c
@@ -144,23 +144,24 @@ struct iscsi_tiqn *iscsit_add_tiqn(unsig
 	spin_lock_init(&tiqn->login_stats.lock);
 	spin_lock_init(&tiqn->logout_stats.lock);
 
-	if (!idr_pre_get(&tiqn_idr, GFP_KERNEL)) {
-		pr_err("idr_pre_get() for tiqn_idr failed\n");
-		kfree(tiqn);
-		return ERR_PTR(-ENOMEM);
-	}
 	tiqn->tiqn_state = TIQN_STATE_ACTIVE;
 
+	idr_preload(GFP_KERNEL);
 	spin_lock(&tiqn_lock);
-	ret = idr_get_new(&tiqn_idr, NULL, &tiqn->tiqn_index);
+
+	ret = idr_alloc(&tiqn_idr, NULL, 0, 0, GFP_NOWAIT);
 	if (ret < 0) {
-		pr_err("idr_get_new() failed for tiqn->tiqn_index\n");
+		pr_err("idr_alloc() failed for tiqn->tiqn_index\n");
 		spin_unlock(&tiqn_lock);
+		idr_preload_end();
 		kfree(tiqn);
 		return ERR_PTR(ret);
 	}
+	tiqn->tiqn_index = ret;
 	list_add_tail(&tiqn->tiqn_list, &g_tiqn_list);
+
 	spin_unlock(&tiqn_lock);
+	idr_preload_end();
 
 	pr_debug("CORE[0] - Added iSCSI Target IQN: %s\n", tiqn->tiqn);
 
diff -puN drivers/target/iscsi/iscsi_target_login.c~target-iscsi-convert-to-idr_alloc drivers/target/iscsi/iscsi_target_login.c
--- a/drivers/target/iscsi/iscsi_target_login.c~target-iscsi-convert-to-idr_alloc
+++ a/drivers/target/iscsi/iscsi_target_login.c
@@ -247,19 +247,16 @@ static int iscsi_login_zero_tsih_s1(
 	spin_lock_init(&sess->session_usage_lock);
 	spin_lock_init(&sess->ttt_lock);
 
-	if (!idr_pre_get(&sess_idr, GFP_KERNEL)) {
-		pr_err("idr_pre_get() for sess_idr failed\n");
-		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
-				ISCSI_LOGIN_STATUS_NO_RESOURCES);
-		kfree(sess);
-		return -ENOMEM;
-	}
+	idr_preload(GFP_KERNEL);
 	spin_lock_bh(&sess_idr_lock);
-	ret = idr_get_new(&sess_idr, NULL, &sess->session_index);
+	ret = idr_alloc(&sess_idr, NULL, 0, 0, GFP_NOWAIT);
+	if (ret >= 0)
+		sess->session_index = ret;
 	spin_unlock_bh(&sess_idr_lock);
+	idr_preload_end();
 
 	if (ret < 0) {
-		pr_err("idr_get_new() for sess_idr failed\n");
+		pr_err("idr_alloc() for sess_idr failed\n");
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
 		kfree(sess);
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
slub-correctly-bootstrap-boot-caches.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch


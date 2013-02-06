From: akpm@linux-foundation.org
Subject: + target-iscsi-convert-to-idr_alloc.patch added to -mm tree
Date: Wed, 06 Feb 2013 14:39:11 -0800
Message-ID: <20130206223912.308B05A42B9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:63564 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368Ab3BFWjN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:39:13 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so95125yhz.3
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:39:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org


The patch titled
     Subject: target/iscsi: convert to idr_alloc()
has been added to the -mm tree.  Its filename is
     target-iscsi-convert-to-idr_alloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: target/iscsi: convert to idr_alloc()

Convert to the much saner new idr interface.

Only compile tested.

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

linux-next.patch
cfq-fix-lock-imbalance-with-failed-allocations.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
memcg-do-not-create-memsw-files-if-swap-accounting-is-disabled.patch
memcg-clean-up-swap-accounting-initialization-code.patch
memcg-prevent-changes-to-move_charge_at_immigrate-during-task-attach.patch
memcg-split-part-of-memcg-creation-to-css_online.patch
memcg-fast-hierarchy-aware-child-test.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock.patch
memcg-increment-static-branch-right-after-limit-set.patch
memcg-avoid-dangling-reference-count-in-creation-failure.patch
idr-fix-a-subtle-bug-in-idr_get_next.patch
idr-make-idr_destroy-imply-idr_remove_all.patch
atm-nicstar-dont-use-idr_remove_all.patch
block-loop-dont-use-idr_remove_all.patch
firewire-dont-use-idr_remove_all.patch
drm-dont-use-idr_remove_all.patch
dm-dont-use-idr_remove_all.patch
remoteproc-dont-use-idr_remove_all.patch
rpmsg-dont-use-idr_remove_all.patch
dlm-use-idr_for_each_entry-in-recover_idr_clear-error-path.patch
dlm-dont-use-idr_remove_all.patch
nfs-idr_destroy-no-longer-needs-idr_remove_all.patch
inotify-dont-use-idr_remove_all.patch
cgroup-dont-use-idr_remove_all.patch
idr-deprecate-idr_remove_all.patch
idr-cosmetic-updates-to-struct-initializer-definitions.patch
idr-relocate-idr_for_each_entry-and-reorganize-id_get_new.patch
idr-remove-_idr_rc_to_errno-hack.patch
idr-refactor-idr_get_new_above.patch
idr-implement-idr_preload-and-idr_alloc.patch
block-fix-synchronization-and-limit-check-in-blk_alloc_devt.patch
block-convert-to-idr_alloc.patch
block-loop-convert-to-idr_alloc.patch
atm-nicstar-convert-to-idr_alloc.patch
drbd-convert-to-idr_alloc.patch
dca-convert-to-idr_alloc.patch
dmaengine-convert-to-idr_alloc.patch
firewire-add-minor-number-range-check-to-fw_device_init.patch
firewire-convert-to-idr_alloc.patch
gpio-convert-to-idr_alloc.patch
drm-convert-to-idr_alloc.patch
drm-exynos-convert-to-idr_alloc.patch
drm-i915-convert-to-idr_alloc.patch
drm-sis-convert-to-idr_alloc.patch
drm-via-convert-to-idr_alloc.patch
drm-vmwgfx-convert-to-idr_alloc.patch
i2c-convert-to-idr_alloc.patch
ib-core-convert-to-idr_alloc.patch
ib-amso1100-convert-to-idr_alloc.patch
ib-cxgb3-convert-to-idr_alloc.patch
ib-cxgb4-convert-to-idr_alloc.patch
ib-ehca-convert-to-idr_alloc.patch
ib-ipath-convert-to-idr_alloc.patch
ib-mlx4-convert-to-idr_alloc.patch
ib-ocrdma-convert-to-idr_alloc.patch
ib-qib-convert-to-idr_alloc.patch
dm-convert-to-idr_alloc.patch
memstick-convert-to-idr_alloc.patch
mfd-convert-to-idr_alloc.patch
misc-c2port-convert-to-idr_alloc.patch
misc-tifm_core-convert-to-idr_alloc.patch
mmc-convert-to-idr_alloc.patch
mtd-convert-to-idr_alloc.patch
macvtap-convert-to-idr_alloc.patch
ppp-convert-to-idr_alloc.patch
power-convert-to-idr_alloc.patch
pps-convert-to-idr_alloc.patch
remoteproc-convert-to-idr_alloc.patch
rpmsg-convert-to-idr_alloc.patch
scsi-bfa-convert-to-idr_alloc.patch
scsi-convert-to-idr_alloc.patch
target-iscsi-convert-to-idr_alloc.patch
scsi-lpfc-convert-to-idr_alloc.patch
thermal-convert-to-idr_alloc.patch
uio-convert-to-idr_alloc.patch
vfio-convert-to-idr_alloc.patch
dlm-convert-to-idr_alloc.patch
inotify-convert-to-idr_alloc.patch
ocfs2-convert-to-idr_alloc.patch
ipc-convert-to-idr_alloc.patch
cgroup-convert-to-idr_alloc.patch
events-convert-to-idr_alloc.patch
posix-timers-convert-to-idr_alloc.patch
net-9p-convert-to-idr_alloc.patch
mac80211-convert-to-idr_alloc.patch
sctp-convert-to-idr_alloc.patch
nfs4client-convert-to-idr_alloc.patch


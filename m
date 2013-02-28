From: akpm@linux-foundation.org
Subject: [merged] ib-mlx4-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:14:21 -0800
Message-ID: <20130228201421.C15EA31C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:61217 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757903Ab3B1UOW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:14:22 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so246688yhr.0
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:14:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, jackm@dev.mellanox.co.il, ogerlitz@mellanox.com, roland@purestorage.com, mm-commits@vger.kernel.org


The patch titled
     Subject: IB/mlx4: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     ib-mlx4-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: IB/mlx4: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jack Morgenstein <jackm@dev.mellanox.co.il>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Roland Dreier <roland@purestorage.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/mlx4/cm.c |   32 ++++++++++++++----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff -puN drivers/infiniband/hw/mlx4/cm.c~ib-mlx4-convert-to-idr_alloc drivers/infiniband/hw/mlx4/cm.c
--- a/drivers/infiniband/hw/mlx4/cm.c~ib-mlx4-convert-to-idr_alloc
+++ a/drivers/infiniband/hw/mlx4/cm.c
@@ -203,7 +203,7 @@ static void sl_id_map_add(struct ib_devi
 static struct id_map_entry *
 id_map_alloc(struct ib_device *ibdev, int slave_id, u32 sl_cm_id)
 {
-	int ret, id;
+	int ret;
 	static int next_id;
 	struct id_map_entry *ent;
 	struct mlx4_ib_sriov *sriov = &to_mdev(ibdev)->sriov;
@@ -220,25 +220,23 @@ id_map_alloc(struct ib_device *ibdev, in
 	ent->dev = to_mdev(ibdev);
 	INIT_DELAYED_WORK(&ent->timeout, id_map_ent_timeout);
 
-	do {
-		spin_lock(&to_mdev(ibdev)->sriov.id_map_lock);
-		ret = idr_get_new_above(&sriov->pv_id_table, ent,
-					next_id, &id);
-		if (!ret) {
-			next_id = ((unsigned) id + 1) & MAX_IDR_MASK;
-			ent->pv_cm_id = (u32)id;
-			sl_id_map_add(ibdev, ent);
-		}
+	idr_preload(GFP_KERNEL);
+	spin_lock(&to_mdev(ibdev)->sriov.id_map_lock);
 
-		spin_unlock(&sriov->id_map_lock);
-	} while (ret == -EAGAIN && idr_pre_get(&sriov->pv_id_table, GFP_KERNEL));
-	/*the function idr_get_new_above can return -ENOSPC, so don't insert in that case.*/
-	if (!ret) {
-		spin_lock(&sriov->id_map_lock);
+	ret = idr_alloc(&sriov->pv_id_table, ent, next_id, 0, GFP_NOWAIT);
+	if (ret >= 0) {
+		next_id = ((unsigned)ret + 1) & MAX_IDR_MASK;
+		ent->pv_cm_id = (u32)ret;
+		sl_id_map_add(ibdev, ent);
 		list_add_tail(&ent->list, &sriov->cm_list);
-		spin_unlock(&sriov->id_map_lock);
-		return ent;
 	}
+
+	spin_unlock(&sriov->id_map_lock);
+	idr_preload_end();
+
+	if (ret >= 0)
+		return ent;
+
 	/*error flow*/
 	kfree(ent);
 	mlx4_ib_warn(ibdev, "No more space in the idr (err:0x%x)\n", ret);
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


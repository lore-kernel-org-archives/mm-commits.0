From: akpm@linux-foundation.org
Subject: [merged] drivers-infiniband-hw-mlx4-convert-to-using-idr_alloc_cyclic.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:02:05 -0700
Message-ID: <20130430190205.7E7E85A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:58642 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638Ab3D3TCI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:02:08 -0400
Received: by mail-ve0-f202.google.com with SMTP id ox1so78056veb.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:02:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, jackm@dev.mellanox.co.il, ogerlitz@mellanox.com, roland@purestorage.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/infiniband/hw/mlx4: convert to using idr_alloc_cyclic()
has been removed from the -mm tree.  Its filename was
     drivers-infiniband-hw-mlx4-convert-to-using-idr_alloc_cyclic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jeff Layton <jlayton@redhat.com>
Subject: drivers/infiniband/hw/mlx4: convert to using idr_alloc_cyclic()

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jack Morgenstein <jackm@dev.mellanox.co.il>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Roland Dreier <roland@purestorage.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/mlx4/cm.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/infiniband/hw/mlx4/cm.c~drivers-infiniband-hw-mlx4-convert-to-using-idr_alloc_cyclic drivers/infiniband/hw/mlx4/cm.c
--- a/drivers/infiniband/hw/mlx4/cm.c~drivers-infiniband-hw-mlx4-convert-to-using-idr_alloc_cyclic
+++ a/drivers/infiniband/hw/mlx4/cm.c
@@ -204,7 +204,6 @@ static struct id_map_entry *
 id_map_alloc(struct ib_device *ibdev, int slave_id, u32 sl_cm_id)
 {
 	int ret;
-	static int next_id;
 	struct id_map_entry *ent;
 	struct mlx4_ib_sriov *sriov = &to_mdev(ibdev)->sriov;
 
@@ -223,9 +222,8 @@ id_map_alloc(struct ib_device *ibdev, in
 	idr_preload(GFP_KERNEL);
 	spin_lock(&to_mdev(ibdev)->sriov.id_map_lock);
 
-	ret = idr_alloc(&sriov->pv_id_table, ent, next_id, 0, GFP_NOWAIT);
+	ret = idr_alloc_cyclic(&sriov->pv_id_table, ent, 0, 0, GFP_NOWAIT);
 	if (ret >= 0) {
-		next_id = max(ret + 1, 0);
 		ent->pv_cm_id = (u32)ret;
 		sl_id_map_add(ibdev, ent);
 		list_add_tail(&ent->list, &sriov->cm_list);
_

Patches currently in -mm which might be from jlayton@redhat.com are

origin.patch
linux-next.patch


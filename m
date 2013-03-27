From: akpm@linux-foundation.org
Subject: + drivers-infiniband-hw-mlx4-convert-to-using-idr_alloc_cyclic.patch added to -mm tree
Date: Wed, 27 Mar 2013 13:22:15 -0700
Message-ID: <20130327202215.CC8345A403C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:38067 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452Ab3C0UWR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Mar 2013 16:22:17 -0400
Received: by mail-ye0-f202.google.com with SMTP id l8so345539yen.1
        for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2013 13:22:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlayton@redhat.com, jackm@dev.mellanox.co.il, ogerlitz@mellanox.com, roland@purestorage.com, tj@kernel.org


The patch titled
     Subject: drivers/infiniband/hw/mlx4: convert to using idr_alloc_cyclic()
has been added to the -mm tree.  Its filename is
     drivers-infiniband-hw-mlx4-convert-to-using-idr_alloc_cyclic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
idr-introduce-idr_alloc_cyclic.patch
drivers-infiniband-hw-amso1100-convert-to-using-idr_alloc_cyclic.patch
drivers-infiniband-hw-mlx4-convert-to-using-idr_alloc_cyclic.patch
nfsd-convert-nfs4_alloc_stid-to-use-idr_alloc_cyclic.patch
inotify-convert-inotify_add_to_idr-to-use-idr_alloc_cyclic.patch
sctp-convert-sctp_assoc_set_id-to-use-idr_alloc_cyclic.patch


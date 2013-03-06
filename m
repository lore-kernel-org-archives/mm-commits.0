From: akpm@linux-foundation.org
Subject: + infiniband-rename-random32-to-prandom_u32.patch added to -mm tree
Date: Tue, 05 Mar 2013 17:02:05 -0800
Message-ID: <20130306010205.D41AD5A41EB@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:52794 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab3CFBCH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Mar 2013 20:02:07 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so809133ghb.3
        for <mm-commits@vger.kernel.org>; Tue, 05 Mar 2013 17:02:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, hal.rosenstock@gmail.com, roland@kernel.org, sean.hefty@intel.com, swise@opengridcomputing.com


The patch titled
     Subject: infiniband: rename random32() to prandom_u32()
has been added to the -mm tree.  Its filename is
     infiniband-rename-random32-to-prandom_u32.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: infiniband: rename random32() to prandom_u32()

Use preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reviewed-by: Steve Wise <swise@opengridcomputing.com>
Cc: Roland Dreier <roland@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Reviewed-by: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/cxgb3/cxio_resource.c |    4 ++--
 drivers/infiniband/hw/cxgb4/id_table.c      |    4 ++--
 drivers/infiniband/hw/mlx4/mad.c            |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c     |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/infiniband/hw/cxgb3/cxio_resource.c~infiniband-rename-random32-to-prandom_u32 drivers/infiniband/hw/cxgb3/cxio_resource.c
--- a/drivers/infiniband/hw/cxgb3/cxio_resource.c~infiniband-rename-random32-to-prandom_u32
+++ a/drivers/infiniband/hw/cxgb3/cxio_resource.c
@@ -62,13 +62,13 @@ static int __cxio_init_resource_fifo(str
 		kfifo_in(fifo, (unsigned char *) &entry, sizeof(u32));
 	if (random) {
 		j = 0;
-		random_bytes = random32();
+		random_bytes = prandom_u32();
 		for (i = 0; i < RANDOM_SIZE; i++)
 			rarray[i] = i + skip_low;
 		for (i = skip_low + RANDOM_SIZE; i < nr - skip_high; i++) {
 			if (j >= RANDOM_SIZE) {
 				j = 0;
-				random_bytes = random32();
+				random_bytes = prandom_u32();
 			}
 			idx = (random_bytes >> (j * 2)) & 0xF;
 			kfifo_in(fifo,
diff -puN drivers/infiniband/hw/cxgb4/id_table.c~infiniband-rename-random32-to-prandom_u32 drivers/infiniband/hw/cxgb4/id_table.c
--- a/drivers/infiniband/hw/cxgb4/id_table.c~infiniband-rename-random32-to-prandom_u32
+++ a/drivers/infiniband/hw/cxgb4/id_table.c
@@ -54,7 +54,7 @@ u32 c4iw_id_alloc(struct c4iw_id_table *
 
 	if (obj < alloc->max) {
 		if (alloc->flags & C4IW_ID_TABLE_F_RANDOM)
-			alloc->last += random32() % RANDOM_SKIP;
+			alloc->last += prandom_u32() % RANDOM_SKIP;
 		else
 			alloc->last = obj + 1;
 		if (alloc->last >= alloc->max)
@@ -88,7 +88,7 @@ int c4iw_id_table_alloc(struct c4iw_id_t
 	alloc->start = start;
 	alloc->flags = flags;
 	if (flags & C4IW_ID_TABLE_F_RANDOM)
-		alloc->last = random32() % RANDOM_SKIP;
+		alloc->last = prandom_u32() % RANDOM_SKIP;
 	else
 		alloc->last = 0;
 	alloc->max  = num;
diff -puN drivers/infiniband/hw/mlx4/mad.c~infiniband-rename-random32-to-prandom_u32 drivers/infiniband/hw/mlx4/mad.c
--- a/drivers/infiniband/hw/mlx4/mad.c~infiniband-rename-random32-to-prandom_u32
+++ a/drivers/infiniband/hw/mlx4/mad.c
@@ -93,7 +93,7 @@ static void __propagate_pkey_ev(struct m
 __be64 mlx4_ib_gen_node_guid(void)
 {
 #define NODE_GUID_HI	((u64) (((u64)IB_OPENIB_OUI) << 40))
-	return cpu_to_be64(NODE_GUID_HI | random32());
+	return cpu_to_be64(NODE_GUID_HI | prandom_u32());
 }
 
 __be64 mlx4_ib_get_new_demux_tid(struct mlx4_ib_demux_ctx *ctx)
diff -puN drivers/infiniband/ulp/ipoib/ipoib_cm.c~infiniband-rename-random32-to-prandom_u32 drivers/infiniband/ulp/ipoib/ipoib_cm.c
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c~infiniband-rename-random32-to-prandom_u32
+++ a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -460,7 +460,7 @@ static int ipoib_cm_req_handler(struct i
 		goto err_qp;
 	}
 
-	psn = random32() & 0xffffff;
+	psn = prandom_u32() & 0xffffff;
 	ret = ipoib_cm_modify_rx_qp(dev, cm_id, p->qp, psn);
 	if (ret)
 		goto err_modify;
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
raid6test-use-prandom_bytes.patch
uuid-use-prandom_bytes.patch
x86-pageattr-test-remove-srandom32-call.patch
x86-rename-random32-to-prandom_u32.patch
lib-rename-random32-to-prandom_u32.patch
mm-rename-random32-to-prandom_u32.patch
kernel-rename-random32-to-prandom_u32.patch
drbd-rename-random32-to-prandom_u32.patch
infiniband-rename-random32-to-prandom_u32.patch
mmc-rename-random32-to-prandom_u32.patch
video-uvesafb-rename-random32-to-prandom_u32.patch
xfs-rename-random32-to-prandom_u32.patch
uwb-rename-random32-to-prandom_u32.patch
lguest-rename-random32-to-prandom_u32.patch
scsi-rename-random32-to-prandom_u32.patch
drivers-net-rename-random32-to-prandom_u32.patch
net-sunrpc-rename-random32-to-prandom_u32.patch
net-sched-rename-random32-to-prandom_u32.patch
net-netfilter-rename-random32-to-prandom_u32.patch
net-core-rename-random32-to-prandom_u32.patch
net-core-remove-duplicate-statements-by-do-while-loop.patch
net-rename-random32-to-prandom.patch
remove-unused-random32-and-srandom32.patch


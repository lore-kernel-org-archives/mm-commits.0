From: akpm@linux-foundation.org
Subject: [merged] drivers-infiniband-hw-mlx4-madc-rename-random32-to-prandom_u32.patch removed from -mm tree
Date: Wed, 08 May 2013 11:34:40 -0700
Message-ID: <20130508183440.6F22B5A415E@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:34253 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758216Ab3EHSel (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 14:34:41 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so207913ggm.1
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 11:34:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/infiniband/hw: rename random32() to prandom_u32()
has been removed from the -mm tree.  Its filename was
     drivers-infiniband-hw-mlx4-madc-rename-random32-to-prandom_u32.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/infiniband/hw: rename random32() to prandom_u32()

Use preferable function name which implies using a pseudo-random
number generator.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/cxgb3/cxio_resource.c |    4 ++--
 drivers/infiniband/hw/cxgb4/id_table.c      |    4 ++--
 drivers/infiniband/hw/mlx4/mad.c            |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c     |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/infiniband/hw/cxgb3/cxio_resource.c~drivers-infiniband-hw-mlx4-madc-rename-random32-to-prandom_u32 drivers/infiniband/hw/cxgb3/cxio_resource.c
--- a/drivers/infiniband/hw/cxgb3/cxio_resource.c~drivers-infiniband-hw-mlx4-madc-rename-random32-to-prandom_u32
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
diff -puN drivers/infiniband/hw/cxgb4/id_table.c~drivers-infiniband-hw-mlx4-madc-rename-random32-to-prandom_u32 drivers/infiniband/hw/cxgb4/id_table.c
--- a/drivers/infiniband/hw/cxgb4/id_table.c~drivers-infiniband-hw-mlx4-madc-rename-random32-to-prandom_u32
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
diff -puN drivers/infiniband/hw/mlx4/mad.c~drivers-infiniband-hw-mlx4-madc-rename-random32-to-prandom_u32 drivers/infiniband/hw/mlx4/mad.c
--- a/drivers/infiniband/hw/mlx4/mad.c~drivers-infiniband-hw-mlx4-madc-rename-random32-to-prandom_u32
+++ a/drivers/infiniband/hw/mlx4/mad.c
@@ -93,7 +93,7 @@ static void __propagate_pkey_ev(struct m
 __be64 mlx4_ib_gen_node_guid(void)
 {
 #define NODE_GUID_HI	((u64) (((u64)IB_OPENIB_OUI) << 40))
-	return cpu_to_be64(NODE_GUID_HI | random32());
+	return cpu_to_be64(NODE_GUID_HI | prandom_u32());
 }
 
 __be64 mlx4_ib_get_new_demux_tid(struct mlx4_ib_demux_ctx *ctx)
diff -puN drivers/infiniband/ulp/ipoib/ipoib_cm.c~drivers-infiniband-hw-mlx4-madc-rename-random32-to-prandom_u32 drivers/infiniband/ulp/ipoib/ipoib_cm.c
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c~drivers-infiniband-hw-mlx4-madc-rename-random32-to-prandom_u32
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

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
drivers-video-implement-a-simple-framebuffer-driver.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
clear_refs-sanitize-accepted-commands-declaration.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
generic-dynamic-per-cpu-refcounting.patch
block-prep-work-for-batch-completion.patch
block-prep-work-for-batch-completion-fix-2.patch
block-prep-work-for-batch-completion-fix-3.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-prep-work-for-batch-completion-fix-99.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
bpf-add-comments-explaining-the-schedule_work-operation.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


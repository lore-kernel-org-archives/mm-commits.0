From: akpm@linux-foundation.org
Subject: [folded] sgi-xpc-fails-to-load-when-cpu-0-is-out-of-irq-resources-v2.patch removed from -mm tree
Date: Tue, 21 Aug 2012 16:12:04 -0700
Message-ID: <20120821231205.1100820004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:49248 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab2HUXMH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Aug 2012 19:12:07 -0400
Received: by wgbdt11 with SMTP id dt11so11238wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 21 Aug 2012 16:12:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holt@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: SGI XPC fails to load when cpu 0 is out of IRQ resources.  -v2
has been removed from the -mm tree.  Its filename was
     sgi-xpc-fails-to-load-when-cpu-0-is-out-of-irq-resources-v2.patch

This patch was dropped because it was folded into sgi-xpc-fails-to-load-when-cpu-0-is-out-of-irq-resources.patch

------------------------------------------------------
From: Robin Holt <holt@sgi.com>
Subject: SGI XPC fails to load when cpu 0 is out of IRQ resources.  -v2

incorporate review comments from Andrew Morton.

Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xpc_uv.c |   30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff -puN drivers/misc/sgi-xp/xpc_uv.c~sgi-xpc-fails-to-load-when-cpu-0-is-out-of-irq-resources-v2 drivers/misc/sgi-xp/xpc_uv.c
--- a/drivers/misc/sgi-xp/xpc_uv.c~sgi-xpc-fails-to-load-when-cpu-0-is-out-of-irq-resources-v2
+++ a/drivers/misc/sgi-xp/xpc_uv.c
@@ -111,9 +111,8 @@ xpc_get_gru_mq_irq_uv(struct xpc_gru_mq_
 #if defined CONFIG_X86_64
 	mq->irq = uv_setup_irq(irq_name, cpu, mq->mmr_blade, mq->mmr_offset,
 			UV_AFFINITY_CPU);
-	if (mq->irq < 0) {
+	if (mq->irq < 0)
 		return mq->irq;
-	}
 
 	mq->mmr_value = uv_read_global_mmr64(mmr_pnode, mq->mmr_offset);
 
@@ -238,8 +237,9 @@ xpc_create_gru_mq_uv(unsigned int mq_siz
 	mq->mmr_blade = uv_cpu_to_blade_id(cpu);
 
 	nid = cpu_to_node(cpu);
-	page = alloc_pages_exact_node(nid, GFP_KERNEL | __GFP_ZERO | GFP_THISNODE,
-				pg_order);
+	page = alloc_pages_exact_node(nid,
+				      GFP_KERNEL | __GFP_ZERO | GFP_THISNODE,
+				      pg_order);
 	if (page == NULL) {
 		dev_err(xpc_part, "xpc_create_gru_mq_uv() failed to alloc %d "
 			"bytes of memory on nid=%d for GRU mq\n", mq_size, nid);
@@ -1736,28 +1736,36 @@ xpc_init_mq_node(int nid)
 {
 	int cpu;
 
+	get_online_cpus();
+
 	for_each_cpu(cpu, cpumask_of_node(nid)) {
-		xpc_activate_mq_uv = xpc_create_gru_mq_uv(XPC_ACTIVATE_MQ_SIZE_UV, nid,
-							  XPC_ACTIVATE_IRQ_NAME,
-							  xpc_handle_activate_IRQ_uv);
+		xpc_activate_mq_uv =
+			xpc_create_gru_mq_uv(XPC_ACTIVATE_MQ_SIZE_UV, nid,
+					     XPC_ACTIVATE_IRQ_NAME,
+					     xpc_handle_activate_IRQ_uv);
 		if (!IS_ERR(xpc_activate_mq_uv))
 			break;
 	}
-	if (IS_ERR(xpc_activate_mq_uv))
+	if (IS_ERR(xpc_activate_mq_uv)) {
+		put_online_cpus();
 		return PTR_ERR(xpc_activate_mq_uv);
+	}
 
 	for_each_cpu(cpu, cpumask_of_node(nid)) {
-		xpc_notify_mq_uv = xpc_create_gru_mq_uv(XPC_NOTIFY_MQ_SIZE_UV, nid,
-							XPC_NOTIFY_IRQ_NAME,
-							xpc_handle_notify_IRQ_uv);
+		xpc_notify_mq_uv =
+			xpc_create_gru_mq_uv(XPC_NOTIFY_MQ_SIZE_UV, nid,
+					     XPC_NOTIFY_IRQ_NAME,
+					     xpc_handle_notify_IRQ_uv);
 		if (!IS_ERR(xpc_notify_mq_uv))
 			break;
 	}
 	if (IS_ERR(xpc_notify_mq_uv)) {
 		xpc_destroy_gru_mq_uv(xpc_activate_mq_uv);
+		put_online_cpus();
 		return PTR_ERR(xpc_notify_mq_uv);
 	}
 
+	put_online_cpus();
 	return 0;
 }
 
_

Patches currently in -mm which might be from holt@sgi.com are

sgi-xpc-fails-to-load-when-cpu-0-is-out-of-irq-resources.patch
sgi-xpc-fails-to-load-when-cpu-0-is-out-of-irq-resources-v2-fix.patch


From: akpm@linux-foundation.org
Subject: [merged] sgi-xpc-fails-to-load-when-cpu-0-is-out-of-irq-resources.patch removed from -mm tree
Date: Fri, 24 Aug 2012 11:41:31 -0700
Message-ID: <20120824184132.146A95C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:63176 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756646Ab2HXSld (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Aug 2012 14:41:33 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so107304wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Aug 2012 11:41:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holt@sgi.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/misc/sgi-xp/xpc_uv.c: SGI XPC fails to load when cpu 0 is out of IRQ resources
has been removed from the -mm tree.  Its filename was
     sgi-xpc-fails-to-load-when-cpu-0-is-out-of-irq-resources.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Robin Holt <holt@sgi.com>
Subject: drivers/misc/sgi-xp/xpc_uv.c: SGI XPC fails to load when cpu 0 is out of IRQ resources

On many of our larger systems, CPU 0 has had all of its IRQ resources
consumed before XPC loads.  Worst cases on machines with multiple 10 GigE
cards and multiple IB cards have depleted the entire first socket of IRQs.
 This patch makes selecting the node upon which IRQs are allocated (as
well as all the other GRU Message Queue structures) specifiable as a
module load param and has a default behavior of searching all nodes/cpus
for an available resources.

[akpm@linux-foundation.org: fix build: include cpu.h and module.h]
Signed-off-by: Robin Holt <holt@sgi.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xpc_uv.c |   84 +++++++++++++++++++++++++--------
 1 file changed, 65 insertions(+), 19 deletions(-)

diff -puN drivers/misc/sgi-xp/xpc_uv.c~sgi-xpc-fails-to-load-when-cpu-0-is-out-of-irq-resources drivers/misc/sgi-xp/xpc_uv.c
--- a/drivers/misc/sgi-xp/xpc_uv.c~sgi-xpc-fails-to-load-when-cpu-0-is-out-of-irq-resources
+++ a/drivers/misc/sgi-xp/xpc_uv.c
@@ -18,6 +18,8 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/device.h>
+#include <linux/cpu.h>
+#include <linux/module.h>
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <asm/uv/uv_hub.h>
@@ -59,6 +61,8 @@ static struct xpc_heartbeat_uv *xpc_hear
 					 XPC_NOTIFY_MSG_SIZE_UV)
 #define XPC_NOTIFY_IRQ_NAME		"xpc_notify"
 
+static int xpc_mq_node = -1;
+
 static struct xpc_gru_mq_uv *xpc_activate_mq_uv;
 static struct xpc_gru_mq_uv *xpc_notify_mq_uv;
 
@@ -109,11 +113,8 @@ xpc_get_gru_mq_irq_uv(struct xpc_gru_mq_
 #if defined CONFIG_X86_64
 	mq->irq = uv_setup_irq(irq_name, cpu, mq->mmr_blade, mq->mmr_offset,
 			UV_AFFINITY_CPU);
-	if (mq->irq < 0) {
-		dev_err(xpc_part, "uv_setup_irq() returned error=%d\n",
-			-mq->irq);
+	if (mq->irq < 0)
 		return mq->irq;
-	}
 
 	mq->mmr_value = uv_read_global_mmr64(mmr_pnode, mq->mmr_offset);
 
@@ -238,8 +239,9 @@ xpc_create_gru_mq_uv(unsigned int mq_siz
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
@@ -1731,9 +1733,50 @@ static struct xpc_arch_operations xpc_ar
 	.notify_senders_of_disconnect = xpc_notify_senders_of_disconnect_uv,
 };
 
+static int
+xpc_init_mq_node(int nid)
+{
+	int cpu;
+
+	get_online_cpus();
+
+	for_each_cpu(cpu, cpumask_of_node(nid)) {
+		xpc_activate_mq_uv =
+			xpc_create_gru_mq_uv(XPC_ACTIVATE_MQ_SIZE_UV, nid,
+					     XPC_ACTIVATE_IRQ_NAME,
+					     xpc_handle_activate_IRQ_uv);
+		if (!IS_ERR(xpc_activate_mq_uv))
+			break;
+	}
+	if (IS_ERR(xpc_activate_mq_uv)) {
+		put_online_cpus();
+		return PTR_ERR(xpc_activate_mq_uv);
+	}
+
+	for_each_cpu(cpu, cpumask_of_node(nid)) {
+		xpc_notify_mq_uv =
+			xpc_create_gru_mq_uv(XPC_NOTIFY_MQ_SIZE_UV, nid,
+					     XPC_NOTIFY_IRQ_NAME,
+					     xpc_handle_notify_IRQ_uv);
+		if (!IS_ERR(xpc_notify_mq_uv))
+			break;
+	}
+	if (IS_ERR(xpc_notify_mq_uv)) {
+		xpc_destroy_gru_mq_uv(xpc_activate_mq_uv);
+		put_online_cpus();
+		return PTR_ERR(xpc_notify_mq_uv);
+	}
+
+	put_online_cpus();
+	return 0;
+}
+
 int
 xpc_init_uv(void)
 {
+	int nid;
+	int ret = 0;
+
 	xpc_arch_ops = xpc_arch_ops_uv;
 
 	if (sizeof(struct xpc_notify_mq_msghdr_uv) > XPC_MSG_HDR_MAX_SIZE) {
@@ -1742,21 +1785,21 @@ xpc_init_uv(void)
 		return -E2BIG;
 	}
 
-	xpc_activate_mq_uv = xpc_create_gru_mq_uv(XPC_ACTIVATE_MQ_SIZE_UV, 0,
-						  XPC_ACTIVATE_IRQ_NAME,
-						  xpc_handle_activate_IRQ_uv);
-	if (IS_ERR(xpc_activate_mq_uv))
-		return PTR_ERR(xpc_activate_mq_uv);
+	if (xpc_mq_node < 0)
+		for_each_online_node(nid) {
+			ret = xpc_init_mq_node(nid);
 
-	xpc_notify_mq_uv = xpc_create_gru_mq_uv(XPC_NOTIFY_MQ_SIZE_UV, 0,
-						XPC_NOTIFY_IRQ_NAME,
-						xpc_handle_notify_IRQ_uv);
-	if (IS_ERR(xpc_notify_mq_uv)) {
-		xpc_destroy_gru_mq_uv(xpc_activate_mq_uv);
-		return PTR_ERR(xpc_notify_mq_uv);
-	}
+			if (!ret)
+				break;
+		}
+	else
+		ret = xpc_init_mq_node(xpc_mq_node);
 
-	return 0;
+	if (ret < 0)
+		dev_err(xpc_part, "xpc_init_mq_node() returned error=%d\n",
+			-ret);
+
+	return ret;
 }
 
 void
@@ -1765,3 +1808,6 @@ xpc_exit_uv(void)
 	xpc_destroy_gru_mq_uv(xpc_notify_mq_uv);
 	xpc_destroy_gru_mq_uv(xpc_activate_mq_uv);
 }
+
+module_param(xpc_mq_node, int, 0);
+MODULE_PARM_DESC(xpc_mq_node, "Node number on which to allocate message queues.");
_

Patches currently in -mm which might be from holt@sgi.com are

origin.patch


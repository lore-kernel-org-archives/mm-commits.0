From: akpm@linux-foundation.org
Subject: + sgi-xpc-fails-to-load-when-cpu-0-is-out-of-irq-resources.patch added to -mm tree
Date: Wed, 15 Aug 2012 15:56:27 -0700
Message-ID: <20120815225627.B9AFC1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:52621 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab2HOW43 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Aug 2012 18:56:29 -0400
Received: by obbwc20 with SMTP id wc20so1524428obb.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Aug 2012 15:56:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holt@sgi.com


The patch titled
     Subject: drivers/misc/sgi-xp/xpc_uv.c: SGI XPC fails to load when cpu 0 is out of IRQ resources
has been added to the -mm tree.  Its filename is
     sgi-xpc-fails-to-load-when-cpu-0-is-out-of-irq-resources.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Robin Holt <holt@sgi.com>
Subject: drivers/misc/sgi-xp/xpc_uv.c: SGI XPC fails to load when cpu 0 is out of IRQ resources

On many of our larger systems, CPU 0 has had all of its IRQ resources
consumed before XPC loads.  Worse cases on machines with multiple 10 GigE
cards and multiple IB cards have depleted the entire first socket of IRQs.
 That patch makes selecting the node upon which IRQs are allocated (as
well as all the other GRU Message Queue structures) specifiable as a
module load param and has a default behavior of searching all nodes/cpus
for an available resource.

Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xpc_uv.c |   66 +++++++++++++++++++++++++--------
 1 file changed, 51 insertions(+), 15 deletions(-)

diff -puN drivers/misc/sgi-xp/xpc_uv.c~sgi-xpc-fails-to-load-when-cpu-0-is-out-of-irq-resources drivers/misc/sgi-xp/xpc_uv.c
--- a/drivers/misc/sgi-xp/xpc_uv.c~sgi-xpc-fails-to-load-when-cpu-0-is-out-of-irq-resources
+++ a/drivers/misc/sgi-xp/xpc_uv.c
@@ -59,6 +59,8 @@ static struct xpc_heartbeat_uv *xpc_hear
 					 XPC_NOTIFY_MSG_SIZE_UV)
 #define XPC_NOTIFY_IRQ_NAME		"xpc_notify"
 
+static int xpc_mq_node = -1;
+
 static struct xpc_gru_mq_uv *xpc_activate_mq_uv;
 static struct xpc_gru_mq_uv *xpc_notify_mq_uv;
 
@@ -110,8 +112,6 @@ xpc_get_gru_mq_irq_uv(struct xpc_gru_mq_
 	mq->irq = uv_setup_irq(irq_name, cpu, mq->mmr_blade, mq->mmr_offset,
 			UV_AFFINITY_CPU);
 	if (mq->irq < 0) {
-		dev_err(xpc_part, "uv_setup_irq() returned error=%d\n",
-			-mq->irq);
 		return mq->irq;
 	}
 
@@ -1731,9 +1731,42 @@ static struct xpc_arch_operations xpc_ar
 	.notify_senders_of_disconnect = xpc_notify_senders_of_disconnect_uv,
 };
 
+static int
+xpc_init_mq_node(int nid)
+{
+	int cpu;
+
+	for_each_cpu(cpu, cpumask_of_node(nid)) {
+		xpc_activate_mq_uv = xpc_create_gru_mq_uv(XPC_ACTIVATE_MQ_SIZE_UV, nid,
+							  XPC_ACTIVATE_IRQ_NAME,
+							  xpc_handle_activate_IRQ_uv);
+		if (!IS_ERR(xpc_activate_mq_uv))
+			break;
+	}
+	if (IS_ERR(xpc_activate_mq_uv))
+		return PTR_ERR(xpc_activate_mq_uv);
+
+	for_each_cpu(cpu, cpumask_of_node(nid)) {
+		xpc_notify_mq_uv = xpc_create_gru_mq_uv(XPC_NOTIFY_MQ_SIZE_UV, nid,
+							XPC_NOTIFY_IRQ_NAME,
+							xpc_handle_notify_IRQ_uv);
+		if (!IS_ERR(xpc_notify_mq_uv))
+			break;
+	}
+	if (IS_ERR(xpc_notify_mq_uv)) {
+		xpc_destroy_gru_mq_uv(xpc_activate_mq_uv);
+		return PTR_ERR(xpc_notify_mq_uv);
+	}
+
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
@@ -1742,21 +1775,21 @@ xpc_init_uv(void)
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
@@ -1765,3 +1798,6 @@ xpc_exit_uv(void)
 	xpc_destroy_gru_mq_uv(xpc_notify_mq_uv);
 	xpc_destroy_gru_mq_uv(xpc_activate_mq_uv);
 }
+
+module_param(xpc_mq_node, int, 0);
+MODULE_PARM_DESC(xpc_mq_node, "Node number on which to allocate message queues.");
_

Patches currently in -mm which might be from holt@sgi.com are

sgi-xpc-fails-to-load-when-cpu-0-is-out-of-irq-resources.patch


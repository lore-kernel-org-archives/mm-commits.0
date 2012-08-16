From: akpm@linux-foundation.org
Subject: + sgi-xpc-fails-to-load-when-cpu-0-is-out-of-irq-resources-v2.patch added to -mm tree
Date: Thu, 16 Aug 2012 11:02:49 -0700
Message-ID: <20120816180250.97E025C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:34656 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab2HPSCw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Aug 2012 14:02:52 -0400
Received: by weyr1 with SMTP id r1so147178wey.1
        for <mm-commits@vger.kernel.org>; Thu, 16 Aug 2012 11:02:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holt@sgi.com


The patch titled
     Subject: SGI XPC fails to load when cpu 0 is out of IRQ resources.  -v2
has been added to the -mm tree.  Its filename is
     sgi-xpc-fails-to-load-when-cpu-0-is-out-of-irq-resources-v2.patch

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
sgi-xpc-fails-to-load-when-cpu-0-is-out-of-irq-resources-v2.patch


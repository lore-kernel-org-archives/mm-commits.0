From: akpm@linux-foundation.org
Subject: - ucc_geth-add-support-for-netpoll.patch removed from -mm tree
Date: Sun, 03 Feb 2008 12:22:29 -0800
Message-ID: <200802032022.m13KMATp029991@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38806 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752191AbYBCUW2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 3 Feb 2008 15:22:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, mm-commits@vger.kernel.org


The patch titled
     ucc_geth: add support for netpoll
has been removed from the -mm tree.  Its filename was
     ucc_geth-add-support-for-netpoll.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ucc_geth: add support for netpoll
From: Anton Vorontsov <avorontsov@ru.mvista.com>

Add netpoll support for the QE UCC Gigabit Ethernet driver.  The approach is
very similar to the gianfar driver.

Tested using netconsole.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ucc_geth.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff -puN drivers/net/ucc_geth.c~ucc_geth-add-support-for-netpoll drivers/net/ucc_geth.c
--- a/drivers/net/ucc_geth.c~ucc_geth-add-support-for-netpoll
+++ a/drivers/net/ucc_geth.c
@@ -3666,6 +3666,22 @@ static irqreturn_t ucc_geth_irq_handler(
 	return IRQ_HANDLED;
 }
 
+#ifdef CONFIG_NET_POLL_CONTROLLER
+/*
+ * Polling 'interrupt' - used by things like netconsole to send skbs
+ * without having to re-enable interrupts. It's not called while
+ * the interrupt routine is executing.
+ */
+static void ucc_netpoll(struct net_device *dev)
+{
+	struct ucc_geth_private *ugeth = netdev_priv(dev);
+
+	disable_irq(ugeth->ug_info->uf_info.irq);
+	ucc_geth_irq_handler(ugeth->ug_info->uf_info.irq, dev);
+	enable_irq(ugeth->ug_info->uf_info.irq);
+}
+#endif /* CONFIG_NET_POLL_CONTROLLER */
+
 /* Called when something needs to use the ethernet device */
 /* Returns 0 for success. */
 static int ucc_geth_open(struct net_device *dev)
@@ -4008,6 +4024,9 @@ static int ucc_geth_probe(struct of_devi
 #ifdef CONFIG_UGETH_NAPI
 	netif_napi_add(dev, &ugeth->napi, ucc_geth_poll, UCC_GETH_DEV_WEIGHT);
 #endif				/* CONFIG_UGETH_NAPI */
+#ifdef CONFIG_NET_POLL_CONTROLLER
+	dev->poll_controller = ucc_netpoll;
+#endif
 	dev->stop = ucc_geth_close;
 //    dev->change_mtu = ucc_geth_change_mtu;
 	dev->mtu = 1500;
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
git-net.patch

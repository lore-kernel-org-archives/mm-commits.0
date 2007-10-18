From: akpm@linux-foundation.org
Subject: + ucc_geth-add-support-for-netpoll.patch added to -mm tree
Date: Wed, 17 Oct 2007 21:02:23 -0700
Message-ID: <200710180402.l9I42Nfb024338@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60720 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750782AbXJRECe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 00:02:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com


The patch titled
     ucc_geth: add support for netpoll
has been added to the -mm tree.  Its filename is
     ucc_geth-add-support-for-netpoll.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -3676,6 +3676,22 @@ static irqreturn_t ucc_geth_irq_handler(
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
@@ -3965,6 +3981,9 @@ static int ucc_geth_probe(struct of_devi
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
ucc_geth-fix-module-removal.patch
ucc_geth-add-support-for-netpoll.patch
phy-implement-release-function.patch

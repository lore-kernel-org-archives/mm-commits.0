From: akpm@linux-foundation.org
Subject: - uml-correctly-handle-skb-allocation-failures.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:39:07 -0700
Message-ID: <200710162039.l9GKd7T8015516@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56009 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936131AbXJPVHv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: correctly handle skb allocation failures
has been removed from the -mm tree.  Its filename was
     uml-correctly-handle-skb-allocation-failures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: correctly handle skb allocation failures
From: Jeff Dike <jdike@addtoit.com>

Handle memory allocation failures when reading packets.

We have to read something from the host, even if we can't allocate any
memory.  If we don't, the host side of the device may fill up and stop
delivering interrupts because no new packets can be queued.

A single sk_buff is allocated whenever an MTU is seen which is larger
than any seen earlier.  This is used to read packets if there is a
memory allocation failure.

The large MTU check is done from eth_configure, which is called when a
interface is added to the system.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/net_kern.c |   47 +++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff -puN arch/um/drivers/net_kern.c~uml-correctly-handle-skb-allocation-failures arch/um/drivers/net_kern.c
--- a/arch/um/drivers/net_kern.c~uml-correctly-handle-skb-allocation-failures
+++ a/arch/um/drivers/net_kern.c
@@ -34,6 +34,46 @@ static inline void set_ether_mac(struct 
 static DEFINE_SPINLOCK(opened_lock);
 static LIST_HEAD(opened);
 
+/*
+ * The drop_skb is used when we can't allocate an skb.  The
+ * packet is read into drop_skb in order to get the data off the
+ * connection to the host.
+ * It is reallocated whenever a maximum packet size is seen which is
+ * larger than any seen before.  update_drop_skb is called from
+ * eth_configure when a new interface is added.
+ */
+static DEFINE_SPINLOCK(drop_lock);
+static struct sk_buff *drop_skb;
+static int drop_max;
+
+static int update_drop_skb(int max)
+{
+	struct sk_buff *new;
+	unsigned long flags;
+	int err = 0;
+
+	spin_lock_irqsave(&drop_lock, flags);
+
+	if (max <= drop_max)
+		goto out;
+
+	err = -ENOMEM;
+	new = dev_alloc_skb(max);
+	if (new == NULL)
+		goto out;
+
+	skb_put(new, max);
+
+	kfree_skb(drop_skb);
+	drop_skb = new;
+	drop_max = max;
+	err = 0;
+out:
+	spin_unlock_irqrestore(&drop_lock, flags);
+
+	return err;
+}
+
 static int uml_net_rx(struct net_device *dev)
 {
 	struct uml_net_private *lp = dev->priv;
@@ -43,6 +83,9 @@ static int uml_net_rx(struct net_device 
 	/* If we can't allocate memory, try again next round. */
 	skb = dev_alloc_skb(lp->max_packet);
 	if (skb == NULL) {
+		drop_skb->dev = dev;
+		/* Read a packet into drop_skb and don't do anything with it. */
+		(*lp->read)(lp->fd, drop_skb, lp);
 		lp->stats.rx_dropped++;
 		return 0;
 	}
@@ -447,6 +490,10 @@ static void eth_configure(int n, void *i
 	dev->watchdog_timeo = (HZ >> 1);
 	dev->irq = UM_ETH_IRQ;
 
+	err = update_drop_skb(lp->max_packet);
+	if (err)
+		goto out_undo_user_init;
+
 	rtnl_lock();
 	err = register_netdevice(dev);
 	rtnl_unlock();
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch
bitops-introduce-lock-ops.patch

From: akpm@linux-foundation.org
Subject: + rapidio-rionet-rework-driver-initialization-and-removal.patch
 added to -mm tree
Date: Fri, 28 Jun 2013 14:19:35 -0700
Message-ID: <51cdfde7.puzVqHB7GOYRHO6V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51737 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab3F1VTg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jun 2013 17:19:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stef.van.os@Prodrive.nl, mporter@kernel.crashing.org, micha.nelissen@Prodrive.nl, leoli@freescale.com, jdelvare@suse.de, galak@kernel.crashing.org, davem@davemloft.net, andre.van.herk@Prodrive.nl, alexandre.bounine@idt.com

Subject: + rapidio-rionet-rework-driver-initialization-and-removal.patch added to -mm tree
To: alexandre.bounine@idt.com,andre.van.herk@Prodrive.nl,davem@davemloft.net,galak@kernel.crashing.org,jdelvare@suse.de,leoli@freescale.com,micha.nelissen@Prodrive.nl,mporter@kernel.crashing.org,stef.van.os@Prodrive.nl
From: akpm@linux-foundation.org
Date: Fri, 28 Jun 2013 14:19:35 -0700


The patch titled
     Subject: rapidio/rionet: rework driver initialization and removal
has been added to the -mm tree.  Its filename is
     rapidio-rionet-rework-driver-initialization-and-removal.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio/rionet: rework driver initialization and removal

Rework probe/remove routines to prevent rionet driver from monopolizing
target RapidIO devices.  Fix conflict with modular RapidIO switch drivers.

Using one of RapidIO messaging channels rionet driver provides a service
layer common to all endpoint devices in a system's RapidIO network.  These
devices may also require their own specific device driver which will be
blocked from attaching to the target device by rionet (or block rionet if
loaded earlier).  To avoid conflict with device-specific drivers, the
rionet driver is reworked to be registered as a subsystem interface on the
RapidIO bus.

The reworked rio_remove_dev() and rionet_exit() routines also include
handling of individual rionet peer device removal which was not supported
before.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andre van Herk <andre.van.herk@Prodrive.nl>
Cc: Micha Nelissen <micha.nelissen@Prodrive.nl>
Cc: Stef van Os <stef.van.os@Prodrive.nl>
Cc: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/rionet.c |  103 +++++++++++++++++++++++++++++++----------
 1 file changed, 78 insertions(+), 25 deletions(-)

diff -puN drivers/net/rionet.c~rapidio-rionet-rework-driver-initialization-and-removal drivers/net/rionet.c
--- a/drivers/net/rionet.c~rapidio-rionet-rework-driver-initialization-and-removal
+++ a/drivers/net/rionet.c
@@ -208,6 +208,17 @@ static int rionet_start_xmit(struct sk_b
 		if (nets[rnet->mport->id].active[destid])
 			rionet_queue_tx_msg(skb, ndev,
 					nets[rnet->mport->id].active[destid]);
+		else {
+			/*
+			 * If the target device was removed from the list of
+			 * active peers but we still have TX packets targeting
+			 * it just report sending a packet to the target
+			 * (without actual packet transfer).
+			 */
+			dev_kfree_skb_any(skb);
+			ndev->stats.tx_packets++;
+			ndev->stats.tx_bytes += skb->len;
+		}
 	}
 
 	spin_unlock_irqrestore(&rnet->tx_lock, flags);
@@ -385,24 +396,28 @@ static int rionet_close(struct net_devic
 	return 0;
 }
 
-static void rionet_remove(struct rio_dev *rdev)
+static int rionet_remove_dev(struct device *dev, struct subsys_interface *sif)
 {
-	struct net_device *ndev = rio_get_drvdata(rdev);
+	struct rio_dev *rdev = to_rio_dev(dev);
 	unsigned char netid = rdev->net->hport->id;
 	struct rionet_peer *peer, *tmp;
 
-	unregister_netdev(ndev);
+	if (dev_rionet_capable(rdev)) {
+		list_for_each_entry_safe(peer, tmp, &nets[netid].peers, node) {
+			if (peer->rdev == rdev) {
+				if (nets[netid].active[rdev->destid]) {
+					nets[netid].active[rdev->destid] = NULL;
+					nets[netid].nact--;
+				}
 
-	free_pages((unsigned long)nets[netid].active, get_order(sizeof(void *) *
-			RIO_MAX_ROUTE_ENTRIES(rdev->net->hport->sys_size)));
-	nets[netid].active = NULL;
-
-	list_for_each_entry_safe(peer, tmp, &nets[netid].peers, node) {
-		list_del(&peer->node);
-		kfree(peer);
+				list_del(&peer->node);
+				kfree(peer);
+				break;
+			}
+		}
 	}
 
-	free_netdev(ndev);
+	return 0;
 }
 
 static void rionet_get_drvinfo(struct net_device *ndev,
@@ -503,12 +518,13 @@ static int rionet_setup_netdev(struct ri
 
 static unsigned long net_table[RIONET_MAX_NETS/sizeof(unsigned long) + 1];
 
-static int rionet_probe(struct rio_dev *rdev, const struct rio_device_id *id)
+static int rionet_add_dev(struct device *dev, struct subsys_interface *sif)
 {
 	int rc = -ENODEV;
 	u32 lsrc_ops, ldst_ops;
 	struct rionet_peer *peer;
 	struct net_device *ndev = NULL;
+	struct rio_dev *rdev = to_rio_dev(dev);
 	unsigned char netid = rdev->net->hport->id;
 	int oldnet;
 
@@ -518,8 +534,9 @@ static int rionet_probe(struct rio_dev *
 	oldnet = test_and_set_bit(netid, net_table);
 
 	/*
-	 * First time through, make sure local device is rionet
-	 * capable, setup netdev (will be skipped on later probes)
+	 * If first time through this net, make sure local device is rionet
+	 * capable and setup netdev (this step will be skipped in later probes
+	 * on the same net).
 	 */
 	if (!oldnet) {
 		rio_local_read_config_32(rdev->net->hport, RIO_SRC_OPS_CAR,
@@ -541,6 +558,12 @@ static int rionet_probe(struct rio_dev *
 		}
 		nets[netid].ndev = ndev;
 		rc = rionet_setup_netdev(rdev->net->hport, ndev);
+		if (rc) {
+			printk(KERN_ERR "%s: failed to setup netdev (rc=%d)\n",
+			       DRV_NAME, rc);
+			goto out;
+		}
+
 		INIT_LIST_HEAD(&nets[netid].peers);
 		nets[netid].nact = 0;
 	} else if (nets[netid].ndev == NULL)
@@ -559,31 +582,61 @@ static int rionet_probe(struct rio_dev *
 		list_add_tail(&peer->node, &nets[netid].peers);
 	}
 
-	rio_set_drvdata(rdev, nets[netid].ndev);
-
-      out:
+	return 0;
+out:
 	return rc;
 }
 
+#ifdef MODULE
 static struct rio_device_id rionet_id_table[] = {
-	{RIO_DEVICE(RIO_ANY_ID, RIO_ANY_ID)}
+	{RIO_DEVICE(RIO_ANY_ID, RIO_ANY_ID)},
+	{ 0, }	/* terminate list */
 };
 
-static struct rio_driver rionet_driver = {
-	.name = "rionet",
-	.id_table = rionet_id_table,
-	.probe = rionet_probe,
-	.remove = rionet_remove,
+MODULE_DEVICE_TABLE(rapidio, rionet_id_table);
+#endif
+
+static struct subsys_interface rionet_interface = {
+	.name		= "rionet",
+	.subsys		= &rio_bus_type,
+	.add_dev	= rionet_add_dev,
+	.remove_dev	= rionet_remove_dev,
 };
 
 static int __init rionet_init(void)
 {
-	return rio_register_driver(&rionet_driver);
+	return subsys_interface_register(&rionet_interface);
 }
 
 static void __exit rionet_exit(void)
 {
-	rio_unregister_driver(&rionet_driver);
+	struct rionet_private *rnet;
+	struct net_device *ndev;
+	struct rionet_peer *peer, *tmp;
+	int i;
+
+	for (i = 0; i < RIONET_MAX_NETS; i++) {
+		if (nets[i].ndev != NULL) {
+			ndev = nets[i].ndev;
+			rnet = netdev_priv(ndev);
+			unregister_netdev(ndev);
+
+			list_for_each_entry_safe(peer,
+						 tmp, &nets[i].peers, node) {
+				list_del(&peer->node);
+				kfree(peer);
+			}
+
+			free_pages((unsigned long)nets[i].active,
+				 get_order(sizeof(void *) *
+				 RIO_MAX_ROUTE_ENTRIES(rnet->mport->sys_size)));
+			nets[i].active = NULL;
+
+			free_netdev(ndev);
+		}
+	}
+
+	subsys_interface_unregister(&rionet_interface);
 }
 
 late_initcall(rionet_init);
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

linux-next.patch
rapidio-switches-remove-tsi500-driver.patch
rapidio-convert-switch-drivers-to-modules.patch
rapidio-rionet-rework-driver-initialization-and-removal.patch
rapidio-update-enumerator-registration-mechanism.patch
rapidio-tsi721-convert-to-modular-mport-driver.patch
rapidio-add-modular-build-option-for-the-subsystem-core.patch
rapidio-add-udev-notification.patch
rapidio-documentation-update.patch


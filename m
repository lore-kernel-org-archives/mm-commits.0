From: akpm@linux-foundation.org
Subject: [merged] rapidio-rionet-add-mport-removal-handling.patch removed
 from -mm tree
Date: Wed, 23 Mar 2016 10:41:45 -0700
Message-ID: <56f2d559.nuwVLRN6i3ZnMdXy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59239 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756589AbcCWRlq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:41:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, a-jacquiot@ti.com, andre.van.herk@prodrive-technologies.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/rionet: add mport removal handling
has been removed from the -mm tree.  Its filename was
     rapidio-rionet-add-mport-removal-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio/rionet: add mport removal handling

Add handling of a local mport device removal.

RIONET driver registers itself as class interface that supports only
removal notification, 'add_device' callback is not provided because RIONET
network device can be initialized only after enumeration is completed and
the existing method (using remote peer addition) satisfies this condition.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/rionet.c |   70 +++++++++++++++++++++++++----------------
 1 file changed, 44 insertions(+), 26 deletions(-)

diff -puN drivers/net/rionet.c~rapidio-rionet-add-mport-removal-handling drivers/net/rionet.c
--- a/drivers/net/rionet.c~rapidio-rionet-add-mport-removal-handling
+++ a/drivers/net/rionet.c
@@ -676,6 +676,34 @@ static int rionet_shutdown(struct notifi
 	return NOTIFY_DONE;
 }
 
+static void rionet_remove_mport(struct device *dev,
+				struct class_interface *class_intf)
+{
+	struct rio_mport *mport = to_rio_mport(dev);
+	struct net_device *ndev;
+	int id = mport->id;
+
+	pr_debug("%s %s\n", __func__, mport->name);
+
+	WARN(nets[id].nact, "%s called when connected to %d peers\n",
+	     __func__, nets[id].nact);
+	WARN(!nets[id].ndev, "%s called for mport without NDEV\n",
+	     __func__);
+
+	if (nets[id].ndev) {
+		ndev = nets[id].ndev;
+		netif_stop_queue(ndev);
+		unregister_netdev(ndev);
+
+		free_pages((unsigned long)nets[id].active,
+			   get_order(sizeof(void *) *
+			   RIO_MAX_ROUTE_ENTRIES(mport->sys_size)));
+		nets[id].active = NULL;
+		free_netdev(ndev);
+		nets[id].ndev = NULL;
+	}
+}
+
 #ifdef MODULE
 static struct rio_device_id rionet_id_table[] = {
 	{RIO_DEVICE(RIO_ANY_ID, RIO_ANY_ID)},
@@ -696,6 +724,13 @@ static struct notifier_block rionet_noti
 	.notifier_call = rionet_shutdown,
 };
 
+/* the rio_mport_interface is used to handle local mport devices */
+static struct class_interface rio_mport_interface __refdata = {
+	.class = &rio_mport_class,
+	.add_dev = NULL,
+	.remove_dev = rionet_remove_mport,
+};
+
 static int __init rionet_init(void)
 {
 	int ret;
@@ -706,39 +741,22 @@ static int __init rionet_init(void)
 		       DRV_NAME, ret);
 		return ret;
 	}
+
+	ret = class_interface_register(&rio_mport_interface);
+	if (ret) {
+		pr_err("%s: class_interface_register error: %d\n",
+		       DRV_NAME, ret);
+		return ret;
+	}
+
 	return subsys_interface_register(&rionet_interface);
 }
 
 static void __exit rionet_exit(void)
 {
-	struct rionet_private *rnet;
-	struct net_device *ndev;
-	struct rionet_peer *peer, *tmp;
-	int i;
-
-	for (i = 0; i < RIONET_MAX_NETS; i++) {
-		if (nets[i].ndev != NULL) {
-			ndev = nets[i].ndev;
-			rnet = netdev_priv(ndev);
-			unregister_netdev(ndev);
-
-			list_for_each_entry_safe(peer,
-						 tmp, &nets[i].peers, node) {
-				list_del(&peer->node);
-				kfree(peer);
-			}
-
-			free_pages((unsigned long)nets[i].active,
-				 get_order(sizeof(void *) *
-				 RIO_MAX_ROUTE_ENTRIES(rnet->mport->sys_size)));
-			nets[i].active = NULL;
-
-			free_netdev(ndev);
-		}
-	}

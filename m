From: akpm@linux-foundation.org
Subject: + rapidio-rionet-add-mport-removal-handling.patch added to -mm
 tree
Date: Mon, 08 Feb 2016 13:22:28 -0800
Message-ID: <56b90714.YK3XnTFyk8ld41CQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35829 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756326AbcBHVW3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2016 16:22:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, a-jacquiot@ti.com, andre.van.herk@prodrive-technologies.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/rionet: add mport removal handling
has been added to the -mm tree.  Its filename is
     rapidio-rionet-add-mport-removal-handling.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-rionet-add-mport-removal-handling.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-rionet-add-mport-removal-handling.patch

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
-
 	unregister_reboot_notifier(&rionet_notifier);
 	subsys_interface_unregister(&rionet_interface);
+	class_interface_unregister(&rio_mport_interface);
 }
 
 late_initcall(rionet_init);
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-tsi721-fix-hardcoded-mrrs-setting.patch
rapidio-tsi721-add-check-for-overlapped-ib-window-mappings.patch
rapidio-tsi721-add-option-to-configure-direct-mapping-of-ib-window.patch
rapidio-tsi721_dma-fix-pending-transaction-queue-handling.patch
rapidio-add-query_mport-operation.patch
rapidio-tsi721-add-query_mport-callback.patch
rapidio-add-shutdown-notification-for-rapidio-devices.patch
rapidio-tsi721-add-shutdown-notification-callback.patch
rapidio-rionet-add-shutdown-event-handling.patch
rapidio-rework-common-rio-device-add-delete-routines.patch
rapidio-move-net-allocation-into-core-code.patch
rapidio-add-core-mport-removal-support.patch
rapidio-tsi721-add-hw-specific-mport-removal.patch
powerpc-fsl_rio-changes-to-mport-registration.patch
rapidio-rionet-add-locking-into-add-remove-device.patch
rapidio-rionet-add-mport-removal-handling.patch
rapidio-add-lock-protection-for-doorbell-list.patch
rapidio-move-rio_local_set_device_id-function-to-the-common-core.patch
rapidio-move-rio_pw_enable-into-core-code.patch
rapidio-add-global-inbound-port-write-interfaces.patch
rapidio-tsi721-fix-locking-in-ob_msg-processing.patch
rapidio-add-outbound-window-support.patch
rapidio-tsi721-add-outbound-windows-mapping-support.patch
rapidio-tsi721-add-filtered-debug-output.patch
rapidio-tsi721_dma-update-error-reporting-from-prep_sg-callback.patch
rapidio-tsi721_dma-fix-synchronization-issues.patch
rapidio-tsi721_dma-fix-hardware-error-handling.patch
rapidio-add-mport-char-device-driver.patch


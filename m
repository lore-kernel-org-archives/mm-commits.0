From: akpm@linux-foundation.org
Subject: + rapidio-rionet-add-shutdown-event-handling.patch added to -mm
 tree
Date: Mon, 08 Feb 2016 13:22:14 -0800
Message-ID: <56b90706.PgnDOSOv3zlUkgvL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35784 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756279AbcBHVWP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2016 16:22:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, a-jacquiot@ti.com, andre.van.herk@prodrive-technologies.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/rionet: add shutdown event handling
has been added to the -mm tree.  Its filename is
     rapidio-rionet-add-shutdown-event-handling.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-rionet-add-shutdown-event-handling.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-rionet-add-shutdown-event-handling.patch

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
Subject: rapidio/rionet: add shutdown event handling

Add shutdown notification handler which terminates active connections with
remote RapidIO nodes.  This prevents remote nodes from sending packets to
the powered off node and eliminates hardware error events on remote nodes.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/rionet.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff -puN drivers/net/rionet.c~rapidio-rionet-add-shutdown-event-handling drivers/net/rionet.c
--- a/drivers/net/rionet.c~rapidio-rionet-add-shutdown-event-handling
+++ a/drivers/net/rionet.c
@@ -24,6 +24,7 @@
 #include <linux/skbuff.h>
 #include <linux/crc32.h>
 #include <linux/ethtool.h>
+#include <linux/reboot.h>
 
 #define DRV_NAME        "rionet"
 #define DRV_VERSION     "0.3"
@@ -599,6 +600,30 @@ out:
 	return rc;
 }
 
+static int rionet_shutdown(struct notifier_block *nb, unsigned long code,
+			   void *unused)
+{
+	struct rionet_peer *peer, *tmp;
+	int i;
+
+	pr_debug("%s: %s\n", DRV_NAME, __func__);
+
+	for (i = 0; i < RIONET_MAX_NETS; i++) {
+		if (!nets[i].ndev)
+			continue;
+
+		list_for_each_entry_safe(peer, tmp, &nets[i].peers, node) {
+			if (nets[i].active[peer->rdev->destid]) {
+				rio_send_doorbell(peer->rdev,
+						  RIONET_DOORBELL_LEAVE);
+				nets[i].active[peer->rdev->destid] = NULL;
+			}
+		}
+	}
+
+	return NOTIFY_DONE;
+}
+
 #ifdef MODULE
 static struct rio_device_id rionet_id_table[] = {
 	{RIO_DEVICE(RIO_ANY_ID, RIO_ANY_ID)},
@@ -615,8 +640,20 @@ static struct subsys_interface rionet_in
 	.remove_dev	= rionet_remove_dev,
 };
 
+static struct notifier_block rionet_notifier = {
+	.notifier_call = rionet_shutdown,
+};
+
 static int __init rionet_init(void)
 {
+	int ret;
+
+	ret = register_reboot_notifier(&rionet_notifier);
+	if (ret) {
+		pr_err("%s: failed to register reboot notifier (err=%d)\n",
+		       DRV_NAME, ret);
+		return ret;
+	}
 	return subsys_interface_register(&rionet_interface);
 }
 
@@ -648,6 +685,7 @@ static void __exit rionet_exit(void)
 		}
 	}
 
+	unregister_reboot_notifier(&rionet_notifier);
 	subsys_interface_unregister(&rionet_interface);
 }
 
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


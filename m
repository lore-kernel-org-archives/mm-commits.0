From: akpm@linux-foundation.org
Subject: [merged] rapidio-rionet-add-shutdown-event-handling.patch removed from -mm tree
Date: Wed, 23 Mar 2016 10:41:31 -0700
Message-ID: <56f2d54b.yHwuF8Lxsom6zjqh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59205 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756645AbcCWRlc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:41:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, a-jacquiot@ti.com, andre.van.herk@prodrive-technologies.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/rionet: add shutdown event handling
has been removed from the -mm tree.  Its filename was
     rapidio-rionet-add-shutdown-event-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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



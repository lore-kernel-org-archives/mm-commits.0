From: akpm@linux-foundation.org
Subject: + rapidio-add-handling-of-orphan-port-write-message.patch added to -mm tree
Date: Tue, 14 Sep 2010 15:21:25 -0700
Message-ID: <201009142221.o8EMLP1D021813@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754451Ab0INWWN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Sep 2010 18:22:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, galak@kernel.crashing.org, leoli@freescale.com, micha@neli.hopto.org, mporter@kernel.crashing.org, thomas.moll@sysgo.com


The patch titled
     rapidio: add handling of orphan port-write message
has been added to the -mm tree.  Its filename is
     rapidio-add-handling-of-orphan-port-write-message.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rapidio: add handling of orphan port-write message
From: Alexandre Bounine <alexandre.bounine@idt.com>

Add check for access to port-write (PW) message source device before
processing the PW message.  If source RIO device is not available (power
down or RIO link failure) trace back to a last available switch/port on
the PW message route and service failure at that point.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Micha Nelissen <micha@neli.hopto.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio.c |  113 ++++++++++++++++++++++++++++++++++++++--
 drivers/rapidio/rio.h |    2 
 2 files changed, 110 insertions(+), 5 deletions(-)

diff -puN drivers/rapidio/rio.c~rapidio-add-handling-of-orphan-port-write-message drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-add-handling-of-orphan-port-write-message
+++ a/drivers/rapidio/rio.c
@@ -495,6 +495,92 @@ int rio_set_port_lockout(struct rio_dev 
 }
 
 /**
+ * rio_chk_dev_route - Validate route to the specified device.
+ * @rdev:  RIO device failed to respond
+ * @nrdev: Last active device on the route to rdev
+ * @npnum: nrdev's port number on the route to rdev
+ *
+ * Follows a route to the specified RIO device to determine the last available
+ * device (and corresponding RIO port) on the route.
+ */
+static int
+rio_chk_dev_route(struct rio_dev *rdev, struct rio_dev **nrdev, int *npnum)
+{
+	u32 result;
+	int p_port, rc = -EIO;
+	struct rio_dev *prev = NULL;
+
+	/* Find switch with failed RIO link */
+	while (rdev->prev && (rdev->prev->pef & RIO_PEF_SWITCH)) {
+		if (!rio_read_config_32(rdev->prev, RIO_DEV_ID_CAR, &result)) {
+			prev = rdev->prev;
+			break;
+		}
+		rdev = rdev->prev;
+	}
+
+	if (prev == NULL)
+		goto err_out;
+
+	/* Find port with failed RIO link */
+	for (p_port = 0;
+	     p_port < RIO_GET_TOTAL_PORTS(prev->swpinfo); p_port++)
+		if (prev->rswitch->nextdev[p_port] == rdev)
+			break;
+
+	if (p_port < RIO_GET_TOTAL_PORTS(prev->swpinfo)) {
+		pr_debug("RIO: link failed on [%s]-P%d\n",
+			 rio_name(prev), p_port);
+		*nrdev = prev;
+		*npnum = p_port;
+		rc = 0;
+	} else
+		pr_debug("RIO: failed to trace route to %s\n", rio_name(prev));
+err_out:
+	return rc;
+}
+
+/**
+ * rio_mport_chk_dev_access - Validate access to the specified device.
+ * @mport: Master port to send transactions
+ * @destid: Device destination ID in network
+ * @hopcount: Number of hops into the network
+ */
+static int
+rio_mport_chk_dev_access(struct rio_mport *mport, u16 destid, u8 hopcount)
+{
+	int i = 0;
+	u32 tmp;
+
+	while (rio_mport_read_config_32(mport, destid, hopcount,
+					RIO_DEV_ID_CAR, &tmp)) {
+		i++;
+		if (i == RIO_MAX_CHK_RETRY)
+			return -EIO;
+		mdelay(1);
+	}
+
+	return 0;
+}
+
+/**
+ * rio_chk_dev_access - Validate access to the specified device.
+ * @rdev: Pointer to RIO device control structure
+ */
+static int rio_chk_dev_access(struct rio_dev *rdev)
+{
+	u8 hopcount = 0xff;
+	u16 destid = rdev->destid;
+
+	if (rdev->rswitch) {
+		destid = rdev->rswitch->destid;
+		hopcount = rdev->rswitch->hopcount;
+	}
+
+	return rio_mport_chk_dev_access(rdev->net->hport, destid, hopcount);
+}
+
+/**
  * rio_get_input_status - Sends a Link-Request/Input-Status control symbol and
  *                        returns link-response (if requested).
  * @rdev: RIO devive to issue Input-status command
@@ -654,8 +740,8 @@ int rio_inb_pwrite_handler(union rio_pw_
 
 	rdev = rio_get_comptag(pw_msg->em.comptag, NULL);
 	if (rdev == NULL) {
-		/* Someting bad here (probably enumeration error) */
-		pr_err("RIO: %s No matching device for CTag 0x%08x\n",
+		/* Device removed or enumeration error */
+		pr_debug("RIO: %s No matching device for CTag 0x%08x\n",
 			__func__, pw_msg->em.comptag);
 		return -EIO;
 	}
@@ -686,6 +772,26 @@ int rio_inb_pwrite_handler(union rio_pw_
 			return 0;
 	}
 
+	portnum = pw_msg->em.is_port & 0xFF;
+
+	/* Check if device and route to it are functional:
+	 * Sometimes devices may send PW message(s) just before being
+	 * powered down (or link being lost).
+	 */
+	if (rio_chk_dev_access(rdev)) {
+		pr_debug("RIO: device access failed - get link partner\n");
+		/* Scan route to the device and identify failed link.
+		 * This will replace device and port reported in PW message.
+		 * PW message should not be used after this point.
+		 */
+		if (rio_chk_dev_route(rdev, &rdev, &portnum)) {
+			pr_err("RIO: Route trace for %s failed\n",
+				rio_name(rdev));
+			return -EIO;
+		}
+		pw_msg = NULL;
+	}
+
 	/* For End-point devices processing stops here */
 	if (!(rdev->pef & RIO_PEF_SWITCH))
 		return 0;
@@ -703,9 +809,6 @@ int rio_inb_pwrite_handler(union rio_pw_
 	/*
 	 * Process the port-write notification from switch
 	 */
-
-	portnum = pw_msg->em.is_port & 0xFF;
-
 	if (rdev->rswitch->em_handle)
 		rdev->rswitch->em_handle(rdev, portnum);
 
diff -puN drivers/rapidio/rio.h~rapidio-add-handling-of-orphan-port-write-message drivers/rapidio/rio.h
--- a/drivers/rapidio/rio.h~rapidio-add-handling-of-orphan-port-write-message
+++ a/drivers/rapidio/rio.h
@@ -14,6 +14,8 @@
 #include <linux/list.h>
 #include <linux/rio.h>
 
+#define RIO_MAX_CHK_RETRY	3
+
 /* Functions internal to the RIO core code */
 
 extern u32 rio_mport_get_feature(struct rio_mport *mport, int local, u16 destid,
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-fix-rapidio-sysfs-hierarchy.patch
rapidio-powerpc-85xx-modify-rio-port-write-interrupt-handler.patch
rapidio-use-stored-ingress-port-number-instead-of-register-read.patch
rapidio-add-relation-links-between-rio-device-structures.patch
rapidio-add-default-handler-for-error-stopped-state.patch
rapidio-modify-sysfs-initialization-for-switches.patch
rapidio-add-handling-of-orphan-port-write-message.patch
rapidio-add-device-access-check-into-the-enumeration.patch
rapidio-add-support-for-idt-cps-gen2-switches.patch
rapidio-add-handling-of-redundant-routes.patch


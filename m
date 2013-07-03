From: akpm@linux-foundation.org
Subject: + rapidio-change-endpoint-device-name-format.patch added to -mm
 tree
Date: Wed, 03 Jul 2013 13:19:48 -0700
Message-ID: <51d48764.EJ9wHIpLfqVuvCHk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39398 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933229Ab3GCUTt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jul 2013 16:19:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stef.van.os@Prodrive.nl, mporter@kernel.crashing.org, micha.nelissen@Prodrive.nl, leoli@freescale.com, galak@kernel.crashing.org, andre.van.herk@Prodrive.nl, alexandre.bounine@idt.com

Subject: + rapidio-change-endpoint-device-name-format.patch added to -mm tree
To: alexandre.bounine@idt.com,andre.van.herk@Prodrive.nl,galak@kernel.crashing.org,leoli@freescale.com,micha.nelissen@Prodrive.nl,mporter@kernel.crashing.org,stef.van.os@Prodrive.nl
From: akpm@linux-foundation.org
Date: Wed, 03 Jul 2013 13:19:48 -0700


The patch titled
     Subject: rapidio: change endpoint device name format
has been added to the -mm tree.  Its filename is
     rapidio-change-endpoint-device-name-format.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-change-endpoint-device-name-format.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-change-endpoint-device-name-format.patch

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
Subject: rapidio: change endpoint device name format

Change endpoint device name format to use a component tag value instead of
device destination ID.

RapidIO specification defines a component tag to be a unique identifier
for devices in a network.  RapidIO switches already use component tag as
part of their device name and also use it for device identification when
processing error management event notifications.

Forming an endpoint's device name using its component tag instead of
destination ID allows to keep sysfs device directories unchanged in case
if a routing process dynamically changes endpoint's destination ID as a
result of route optimization.

This change should not affect any existing users because a valid device
destination ID always should be obtained by reading "destid" attribute and
not by parsing device name.

This patch also removes switchid member from struct rio_switch because it
simply duplicates the component tag and does not have other use than in
device name generation.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Andre van Herk <andre.van.herk@Prodrive.nl>
Cc: Micha Nelissen <micha.nelissen@Prodrive.nl>
Cc: Stef van Os <stef.van.os@Prodrive.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c |    5 ++---
 include/linux/rio.h        |    2 --
 2 files changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/rapidio/rio-scan.c~rapidio-change-endpoint-device-name-format drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rapidio-change-endpoint-device-name-format
+++ a/drivers/rapidio/rio-scan.c
@@ -433,7 +433,6 @@ static struct rio_dev *rio_setup_device(
 	/* If a PE has both switch and other functions, show it as a switch */
 	if (rio_is_switch(rdev)) {
 		rswitch = rdev->rswitch;
-		rswitch->switchid = rdev->comp_tag & RIO_CTAG_UDEVID;
 		rswitch->port_ok = 0;
 		spin_lock_init(&rswitch->lock);
 		rswitch->route_table = kzalloc(sizeof(u8)*
@@ -446,7 +445,7 @@ static struct rio_dev *rio_setup_device(
 				rdid++)
 			rswitch->route_table[rdid] = RIO_INVALID_ROUTE;
 		dev_set_name(&rdev->dev, "%02x:s:%04x", rdev->net->id,
-			     rswitch->switchid);
+			     rdev->comp_tag & RIO_CTAG_UDEVID);
 
 		if (do_enum)
 			rio_route_clr_table(rdev, RIO_GLOBAL_TABLE, 0);
@@ -459,7 +458,7 @@ static struct rio_dev *rio_setup_device(
 			rio_enable_rx_tx_port(port, 0, destid, hopcount, 0);
 
 		dev_set_name(&rdev->dev, "%02x:e:%04x", rdev->net->id,
-			     rdev->destid);
+			     rdev->comp_tag & RIO_CTAG_UDEVID);
 	}
 
 	rio_attach_device(rdev);
diff -puN include/linux/rio.h~rapidio-change-endpoint-device-name-format include/linux/rio.h
--- a/include/linux/rio.h~rapidio-change-endpoint-device-name-format
+++ a/include/linux/rio.h
@@ -92,7 +92,6 @@ union rio_pw_msg;
 /**
  * struct rio_switch - RIO switch info
  * @node: Node in global list of switches
- * @switchid: Switch ID that is unique across a network
  * @route_table: Copy of switch routing table
  * @port_ok: Status of each port (one bit per port) - OK=1 or UNINIT=0
  * @ops: pointer to switch-specific operations
@@ -101,7 +100,6 @@ union rio_pw_msg;
  */
 struct rio_switch {
 	struct list_head node;
-	u16 switchid;
 	u8 *route_table;
 	u32 port_ok;
 	struct rio_switch_ops *ops;
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-switches-remove-tsi500-driver.patch
rapidio-convert-switch-drivers-to-modules.patch
rapidio-rionet-rework-driver-initialization-and-removal.patch
rapidio-update-enumerator-registration-mechanism.patch
rapidio-tsi721-convert-to-modular-mport-driver.patch
rapidio-add-modular-build-option-for-the-subsystem-core.patch
rapidio-add-udev-notification.patch
rapidio-documentation-update.patch
rapidio-change-endpoint-device-name-format.patch


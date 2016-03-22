From: akpm@linux-foundation.org
Subject: [folded-merged]
 rapidio-add-lock-protection-for-doorbell-list-fix.patch removed from -mm
 tree
Date: Tue, 22 Mar 2016 13:55:13 -0700
Message-ID: <56f1b131.P1xxbgZo4F1G40QI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59391 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbcCVUzO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2016 16:55:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, a-jacquiot@ti.com, andre.van.herk@prodrive-technologies.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: add lock protection for doorbell list fix
has been removed from the -mm tree.  Its filename was
     rapidio-add-lock-protection-for-doorbell-list-fix.patch

This patch was dropped because it was folded into rapidio-add-lock-protection-for-doorbell-list.patch

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio: add lock protection for doorbell list fix

Fix documentation warning for patch:
	rapidio: add lock protection for doorbell list

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rio.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/rio.h~rapidio-add-lock-protection-for-doorbell-list-fix include/linux/rio.h
--- a/include/linux/rio.h~rapidio-add-lock-protection-for-doorbell-list-fix
+++ a/include/linux/rio.h
@@ -248,7 +248,7 @@ enum rio_phy_type {
  * @node: Node in global list of master ports
  * @nnode: Node in network list of master ports
  * @net: RIO net this mport is attached to
- * @mutex lock: lock to synchronize lists manipulations
+ * @lock: lock to synchronize lists manipulations
  * @iores: I/O mem resource that this master port interface owns
  * @riores: RIO resources that this master port interfaces owns
  * @inb_msg: RIO inbound message event descriptors
@@ -272,7 +272,7 @@ struct rio_mport {
 	struct list_head node;	/* node in global list of ports */
 	struct list_head nnode;	/* node in net list of ports */
 	struct rio_net *net;	/* RIO net this mport is attached to */
-	struct mutex lock;	/* lock to synchronize lists manipulations */
+	struct mutex lock;
 	struct resource iores;
 	struct resource riores[RIO_MAX_MPORT_RESOURCES];
 	struct rio_msg inb_msg[RIO_MAX_MBOX];
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
rapidio-move-rio_pw_enable-into-core-code-fix.patch
rapidio-add-global-inbound-port-write-interfaces.patch
rapidio-add-global-inbound-port-write-interfaces-fix.patch
rapidio-tsi721-fix-locking-in-ob_msg-processing.patch
rapidio-add-outbound-window-support.patch
rapidio-tsi721-add-outbound-windows-mapping-support.patch
rapidio-tsi721-add-filtered-debug-output.patch
rapidio-tsi721_dma-update-error-reporting-from-prep_sg-callback.patch
rapidio-tsi721_dma-fix-synchronization-issues.patch
rapidio-tsi721_dma-fix-hardware-error-handling.patch
rapidio-add-mport-char-device-driver.patch
rapidio-add-mport-char-device-driver-fix-3.patch
rapidio-add-mport-char-device-driver-fix-4.patch


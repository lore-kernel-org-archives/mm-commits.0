From: akpm@linux-foundation.org
Subject: [folded-merged]
 rapidio-add-global-inbound-port-write-interfaces-fix.patch removed from -mm tree
Date: Tue, 22 Mar 2016 13:55:43 -0700
Message-ID: <56f1b14f.0jmvjPWoyqZe/F51%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59403 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbcCVUzo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2016 16:55:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, a-jacquiot@ti.com, andre.van.herk@prodrive-technologies.com, benh@kernel.crashing.org, mporter@kernel.crashing.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/fsl_rio: update for port-write interface change
has been removed from the -mm tree.  Its filename was
     rapidio-add-global-inbound-port-write-interfaces-fix.patch

This patch was dropped because it was folded into rapidio-add-global-inbound-port-write-interfaces.patch

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: powerpc/fsl_rio: update for port-write interface change

Platform-specific update following changes in port-write handler interface.

This is a follow-up patch for
    [PATCH 22/30] rapidio: add global inbound port write interfaces

Fixes powerpc build with RapidIO enabled.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_rio.c |    1 +
 arch/powerpc/sysdev/fsl_rio.h |    1 +
 arch/powerpc/sysdev/fsl_rmu.c |   16 ++++++++++------
 3 files changed, 12 insertions(+), 6 deletions(-)

diff -puN arch/powerpc/sysdev/fsl_rio.c~rapidio-add-global-inbound-port-write-interfaces-fix arch/powerpc/sysdev/fsl_rio.c
--- a/arch/powerpc/sysdev/fsl_rio.c~rapidio-add-global-inbound-port-write-interfaces-fix
+++ a/arch/powerpc/sysdev/fsl_rio.c
@@ -726,6 +726,7 @@ int fsl_rio_setup(struct platform_device
 		fsl_rio_inbound_mem_init(priv);
 
 		dbell->mport[i] = port;
+		pw->mport[i] = port;
 
 		if (rio_register_mport(port)) {
 			release_resource(&port->iores);
diff -puN arch/powerpc/sysdev/fsl_rio.h~rapidio-add-global-inbound-port-write-interfaces-fix arch/powerpc/sysdev/fsl_rio.h
--- a/arch/powerpc/sysdev/fsl_rio.h~rapidio-add-global-inbound-port-write-interfaces-fix
+++ a/arch/powerpc/sysdev/fsl_rio.h
@@ -97,6 +97,7 @@ struct fsl_rio_dbell {
 };
 
 struct fsl_rio_pw {
+	struct rio_mport *mport[MAX_PORT_NUM];
 	struct device *dev;
 	struct rio_pw_regs __iomem *pw_regs;
 	struct rio_port_write_msg port_write_msg;
diff -puN arch/powerpc/sysdev/fsl_rmu.c~rapidio-add-global-inbound-port-write-interfaces-fix arch/powerpc/sysdev/fsl_rmu.c
--- a/arch/powerpc/sysdev/fsl_rmu.c~rapidio-add-global-inbound-port-write-interfaces-fix
+++ a/arch/powerpc/sysdev/fsl_rmu.c
@@ -481,14 +481,14 @@ pw_done:
 static void fsl_pw_dpc(struct work_struct *work)
 {
 	struct fsl_rio_pw *pw = container_of(work, struct fsl_rio_pw, pw_work);
-	u32 msg_buffer[RIO_PW_MSG_SIZE/sizeof(u32)];
+	union rio_pw_msg msg_buffer;
+	int i;
 
 	/*
 	 * Process port-write messages
 	 */
-	while (kfifo_out_spinlocked(&pw->pw_fifo, (unsigned char *)msg_buffer,
+	while (kfifo_out_spinlocked(&pw->pw_fifo, (unsigned char *)&msg_buffer,
 			 RIO_PW_MSG_SIZE, &pw->pw_fifo_lock)) {
-		/* Process one message */
 #ifdef DEBUG_PW
 		{
 		u32 i;
@@ -496,15 +496,19 @@ static void fsl_pw_dpc(struct work_struc
 		for (i = 0; i < RIO_PW_MSG_SIZE/sizeof(u32); i++) {
 			if ((i%4) == 0)
 				pr_debug("\n0x%02x: 0x%08x", i*4,
-					 msg_buffer[i]);
+					 msg_buffer.raw[i]);
 			else
-				pr_debug(" 0x%08x", msg_buffer[i]);
+				pr_debug(" 0x%08x", msg_buffer.raw[i]);
 		}
 		pr_debug("\n");
 		}
 #endif
 		/* Pass the port-write message to RIO core for processing */
-		rio_inb_pwrite_handler((union rio_pw_msg *)msg_buffer);
+		for (i = 0; i < MAX_PORT_NUM; i++) {
+			if (pw->mport[i])
+				rio_inb_pwrite_handler(pw->mport[i],
+						       &msg_buffer);
+		}
 	}
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
rapidio-add-mport-char-device-driver-fix-3.patch
rapidio-add-mport-char-device-driver-fix-4.patch


From: akpm@linux-foundation.org
Subject: - xilinx-hwicap-refactor-status-handling-code.patch removed from -mm tree
Date: Tue, 01 Apr 2008 14:38:38 -0700
Message-ID: <200804012138.m31LccHr014941@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60230 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758514AbYDAVjf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2008 17:39:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stephen.neuendorffer@xilinx.com, grant.likely@secretlab.ca, jwboyer@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     xilinx: hwicap: refactor status handling code
has been removed from the -mm tree.  Its filename was
     xilinx-hwicap-refactor-status-handling-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xilinx: hwicap: refactor status handling code
From: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>

Both the buffer-based and fifo-based icap cores have a status register. 
Previously, this was only used internally to check whether transactions have
completed.  However, the status can be useful to the main driver as well. 
This patch exposes these status functions to the main driver along with some
masks for the differnet bits.

Signed-off-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/xilinx_hwicap/buffer_icap.c   |   22 +++----------
 drivers/char/xilinx_hwicap/buffer_icap.h   |    5 +--
 drivers/char/xilinx_hwicap/fifo_icap.c     |   31 ++++++++++++++-----
 drivers/char/xilinx_hwicap/fifo_icap.h     |    1 
 drivers/char/xilinx_hwicap/xilinx_hwicap.c |    2 +
 drivers/char/xilinx_hwicap/xilinx_hwicap.h |   24 ++++++++++++++
 6 files changed, 58 insertions(+), 27 deletions(-)

diff -puN drivers/char/xilinx_hwicap/buffer_icap.c~xilinx-hwicap-refactor-status-handling-code drivers/char/xilinx_hwicap/buffer_icap.c
--- a/drivers/char/xilinx_hwicap/buffer_icap.c~xilinx-hwicap-refactor-status-handling-code
+++ a/drivers/char/xilinx_hwicap/buffer_icap.c
@@ -74,7 +74,7 @@
 
 /**
  * buffer_icap_get_status - Get the contents of the status register.
- * @base_address: is the base address of the device
+ * @drvdata: a pointer to the drvdata.
  *
  * The status register contains the ICAP status and the done bit.
  *
@@ -88,9 +88,9 @@
  * D1 - Always 1
  * D0 - Done bit
  **/
-static inline u32 buffer_icap_get_status(void __iomem *base_address)
+u32 buffer_icap_get_status(struct hwicap_drvdata *drvdata)
 {
-	return in_be32(base_address + XHI_STATUS_REG_OFFSET);
+	return in_be32(drvdata->base_address + XHI_STATUS_REG_OFFSET);
 }
 
 /**
@@ -117,20 +117,8 @@ static inline u32 buffer_icap_get_bram(v
  **/
 static inline bool buffer_icap_busy(void __iomem *base_address)
 {
-	return (buffer_icap_get_status(base_address) & 1) == XHI_NOT_FINISHED;
-}
-
-/**
- * buffer_icap_busy - Return true if the icap device is not busy
- * @base_address: is the base address of the device
- *
- * The queries the low order bit of the status register, which
- * indicates whether the current configuration or readback operation
- * has completed.
- **/
-static inline bool buffer_icap_done(void __iomem *base_address)
-{
-	return (buffer_icap_get_status(base_address) & 1) == XHI_FINISHED;
+	u32 status = in_be32(base_address + XHI_STATUS_REG_OFFSET);
+	return (status & 1) == XHI_NOT_FINISHED;
 }
 
 /**
diff -puN drivers/char/xilinx_hwicap/buffer_icap.h~xilinx-hwicap-refactor-status-handling-code drivers/char/xilinx_hwicap/buffer_icap.h
--- a/drivers/char/xilinx_hwicap/buffer_icap.h~xilinx-hwicap-refactor-status-handling-code
+++ a/drivers/char/xilinx_hwicap/buffer_icap.h
@@ -44,8 +44,6 @@
 #include <asm/io.h>
 #include "xilinx_hwicap.h"
 
-void buffer_icap_reset(struct hwicap_drvdata *drvdata);
-
 /* Loads a partial bitstream from system memory. */
 int buffer_icap_set_configuration(struct hwicap_drvdata *drvdata, u32 *data,
 			     u32 Size);
@@ -54,4 +52,7 @@ int buffer_icap_set_configuration(struct
 int buffer_icap_get_configuration(struct hwicap_drvdata *drvdata, u32 *data,
 			     u32 Size);
 
+u32 buffer_icap_get_status(struct hwicap_drvdata *drvdata);
+void buffer_icap_reset(struct hwicap_drvdata *drvdata);
+
 #endif
diff -puN drivers/char/xilinx_hwicap/fifo_icap.c~xilinx-hwicap-refactor-status-handling-code drivers/char/xilinx_hwicap/fifo_icap.c
--- a/drivers/char/xilinx_hwicap/fifo_icap.c~xilinx-hwicap-refactor-status-handling-code
+++ a/drivers/char/xilinx_hwicap/fifo_icap.c
@@ -78,13 +78,6 @@
 #define XHI_CR_READ_MASK 0x00000002 /* Read from ICAP to FIFO */
 #define XHI_CR_WRITE_MASK 0x00000001 /* Write from FIFO to ICAP */
 
-/* Status Register (SR) */
-#define XHI_SR_CFGERR_N_MASK 0x00000100 /* Config Error Mask */
-#define XHI_SR_DALIGN_MASK 0x00000080 /* Data Alignment Mask */
-#define XHI_SR_RIP_MASK 0x00000040 /* Read back Mask */
-#define XHI_SR_IN_ABORT_N_MASK 0x00000020 /* Select Map Abort Mask */
-#define XHI_SR_DONE_MASK 0x00000001 /* Done bit Mask  */
-
 
 #define XHI_WFO_MAX_VACANCY 1024 /* Max Write FIFO Vacancy, in words */
 #define XHI_RFO_MAX_OCCUPANCY 256 /* Max Read FIFO Occupancy, in words */
@@ -152,13 +145,35 @@ static inline void fifo_icap_start_readb
 }
 
 /**
+ * fifo_icap_get_status - Get the contents of the status register.
+ * @drvdata: a pointer to the drvdata.
+ *
+ * The status register contains the ICAP status and the done bit.
+ *
+ * D8 - cfgerr
+ * D7 - dalign
+ * D6 - rip
+ * D5 - in_abort_l
+ * D4 - Always 1
+ * D3 - Always 1
+ * D2 - Always 1
+ * D1 - Always 1
+ * D0 - Done bit
+ **/
+u32 fifo_icap_get_status(struct hwicap_drvdata *drvdata)
+{
+	u32 status = in_be32(drvdata->base_address + XHI_SR_OFFSET);
+	dev_dbg(drvdata->dev, "Getting status = %x\n", status);
+	return status;
+}
+
+/**
  * fifo_icap_busy - Return true if the ICAP is still processing a transaction.
  * @drvdata: a pointer to the drvdata.
  **/
 static inline u32 fifo_icap_busy(struct hwicap_drvdata *drvdata)
 {
 	u32 status = in_be32(drvdata->base_address + XHI_SR_OFFSET);
-	dev_dbg(drvdata->dev, "Getting status = %x\n", status);
 	return (status & XHI_SR_DONE_MASK) ? 0 : 1;
 }
 
diff -puN drivers/char/xilinx_hwicap/fifo_icap.h~xilinx-hwicap-refactor-status-handling-code drivers/char/xilinx_hwicap/fifo_icap.h
--- a/drivers/char/xilinx_hwicap/fifo_icap.h~xilinx-hwicap-refactor-status-handling-code
+++ a/drivers/char/xilinx_hwicap/fifo_icap.h
@@ -56,6 +56,7 @@ int fifo_icap_set_configuration(
 		u32 *FrameBuffer,
 		u32 NumWords);
 
+u32 fifo_icap_get_status(struct hwicap_drvdata *drvdata);
 void fifo_icap_reset(struct hwicap_drvdata *drvdata);
 void fifo_icap_flush_fifo(struct hwicap_drvdata *drvdata);
 
diff -puN drivers/char/xilinx_hwicap/xilinx_hwicap.c~xilinx-hwicap-refactor-status-handling-code drivers/char/xilinx_hwicap/xilinx_hwicap.c
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c~xilinx-hwicap-refactor-status-handling-code
+++ a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
@@ -664,12 +664,14 @@ static int __devinit hwicap_setup(struct
 static struct hwicap_driver_config buffer_icap_config = {
 	.get_configuration = buffer_icap_get_configuration,
 	.set_configuration = buffer_icap_set_configuration,
+	.get_status = buffer_icap_get_status,
 	.reset = buffer_icap_reset,
 };
 
 static struct hwicap_driver_config fifo_icap_config = {
 	.get_configuration = fifo_icap_get_configuration,
 	.set_configuration = fifo_icap_set_configuration,
+	.get_status = fifo_icap_get_status,
 	.reset = fifo_icap_reset,
 };
 
diff -puN drivers/char/xilinx_hwicap/xilinx_hwicap.h~xilinx-hwicap-refactor-status-handling-code drivers/char/xilinx_hwicap/xilinx_hwicap.h
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.h~xilinx-hwicap-refactor-status-handling-code
+++ a/drivers/char/xilinx_hwicap/xilinx_hwicap.h
@@ -65,10 +65,27 @@ struct hwicap_drvdata {
 };
 
 struct hwicap_driver_config {
+	/* Read configuration data given by size into the data buffer.
+	   Return 0 if successful. */
 	int (*get_configuration)(struct hwicap_drvdata *drvdata, u32 *data,
 			u32 size);
+	/* Write configuration data given by size from the data buffer.
+	   Return 0 if successful. */
 	int (*set_configuration)(struct hwicap_drvdata *drvdata, u32 *data,
 			u32 size);
+	/* Get the status register, bit pattern given by:
+	 * D8 - 0 = configuration error
+	 * D7 - 1 = alignment found
+	 * D6 - 1 = readback in progress
+	 * D5 - 0 = abort in progress
+	 * D4 - Always 1
+	 * D3 - Always 1
+	 * D2 - Always 1
+	 * D1 - Always 1
+	 * D0 - 1 = operation completed
+	 */
+	u32 (*get_status)(struct hwicap_drvdata *drvdata);
+	/* Reset the hw */
 	void (*reset)(struct hwicap_drvdata *drvdata);
 };
 
@@ -163,6 +180,13 @@ struct config_registers {
 /* Constant to use for CRC check when CRC has been disabled */
 #define XHI_DISABLED_AUTO_CRC       0x0000DEFCUL
 
+/* Meanings of the bits returned by get_status */
+#define XHI_SR_CFGERR_N_MASK 0x00000100 /* Config Error Mask */
+#define XHI_SR_DALIGN_MASK 0x00000080 /* Data Alignment Mask */
+#define XHI_SR_RIP_MASK 0x00000040 /* Read back Mask */
+#define XHI_SR_IN_ABORT_N_MASK 0x00000020 /* Select Map Abort Mask */
+#define XHI_SR_DONE_MASK 0x00000001 /* Done bit Mask  */
+
 /**
  * hwicap_type_1_read - Generates a Type 1 read packet header.
  * @reg: is the address of the register to be read back.
_

Patches currently in -mm which might be from stephen.neuendorffer@xilinx.com are

git-powerpc.patch


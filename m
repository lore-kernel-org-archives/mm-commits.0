From: akpm@linux-foundation.org
Subject: [folded] edac-new-ppc4xx-driver-module-update.patch removed from -mm tree
Date: Thu, 02 Apr 2009 16:23:23 -0700
Message-ID: <200904022323.n32NNOqa011831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55833 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759252AbZDBX0I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Apr 2009 19:26:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerickson@nuovations.com, benh@kernel.crashing.org, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     edac-new-ppc4xx-driver-module-update
has been removed from the -mm tree.  Its filename was
     edac-new-ppc4xx-driver-module-update.patch

This patch was dropped because it was folded into edac-new-ppc4xx-driver-module.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac-new-ppc4xx-driver-module-update
From: Grant Erickson <gerickson@nuovations.com>

This adds support for an EDAC memory controller adaptation driver for the
"ibm,sdram-4xx-ddr2" ECC controller realized in the AMCC PowerPC 405EX[r].

At present, this driver has been developed and tested against the
controller realization in the AMCC PPC405EX[r] on the AMCC Kilauea and
Haleakala boards (256 MiB w/o ECC memory soldered onto the board) and a
proprietary board based on those designs (128 MiB ECC memory, also
soldered onto the board).

In the future, dynamic feature detection and handling needs to be added
for the other realizations of this controller found in the 440SP, 440SPe,
460EX, 460GT and 460SX.

Eventually, this driver will likely be evolved and adapted to the above
variant realizations of this controller as well as broken apart to handle
the other known ECC-capable controllers prevalent in other PPC4xx
processors:

  - IBM SDRAM (405GP, 405CR and 405EP) "ibm,sdram-4xx"
  - IBM DDR1 (440GP, 440GX, 440EP and 440GR) "ibm,sdram-4xx-ddr"
  - Denali DDR1/DDR2 (440EPX and 440GRX) "denali,sdram-4xx-ddr2"

Signed-off-by: Grant Erickson <gerickson@nuovations.com>
Cc: Doug Thompson <dougthompson@xmission.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/ppc4xx_edac.c |  386 +++++++++++++++++++----------------
 1 file changed, 210 insertions(+), 176 deletions(-)

diff -puN drivers/edac/ppc4xx_edac.c~edac-new-ppc4xx-driver-module-update drivers/edac/ppc4xx_edac.c
--- a/drivers/edac/ppc4xx_edac.c~edac-new-ppc4xx-driver-module-update
+++ a/drivers/edac/ppc4xx_edac.c
@@ -235,13 +235,14 @@ static const char * const ppc4xx_plb_mas
 };
 
 /**
+ * mfsdram - read and return controller register data
+ * @dcr_host: A pointer to the DCR mapping.
+ * @idcr_n: The indirect DCR register to read.
+ *
  * This routine reads and returns the data associated with the
  * controller's specified indirect DCR register.
  *
- * @param dcr_host A pointer to the DCR mapping.
- * @param idcr_n The indirect DCR register to read.
- *
- * @return The read data.
+ * Returns the read data.
  */
 static inline u32
 mfsdram(const dcr_host_t *dcr_host, unsigned int idcr_n)
@@ -252,12 +253,13 @@ mfsdram(const dcr_host_t *dcr_host, unsi
 }
 
 /**
+ * mtsdram - write controller register data
+ * @dcr_host: A pointer to the DCR mapping.
+ * @idcr_n: The indirect DCR register to write.
+ * @value: The data to write.
+ *
  * This routine writes the provided data to the controller's specified
  * indirect DCR register.
- *
- * @param dcr_host A pointer to the DCR mapping.
- * @param idcr_n The indirect DCR register to write.
- * @param value The data to write.
  */
 static inline void
 mtsdram(const dcr_host_t *dcr_host, unsigned int idcr_n, u32 value)
@@ -269,14 +271,15 @@ mtsdram(const dcr_host_t *dcr_host, unsi
 }
 
 /**
+ * ppc4xx_edac_check_bank_error - check a bank for an ECC bank error
+ * @status: A pointer to the ECC status structure to check for an
+ *          ECC bank error.
+ * @bank: The bank to check for an ECC error.
+ *
  * This routine determines whether the specified bank has an ECC
  * error.
  *
- * @param status A pointer to the ECC status structure to check for an
- * ECC bank error.
- * @param bank The bank to check for an ECC error.
- *
- * @return True if the specified bank has an ECC error; otherwise,
+ * Returns true if the specified bank has an ECC error; otherwise,
  * false.
  */
 static bool
@@ -294,19 +297,20 @@ ppc4xx_edac_check_bank_error(const struc
 }
 
 /**
+ * ppc4xx_edac_generate_bank_message - generate interpretted bank status message
+ * @mci: A pointer to the EDAC memory controller instance associated
+ *       with the bank message being generated.
+ * @status: A pointer to the ECC status structure to generate the
+ *          message from.
+ * @buffer: A pointer to the buffer in which to generate the
+ *          message.
+ * @size: The size, in bytes, of space available in buffer.
+ *
  * This routine generates to the provided buffer the portion of the
  * driver-unique report message associated with the ECCESS[BKNER]
  * field of the specified ECC status.
  *
- * @param mci A pointer to the EDAC memory controller instance
- * associated with the bank message being generated.
- * @param status A pointer to the ECC status structure to generate the
- * message from.
- * @param buffer A pointer to the buffer in which to generate the
- * message.
- * @param size The size, in bytes, of space available in buffer.
- *
- * @return The number of characters generated on success; otherwise, <
+ * Returns the number of characters generated on success; otherwise, <
  * 0 on error.
  */
 static int
@@ -316,7 +320,7 @@ ppc4xx_edac_generate_bank_message(const 
 				  size_t size)
 {
 	int n, total = 0;
-	size_t row, rows;
+	unsigned int row, rows;
 
 	n = snprintf(buffer, size, "%s: Banks: ", mci->dev_name);
 
@@ -329,16 +333,16 @@ ppc4xx_edac_generate_bank_message(const 
 
 	for (rows = 0, row = 0; row < mci->nr_csrows; row++)
 		if (ppc4xx_edac_check_bank_error(status, row)) {
-				n = snprintf(buffer, size,
-					 "%s%d",
+			    n = snprintf(buffer, size,
+					 "%s%u",
 					 (rows++ ? ", " : ""), row);
 
-			if (n < 0 || n >= size)
-				goto fail;
+		    if (n < 0 || n >= size)
+			    goto fail;
 
-			buffer += n;
-			size -= n;
-			total += n;
+		    buffer += n;
+		    size -= n;
+		    total += n;
 		}
 
 	n = snprintf(buffer, size, "%s; ", rows ? "" : "None");
@@ -355,19 +359,20 @@ ppc4xx_edac_generate_bank_message(const 
 }
 
 /**
+ * ppc4xx_edac_generate_checkbit_message - generate interpretted checkbit message
+ * @mci: A pointer to the EDAC memory controller instance associated
+ *       with the checkbit message being generated.
+ * @status: A pointer to the ECC status structure to generate the
+ *          message from.
+ * @buffer: A pointer to the buffer in which to generate the
+ *          message.
+ * @size: The size, in bytes, of space available in buffer.
+ *
  * This routine generates to the provided buffer the portion of the
  * driver-unique report message associated with the ECCESS[CKBER]
  * field of the specified ECC status.
  *
- * @param mci A pointer to the EDAC memory controller instance
- * associated with the checkbit message being generated.
- * @param status A pointer to the ECC status structure to generate the
- * message from.
- * @param buffer A pointer to the buffer in which to generate the
- * message.
- * @param size The size, in bytes, of space available in buffer.
- *
- * @return The number of characters generated on success; otherwise, <
+ * Returns the number of characters generated on success; otherwise, <
  * 0 on error.
  */
 static int
@@ -412,19 +417,20 @@ ppc4xx_edac_generate_checkbit_message(co
 }
 
 /**
+ * ppc4xx_edac_generate_lane_message - generate interpretted byte lane message
+ * @mci: A pointer to the EDAC memory controller instance associated
+ *       with the byte lane message being generated.
+ * @status: A pointer to the ECC status structure to generate the
+ *          message from.
+ * @buffer: A pointer to the buffer in which to generate the
+ *          message.
+ * @size: The size, in bytes, of space available in buffer.
+ *
  * This routine generates to the provided buffer the portion of the
  * driver-unique report message associated with the ECCESS[BNCE]
  * field of the specified ECC status.
  *
- * @param mci A pointer to the EDAC memory controller instance
- * associated with the byte lane message being generated.
- * @param status A pointer to the ECC status structure to generate the
- * message from.
- * @param buffer A pointer to the buffer in which to generate the
- * message.
- * @param size The size, in bytes, of space available in buffer.
- *
- * @return The number of characters generated on success; otherwise, <
+ * Returns the number of characters generated on success; otherwise, <
  * 0 on error.
  */
 static int
@@ -434,7 +440,7 @@ ppc4xx_edac_generate_lane_message(const 
 				  size_t size)
 {
 	int n, total = 0;
-	size_t lane, lanes;
+	unsigned int lane, lanes;
 	const unsigned int first_lane = 0;
 	const unsigned int lane_count = 16;
 
@@ -450,7 +456,7 @@ ppc4xx_edac_generate_lane_message(const 
 	for (lanes = 0, lane = first_lane; lane < lane_count; lane++) {
 		if ((status->ecces & SDRAM_ECCES_BNCE_ENCODE(lane)) != 0) {
 			n = snprintf(buffer, size,
-				     "%s%d",
+				     "%s%u",
 				     (lanes++ ? ", " : ""), lane);
 
 			if (n < 0 || n >= size)
@@ -476,19 +482,20 @@ ppc4xx_edac_generate_lane_message(const 
 }
 
 /**
+ * ppc4xx_edac_generate_ecc_message - generate interpretted ECC status message
+ * @mci: A pointer to the EDAC memory controller instance associated
+ *       with the ECCES message being generated.
+ * @status: A pointer to the ECC status structure to generate the
+ *          message from.
+ * @buffer: A pointer to the buffer in which to generate the
+ *          message.
+ * @size: The size, in bytes, of space available in buffer.
+ *
  * This routine generates to the provided buffer the portion of the
  * driver-unique report message associated with the ECCESS register of
  * the specified ECC status.
  *
- * @param mci A pointer to the EDAC memory controller instance
- * associated with the ECCES message being generated.
- * @param status A pointer to the ECC status structure to generate the
- * message from.
- * @param buffer A pointer to the buffer in which to generate the
- * message.
- * @param size The size, in bytes, of space available in buffer.
- *
- * @return The number of characters generated on success; otherwise, <
+ * Returns the number of characters generated on success; otherwise, <
  * 0 on error.
  */
 static int
@@ -531,19 +538,20 @@ ppc4xx_edac_generate_ecc_message(const s
 }
 
 /**
+ * ppc4xx_edac_generate_plb_message - generate interpretted PLB status message
+ * @mci: A pointer to the EDAC memory controller instance associated
+ *       with the PLB message being generated.
+ * @status: A pointer to the ECC status structure to generate the
+ *          message from.
+ * @buffer: A pointer to the buffer in which to generate the
+ *          message.
+ * @size: The size, in bytes, of space available in buffer.
+ *
  * This routine generates to the provided buffer the portion of the
  * driver-unique report message associated with the PLB-related BESR
  * and/or WMIRQ registers of the specified ECC status.
  *
- * @param mci A pointer to the EDAC memory controller instance
- * associated with the PLB message being generated.
- * @param status A pointer to the ECC status structure to generate the
- * message from.
- * @param buffer A pointer to the buffer in which to generate the
- * message.
- * @param size The size, in bytes, of space available in buffer.
- *
- * @return The number of characters generated on success; otherwise, <
+ * Returns the number of characters generated on success; otherwise, <
  * 0 on error.
  */
 static int
@@ -575,16 +583,17 @@ ppc4xx_edac_generate_plb_message(const s
 }
 
 /**
+ * ppc4xx_edac_generate_message - generate interpretted status message
+ * @mci: A pointer to the EDAC memory controller instance associated
+ *       with the driver-unique message being generated.
+ * @status: A pointer to the ECC status structure to generate the
+ *          message from.
+ * @buffer: A pointer to the buffer in which to generate the
+ *          message.
+ * @size: The size, in bytes, of space available in buffer.
+ *
  * This routine generates to the provided buffer the driver-unique
  * EDAC report message from the specified ECC status.
- *
- * @param mci A pointer to the EDAC memory controller instance
- * associated with the driver-unique message being generated.
- * @param status A pointer to the ECC status structure to generate the
- * message from.
- * @param buffer A pointer to the buffer in which to generate the
- * message.
- * @param size The size, in bytes, of space available in buffer.
  */
 static void
 ppc4xx_edac_generate_message(const struct mem_ctl_info *mci,
@@ -610,13 +619,14 @@ ppc4xx_edac_generate_message(const struc
 
 #ifdef DEBUG
 /**
+ * ppc4xx_ecc_dump_status - dump controller ECC status registers
+ * @mci: A pointer to the EDAC memory controller instance
+ *       associated with the status being dumped.
+ * @status: A pointer to the ECC status structure to generate the
+ *          dump from.
+ *
  * This routine dumps to the kernel log buffer the raw and
  * interpretted specified ECC status.
- *
- * @param mci A pointer to the EDAC memory controller instance
- * associated with the status being dumped.
- * @param status A pointer to the ECC status structure to generate the
- * dump from.
  */
 static void
 ppc4xx_ecc_dump_status(const struct mem_ctl_info *mci,
@@ -643,16 +653,17 @@ ppc4xx_ecc_dump_status(const struct mem_
 #endif /* DEBUG */
 
 /**
- * Read and masks, as appropriate, all the relevant status registers
- * that deal with ibm,sdram-4xx-ddr2 ECC errors. While we read all of
- * them, for correctable errors, we only expect to deal with
- * ECCES. For uncorrectable errors, we expect to deal with all of
- * them.
- *
- * @param mci A pointer to the EDAC memory controller instance
- * associated with the status being retrieved.
- * @param status A pointer to the ECC status structure to populate the
- * ECC status with.
+ * ppc4xx_ecc_get_status - get controller ECC status
+ * @mci: A pointer to the EDAC memory controller instance
+ *       associated with the status being retrieved.
+ * @status: A pointer to the ECC status structure to populate the
+ *          ECC status with.
+ *
+ * This routine reads and masks, as appropriate, all the relevant
+ * status registers that deal with ibm,sdram-4xx-ddr2 ECC errors.
+ * While we read all of them, for correctable errors, we only expect
+ * to deal with ECCES. For uncorrectable errors, we expect to deal
+ * with all of them.
  */
 static void
 ppc4xx_ecc_get_status(const struct mem_ctl_info *mci,
@@ -669,14 +680,15 @@ ppc4xx_ecc_get_status(const struct mem_c
 }
 
 /**
+ * ppc4xx_ecc_clear_status - clear controller ECC status
+ * @mci: A pointer to the EDAC memory controller instance
+ *       associated with the status being cleared.
+ * @status: A pointer to the ECC status structure containing the
+ *          values to write to clear the ECC status.
+ *
  * This routine clears--by writing the masked (as appropriate) status
  * values back to--the status registers that deal with
  * ibm,sdram-4xx-ddr2 ECC errors.
- *
- * @param mci A pointer to the EDAC memory controller instance
- * associated with the status being cleared.
- * @param status A pointer to the ECC status structure containing the
- * values to write to clear the ECC status.
  */
 static void
 ppc4xx_ecc_clear_status(const struct mem_ctl_info *mci,
@@ -693,16 +705,17 @@ ppc4xx_ecc_clear_status(const struct mem
 }
 
 /**
+ * ppc4xx_edac_handle_ce - handle controller correctable ECC error (CE)
+ * @mci: A pointer to the EDAC memory controller instance
+ *       associated with the correctable error being handled and reported.
+ * @status: A pointer to the ECC status structure associated with
+ *          the correctable error being handled and reported.
+ *
  * This routine handles an ibm,sdram-4xx-ddr2 controller ECC
  * correctable error. Per the aforementioned discussion, there's not
  * enough status available to use the full EDAC correctable error
  * interface, so we just pass driver-unique message to the "no info"
  * interface.
- *
- * @param mci A pointer to the EDAC memory controller instance
- * associated with the correctable error being handled and reported.
- * @param status A pointer to the ECC status structure associated with
- * the correctable error being handled and reported.
  */
 static void
 ppc4xx_edac_handle_ce(struct mem_ctl_info *mci,
@@ -719,21 +732,23 @@ ppc4xx_edac_handle_ce(struct mem_ctl_inf
 }
 
 /**
+ * ppc4xx_edac_handle_ue - handle controller uncorrectable ECC error (UE)
+ * @mci: A pointer to the EDAC memory controller instance
+ *       associated with the uncorrectable error being handled and
+ *       reported.
+ * @status: A pointer to the ECC status structure associated with
+ *          the uncorrectable error being handled and reported.
+ *
  * This routine handles an ibm,sdram-4xx-ddr2 controller ECC
  * uncorrectable error.
- *
- * @param mci A pointer to the EDAC memory controller instance
- * associated with the uncorrectable error being handled and reported.
- * @param status A pointer to the ECC status structure associated with
- * the uncorrectable error being handled and reported.
  */
 static void
 ppc4xx_edac_handle_ue(struct mem_ctl_info *mci,
 		      const struct ppc4xx_ecc_status *status)
 {
 	const u64 bear = ((u64)status->bearh << 32 | status->bearl);
-	const unsigned long pfn = bear >> PAGE_SHIFT;
-	const unsigned long poff = bear & ~PAGE_MASK;
+	const unsigned long page = bear >> PAGE_SHIFT;
+	const unsigned long offset = bear & ~PAGE_MASK;
 	int row;
 	char message[PPC4XX_EDAC_MESSAGE_SIZE];
 
@@ -741,16 +756,18 @@ ppc4xx_edac_handle_ue(struct mem_ctl_inf
 
 	for (row = 0; row < mci->nr_csrows; row++)
 		if (ppc4xx_edac_check_bank_error(status, row))
-			edac_mc_handle_ue(mci, pfn, poff, row, message);
+			edac_mc_handle_ue(mci, page, offset, row, message);
 }
 
 /**
+ * ppc4xx_edac_check - check controller for ECC errors
+ * @mci: A pointer to the EDAC memory controller instance
+ *       associated with the ibm,sdram-4xx-ddr2 controller being
+ *       checked.
+ *
  * This routine is used to check and post ECC errors and is called by
  * both the EDAC polling thread and this driver's CE and UE interrupt
  * handler.
- *
- * @param mci A pointer to the EDAC memory controller instance
- * associated with the ibm,sdram-4xx-ddr2 controller being checked.
  */
 static void
 ppc4xx_edac_check(struct mem_ctl_info *mci)
@@ -777,21 +794,22 @@ ppc4xx_edac_check(struct mem_ctl_info *m
 }
 
 /**
+ * ppc4xx_edac_isr - SEC (CE) and DED (UE) interrupt service routine
+ * @irq:    The virtual interrupt number being serviced.
+ * @dev_id: A pointer to the EDAC memory controller instance
+ *          associated with the interrupt being handled.
+ *
  * This routine implements the interrupt handler for both correctable
- * and uncorrectable ECC errors for the ibm,sdram-4xx-ddr2
+ * (CE) and uncorrectable (UE) ECC errors for the ibm,sdram-4xx-ddr2
  * controller. It simply calls through to the same routine used during
  * polling to check, report and clear the ECC status.
  *
- * @param irq The virtual interrupt number being serviced.
- * @param dev_id A pointer to the EDAC memory controller instance
- * associated with the interrupt being handled.
- *
- * @return
+ * Unconditionally returns IRQ_HANDLED.
  */
 static irqreturn_t
 ppc4xx_edac_isr(int irq, void *dev_id)
 {
-	struct mem_ctl_info *mci = (struct mem_ctl_info *)dev_id;
+	struct mem_ctl_info *mci = dev_id;
 
 	ppc4xx_edac_check(mci);
 
@@ -799,6 +817,11 @@ ppc4xx_edac_isr(int irq, void *dev_id)
 }
 
 /**
+ * ppc4xx_edac_get_dtype - return the controller memory width
+ * @mcopt1: The 32-bit Memory Controller Option 1 register value
+ *          currently set for the controller, from which the width
+ *          is derived.
+ *
  * This routine returns the EDAC device type width appropriate for the
  * current controller configuration.
  *
@@ -808,10 +831,7 @@ ppc4xx_edac_isr(int irq, void *dev_id)
  * 16- and 64-bit field definition/value/enumeration (b1) overloaded
  * among them.
  *
- * @param mcopt1 The 32-bit Memory Controller Option 1 register value
- * currently set for the controller, from which the width is derived.
- *
- * @return A device type width enumeration.
+ * Returns a device type width enumeration.
  */
 static enum dev_type __devinit
 ppc4xx_edac_get_dtype(u32 mcopt1)
@@ -827,14 +847,15 @@ ppc4xx_edac_get_dtype(u32 mcopt1)
 }
 
 /**
+ * ppc4xx_edac_get_mtype - return controller memory type
+ * @mcopt1: The 32-bit Memory Controller Option 1 register value
+ *          currently set for the controller, from which the memory type
+ *          is derived.
+ *
  * This routine returns the EDAC memory type appropriate for the
  * current controller configuration.
  *
- * @param The 32-bit Memory Controller Option 1 register value
- * currently set for the controller, from which the memory type is
- * derived.
- *
- * @return A memory type enumeration.
+ * Returns a memory type enumeration.
  */
 static enum mem_type __devinit
 ppc4xx_edac_get_mtype(u32 mcopt1)
@@ -852,18 +873,19 @@ ppc4xx_edac_get_mtype(u32 mcopt1)
 }
 
 /**
+ * ppc4xx_edac_init_csrows - intialize driver instance rows
+ * @mci: A pointer to the EDAC memory controller instance
+ *       associated with the ibm,sdram-4xx-ddr2 controller for which
+ *       the csrows (i.e. banks/ranks) are being initialized.
+ * @mcopt1: The 32-bit Memory Controller Option 1 register value
+ *          currently set for the controller, from which bank width
+ *          and memory typ information is derived.
+ *
  * This routine intializes the virtual "chip select rows" associated
  * with the EDAC memory controller instance. An ibm,sdram-4xx-ddr2
  * controller bank/rank is mapped to a row.
  *
- * @param mci A pointer to the EDAC memory controller instance
- * associated with the ibm,sdram-4xx-ddr2 controller for which the
- * csrows (i.e. banks/ranks) are being initialized.
- * @param mcopt1 The 32-bit Memory Controller Option 1 register value
- * currently set for the controller, from which bank width and memory
- * typ information is derived.
- *
- * @return 0 if OK; otherwise, -EINVAL if the memory bank size
+ * Returns 0 if OK; otherwise, -EINVAL if the memory bank size
  * configuration cannot be determined.
  */
 static int __devinit
@@ -970,24 +992,25 @@ ppc4xx_edac_init_csrows(struct mem_ctl_i
 }
 
 /**
+ * ppc4xx_edac_mc_init - intialize driver instance
+ * @mci: A pointer to the EDAC memory controller instance being
+ *       initialized.
+ * @op: A pointer to the OpenFirmware device tree node associated
+ *      with the controller this EDAC instance is bound to.
+ * @match: A pointer to the OpenFirmware device tree match
+ *         information associated with the controller this EDAC instance
+ *         is bound to.
+ * @dcr_host: A pointer to the DCR data containing the DCR mapping
+ *            for this controller instance.
+ * @mcopt1: The 32-bit Memory Controller Option 1 register value
+ *          currently set for the controller, from which ECC capabilities
+ *          and scrub mode are derived.
+ *
  * This routine performs initialization of the EDAC memory controller
  * instance and related driver-private data associated with the
  * ibm,sdram-4xx-ddr2 memory controller the instance is bound to.
  *
- * @param mci A pointer to the EDAC memory controller instance being
- * initialized.
- * @param op A pointer to the OpenFirmware device tree node associated
- * with the controller this EDAC instance is bound to.
- * @param match A pointer to the OpenFirmware device tree match
- * information associated with the controller this EDAC instance is
- * bound to.
- * @param dcr_host A pointer to the DCR data containing the DCR mapping
- * for this controller instance.
- * @param mcopt1 The 32-bit Memory Controller Option 1 register value
- * currently set for the controller, from which ECC capabilities and
- * scrub mode are derived.
- *
- * @return 0 if OK; otherwise, < 0 on error.
+ * Returns 0 if OK; otherwise, < 0 on error.
  */
 static int __devinit
 ppc4xx_edac_mc_init(struct mem_ctl_info *mci,
@@ -1001,7 +1024,7 @@ ppc4xx_edac_mc_init(struct mem_ctl_info 
 	struct ppc4xx_edac_pdata *pdata = NULL;
 	const struct device_node *np = op->node;
 
-	if (mci == NULL || op == NULL || match == NULL || dcr_host == NULL)
+	if (match == NULL)
 		return -EINVAL;
 
 	/* Initial driver pointers and private data */
@@ -1070,17 +1093,18 @@ ppc4xx_edac_mc_init(struct mem_ctl_info 
 }
 
 /**
- * This routine parses the correctable and uncorrectable error
+ * ppc4xx_edac_register_irq - setup and register controller interrupts
+ * @op: A pointer to the OpenFirmware device tree node associated
+ *      with the controller this EDAC instance is bound to.
+ * @mci: A pointer to the EDAC memory controller instance
+ *       associated with the ibm,sdram-4xx-ddr2 controller for which
+ *       interrupts are being registered.
+ *
+ * This routine parses the correctable (CE) and uncorrectable error (UE)
  * interrupts from the device tree node and maps and assigns them to
  * the associated EDAC memory controller instance.
  *
- * @param op A pointer to the OpenFirmware device tree node associated
- * with the controller this EDAC instance is bound to.
- * @param mci A pointer to the EDAC memory controller instance
- * associated with the ibm,sdram-4xx-ddr2 controller for which
- * interrupts are being registered.
- *
- * @return 0 if OK; otherwise, -ENODEV if the interrupts could not be
+ * Returns 0 if OK; otherwise, -ENODEV if the interrupts could not be
  * mapped and assigned.
  */
 static int __devinit
@@ -1148,16 +1172,17 @@ ppc4xx_edac_register_irq(struct of_devic
 }
 
 /**
+ * ppc4xx_edac_map_dcrs - locate and map controller registers
+ * @np: A pointer to the device tree node containing the DCR
+ *      resources to map.
+ * @dcr_host: A pointer to the DCR data to populate with the
+ *            DCR mapping.
+ *
  * This routine attempts to locate in the device tree and map the DCR
  * register resources associated with the controller's indirect DCR
  * address and data windows.
  *
- * @param np A pointer to the device tree node containing the DCR
- * resources to map.
- * @param dcr_host A pointer to the DCR data to populate with the
- * DCR mapping.
- *
- * @return 0 if the DCRs were successfully mapped; otherwise, < 0 on
+ * Returns 0 if the DCRs were successfully mapped; otherwise, < 0 on
  * error.
  */
 static int __devinit
@@ -1199,16 +1224,17 @@ ppc4xx_edac_map_dcrs(const struct device
 }
 
 /**
+ * ppc4xx_edac_probe - check controller and bind driver
+ * @op: A pointer to the OpenFirmware device tree node associated
+ *      with the controller being probed for driver binding.
+ * @match: A pointer to the OpenFirmware device tree match
+ *         information associated with the controller being probed
+ *         for driver binding.
+ *
  * This routine probes a specific ibm,sdram-4xx-ddr2 controller
  * instance for binding with the driver.
  *
- * @param op A pointer to the OpenFirmware device tree node associated
- * with the controller being probed for driver binding.
- * @param match A pointer to the OpenFirmware device tree match
- * information associated with the controller being probed for driver
- * binding.
- *
- * @return 0 if the controller instance was successfully bound to the
+ * Returns 0 if the controller instance was successfully bound to the
  * driver; otherwise, < 0 on error.
  */
 static int __devinit
@@ -1321,14 +1347,16 @@ ppc4xx_edac_probe(struct of_device *op, 
 }
 
 /**
+ * ppc4xx_edac_remove - unbind driver from controller
+ * @op: A pointer to the OpenFirmware device tree node associated
+ *      with the controller this EDAC instance is to be unbound/removed
+ *      from.
+ *
  * This routine unbinds the EDAC memory controller instance associated
  * with the specified ibm,sdram-4xx-ddr2 controller described by the
  * OpenFirmware device tree node passed as a parameter.
  *
- * @param op A pointer to the OpenFirmware device tree node associated
- * with the controller this EDAC instance is to be unbound/removed from.
- *
- * @return Unconditionally 0.
+ * Unconditionally returns 0.
  */
 static int
 ppc4xx_edac_remove(struct of_device *op)
@@ -1350,6 +1378,8 @@ ppc4xx_edac_remove(struct of_device *op)
 }
 
 /**
+ * ppc4xx_edac_opstate_init - initialize EDAC reporting method
+ *
  * This routine ensures that the EDAC memory controller reporting
  * method is mapped to a sane value as the EDAC core defines the value
  * to EDAC_OPSTATE_INVAL by default. We don't call the global
@@ -1377,6 +1407,8 @@ ppc4xx_edac_opstate_init(void)
 }
 
 /**
+ * ppc4xx_edac_init - driver/module insertion entry point
+ *
  * This routine is the driver/module insertion entry point. It
  * initializes the EDAC memory controller reporting state and
  * registers the driver as an OpenFirmware device tree platform
@@ -1393,6 +1425,8 @@ ppc4xx_edac_init(void)
 }
 
 /**
+ * ppc4xx_edac_exit - driver/module removal entry point
+ *
  * This routine is the driver/module removal entry point. It
  * unregisters the driver as an OpenFirmware device tree platform
  * driver.
_

Patches currently in -mm which might be from gerickson@nuovations.com are

edac-new-ppc4xx-driver-module.patch
edac-new-ppc4xx-driver-module-update.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes-checkpatch-fixes.patch


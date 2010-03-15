From: akpm@linux-foundation.org
Subject: [merged] edac-mpc85xx-improve-sdram-error-reporting.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:01:50 -0400
Message-ID: <201003150702.o2F72NRj016869@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935855Ab0COHC2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:02:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ptyser@xes-inc.com, djiang@mvista.com, dougthompson@xmission.com, galak@gate.crashing.org, mm-commits@vger.kernel.org


The patch titled
     edac: mpc85xx improve SDRAM error reporting
has been removed from the -mm tree.  Its filename was
     edac-mpc85xx-improve-sdram-error-reporting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: mpc85xx improve SDRAM error reporting
From: Peter Tyser <ptyser@xes-inc.com>

Add the ability to detect the specific data line or ECC line which failed
when printing out SDRAM single-bit errors.  An example of a single-bit
SDRAM ECC error is below:

  EDAC MPC85xx MC1: Err Detect Register: 0x80000004
  EDAC MPC85xx MC1: Faulty data bit: 59
  EDAC MPC85xx MC1: Expected Data / ECC:  0x7f80d000_409effa0 / 0x6d
  EDAC MPC85xx MC1: Captured Data / ECC:  0x7780d000_409effa0 / 0x6d
  EDAC MPC85xx MC1: Err addr: 0x00031ca0
  EDAC MPC85xx MC1: PFN: 0x00000031

Knowning which specific data or ECC line caused an error can be useful in
tracking down hardware issues such as improperly terminated signals, loose
pins, etc.

Note that this feature is only currently enabled for 64-bit wide data
buses, 32-bit wide bus support should be added.

I don't have any 32-bit wide systems to test on.  If someone has one and
is willing to give this patch a shot with the check for a 64-bit data bus
removed it would be much appreciated and I can re-submit with both 32 and
64 bit buses supported.

Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Dave Jiang <djiang@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/mpc85xx_edac.c |  146 ++++++++++++++++++++++++++++++++--
 1 file changed, 138 insertions(+), 8 deletions(-)

diff -puN drivers/edac/mpc85xx_edac.c~edac-mpc85xx-improve-sdram-error-reporting drivers/edac/mpc85xx_edac.c
--- a/drivers/edac/mpc85xx_edac.c~edac-mpc85xx-improve-sdram-error-reporting
+++ a/drivers/edac/mpc85xx_edac.c
@@ -668,6 +668,111 @@ static struct of_platform_driver mpc85xx
 
 /**************************** MC Err device ***************************/
 
+/*
+ * Taken from table 8-55 in the MPC8641 User's Manual and/or 9-61 in the
+ * MPC8572 User's Manual.  Each line represents a syndrome bit column as a
+ * 64-bit value, but split into an upper and lower 32-bit chunk.  The labels
+ * below correspond to Freescale's manuals.
+ */
+static unsigned int ecc_table[16] = {
+	/* MSB           LSB */
+	/* [0:31]    [32:63] */
+	0xf00fe11e, 0xc33c0ff7,	/* Syndrome bit 7 */
+	0x00ff00ff, 0x00fff0ff,
+	0x0f0f0f0f, 0x0f0fff00,
+	0x11113333, 0x7777000f,
+	0x22224444, 0x8888222f,
+	0x44448888, 0xffff4441,
+	0x8888ffff, 0x11118882,
+	0xffff1111, 0x22221114,	/* Syndrome bit 0 */
+};
+
+/*
+ * Calculate the correct ECC value for a 64-bit value specified by high:low
+ */
+static u8 calculate_ecc(u32 high, u32 low)
+{
+	u32 mask_low;
+	u32 mask_high;
+	int bit_cnt;
+	u8 ecc = 0;
+	int i;
+	int j;
+
+	for (i = 0; i < 8; i++) {
+		mask_high = ecc_table[i * 2];
+		mask_low = ecc_table[i * 2 + 1];
+		bit_cnt = 0;
+
+		for (j = 0; j < 32; j++) {
+			if ((mask_high >> j) & 1)
+				bit_cnt ^= (high >> j) & 1;
+			if ((mask_low >> j) & 1)
+				bit_cnt ^= (low >> j) & 1;
+		}
+
+		ecc |= bit_cnt << i;
+	}
+
+	return ecc;
+}
+
+/*
+ * Create the syndrome code which is generated if the data line specified by
+ * 'bit' failed.  Eg generate an 8-bit codes seen in Table 8-55 in the MPC8641
+ * User's Manual and 9-61 in the MPC8572 User's Manual.
+ */
+static u8 syndrome_from_bit(unsigned int bit) {
+	int i;
+	u8 syndrome = 0;
+
+	/*
+	 * Cycle through the upper or lower 32-bit portion of each value in
+	 * ecc_table depending on if 'bit' is in the upper or lower half of
+	 * 64-bit data.
+	 */
+	for (i = bit < 32; i < 16; i += 2)
+		syndrome |= ((ecc_table[i] >> (bit % 32)) & 1) << (i / 2);
+
+	return syndrome;
+}
+
+/*
+ * Decode data and ecc syndrome to determine what went wrong
+ * Note: This can only decode single-bit errors
+ */
+static void sbe_ecc_decode(u32 cap_high, u32 cap_low, u32 cap_ecc,
+		       int *bad_data_bit, int *bad_ecc_bit)
+{
+	int i;
+	u8 syndrome;
+
+	*bad_data_bit = -1;
+	*bad_ecc_bit = -1;
+
+	/*
+	 * Calculate the ECC of the captured data and XOR it with the captured
+	 * ECC to find an ECC syndrome value we can search for
+	 */
+	syndrome = calculate_ecc(cap_high, cap_low) ^ cap_ecc;
+
+	/* Check if a data line is stuck... */
+	for (i = 0; i < 64; i++) {
+		if (syndrome == syndrome_from_bit(i)) {
+			*bad_data_bit = i;
+			return;
+		}
+	}
+
+	/* If data is correct, check ECC bits for errors... */
+	for (i = 0; i < 8; i++) {
+		if ((syndrome >> i) & 0x1) {
+			*bad_ecc_bit = i;
+			return;
+		}
+	}
+}
+
 static void mpc85xx_mc_check(struct mem_ctl_info *mci)
 {
 	struct mpc85xx_mc_pdata *pdata = mci->pvt_info;
@@ -678,6 +783,10 @@ static void mpc85xx_mc_check(struct mem_
 	u32 err_addr;
 	u32 pfn;
 	int row_index;
+	u32 cap_high;
+	u32 cap_low;
+	int bad_data_bit;
+	int bad_ecc_bit;
 
 	err_detect = in_be32(pdata->mc_vbase + MPC85XX_MC_ERR_DETECT);
 	if (!err_detect)
@@ -711,14 +820,35 @@ static void mpc85xx_mc_check(struct mem_
 			break;
 	}
 
-	mpc85xx_mc_printk(mci, KERN_ERR, "Capture Data High: %#8.8x\n",
-			  in_be32(pdata->mc_vbase +
-				  MPC85XX_MC_CAPTURE_DATA_HI));
-	mpc85xx_mc_printk(mci, KERN_ERR, "Capture Data Low: %#8.8x\n",
-			  in_be32(pdata->mc_vbase +
-				  MPC85XX_MC_CAPTURE_DATA_LO));
-	mpc85xx_mc_printk(mci, KERN_ERR, "syndrome: %#2.2x\n", syndrome);
-	mpc85xx_mc_printk(mci, KERN_ERR, "err addr: %#8.8x\n", err_addr);
+	cap_high = in_be32(pdata->mc_vbase + MPC85XX_MC_CAPTURE_DATA_HI);
+	cap_low = in_be32(pdata->mc_vbase + MPC85XX_MC_CAPTURE_DATA_LO);
+
+	/*
+	 * Analyze single-bit errors on 64-bit wide buses
+	 * TODO: Add support for 32-bit wide buses
+	 */
+	if ((err_detect & DDR_EDE_SBE) && (bus_width == 64)) {
+		sbe_ecc_decode(cap_high, cap_low, syndrome,
+				&bad_data_bit, &bad_ecc_bit);
+
+		if (bad_data_bit != -1)
+			mpc85xx_mc_printk(mci, KERN_ERR,
+				"Faulty Data bit: %d\n", bad_data_bit);
+		if (bad_ecc_bit != -1)
+			mpc85xx_mc_printk(mci, KERN_ERR,
+				"Faulty ECC bit: %d\n", bad_ecc_bit);
+
+		mpc85xx_mc_printk(mci, KERN_ERR,
+			"Expected Data / ECC:\t%#8.8x_%08x / %#2.2x\n",
+			cap_high ^ (1 << (bad_data_bit - 32)),
+			cap_low ^ (1 << bad_data_bit),
+			syndrome ^ (1 << bad_ecc_bit));
+	}
+
+	mpc85xx_mc_printk(mci, KERN_ERR,
+			"Captured Data / ECC:\t%#8.8x_%08x / %#2.2x\n",
+			cap_high, cap_low, syndrome);
+	mpc85xx_mc_printk(mci, KERN_ERR, "Err addr: %#8.8x\n", err_addr);
 	mpc85xx_mc_printk(mci, KERN_ERR, "PFN: %#8.8x\n", pfn);
 
 	/* we are out of range */
_

Patches currently in -mm which might be from ptyser@xes-inc.com are

origin.patch


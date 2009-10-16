From: akpm@linux-foundation.org
Subject: + edac-i5400-fix-csrow-mapping.patch added to -mm tree
Date: Thu, 15 Oct 2009 20:39:33 -0700
Message-ID: <200910160339.n9G3dXYp014778@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55004 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752549AbZJPDkQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Oct 2009 23:40:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jroberson@jroberson.net, dougthompson@xmission.com


The patch titled
     edac: i5400 fix csrow mapping
has been added to the -mm tree.  Its filename is
     edac-i5400-fix-csrow-mapping.patch

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
Subject: edac: i5400 fix csrow mapping
From: Jeff Roberson <jroberson@jroberson.net>

The i5400 EDAC driver has several bugs with chip-select row computation
which most likely lead to bugs in detailed error reporting.  Attempts to
contact the authors have gone mostly unanswered so I am presenting my diff
here.  I do not subscribe to lkml and would appreciate being kept in the
cc.

The most egregious problem was miscalculating the addresses of MTR
registers after register 0 by assuming they are 32bit rather than 16. 
This caused the driver to miss half of the memories.  Most motherboards
tend to have only 8 dimm slots and not 16, so this may not have been
noticed before.

Further, the row calculations multiplied the number of dimms several
times, ultimately ending up with a maximum row of 32.  The chipset only
supports 4 dimms in each of 4 channels, so csrow could not be higher than
4 unless you use a row per-rank with dual-rank dimms.  I opted to
eliminate this behavior as it is confusing to the user and the error
reporting works by slot and not rank.  This gives a much clearer view of
memory by slot and channel in /sys.

Signed-off-by: Jeff Roberson <jroberson@jroberson.net>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i5400_edac.c |   87 +++++++++++-------------------------
 1 file changed, 27 insertions(+), 60 deletions(-)

diff -puN drivers/edac/i5400_edac.c~edac-i5400-fix-csrow-mapping drivers/edac/i5400_edac.c
--- a/drivers/edac/i5400_edac.c~edac-i5400-fix-csrow-mapping
+++ a/drivers/edac/i5400_edac.c
@@ -46,9 +46,10 @@
 /* Limits for i5400 */
 #define NUM_MTRS_PER_BRANCH	4
 #define CHANNELS_PER_BRANCH	2
+#define MAX_DIMMS_PER_CHANNEL	NUM_MTRS_PER_BRANCH
 #define	MAX_CHANNELS		4
-#define MAX_DIMMS		(MAX_CHANNELS * 4)	/* Up to 4 DIMM's per channel */
-#define MAX_CSROWS		(MAX_DIMMS * 2)		/* max possible csrows per channel */
+/* max possible csrows per channel */
+#define MAX_CSROWS		(MAX_DIMMS_PER_CHANNEL)
 
 /* Device 16,
  * Function 0: System Address
@@ -331,7 +332,6 @@ static const struct i5400_dev_info i5400
 
 struct i5400_dimm_info {
 	int megabytes;		/* size, 0 means not present  */
-	int dual_rank;
 };
 
 /* driver private data structure */
@@ -849,11 +849,9 @@ static int determine_mtr(struct i5400_pv
 	int n;
 
 	/* There is one MTR for each slot pair of FB-DIMMs,
-	   Each slot may have one or two ranks (2 csrows),
 	   Each slot pair may be at branch 0 or branch 1.
-	   So, csrow should be divided by eight
 	 */
-	n = csrow >> 3;
+	n = csrow;
 
 	if (n >= NUM_MTRS_PER_BRANCH) {
 		debugf0("ERROR: trying to access an invalid csrow: %d\n",
@@ -905,25 +903,22 @@ static void handle_channel(struct i5400_
 		amb_present_reg = determine_amb_present_reg(pvt, channel);
 
 		/* Determine if there is a DIMM present in this DIMM slot */
-		if (amb_present_reg & (1 << (csrow >> 1))) {
-			dinfo->dual_rank = MTR_DIMM_RANK(mtr);
+		if (amb_present_reg & (1 << csrow)) {
+			/* Start with the number of bits for a Bank
+			 * on the DRAM */
+			addrBits = MTR_DRAM_BANKS_ADDR_BITS(mtr);
+			/* Add thenumber of ROW bits */
+			addrBits += MTR_DIMM_ROWS_ADDR_BITS(mtr);
+			/* add the number of COLUMN bits */
+			addrBits += MTR_DIMM_COLS_ADDR_BITS(mtr);
+			/* add the number of RANK bits */
+			addrBits += MTR_DIMM_RANK(mtr);
+
+			addrBits += 6;	/* add 64 bits per DIMM */
+			addrBits -= 20;	/* divide by 2^^20 */
+			addrBits -= 3;	/* 8 bits per bytes */
 
-			if (!((dinfo->dual_rank == 0) &&
-				((csrow & 0x1) == 0x1))) {
-				/* Start with the number of bits for a Bank
-				 * on the DRAM */
-				addrBits = MTR_DRAM_BANKS_ADDR_BITS(mtr);
-				/* Add thenumber of ROW bits */
-				addrBits += MTR_DIMM_ROWS_ADDR_BITS(mtr);
-				/* add the number of COLUMN bits */
-				addrBits += MTR_DIMM_COLS_ADDR_BITS(mtr);
-
-				addrBits += 6;	/* add 64 bits per DIMM */
-				addrBits -= 20;	/* divide by 2^^20 */
-				addrBits -= 3;	/* 8 bits per bytes */
-
-				dinfo->megabytes = 1 << addrBits;
-			}
+			dinfo->megabytes = 1 << addrBits;
 		}
 	}
 }
@@ -951,12 +946,12 @@ static void calculate_dimm_size(struct i
 		return;
 	}
 
-	/* Scan all the actual CSROWS (which is # of DIMMS * 2)
+	/* Scan all the actual CSROWS
 	 * and calculate the information for each DIMM
 	 * Start with the highest csrow first, to display it first
 	 * and work toward the 0th csrow
 	 */
-	max_csrows = pvt->maxdimmperch * 2;
+	max_csrows = pvt->maxdimmperch;
 	for (csrow = max_csrows - 1; csrow >= 0; csrow--) {
 
 		/* on an odd csrow, first output a 'boundary' marker,
@@ -1064,7 +1059,7 @@ static void i5400_get_mc_regs(struct mem
 
 	/* Get the set of MTR[0-3] regs by each branch */
 	for (slot_row = 0; slot_row < NUM_MTRS_PER_BRANCH; slot_row++) {
-		int where = MTR0 + (slot_row * sizeof(u32));
+		int where = MTR0 + (slot_row * sizeof(u16));
 
 		/* Branch 0 set of MTR registers */
 		pci_read_config_word(pvt->branch_0, where,
@@ -1146,7 +1141,7 @@ static int i5400_init_csrows(struct mem_
 	pvt = mci->pvt_info;
 
 	channel_count = pvt->maxch;
-	max_csrows = pvt->maxdimmperch * 2;
+	max_csrows = pvt->maxdimmperch;
 
 	empty = 1;		/* Assume NO memory */
 
@@ -1215,28 +1210,6 @@ static void i5400_enable_error_reporting
 }
 
 /*
- * i5400_get_dimm_and_channel_counts(pdev, &num_csrows, &num_channels)
- *
- *	ask the device how many channels are present and how many CSROWS
- *	 as well
- */
-static void i5400_get_dimm_and_channel_counts(struct pci_dev *pdev,
-					int *num_dimms_per_channel,
-					int *num_channels)
-{
-	u8 value;
-
-	/* Need to retrieve just how many channels and dimms per channel are
-	 * supported on this memory controller
-	 */
-	pci_read_config_byte(pdev, MAXDIMMPERCH, &value);
-	*num_dimms_per_channel = (int)value * 2;
-
-	pci_read_config_byte(pdev, MAXCH, &value);
-	*num_channels = (int)value;
-}
-
-/*
  *	i5400_probe1	Probe for ONE instance of device to see if it is
  *			present.
  *	return:
@@ -1263,22 +1236,16 @@ static int i5400_probe1(struct pci_dev *
 	if (PCI_FUNC(pdev->devfn) != 0)
 		return -ENODEV;
 
-	/* Ask the devices for the number of CSROWS and CHANNELS so
-	 * that we can calculate the memory resources, etc
-	 *
-	 * The Chipset will report what it can handle which will be greater
-	 * or equal to what the motherboard manufacturer will implement.
-	 *
-	 * As we don't have a motherboard identification routine to determine
+	/* As we don't have a motherboard identification routine to determine
 	 * actual number of slots/dimms per channel, we thus utilize the
 	 * resource as specified by the chipset. Thus, we might have
 	 * have more DIMMs per channel than actually on the mobo, but this
 	 * allows the driver to support upto the chipset max, without
 	 * some fancy mobo determination.
 	 */
-	i5400_get_dimm_and_channel_counts(pdev, &num_dimms_per_channel,
-					&num_channels);
-	num_csrows = num_dimms_per_channel * 2;
+	num_dimms_per_channel = MAX_DIMMS_PER_CHANNEL;
+	num_channels = MAX_CHANNELS;
+	num_csrows = num_dimms_per_channel;
 
 	debugf0("MC: %s(): Number of - Channels= %d  DIMMS= %d  CSROWS= %d\n",
 		__func__, num_channels, num_dimms_per_channel, num_csrows);
_

Patches currently in -mm which might be from jroberson@jroberson.net are

edac-i5400-fix-csrow-mapping.patch


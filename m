From: akpm@linux-foundation.org
Subject: - edac-i5000-fix-error-messages.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:19:24 -0700
Message-ID: <200810182319.m9INJOBW029473@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37986 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868AbYJRXTu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:19:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aris@redhat.com, alan@lxorguk.ukuu.org.uk, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     edac i5000: fix error messages
has been removed from the -mm tree.  Its filename was
     edac-i5000-fix-error-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac i5000: fix error messages
From: Aristeu Rozanski <aris@redhat.com>

Update the i5000_edac messages, making everything pass through the EDAC
(so the log controls will work) and being more specific about the errors. 
Also, it makes the miscellaneous errors optional and disabled by default.

As I didn't found anywhere information about M23ERR-M26ERR
(FERR_NF_THERMAL) on FERR_NF_FBD, I'm removing them.

Signed-off-by: Aristeu Rozanski <aris@redhat.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i5000_edac.c |  181 +++++++++++++++++++++++-------------
 1 file changed, 119 insertions(+), 62 deletions(-)

diff -puN drivers/edac/i5000_edac.c~edac-i5000-fix-error-messages drivers/edac/i5000_edac.c
--- a/drivers/edac/i5000_edac.c~edac-i5000-fix-error-messages
+++ a/drivers/edac/i5000_edac.c
@@ -119,6 +119,7 @@
 #define			FERR_NF_UNCORRECTABLE	(FERR_NF_M12ERR | \
 							FERR_NF_M11ERR | \
 							FERR_NF_M10ERR | \
+							FERR_NF_M9ERR | \
 							FERR_NF_M8ERR | \
 							FERR_NF_M7ERR | \
 							FERR_NF_M6ERR | \
@@ -301,6 +302,9 @@ static char *numcol_toString[] = {
 };
 #endif
 
+/* enables the report of miscellaneous messages as CE errors - default off */
+static int misc_messages;
+
 /* Enumeration of supported devices */
 enum i5000_chips {
 	I5000P = 0,
@@ -466,7 +470,8 @@ static void i5000_process_fatal_error_in
 					struct i5000_error_info *info,
 					int handle_errors)
 {
-	char msg[EDAC_MC_LABEL_LEN + 1 + 90];
+	char msg[EDAC_MC_LABEL_LEN + 1 + 160];
+	char *specific = NULL;
 	u32 allErrors;
 	int branch;
 	int channel;
@@ -480,11 +485,6 @@ static void i5000_process_fatal_error_in
 	if (!allErrors)
 		return;		/* if no error, return now */
 
-	/* ONLY ONE of the possible error bits will be set, as per the docs */
-	i5000_mc_printk(mci, KERN_ERR,
-			"FATAL ERRORS Found!!! 1st FATAL Err Reg= 0x%x\n",
-			allErrors);
-
 	branch = EXTRACT_FBDCHAN_INDX(info->ferr_fat_fbd);
 	channel = branch;
 
@@ -501,28 +501,27 @@ static void i5000_process_fatal_error_in
 		rdwr ? "Write" : "Read", ras, cas);
 
 	/* Only 1 bit will be on */
-	if (allErrors & FERR_FAT_M1ERR) {
-		i5000_mc_printk(mci, KERN_ERR,
-				"Alert on non-redundant retry or fast "
-				"reset timeout\n");
-
-	} else if (allErrors & FERR_FAT_M2ERR) {
-		i5000_mc_printk(mci, KERN_ERR,
-				"Northbound CRC error on non-redundant "
-				"retry\n");
-
-	} else if (allErrors & FERR_FAT_M3ERR) {
-		i5000_mc_printk(mci, KERN_ERR,
-				">Tmid Thermal event with intelligent "
-				"throttling disabled\n");
+	switch (allErrors) {
+	case FERR_FAT_M1ERR:
+		specific = "Alert on non-redundant retry or fast "
+				"reset timeout";
+		break;
+	case FERR_FAT_M2ERR:
+		specific = "Northbound CRC error on non-redundant "
+				"retry";
+		break;
+	case FERR_FAT_M3ERR:
+		specific = ">Tmid Thermal event with intelligent "
+				"throttling disabled";
+		break;
 	}
 
 	/* Form out message */
 	snprintf(msg, sizeof(msg),
 		 "(Branch=%d DRAM-Bank=%d RDWR=%s RAS=%d CAS=%d "
-		 "FATAL Err=0x%x)",
+		 "FATAL Err=0x%x (%s))",
 		 branch >> 1, bank, rdwr ? "Write" : "Read", ras, cas,
-		 allErrors);
+		 allErrors, specific);
 
 	/* Call the helper to output message */
 	edac_mc_handle_fbd_ue(mci, rank, channel, channel + 1, msg);
@@ -539,7 +538,8 @@ static void i5000_process_nonfatal_error
 					struct i5000_error_info *info,
 					int handle_errors)
 {
-	char msg[EDAC_MC_LABEL_LEN + 1 + 90];
+	char msg[EDAC_MC_LABEL_LEN + 1 + 170];
+	char *specific = NULL;
 	u32 allErrors;
 	u32 ue_errors;
 	u32 ce_errors;
@@ -557,10 +557,6 @@ static void i5000_process_nonfatal_error
 		return;		/* if no error, return now */
 
 	/* ONLY ONE of the possible error bits will be set, as per the docs */
-	i5000_mc_printk(mci, KERN_WARNING,
-			"NON-FATAL ERRORS Found!!! 1st NON-FATAL Err "
-			"Reg= 0x%x\n", allErrors);
-
 	ue_errors = allErrors & FERR_NF_UNCORRECTABLE;
 	if (ue_errors) {
 		debugf0("\tUncorrected bits= 0x%x\n", ue_errors);
@@ -579,12 +575,47 @@ static void i5000_process_nonfatal_error
 			rank, channel, channel + 1, branch >> 1, bank,
 			rdwr ? "Write" : "Read", ras, cas);
 
+		switch (ue_errors) {
+		case FERR_NF_M12ERR:
+			specific = "Non-Aliased Uncorrectable Patrol Data ECC";
+			break;
+		case FERR_NF_M11ERR:
+			specific = "Non-Aliased Uncorrectable Spare-Copy "
+					"Data ECC";
+			break;
+		case FERR_NF_M10ERR:
+			specific = "Non-Aliased Uncorrectable Mirrored Demand "
+					"Data ECC";
+			break;
+		case FERR_NF_M9ERR:
+			specific = "Non-Aliased Uncorrectable Non-Mirrored "
+					"Demand Data ECC";
+			break;
+		case FERR_NF_M8ERR:
+			specific = "Aliased Uncorrectable Patrol Data ECC";
+			break;
+		case FERR_NF_M7ERR:
+			specific = "Aliased Uncorrectable Spare-Copy Data ECC";
+			break;
+		case FERR_NF_M6ERR:
+			specific = "Aliased Uncorrectable Mirrored Demand "
+					"Data ECC";
+			break;
+		case FERR_NF_M5ERR:
+			specific = "Aliased Uncorrectable Non-Mirrored Demand "
+					"Data ECC";
+			break;
+		case FERR_NF_M4ERR:
+			specific = "Uncorrectable Data ECC on Replay";
+			break;
+		}
+
 		/* Form out message */
 		snprintf(msg, sizeof(msg),
 			 "(Branch=%d DRAM-Bank=%d RDWR=%s RAS=%d "
-			 "CAS=%d, UE Err=0x%x)",
+			 "CAS=%d, UE Err=0x%x (%s))",
 			 branch >> 1, bank, rdwr ? "Write" : "Read", ras, cas,
-			 ue_errors);
+			 ue_errors, specific);
 
 		/* Call the helper to output message */
 		edac_mc_handle_fbd_ue(mci, rank, channel, channel + 1, msg);
@@ -616,51 +647,74 @@ static void i5000_process_nonfatal_error
 			rank, channel, branch >> 1, bank,
 			rdwr ? "Write" : "Read", ras, cas);
 
+		switch (ce_errors) {
+		case FERR_NF_M17ERR:
+			specific = "Correctable Non-Mirrored Demand Data ECC";
+			break;
+		case FERR_NF_M18ERR:
+			specific = "Correctable Mirrored Demand Data ECC";
+			break;
+		case FERR_NF_M19ERR:
+			specific = "Correctable Spare-Copy Data ECC";
+			break;
+		case FERR_NF_M20ERR:
+			specific = "Correctable Patrol Data ECC";
+			break;
+		}
+
 		/* Form out message */
 		snprintf(msg, sizeof(msg),
 			 "(Branch=%d DRAM-Bank=%d RDWR=%s RAS=%d "
-			 "CAS=%d, CE Err=0x%x)", branch >> 1, bank,
-			 rdwr ? "Write" : "Read", ras, cas, ce_errors);
+			 "CAS=%d, CE Err=0x%x (%s))", branch >> 1, bank,
+			 rdwr ? "Write" : "Read", ras, cas, ce_errors,
+			 specific);
 
 		/* Call the helper to output message */
 		edac_mc_handle_fbd_ce(mci, rank, channel, msg);
 	}
 
-	/* See if any of the thermal errors have fired */
-	misc_errors = allErrors & FERR_NF_THERMAL;
-	if (misc_errors) {
-		i5000_printk(KERN_WARNING, "\tTHERMAL Error, bits= 0x%x\n",
-			misc_errors);
-	}
-
-	/* See if any of the thermal errors have fired */
-	misc_errors = allErrors & FERR_NF_NON_RETRY;
-	if (misc_errors) {
-		i5000_printk(KERN_WARNING, "\tNON-Retry  Errors, bits= 0x%x\n",
-			misc_errors);
-	}
+	if (!misc_messages)
+		return;
 
-	/* See if any of the thermal errors have fired */
-	misc_errors = allErrors & FERR_NF_NORTH_CRC;
+	misc_errors = allErrors & (FERR_NF_NON_RETRY | FERR_NF_NORTH_CRC |
+				   FERR_NF_SPD_PROTOCOL | FERR_NF_DIMM_SPARE);
 	if (misc_errors) {
-		i5000_printk(KERN_WARNING,
-			"\tNORTHBOUND CRC  Error, bits= 0x%x\n",
-			misc_errors);
-	}
+		switch (misc_errors) {
+		case FERR_NF_M13ERR:
+			specific = "Non-Retry or Redundant Retry FBD Memory "
+					"Alert or Redundant Fast Reset Timeout";
+			break;
+		case FERR_NF_M14ERR:
+			specific = "Non-Retry or Redundant Retry FBD "
+					"Configuration Alert";
+			break;
+		case FERR_NF_M15ERR:
+			specific = "Non-Retry or Redundant Retry FBD "
+					"Northbound CRC error on read data";
+			break;
+		case FERR_NF_M21ERR:
+			specific = "FBD Northbound CRC error on "
+					"FBD Sync Status";
+			break;
+		case FERR_NF_M22ERR:
+			specific = "SPD protocol error";
+			break;
+		case FERR_NF_M27ERR:
+			specific = "DIMM-spare copy started";
+			break;
+		case FERR_NF_M28ERR:
+			specific = "DIMM-spare copy completed";
+			break;
+		}
+		branch = EXTRACT_FBDCHAN_INDX(info->ferr_nf_fbd);
 
-	/* See if any of the thermal errors have fired */
-	misc_errors = allErrors & FERR_NF_SPD_PROTOCOL;
-	if (misc_errors) {
-		i5000_printk(KERN_WARNING,
-			"\tSPD Protocol  Error, bits= 0x%x\n",
-			misc_errors);
-	}
+		/* Form out message */
+		snprintf(msg, sizeof(msg),
+			 "(Branch=%d Err=%#x (%s))", branch >> 1,
+			 misc_errors, specific);
 
-	/* See if any of the thermal errors have fired */
-	misc_errors = allErrors & FERR_NF_DIMM_SPARE;
-	if (misc_errors) {
-		i5000_printk(KERN_WARNING, "\tDIMM-Spare  Error, bits= 0x%x\n",
-			misc_errors);
+		/* Call the helper to output message */
+		edac_mc_handle_fbd_ce(mci, 0, 0, msg);
 	}
 }
 
@@ -1497,3 +1551,6 @@ MODULE_DESCRIPTION("MC Driver for Intel 
 
 module_param(edac_op_state, int, 0444);
 MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state: 0=Poll,1=NMI");
+module_param(misc_messages, int, 0444);
+MODULE_PARM_DESC(misc_messages, "Log miscellaneous non fatal messages");
+
_

Patches currently in -mm which might be from aris@redhat.com are

origin.patch


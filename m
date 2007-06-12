From: akpm@linux-foundation.org
Subject: + driver-edac-i5000-code-tidying.patch added to -mm tree
Date: Tue, 12 Jun 2007 12:55:25 -0700
Message-ID: <200706121955.l5CJtP6d019980@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46932 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752026AbXFLT4B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 15:56:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dougthompson@xmission.com


The patch titled
     drivers/edac: i5000 code tidying
has been added to the -mm tree.  Its filename is
     driver-edac-i5000-code-tidying.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/edac: i5000 code tidying
From: Douglas Thompson <dougthompson@xmission.com>

Various code style conformance patches on the i5000 driver

Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i5000_edac.c |   71 +++++++++++++++++-------------------
 1 files changed, 35 insertions(+), 36 deletions(-)

diff -puN drivers/edac/i5000_edac.c~driver-edac-i5000-code-tidying drivers/edac/i5000_edac.c
--- a/drivers/edac/i5000_edac.c~driver-edac-i5000-code-tidying
+++ a/drivers/edac/i5000_edac.c
@@ -384,18 +384,18 @@ struct i5000_error_info {
 
 static struct edac_pci_ctl_info *i5000_pci;
 
-/******************************************************************************
+/*
  *	i5000_get_error_info	Retrieve the hardware error information from
  *				the hardware and cache it in the 'info'
  *				structure
  */
 static void i5000_get_error_info(struct mem_ctl_info *mci,
-				 struct i5000_error_info * info)
+				 struct i5000_error_info *info)
 {
 	struct i5000_pvt *pvt;
 	u32 value;
 
-	pvt = (struct i5000_pvt *)mci->pvt_info;
+	pvt = mci->pvt_info;
 
 	/* read in the 1st FATAL error register */
 	pci_read_config_dword(pvt->branchmap_werrors, FERR_FAT_FBD, &value);
@@ -457,7 +457,7 @@ static void i5000_get_error_info(struct 
 	}
 }
 
-/******************************************************************************
+/*
  * i5000_process_fatal_error_info(struct mem_ctl_info *mci,
  * 					struct i5000_error_info *info,
  * 					int handle_errors);
@@ -465,7 +465,7 @@ static void i5000_get_error_info(struct 
  *	handle the Intel FATAL errors, if any
  */
 static void i5000_process_fatal_error_info(struct mem_ctl_info *mci,
-					struct i5000_error_info * info,
+					struct i5000_error_info *info,
 					int handle_errors)
 {
 	char msg[EDAC_MC_LABEL_LEN + 1 + 90];
@@ -530,7 +530,7 @@ static void i5000_process_fatal_error_in
 	edac_mc_handle_fbd_ue(mci, rank, channel, channel + 1, msg);
 }
 
-/******************************************************************************
+/*
  * i5000_process_fatal_error_info(struct mem_ctl_info *mci,
  * 				struct i5000_error_info *info,
  * 				int handle_errors);
@@ -538,7 +538,7 @@ static void i5000_process_fatal_error_in
  *	handle the Intel NON-FATAL errors, if any
  */
 static void i5000_process_nonfatal_error_info(struct mem_ctl_info *mci,
-					struct i5000_error_info * info,
+					struct i5000_error_info *info,
 					int handle_errors)
 {
 	char msg[EDAC_MC_LABEL_LEN + 1 + 90];
@@ -666,12 +666,12 @@ static void i5000_process_nonfatal_error
 	}
 }
 
-/******************************************************************************
+/*
  *	i5000_process_error_info	Process the error info that is
  *	in the 'info' structure, previously retrieved from hardware
  */
 static void i5000_process_error_info(struct mem_ctl_info *mci,
-				struct i5000_error_info * info,
+				struct i5000_error_info *info,
 				int handle_errors)
 {
 	/* First handle any fatal errors that occurred */
@@ -681,7 +681,7 @@ static void i5000_process_error_info(str
 	i5000_process_nonfatal_error_info(mci, info, handle_errors);
 }
 
-/******************************************************************************
+/*
  *	i5000_clear_error	Retrieve any error from the hardware
  *				but do NOT process that error.
  *				Used for 'clearing' out of previous errors
@@ -694,7 +694,7 @@ static void i5000_clear_error(struct mem
 	i5000_get_error_info(mci, &info);
 }
 
-/******************************************************************************
+/*
  *	i5000_check_error	Retrieve and process errors reported by the
  *				hardware. Called by the Core module.
  */
@@ -706,7 +706,7 @@ static void i5000_check_error(struct mem
 	i5000_process_error_info(mci, &info, 1);
 }
 
-/******************************************************************************
+/*
  *	i5000_get_devices	Find and perform 'get' operation on the MCH's
  *			device/functions we want to reference for this driver
  *
@@ -718,7 +718,7 @@ static int i5000_get_devices(struct mem_
 	struct i5000_pvt *pvt;
 	struct pci_dev *pdev;
 
-	pvt = (struct i5000_pvt *)mci->pvt_info;
+	pvt = mci->pvt_info;
 
 	/* Attempt to 'get' the MCH register we want */
 	pdev = NULL;
@@ -827,7 +827,7 @@ static int i5000_get_devices(struct mem_
 	return 0;
 }
 
-/******************************************************************************
+/*
  *	i5000_put_devices	'put' all the devices that we have
  *				reserved via 'get'
  */
@@ -835,19 +835,18 @@ static void i5000_put_devices(struct mem
 {
 	struct i5000_pvt *pvt;
 
-	pvt = (struct i5000_pvt *)mci->pvt_info;
+	pvt = mci->pvt_info;
 
 	pci_dev_put(pvt->branchmap_werrors);	/* FUNC 1 */
 	pci_dev_put(pvt->fsb_error_regs);	/* FUNC 2 */
 	pci_dev_put(pvt->branch_0);	/* DEV 21 */
 
 	/* Only if more than 2 channels do we release the second branch */
-	if (pvt->maxch >= CHANNELS_PER_BRANCH) {
+	if (pvt->maxch >= CHANNELS_PER_BRANCH)
 		pci_dev_put(pvt->branch_1);	/* DEV 22 */
-	}
 }
 
-/******************************************************************************
+/*
  *	determine_amb_resent
  *
  *		the information is contained in NUM_MTRS different registers
@@ -879,7 +878,7 @@ static int determine_amb_present_reg(str
 	return amb_present;
 }
 
-/******************************************************************************
+/*
  * determine_mtr(pvt, csrow, channel)
  *
  *	return the proper MTR register as determine by the csrow and channel desired
@@ -896,7 +895,7 @@ static int determine_mtr(struct i5000_pv
 	return mtr;
 }
 
-/******************************************************************************
+/*
  */
 static void decode_mtr(int slot_row, u16 mtr)
 {
@@ -951,7 +950,7 @@ static void handle_channel(struct i5000_
 	}
 }
 
-/******************************************************************************
+/*
  *	calculate_dimm_size
  *
  *	also will output a DIMM matrix map, if debug is enabled, for viewing
@@ -1037,7 +1036,7 @@ static void calculate_dimm_size(struct i
 	kfree(mem_buffer);
 }
 
-/******************************************************************************
+/*
  *	i5000_get_mc_regs	read in the necessary registers and
  *				cache locally
  *
@@ -1053,7 +1052,7 @@ static void i5000_get_mc_regs(struct mem
 	int maxdimmperch;
 	int way0, way1;
 
-	pvt = (struct i5000_pvt *)mci->pvt_info;
+	pvt = mci->pvt_info;
 
 	pci_read_config_dword(pvt->system_address, AMBASE,
 			(u32 *) & pvt->ambase);
@@ -1151,7 +1150,7 @@ static void i5000_get_mc_regs(struct mem
 	calculate_dimm_size(pvt);
 }
 
-/******************************************************************************
+/*
  *	i5000_init_csrows	Initialize the 'csrows' table within
  *				the mci control	structure with the
  *				addressing of memory.
@@ -1171,7 +1170,7 @@ static int i5000_init_csrows(struct mem_
 	int channel;
 	int csrow;
 
-	pvt = (struct i5000_pvt *)mci->pvt_info;
+	pvt = mci->pvt_info;
 
 	channel_count = pvt->maxch;
 	max_csrows = pvt->maxdimmperch * 2;
@@ -1221,7 +1220,7 @@ static int i5000_init_csrows(struct mem_
 	return empty;
 }
 
-/******************************************************************************
+/*
  *	i5000_enable_error_reporting
  *			Turn on the memory reporting features of the hardware
  */
@@ -1230,7 +1229,7 @@ static void i5000_enable_error_reporting
 	struct i5000_pvt *pvt;
 	u32 fbd_error_mask;
 
-	pvt = (struct i5000_pvt *)mci->pvt_info;
+	pvt = mci->pvt_info;
 
 	/* Read the FBD Error Mask Register */
 	pci_read_config_dword(pvt->branchmap_werrors, EMASK_FBD,
@@ -1243,7 +1242,7 @@ static void i5000_enable_error_reporting
 			fbd_error_mask);
 }
 
-/******************************************************************************
+/*
  * i5000_get_dimm_and_channel_counts(pdev, &num_csrows, &num_channels)
  *
  *	ask the device how many channels are present and how many CSROWS
@@ -1265,7 +1264,7 @@ static void i5000_get_dimm_and_channel_c
 	*num_channels = (int)value;
 }
 
-/******************************************************************************
+/*
  *	i5000_probe1	Probe for ONE instance of device to see if it is
  *			present.
  *	return:
@@ -1329,7 +1328,7 @@ static int i5000_probe1(struct pci_dev *
 
 	mci->dev = &pdev->dev;	/* record ptr  to the generic device */
 
-	pvt = (struct i5000_pvt *)mci->pvt_info;
+	pvt = mci->pvt_info;
 	pvt->system_address = pdev;	/* Record this device in our private */
 	pvt->maxch = num_channels;
 	pvt->maxdimmperch = num_dimms_per_channel;
@@ -1401,7 +1400,7 @@ fail0:
 	return -ENODEV;
 }
 
-/******************************************************************************
+/*
  *	i5000_init_one	constructor for one instance of device
  *
  * 	returns:
@@ -1424,7 +1423,7 @@ static int __devinit i5000_init_one(stru
 	return i5000_probe1(pdev, id->driver_data);
 }
 
-/**************************************************************************
+/*
  *	i5000_remove_one	destructor for one instance of device
  *
  */
@@ -1446,7 +1445,7 @@ static void __devexit i5000_remove_one(s
 	edac_mc_free(mci);
 }
 
-/**************************************************************************
+/*
  *	pci_device_id	table for which devices we are looking for
  *
  *	The "E500P" device is the first device supported.
@@ -1460,7 +1459,7 @@ static const struct pci_device_id i5000_
 
 MODULE_DEVICE_TABLE(pci, i5000_pci_tbl);
 
-/**************************************************************************
+/*
  *	i5000_driver	pci_driver structure for this module
  *
  */
@@ -1471,7 +1470,7 @@ static struct pci_driver i5000_driver = 
 	.id_table = i5000_pci_tbl,
 };
 
-/**************************************************************************
+/*
  *	i5000_init		Module entry function
  *			Try to initialize this module for its devices
  */
@@ -1486,7 +1485,7 @@ static int __init i5000_init(void)
 	return (pci_rc < 0) ? pci_rc : 0;
 }
 
-/**************************************************************************
+/*
  *	i5000_exit()	Module exit function
  *			Unregister the driver
  */
_

Patches currently in -mm which might be from dougthompson@xmission.com are

drivers-edac-add-edac_mc_find-api.patch
drivers-edac-add-rddr2-memory-types.patch
drivers-edac-split-out-functions-to-unique-files.patch
drivers-edac-add-edac_device-class.patch
drivers-edac-mc-sysfs-add-missing-mem-types.patch
drivers-edac-change-from-semaphore-to-mutex-operation.patch
drivers-edac-coreh-fix-scrubdefs.patch
drivers-edac-new-i82443bxgz-mc-driver.patch
drivers-edac-add-new-nmi-rescan.patch
drivers-edac-mod-use-edac_coreh.patch
drivers-edac-add-dev_name-getter-function.patch
drivers-edac-new-inte-30x0-mc-driver.patch
drivers-edac-mod-mc-to-use-workq-instead-of-kthread.patch
drivers-edac-updated-pci-monitoring.patch
drivers-edac-mod-assert_error-check.patch
drivers-edac-core-lindent-cleanup.patch
drivers-edac-edac_device-sysfs-cleanup.patch
drivers-edac-cleanup-workq-ifdefs.patch
drivers-edac-lindent-amd76x.patch
drivers-edac-lindent-i5000.patch
drivers-edac-lindent-e7xxx.patch
drivers-edac-lindent-i3000.patch
drivers-edac-lindent-i82860.patch
drivers-edac-lindent-i82875p.patch
drivers-edac-lindent-e752x.patch
drivers-edac-lindent-i82443bxgx.patch
drivers-edac-lindent-r82600.patch
drivers-edac-drivers-to-use-new-pci-operation.patch
drivers-edac-add-device-sysfs-attributes.patch
drivers-edac-device-output-clenaup.patch
drivers-edac-add-info-kconfig.patch
drivers-edac-update-maintainers-files-for-edac.patch
drivers-edac-cleanup-spaces-gotos-after-lindent-messup.patch
driver-edac-add-mips-and-ppc-visibility.patch
driver-edac-mod-race-fix-i82875p.patch
driver-edac-fix-ignored-return-i82875p.patch
include-linux-pci_id-h-add-amd-northbridge-defines.patch
driver-edac-i5000-define-typo.patch
driver-edac-remove-null-from-statics.patch
driver-edac-i5000-code-tidying.patch
driver-edac-edac_device-code-tidying.patch
driver-edac-mod-edac_align_ptr-function.patch
driver-edac-mod-edac_opt_state_to_string-function.patch
driver-edac-remove-file-edac_mc-h.patch

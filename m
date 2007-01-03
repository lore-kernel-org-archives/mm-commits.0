From: akpm@osdl.org
Subject: + edac-k8-driver-coding-tidy.patch added to -mm tree
Date: Tue, 02 Jan 2007 16:38:37 -0800
Message-ID: <200701030038.l030cbjc002901@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50286 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949AbXACAio (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 19:38:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: norsk5@yahoo.com, ak@suse.de, alan@lxorguk.ukuu.org.uk, ebiederm@xmission.com, norsk5@xmission.com


The patch titled
     EDAC: K8 driver coding tidy
has been added to the -mm tree.  Its filename is
     edac-k8-driver-coding-tidy.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: EDAC: K8 driver coding tidy
From: Doug Thompson <norsk5@yahoo.com>

Various coding tidyings as suggested by Andrew Morton on the k8_edac.c file

Signed-off-by: Doug Thompson <norsk5@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <ak@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/edac/k8_edac.c |   69 ++++++++++++++++++++++-----------------
 1 files changed, 39 insertions(+), 30 deletions(-)

diff -puN drivers/edac/k8_edac.c~edac-k8-driver-coding-tidy drivers/edac/k8_edac.c
--- a/drivers/edac/k8_edac.c~edac-k8-driver-coding-tidy
+++ a/drivers/edac/k8_edac.c
@@ -1131,7 +1131,7 @@ static u64 dram_addr_to_sys_addr(struct 
 	 */
 	sys_addr |= ~((sys_addr & (1ull << 39)) - 1);
 
-	debugf1("Using DRAM Base register for node %d to translate "
+	debugf1("Using DRAM Base reg on node %d to translate "
 		"DramAddr 0x%lx to SysAddr 0x%lx\n", pvt->node_id,
 		(unsigned long) dram_addr, (unsigned long) sys_addr);
 	return sys_addr;
@@ -1339,8 +1339,10 @@ static void k8_handle_ce(struct mem_ctl_
 	log_mci = mci;
 	pvt = mci->pvt_info;
 
-	if ((info->error_info.nbsh & BIT(26)) == 0)
-		goto no_info;  /* error address not valid */
+	if ((info->error_info.nbsh & BIT(26)) == 0) {
+		edac_mc_handle_ce_no_info(log_mci,EDAC_MOD_STR);
+		return;
+	}
 
 	error_address = error_address_from_k8_error_info(info);
 	syndrome = ((info->error_info.nbsh >> 15) & 0xff);
@@ -1360,7 +1362,8 @@ static void k8_handle_ce(struct mem_ctl_
 			k8_mc_printk(mci, KERN_WARNING,
 				     "unknown syndrome 0x%x - possible error "
 				     "reporting race\n", syndrome);
-			goto no_info;
+			edac_mc_handle_ce_no_info(log_mci,EDAC_MOD_STR);
+			return;
 		}
 	} else
 		/* non-chipkill ecc mode
@@ -1374,25 +1377,25 @@ static void k8_handle_ce(struct mem_ctl_
 	/* Find out which node the error address belongs to.  This may be
 	 * different from the node that detected the error.
 	 */
-	if ((src_mci = find_mc_by_sys_addr(mci, error_address)) == NULL) {
+	src_mci = find_mc_by_sys_addr(mci, error_address);
+	if (src_mci == NULL) {
 		k8_mc_printk(mci, KERN_ERR,
 			     "failed to map error address 0x%lx to a node\n",
 			     (unsigned long) error_address);
-		goto no_info;
+		edac_mc_handle_ce_no_info(log_mci,EDAC_MOD_STR);
+		return;
 	}
 
 	log_mci = src_mci;
 
-	if ((csrow = sys_addr_to_csrow(log_mci, error_address)) < 0)
-		goto no_info;
-
-	error_address_to_page_and_offset(error_address, &page, &offset);
-	edac_mc_handle_ce(log_mci, page, offset, syndrome, csrow, channel,
-			  EDAC_MOD_STR);
-	return;
-
-no_info:
-	edac_mc_handle_ce_no_info(log_mci,EDAC_MOD_STR);
+	csrow = sys_addr_to_csrow(log_mci, error_address);
+	if (csrow < 0) {
+		edac_mc_handle_ce_no_info(log_mci,EDAC_MOD_STR);
+	} else {
+		error_address_to_page_and_offset(error_address, &page, &offset);
+		edac_mc_handle_ce(log_mci, page, offset, syndrome, csrow,
+			channel, EDAC_MOD_STR);
+	}
 }
 
 static void k8_handle_ue(struct mem_ctl_info *mci, struct k8_error_info *info)
@@ -1404,8 +1407,9 @@ static void k8_handle_ue(struct mem_ctl_
 
 	log_mci = mci;
 
-	if ((info->error_info.nbsh & BIT(26)) == 0)
-		goto no_info;  /* error address not valid */
+	if ((info->error_info.nbsh & BIT(26)) == 0) {
+		edac_mc_handle_ue_no_info(log_mci, EDAC_MOD_STR);
+	}
 
 	error_address = error_address_from_k8_error_info(info);
 
@@ -1416,20 +1420,19 @@ static void k8_handle_ue(struct mem_ctl_
 		k8_mc_printk(mci, KERN_ERR,
 			     "failed to map error address 0x%lx to a node\n",
 			     (unsigned long) error_address);
-		goto no_info;
+		edac_mc_handle_ue_no_info(log_mci, EDAC_MOD_STR);
+		return;
 	}
 
 	log_mci = src_mci;
 
-	if ((csrow = sys_addr_to_csrow(log_mci, error_address)) < 0)
-		goto no_info;
-
-	error_address_to_page_and_offset(error_address, &page, &offset);
-	edac_mc_handle_ue(log_mci, page, offset, csrow, EDAC_MOD_STR);
-	return;
-
-no_info:
-	edac_mc_handle_ue_no_info(log_mci, EDAC_MOD_STR);
+	csrow = sys_addr_to_csrow(log_mci, error_address);
+	if (csrow < 0) {
+		edac_mc_handle_ue_no_info(log_mci, EDAC_MOD_STR);
+	} else {
+		error_address_to_page_and_offset(error_address, &page, &offset);
+		edac_mc_handle_ue(log_mci, page, offset, csrow, EDAC_MOD_STR);
+	}
 }
 
 static void decode_bus_error(struct mem_ctl_info *mci,
@@ -1550,6 +1553,9 @@ static int k8_process_error_info(struct 
 	return 1;
 }
 
+/* The main 'check' function to be called by the helper thread
+ * for this hardware.  Get the error information, then process any errors
+ */
 static void k8_check(struct mem_ctl_info *mci)
 {
 	struct k8_error_info info;
@@ -1559,6 +1565,9 @@ static void k8_check(struct mem_ctl_info
 	k8_process_error_info(mci, &info, 1);
 }
 
+/* 'get' (reserve) the various PCI devices composing the memory controller
+ * which we need to retrieve data from in the processing of errors
+ */
 static int k8_get_devs(struct mem_ctl_info *mci, int dev_idx)
 {
 	const struct k8_dev_info *k8_dev = &k8_devs[dev_idx];
@@ -1701,8 +1710,8 @@ static int k8_init_csrows(struct mem_ctl
 		csrow->dtype = ((pvt->dcl >> (20 + (i / 2))) & 0x01) ?
 			       DEV_X4 : DEV_UNKNOWN;
 		debugf1("for node %d csrow %d:\n    nr_pages: %u "
-			"input_addr_min: 0x%lx input_addr_max: 0x%lx "
-			"sys_addr: 0x%lx first_page: 0x%lx last_page: 0x%lx "
+			"input_addr_min: 0x%lx input_addr_max: 0x%lx\n"
+			"    sys_addr: 0x%lx first_page: 0x%lx last_page: 0x%lx "
 			"page_mask: 0x%lx\n", pvt->node_id, i,
 			(unsigned) csrow->nr_pages,
 			(unsigned long) input_addr_min,
_

Patches currently in -mm which might be from norsk5@yahoo.com are

edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch

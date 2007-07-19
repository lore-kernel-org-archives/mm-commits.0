From: akpm@linux-foundation.org
Subject: - drivers-edac-cleanup-spaces-gotos-after-lindent-messup.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:06:41 -0700
Message-ID: <200707192006.l6JK6fD2020167@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54899 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761390AbXGSURm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:17:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: cleanup spaces-gotos after Lindent messup
has been removed from the -mm tree.  Its filename was
     drivers-edac-cleanup-spaces-gotos-after-lindent-messup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: cleanup spaces-gotos after Lindent messup
From: Douglas Thompson <dougthompson@xmission.com>

This patch fixes some remnant spaces inserted by the use of Lindent.
Seems Lindent adds some spaces when it shoulded. These have been fixed.
In addition, goto targets have issues, these have been fixed
in this patch.

Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/amd76x_edac.c       |   26 ++--
 drivers/edac/e752x_edac.c        |  181 ++++++++++++++---------------
 drivers/edac/e7xxx_edac.c        |   54 ++++----
 drivers/edac/edac_device.c       |  110 ++++++++---------
 drivers/edac/edac_device_sysfs.c |  108 ++++++++---------
 drivers/edac/edac_mc.c           |  144 +++++++++++------------
 drivers/edac/edac_mc_sysfs.c     |   84 ++++++-------
 drivers/edac/edac_module.c       |   10 -
 drivers/edac/edac_pci.c          |   34 ++---
 drivers/edac/edac_pci_sysfs.c    |   46 +++----
 drivers/edac/i3000_edac.c        |   21 +--
 drivers/edac/i5000_edac.c        |  160 ++++++++++++-------------
 drivers/edac/i82443bxgx_edac.c   |   47 +++----
 drivers/edac/i82860_edac.c       |   24 +--
 drivers/edac/i82875p_edac.c      |   38 +++---
 drivers/edac/r82600_edac.c       |   23 +--
 16 files changed, 558 insertions(+), 552 deletions(-)

diff -puN drivers/edac/amd76x_edac.c~drivers-edac-cleanup-spaces-gotos-after-lindent-messup drivers/edac/amd76x_edac.c
--- a/drivers/edac/amd76x_edac.c~drivers-edac-cleanup-spaces-gotos-after-lindent-messup
+++ a/drivers/edac/amd76x_edac.c
@@ -86,9 +86,9 @@ struct amd76x_dev_info {
 
 static const struct amd76x_dev_info amd76x_devs[] = {
 	[AMD761] = {
-		    .ctl_name = "AMD761"},
+		.ctl_name = "AMD761"},
 	[AMD762] = {
-		    .ctl_name = "AMD762"},
+		.ctl_name = "AMD762"},
 };
 
 static struct edac_pci_ctl_info *amd76x_pci;
@@ -102,13 +102,13 @@ static struct edac_pci_ctl_info *amd76x_
  *	on the chip so that further errors will be reported
  */
 static void amd76x_get_error_info(struct mem_ctl_info *mci,
-				  struct amd76x_error_info *info)
+				struct amd76x_error_info *info)
 {
 	struct pci_dev *pdev;
 
 	pdev = to_pci_dev(mci->dev);
 	pci_read_config_dword(pdev, AMD76X_ECC_MODE_STATUS,
-			      &info->ecc_mode_status);
+			&info->ecc_mode_status);
 
 	if (info->ecc_mode_status & BIT(8))
 		pci_write_bits32(pdev, AMD76X_ECC_MODE_STATUS,
@@ -130,8 +130,8 @@ static void amd76x_get_error_info(struct
  *	then attempt to handle and clean up after the error
  */
 static int amd76x_process_error_info(struct mem_ctl_info *mci,
-				     struct amd76x_error_info *info,
-				     int handle_errors)
+				struct amd76x_error_info *info,
+				int handle_errors)
 {
 	int error_found;
 	u32 row;
@@ -147,7 +147,7 @@ static int amd76x_process_error_info(str
 		if (handle_errors) {
 			row = (info->ecc_mode_status >> 4) & 0xf;
 			edac_mc_handle_ue(mci, mci->csrows[row].first_page, 0,
-					  row, mci->ctl_name);
+					row, mci->ctl_name);
 		}
 	}
 
@@ -160,7 +160,7 @@ static int amd76x_process_error_info(str
 		if (handle_errors) {
 			row = info->ecc_mode_status & 0xf;
 			edac_mc_handle_ce(mci, mci->csrows[row].first_page, 0,
-					  0, row, 0, mci->ctl_name);
+					0, row, 0, mci->ctl_name);
 		}
 	}
 
@@ -183,7 +183,7 @@ static void amd76x_check(struct mem_ctl_
 }
 
 static void amd76x_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
-			       enum edac_type edac_mode)
+			enum edac_type edac_mode)
 {
 	struct csrow_info *csrow;
 	u32 mba, mba_base, mba_mask, dms;
@@ -194,7 +194,7 @@ static void amd76x_init_csrows(struct me
 
 		/* find the DRAM Chip Select Base address and mask */
 		pci_read_config_dword(pdev,
-				      AMD76X_MEM_BASE_ADDR + (index * 4), &mba);
+				AMD76X_MEM_BASE_ADDR + (index * 4), &mba);
 
 		if (!(mba & BIT(0)))
 			continue;
@@ -249,7 +249,7 @@ static int amd76x_probe1(struct pci_dev 
 	mci->mtype_cap = MEM_FLAG_RDDR;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_EC | EDAC_FLAG_SECDED;
 	mci->edac_cap = ems_mode ?
-	    (EDAC_FLAG_EC | EDAC_FLAG_SECDED) : EDAC_FLAG_NONE;
+		(EDAC_FLAG_EC | EDAC_FLAG_SECDED) : EDAC_FLAG_NONE;
 	mci->mod_name = EDAC_MOD_STR;
 	mci->mod_ver = AMD76X_REVISION;
 	mci->ctl_name = amd76x_devs[dev_idx].ctl_name;
@@ -283,14 +283,14 @@ static int amd76x_probe1(struct pci_dev 
 	debugf3("%s(): success\n", __func__);
 	return 0;
 
-      fail:
+fail:
 	edac_mc_free(mci);
 	return -ENODEV;
 }
 
 /* returns count (>= 0), or negative on error */
 static int __devinit amd76x_init_one(struct pci_dev *pdev,
-				     const struct pci_device_id *ent)
+				const struct pci_device_id *ent)
 {
 	debugf0("%s()\n", __func__);
 
diff -puN drivers/edac/e752x_edac.c~drivers-edac-cleanup-spaces-gotos-after-lindent-messup drivers/edac/e752x_edac.c
--- a/drivers/edac/e752x_edac.c~drivers-edac-cleanup-spaces-gotos-after-lindent-messup
+++ a/drivers/edac/e752x_edac.c
@@ -204,21 +204,21 @@ struct e752x_error_info {
 
 static const struct e752x_dev_info e752x_devs[] = {
 	[E7520] = {
-		   .err_dev = PCI_DEVICE_ID_INTEL_7520_1_ERR,
-		   .ctl_dev = PCI_DEVICE_ID_INTEL_7520_0,
-		   .ctl_name = "E7520"},
+		.err_dev = PCI_DEVICE_ID_INTEL_7520_1_ERR,
+		.ctl_dev = PCI_DEVICE_ID_INTEL_7520_0,
+		.ctl_name = "E7520"},
 	[E7525] = {
-		   .err_dev = PCI_DEVICE_ID_INTEL_7525_1_ERR,
-		   .ctl_dev = PCI_DEVICE_ID_INTEL_7525_0,
-		   .ctl_name = "E7525"},
+		.err_dev = PCI_DEVICE_ID_INTEL_7525_1_ERR,
+		.ctl_dev = PCI_DEVICE_ID_INTEL_7525_0,
+		.ctl_name = "E7525"},
 	[E7320] = {
-		   .err_dev = PCI_DEVICE_ID_INTEL_7320_1_ERR,
-		   .ctl_dev = PCI_DEVICE_ID_INTEL_7320_0,
-		   .ctl_name = "E7320"},
+		.err_dev = PCI_DEVICE_ID_INTEL_7320_1_ERR,
+		.ctl_dev = PCI_DEVICE_ID_INTEL_7320_0,
+		.ctl_name = "E7320"},
 };
 
 static unsigned long ctl_page_to_phys(struct mem_ctl_info *mci,
-				      unsigned long page)
+				unsigned long page)
 {
 	u32 remap;
 	struct e752x_pvt *pvt = (struct e752x_pvt *)mci->pvt_info;
@@ -241,7 +241,7 @@ static unsigned long ctl_page_to_phys(st
 }
 
 static void do_process_ce(struct mem_ctl_info *mci, u16 error_one,
-			  u32 sec1_add, u16 sec1_syndrome)
+			u32 sec1_add, u16 sec1_syndrome)
 {
 	u32 page;
 	int row;
@@ -259,10 +259,10 @@ static void do_process_ce(struct mem_ctl
 		/* chip select are bits 14 & 13 */
 		row = ((page >> 1) & 3);
 		e752x_printk(KERN_WARNING,
-			     "Test row %d Table %d %d %d %d %d %d %d %d\n", row,
-			     pvt->map[0], pvt->map[1], pvt->map[2], pvt->map[3],
-			     pvt->map[4], pvt->map[5], pvt->map[6],
-			     pvt->map[7]);
+			"Test row %d Table %d %d %d %d %d %d %d %d\n", row,
+			pvt->map[0], pvt->map[1], pvt->map[2], pvt->map[3],
+			pvt->map[4], pvt->map[5], pvt->map[6],
+			pvt->map[7]);
 
 		/* test for channel remapping */
 		for (i = 0; i < 8; i++) {
@@ -289,12 +289,12 @@ static void do_process_ce(struct mem_ctl
 
 	/* e752x mc reads 34:6 of the DRAM linear address */
 	edac_mc_handle_ce(mci, page, offset_in_page(sec1_add << 4),
-			  sec1_syndrome, row, channel, "e752x CE");
+			sec1_syndrome, row, channel, "e752x CE");
 }
 
 static inline void process_ce(struct mem_ctl_info *mci, u16 error_one,
-			      u32 sec1_add, u16 sec1_syndrome, int *error_found,
-			      int handle_error)
+			u32 sec1_add, u16 sec1_syndrome, int *error_found,
+			int handle_error)
 {
 	*error_found = 1;
 
@@ -303,7 +303,7 @@ static inline void process_ce(struct mem
 }
 
 static void do_process_ue(struct mem_ctl_info *mci, u16 error_one,
-			  u32 ded_add, u32 scrb_add)
+			u32 ded_add, u32 scrb_add)
 {
 	u32 error_2b, block_page;
 	int row;
@@ -318,14 +318,14 @@ static void do_process_ue(struct mem_ctl
 		block_page = error_2b >> (PAGE_SHIFT - 4);
 
 		row = pvt->mc_symmetric ?
-		    /* chip select are bits 14 & 13 */
-		    ((block_page >> 1) & 3) :
-		    edac_mc_find_csrow_by_page(mci, block_page);
+		/* chip select are bits 14 & 13 */
+			((block_page >> 1) & 3) :
+			edac_mc_find_csrow_by_page(mci, block_page);
 
 		/* e752x mc reads 34:6 of the DRAM linear address */
 		edac_mc_handle_ue(mci, block_page,
-				  offset_in_page(error_2b << 4),
-				  row, "e752x UE from Read");
+				offset_in_page(error_2b << 4),
+				row, "e752x UE from Read");
 	}
 	if (error_one & 0x0404) {
 		error_2b = scrb_add;
@@ -334,20 +334,20 @@ static void do_process_ue(struct mem_ctl
 		block_page = error_2b >> (PAGE_SHIFT - 4);
 
 		row = pvt->mc_symmetric ?
-		    /* chip select are bits 14 & 13 */
-		    ((block_page >> 1) & 3) :
-		    edac_mc_find_csrow_by_page(mci, block_page);
+		/* chip select are bits 14 & 13 */
+			((block_page >> 1) & 3) :
+			edac_mc_find_csrow_by_page(mci, block_page);
 
 		/* e752x mc reads 34:6 of the DRAM linear address */
 		edac_mc_handle_ue(mci, block_page,
-				  offset_in_page(error_2b << 4),
-				  row, "e752x UE from Scruber");
+				offset_in_page(error_2b << 4),
+				row, "e752x UE from Scruber");
 	}
 }
 
 static inline void process_ue(struct mem_ctl_info *mci, u16 error_one,
-			      u32 ded_add, u32 scrb_add, int *error_found,
-			      int handle_error)
+			u32 ded_add, u32 scrb_add, int *error_found,
+			int handle_error)
 {
 	*error_found = 1;
 
@@ -377,15 +377,15 @@ static void do_process_ded_retry(struct 
 	error_1b = retry_add;
 	page = error_1b >> (PAGE_SHIFT - 4);	/* convert the addr to 4k page */
 	row = pvt->mc_symmetric ? ((page >> 1) & 3) :	/* chip select are bits 14 & 13 */
-	    edac_mc_find_csrow_by_page(mci, page);
+		edac_mc_find_csrow_by_page(mci, page);
 	e752x_mc_printk(mci, KERN_WARNING,
 			"CE page 0x%lx, row %d : Memory read retry\n",
 			(long unsigned int)page, row);
 }
 
 static inline void process_ded_retry(struct mem_ctl_info *mci, u16 error,
-				     u32 retry_add, int *error_found,
-				     int handle_error)
+				u32 retry_add, int *error_found,
+				int handle_error)
 {
 	*error_found = 1;
 
@@ -418,7 +418,7 @@ static void do_global_error(int fatal, u
 	for (i = 0; i < 11; i++) {
 		if (errors & (1 << i))
 			e752x_printk(KERN_WARNING, "%sError %s\n",
-				     fatal_message[fatal], global_message[i]);
+				fatal_message[fatal], global_message[i]);
 	}
 }
 
@@ -445,12 +445,12 @@ static void do_hub_error(int fatal, u8 e
 	for (i = 0; i < 7; i++) {
 		if (errors & (1 << i))
 			e752x_printk(KERN_WARNING, "%sError %s\n",
-				     fatal_message[fatal], hub_message[i]);
+				fatal_message[fatal], hub_message[i]);
 	}
 }
 
 static inline void hub_error(int fatal, u8 errors, int *error_found,
-			     int handle_error)
+			int handle_error)
 {
 	*error_found = 1;
 
@@ -472,7 +472,7 @@ static void do_membuf_error(u8 errors)
 	for (i = 0; i < 4; i++) {
 		if (errors & (1 << i))
 			e752x_printk(KERN_WARNING, "Non-Fatal Error %s\n",
-				     membuf_message[i]);
+				membuf_message[i]);
 	}
 }
 
@@ -503,7 +503,7 @@ static void do_sysbus_error(int fatal, u
 	for (i = 0; i < 10; i++) {
 		if (errors & (1 << i))
 			e752x_printk(KERN_WARNING, "%sError System Bus %s\n",
-				     fatal_message[fatal], sysbus_message[i]);
+				fatal_message[fatal], sysbus_message[i]);
 	}
 }
 
@@ -517,7 +517,7 @@ static inline void sysbus_error(int fata
 }
 
 static void e752x_check_hub_interface(struct e752x_error_info *info,
-				      int *error_found, int handle_error)
+				int *error_found, int handle_error)
 {
 	u8 stat8;
 
@@ -550,7 +550,7 @@ static void e752x_check_hub_interface(st
 }
 
 static void e752x_check_sysbus(struct e752x_error_info *info,
-			       int *error_found, int handle_error)
+			int *error_found, int handle_error)
 {
 	u32 stat32, error32;
 
@@ -577,7 +577,7 @@ static void e752x_check_sysbus(struct e7
 }
 
 static void e752x_check_membuf(struct e752x_error_info *info,
-			       int *error_found, int handle_error)
+			int *error_found, int handle_error)
 {
 	u8 stat8;
 
@@ -597,8 +597,8 @@ static void e752x_check_membuf(struct e7
 }
 
 static void e752x_check_dram(struct mem_ctl_info *mci,
-			     struct e752x_error_info *info, int *error_found,
-			     int handle_error)
+			struct e752x_error_info *info, int *error_found,
+			int handle_error)
 {
 	u16 error_one, error_next;
 
@@ -608,11 +608,11 @@ static void e752x_check_dram(struct mem_
 	/* decode and report errors */
 	if (error_one & 0x0101)	/* check first error correctable */
 		process_ce(mci, error_one, info->dram_sec1_add,
-			   info->dram_sec1_syndrome, error_found, handle_error);
+			info->dram_sec1_syndrome, error_found, handle_error);
 
 	if (error_next & 0x0101)	/* check next error correctable */
 		process_ce(mci, error_next, info->dram_sec2_add,
-			   info->dram_sec2_syndrome, error_found, handle_error);
+			info->dram_sec2_syndrome, error_found, handle_error);
 
 	if (error_one & 0x4040)
 		process_ue_no_info_wr(mci, error_found, handle_error);
@@ -622,26 +622,26 @@ static void e752x_check_dram(struct mem_
 
 	if (error_one & 0x2020)
 		process_ded_retry(mci, error_one, info->dram_retr_add,
-				  error_found, handle_error);
+				error_found, handle_error);
 
 	if (error_next & 0x2020)
 		process_ded_retry(mci, error_next, info->dram_retr_add,
-				  error_found, handle_error);
+				error_found, handle_error);
 
 	if (error_one & 0x0808)
 		process_threshold_ce(mci, error_one, error_found, handle_error);
 
 	if (error_next & 0x0808)
 		process_threshold_ce(mci, error_next, error_found,
-				     handle_error);
+				handle_error);
 
 	if (error_one & 0x0606)
 		process_ue(mci, error_one, info->dram_ded_add,
-			   info->dram_scrb_add, error_found, handle_error);
+			info->dram_scrb_add, error_found, handle_error);
 
 	if (error_next & 0x0606)
 		process_ue(mci, error_next, info->dram_ded_add,
-			   info->dram_scrb_add, error_found, handle_error);
+			info->dram_scrb_add, error_found, handle_error);
 }
 
 static void e752x_get_error_info(struct mem_ctl_info *mci,
@@ -658,38 +658,38 @@ static void e752x_get_error_info(struct 
 	if (info->ferr_global) {
 		pci_read_config_byte(dev, E752X_HI_FERR, &info->hi_ferr);
 		pci_read_config_word(dev, E752X_SYSBUS_FERR,
-				     &info->sysbus_ferr);
+				&info->sysbus_ferr);
 		pci_read_config_byte(dev, E752X_BUF_FERR, &info->buf_ferr);
 		pci_read_config_word(dev, E752X_DRAM_FERR, &info->dram_ferr);
 		pci_read_config_dword(dev, E752X_DRAM_SEC1_ADD,
-				      &info->dram_sec1_add);
+				&info->dram_sec1_add);
 		pci_read_config_word(dev, E752X_DRAM_SEC1_SYNDROME,
-				     &info->dram_sec1_syndrome);
+				&info->dram_sec1_syndrome);
 		pci_read_config_dword(dev, E752X_DRAM_DED_ADD,
-				      &info->dram_ded_add);
+				&info->dram_ded_add);
 		pci_read_config_dword(dev, E752X_DRAM_SCRB_ADD,
-				      &info->dram_scrb_add);
+				&info->dram_scrb_add);
 		pci_read_config_dword(dev, E752X_DRAM_RETR_ADD,
-				      &info->dram_retr_add);
+				&info->dram_retr_add);
 
 		if (info->hi_ferr & 0x7f)
 			pci_write_config_byte(dev, E752X_HI_FERR,
-					      info->hi_ferr);
+					info->hi_ferr);
 
 		if (info->sysbus_ferr)
 			pci_write_config_word(dev, E752X_SYSBUS_FERR,
-					      info->sysbus_ferr);
+					info->sysbus_ferr);
 
 		if (info->buf_ferr & 0x0f)
 			pci_write_config_byte(dev, E752X_BUF_FERR,
-					      info->buf_ferr);
+					info->buf_ferr);
 
 		if (info->dram_ferr)
 			pci_write_bits16(pvt->bridge_ck, E752X_DRAM_FERR,
 					 info->dram_ferr, info->dram_ferr);
 
 		pci_write_config_dword(dev, E752X_FERR_GLOBAL,
-				       info->ferr_global);
+				info->ferr_global);
 	}
 
 	pci_read_config_dword(dev, E752X_NERR_GLOBAL, &info->nerr_global);
@@ -697,38 +697,38 @@ static void e752x_get_error_info(struct 
 	if (info->nerr_global) {
 		pci_read_config_byte(dev, E752X_HI_NERR, &info->hi_nerr);
 		pci_read_config_word(dev, E752X_SYSBUS_NERR,
-				     &info->sysbus_nerr);
+				&info->sysbus_nerr);
 		pci_read_config_byte(dev, E752X_BUF_NERR, &info->buf_nerr);
 		pci_read_config_word(dev, E752X_DRAM_NERR, &info->dram_nerr);
 		pci_read_config_dword(dev, E752X_DRAM_SEC2_ADD,
-				      &info->dram_sec2_add);
+				&info->dram_sec2_add);
 		pci_read_config_word(dev, E752X_DRAM_SEC2_SYNDROME,
-				     &info->dram_sec2_syndrome);
+				&info->dram_sec2_syndrome);
 
 		if (info->hi_nerr & 0x7f)
 			pci_write_config_byte(dev, E752X_HI_NERR,
-					      info->hi_nerr);
+					info->hi_nerr);
 
 		if (info->sysbus_nerr)
 			pci_write_config_word(dev, E752X_SYSBUS_NERR,
-					      info->sysbus_nerr);
+					info->sysbus_nerr);
 
 		if (info->buf_nerr & 0x0f)
 			pci_write_config_byte(dev, E752X_BUF_NERR,
-					      info->buf_nerr);
+					info->buf_nerr);
 
 		if (info->dram_nerr)
 			pci_write_bits16(pvt->bridge_ck, E752X_DRAM_NERR,
 					 info->dram_nerr, info->dram_nerr);
 
 		pci_write_config_dword(dev, E752X_NERR_GLOBAL,
-				       info->nerr_global);
+				info->nerr_global);
 	}
 }
 
 static int e752x_process_error_info(struct mem_ctl_info *mci,
-				    struct e752x_error_info *info,
-				    int handle_errors)
+				struct e752x_error_info *info,
+				int handle_errors)
 {
 	u32 error32, stat32;
 	int error_found;
@@ -775,7 +775,7 @@ static inline int dual_channel_active(u1
 }
 
 static void e752x_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
-			      u16 ddrcsr)
+			u16 ddrcsr)
 {
 	struct csrow_info *csrow;
 	unsigned long last_cumul_size;
@@ -841,7 +841,7 @@ static void e752x_init_csrows(struct mem
 }
 
 static void e752x_init_mem_map_table(struct pci_dev *pdev,
-				     struct e752x_pvt *pvt)
+				struct e752x_pvt *pvt)
 {
 	int index;
 	u8 value, last, row, stat8;
@@ -864,11 +864,11 @@ static void e752x_init_mem_map_table(str
 			 * sided
 			 */
 			pci_read_config_byte(pdev, E752X_DRB + index + 1,
-					     &value);
-			pvt->map[index + 1] = (value == last) ? 0xff :	/* the dimm is single sided,
-									   so flag as empty */
-			    row;	/* this is a double sided dimm
-					   to save the next row # */
+					&value);
+
+			/* the dimm is single sided, so flag as empty */
+			/* this is a double sided dimm to save the next row #*/
+			pvt->map[index + 1] = (value == last) ? 0xff :	row;
 			row++;
 			last = value;
 		}
@@ -881,7 +881,7 @@ static void e752x_init_mem_map_table(str
 
 /* Return 0 on success or 1 on failure. */
 static int e752x_get_devs(struct pci_dev *pdev, int dev_idx,
-			  struct e752x_pvt *pvt)
+			struct e752x_pvt *pvt)
 {
 	struct pci_dev *dev;
 
@@ -894,13 +894,13 @@ static int e752x_get_devs(struct pci_dev
 
 	if (pvt->bridge_ck == NULL) {
 		e752x_printk(KERN_ERR, "error reporting device not found:"
-			     "vendor %x device 0x%x (broken BIOS?)\n",
-			     PCI_VENDOR_ID_INTEL, e752x_devs[dev_idx].err_dev);
+			"vendor %x device 0x%x (broken BIOS?)\n",
+			PCI_VENDOR_ID_INTEL, e752x_devs[dev_idx].err_dev);
 		return 1;
 	}
 
 	dev = pci_get_device(PCI_VENDOR_ID_INTEL, e752x_devs[dev_idx].ctl_dev,
-			     NULL);
+			NULL);
 
 	if (dev == NULL)
 		goto fail;
@@ -910,7 +910,7 @@ static int e752x_get_devs(struct pci_dev
 
 	return 0;
 
-      fail:
+fail:
 	pci_dev_put(pvt->bridge_ck);
 	return 1;
 }
@@ -961,7 +961,7 @@ static int e752x_probe1(struct pci_dev *
 	pci_read_config_byte(pdev, E752X_DEVPRES1, &stat8);
 	if (!force_function_unhide && !(stat8 & (1 << 5))) {
 		printk(KERN_INFO "Contact your BIOS vendor to see if the "
-		       "E752x error registers can be safely un-hidden\n");
+			"E752x error registers can be safely un-hidden\n");
 		return -ENOMEM;
 	}
 	stat8 |= (1 << 5);
@@ -981,7 +981,7 @@ static int e752x_probe1(struct pci_dev *
 	debugf3("%s(): init mci\n", __func__);
 	mci->mtype_cap = MEM_FLAG_RDDR;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED |
-	    EDAC_FLAG_S4ECD4ED;
+		EDAC_FLAG_S4ECD4ED;
 	/* FIXME - what if different memory types are in different csrows? */
 	mci->mod_name = EDAC_MOD_STR;
 	mci->mod_ver = E752X_REVISION;
@@ -1021,8 +1021,8 @@ static int e752x_probe1(struct pci_dev *
 	pci_read_config_word(pdev, E752X_REMAPLIMIT, &pci_data);
 	pvt->remaplimit = ((u32) pci_data) << 14;
 	e752x_printk(KERN_INFO,
-		     "tolm = %x, remapbase = %x, remaplimit = %x\n", pvt->tolm,
-		     pvt->remapbase, pvt->remaplimit);
+			"tolm = %x, remapbase = %x, remaplimit = %x\n",
+			pvt->tolm, pvt->remapbase, pvt->remaplimit);
 
 	/* Here we assume that we will never see multiple instances of this
 	 * type of memory controller.  The ID is therefore hardcoded to 0.
@@ -1039,16 +1039,17 @@ static int e752x_probe1(struct pci_dev *
 	e752x_pci = edac_pci_create_generic_ctl(&pdev->dev, EDAC_MOD_STR);
 	if (!e752x_pci) {
 		printk(KERN_WARNING
-		       "%s(): Unable to create PCI control\n", __func__);
+			"%s(): Unable to create PCI control\n", __func__);
 		printk(KERN_WARNING
-		       "%s(): PCI error report via EDAC not setup\n", __func__);
+			"%s(): PCI error report via EDAC not setup\n",
+			__func__);
 	}
 
 	/* get this far and it's successful */
 	debugf3("%s(): success\n", __func__);
 	return 0;
 
-      fail:
+fail:
 	pci_dev_put(pvt->dev_d0f0);
 	pci_dev_put(pvt->dev_d0f1);
 	pci_dev_put(pvt->bridge_ck);
@@ -1059,7 +1060,7 @@ static int e752x_probe1(struct pci_dev *
 
 /* returns count (>= 0), or negative on error */
 static int __devinit e752x_init_one(struct pci_dev *pdev,
-				    const struct pci_device_id *ent)
+				const struct pci_device_id *ent)
 {
 	debugf0("%s()\n", __func__);
 
diff -puN drivers/edac/e7xxx_edac.c~drivers-edac-cleanup-spaces-gotos-after-lindent-messup drivers/edac/e7xxx_edac.c
--- a/drivers/edac/e7xxx_edac.c~drivers-edac-cleanup-spaces-gotos-after-lindent-messup
+++ a/drivers/edac/e7xxx_edac.c
@@ -148,17 +148,17 @@ static struct edac_pci_ctl_info *e7xxx_p
 
 static const struct e7xxx_dev_info e7xxx_devs[] = {
 	[E7500] = {
-		   .err_dev = PCI_DEVICE_ID_INTEL_7500_1_ERR,
-		   .ctl_name = "E7500"},
+		.err_dev = PCI_DEVICE_ID_INTEL_7500_1_ERR,
+		.ctl_name = "E7500"},
 	[E7501] = {
-		   .err_dev = PCI_DEVICE_ID_INTEL_7501_1_ERR,
-		   .ctl_name = "E7501"},
+		.err_dev = PCI_DEVICE_ID_INTEL_7501_1_ERR,
+		.ctl_name = "E7501"},
 	[E7505] = {
-		   .err_dev = PCI_DEVICE_ID_INTEL_7505_1_ERR,
-		   .ctl_name = "E7505"},
+		.err_dev = PCI_DEVICE_ID_INTEL_7505_1_ERR,
+		.ctl_name = "E7505"},
 	[E7205] = {
-		   .err_dev = PCI_DEVICE_ID_INTEL_7205_1_ERR,
-		   .ctl_name = "E7205"},
+		.err_dev = PCI_DEVICE_ID_INTEL_7205_1_ERR,
+		.ctl_name = "E7205"},
 };
 
 /* FIXME - is this valid for both SECDED and S4ECD4ED? */
@@ -179,7 +179,7 @@ static inline int e7xxx_find_channel(u16
 }
 
 static unsigned long ctl_page_to_phys(struct mem_ctl_info *mci,
-				      unsigned long page)
+				unsigned long page)
 {
 	u32 remap;
 	struct e7xxx_pvt *pvt = (struct e7xxx_pvt *)mci->pvt_info;
@@ -187,7 +187,7 @@ static unsigned long ctl_page_to_phys(st
 	debugf3("%s()\n", __func__);
 
 	if ((page < pvt->tolm) ||
-	    ((page >= 0x100000) && (page < pvt->remapbase)))
+		((page >= 0x100000) && (page < pvt->remapbase)))
 		return page;
 
 	remap = (page - pvt->tolm) + pvt->remapbase;
@@ -257,15 +257,15 @@ static void e7xxx_get_error_info(struct 
 
 	if ((info->dram_ferr & 1) || (info->dram_nerr & 1)) {
 		pci_read_config_dword(pvt->bridge_ck, E7XXX_DRAM_CELOG_ADD,
-				      &info->dram_celog_add);
+				&info->dram_celog_add);
 		pci_read_config_word(pvt->bridge_ck,
-				     E7XXX_DRAM_CELOG_SYNDROME,
-				     &info->dram_celog_syndrome);
+				E7XXX_DRAM_CELOG_SYNDROME,
+				&info->dram_celog_syndrome);
 	}
 
 	if ((info->dram_ferr & 2) || (info->dram_nerr & 2))
 		pci_read_config_dword(pvt->bridge_ck, E7XXX_DRAM_UELOG_ADD,
-				      &info->dram_uelog_add);
+				&info->dram_uelog_add);
 
 	if (info->dram_ferr & 3)
 		pci_write_bits8(pvt->bridge_ck, E7XXX_DRAM_FERR, 0x03, 0x03);
@@ -275,8 +275,8 @@ static void e7xxx_get_error_info(struct 
 }
 
 static int e7xxx_process_error_info(struct mem_ctl_info *mci,
-				    struct e7xxx_error_info *info,
-				    int handle_errors)
+				struct e7xxx_error_info *info,
+				int handle_errors)
 {
 	int error_found;
 
@@ -345,7 +345,7 @@ static inline int drb_granularity(u32 dr
 }
 
 static void e7xxx_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
-			      int dev_idx, u32 drc)
+			int dev_idx, u32 drc)
 {
 	unsigned long last_cumul_size;
 	int index;
@@ -435,7 +435,7 @@ static int e7xxx_probe1(struct pci_dev *
 	debugf3("%s(): init mci\n", __func__);
 	mci->mtype_cap = MEM_FLAG_RDDR;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED |
-	    EDAC_FLAG_S4ECD4ED;
+		EDAC_FLAG_S4ECD4ED;
 	/* FIXME - what if different memory types are in different csrows? */
 	mci->mod_name = EDAC_MOD_STR;
 	mci->mod_ver = E7XXX_REVISION;
@@ -448,8 +448,8 @@ static int e7xxx_probe1(struct pci_dev *
 
 	if (!pvt->bridge_ck) {
 		e7xxx_printk(KERN_ERR, "error reporting device not found:"
-			     "vendor %x device 0x%x (broken BIOS?)\n",
-			     PCI_VENDOR_ID_INTEL, e7xxx_devs[dev_idx].err_dev);
+			"vendor %x device 0x%x (broken BIOS?)\n",
+			PCI_VENDOR_ID_INTEL, e7xxx_devs[dev_idx].err_dev);
 		goto fail0;
 	}
 
@@ -469,8 +469,8 @@ static int e7xxx_probe1(struct pci_dev *
 	pci_read_config_word(pdev, E7XXX_REMAPLIMIT, &pci_data);
 	pvt->remaplimit = ((u32) pci_data) << 14;
 	e7xxx_printk(KERN_INFO,
-		     "tolm = %x, remapbase = %x, remaplimit = %x\n", pvt->tolm,
-		     pvt->remapbase, pvt->remaplimit);
+		"tolm = %x, remapbase = %x, remaplimit = %x\n", pvt->tolm,
+		pvt->remapbase, pvt->remaplimit);
 
 	/* clear any pending errors, or initial state bits */
 	e7xxx_get_error_info(mci, &discard);
@@ -498,10 +498,10 @@ static int e7xxx_probe1(struct pci_dev *
 	debugf3("%s(): success\n", __func__);
 	return 0;
 
-      fail1:
+fail1:
 	pci_dev_put(pvt->bridge_ck);
 
-      fail0:
+fail0:
 	edac_mc_free(mci);
 
 	return -ENODEV;
@@ -509,13 +509,13 @@ static int e7xxx_probe1(struct pci_dev *
 
 /* returns count (>= 0), or negative on error */
 static int __devinit e7xxx_init_one(struct pci_dev *pdev,
-				    const struct pci_device_id *ent)
+				const struct pci_device_id *ent)
 {
 	debugf0("%s()\n", __func__);
 
 	/* wake up and enable device */
 	return pci_enable_device(pdev) ?
-	    -EIO : e7xxx_probe1(pdev, ent->driver_data);
+		-EIO : e7xxx_probe1(pdev, ent->driver_data);
 }
 
 static void __devexit e7xxx_remove_one(struct pci_dev *pdev)
@@ -578,7 +578,7 @@ module_exit(e7xxx_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Linux Networx (http://lnxi.com) Thayne Harbaugh et al\n"
-	      "Based on.work by Dan Hollis et al");
+		"Based on.work by Dan Hollis et al");
 MODULE_DESCRIPTION("MC support for Intel e7xxx memory controllers");
 module_param(edac_op_state, int, 0444);
 MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state: 0=Poll,1=NMI");
diff -puN drivers/edac/edac_device.c~drivers-edac-cleanup-spaces-gotos-after-lindent-messup drivers/edac/edac_device.c
--- a/drivers/edac/edac_device.c~drivers-edac-cleanup-spaces-gotos-after-lindent-messup
+++ a/drivers/edac/edac_device.c
@@ -94,16 +94,16 @@ struct edac_device_ctl_info *edac_device
 
 	/* Calc the 'end' offset past the ctl_info structure */
 	dev_inst = (struct edac_device_instance *)
-	    edac_align_ptr(&dev_ctl[1], sizeof(*dev_inst));
+		edac_align_ptr(&dev_ctl[1], sizeof(*dev_inst));
 
 	/* Calc the 'end' offset past the instance array */
 	dev_blk = (struct edac_device_block *)
-	    edac_align_ptr(&dev_inst[nr_instances], sizeof(*dev_blk));
+		edac_align_ptr(&dev_inst[nr_instances], sizeof(*dev_blk));
 
 	/* Calc the 'end' offset past the dev_blk array */
 	count = nr_instances * nr_blocks;
 	dev_attrib = (struct edac_attrib *)
-	    edac_align_ptr(&dev_blk[count], sizeof(*dev_attrib));
+		edac_align_ptr(&dev_blk[count], sizeof(*dev_attrib));
 
 	/* Check for case of NO attributes specified */
 	if (nr_attribs > 0)
@@ -121,11 +121,11 @@ struct edac_device_ctl_info *edac_device
 	 * rather than an imaginary chunk of memory located at address 0.
 	 */
 	dev_inst = (struct edac_device_instance *)
-	    (((char *)dev_ctl) + ((unsigned long)dev_inst));
+		(((char *)dev_ctl) + ((unsigned long)dev_inst));
 	dev_blk = (struct edac_device_block *)
-	    (((char *)dev_ctl) + ((unsigned long)dev_blk));
+		(((char *)dev_ctl) + ((unsigned long)dev_blk));
 	dev_attrib = (struct edac_attrib *)
-	    (((char *)dev_ctl) + ((unsigned long)dev_attrib));
+		(((char *)dev_ctl) + ((unsigned long)dev_attrib));
 	pvt = sz_private ? (((char *)dev_ctl) + ((unsigned long)pvt)) : NULL;
 
 	memset(dev_ctl, 0, total_size);	/* clear all fields */
@@ -257,18 +257,18 @@ static int add_edac_dev_to_global_list(s
 	list_add_tail_rcu(&edac_dev->link, insert_before);
 	return 0;
 
-      fail0:
+fail0:
 	edac_printk(KERN_WARNING, EDAC_MC,
-		    "%s (%s) %s %s already assigned %d\n",
-		    rover->dev->bus_id, dev_name(rover),
-		    rover->mod_name, rover->ctl_name, rover->dev_idx);
+			"%s (%s) %s %s already assigned %d\n",
+			rover->dev->bus_id, dev_name(rover),
+			rover->mod_name, rover->ctl_name, rover->dev_idx);
 	return 1;
 
-      fail1:
+fail1:
 	edac_printk(KERN_WARNING, EDAC_MC,
-		    "bug in low-level driver: attempt to assign\n"
-		    "    duplicate dev_idx %d in %s()\n", rover->dev_idx,
-		    __func__);
+			"bug in low-level driver: attempt to assign\n"
+			"    duplicate dev_idx %d in %s()\n", rover->dev_idx,
+			__func__);
 	return 1;
 }
 
@@ -288,7 +288,7 @@ static void complete_edac_device_list_de
  * del_edac_device_from_global_list
  */
 static void del_edac_device_from_global_list(struct edac_device_ctl_info
-					     *edac_device)
+						*edac_device)
 {
 	list_del_rcu(&edac_device->link);
 	init_completion(&edac_device->complete);
@@ -342,8 +342,8 @@ static void edac_device_workq_function(s
 
 	/* Only poll controllers that are running polled and have a check */
 	if ((edac_dev->op_state == OP_RUNNING_POLL) &&
-	    (edac_dev->edac_check != NULL)) {
-		edac_dev->edac_check(edac_dev);
+		(edac_dev->edac_check != NULL)) {
+			edac_dev->edac_check(edac_dev);
 	}
 
 	unlock_device_list();
@@ -358,7 +358,7 @@ static void edac_device_workq_function(s
  *	passing in the new delay period in msec
  */
 void edac_device_workq_setup(struct edac_device_ctl_info *edac_dev,
-			     unsigned msec)
+				unsigned msec)
 {
 	debugf0("%s()\n", __func__);
 
@@ -389,7 +389,7 @@ void edac_device_workq_teardown(struct e
  */
 
 void edac_device_reset_delay_period(struct edac_device_ctl_info *edac_dev,
-				    unsigned long value)
+					unsigned long value)
 {
 	lock_device_list();
 
@@ -434,7 +434,7 @@ int edac_device_add_device(struct edac_d
 	/* create this instance's sysfs entries */
 	if (edac_device_create_sysfs(edac_dev)) {
 		edac_device_printk(edac_dev, KERN_WARNING,
-				   "failed to create sysfs device\n");
+					"failed to create sysfs device\n");
 		goto fail1;
 	}
 
@@ -454,21 +454,21 @@ int edac_device_add_device(struct edac_d
 
 	/* Report action taken */
 	edac_device_printk(edac_dev, KERN_INFO,
-			   "Giving out device to module '%s' controller '%s': DEV '%s' (%s)\n",
-			   edac_dev->mod_name,
-			   edac_dev->ctl_name,
-			   dev_name(edac_dev),
-			   edac_op_state_toString(edac_dev->op_state)
-	    );
+				"Giving out device to module '%s' controller "
+				"'%s': DEV '%s' (%s)\n",
+				edac_dev->mod_name,
+				edac_dev->ctl_name,
+				dev_name(edac_dev),
+				edac_op_state_toString(edac_dev->op_state));
 
 	unlock_device_list();
 	return 0;
 
-      fail1:
+fail1:
 	/* Some error, so remove the entry from the lsit */
 	del_edac_device_from_global_list(edac_dev);
 
-      fail0:
+fail0:
 	unlock_device_list();
 	return 1;
 }
@@ -516,9 +516,9 @@ struct edac_device_ctl_info *edac_device
 	unlock_device_list();
 
 	edac_printk(KERN_INFO, EDAC_MC,
-		    "Removed device %d for %s %s: DEV %s\n",
-		    edac_dev->dev_idx,
-		    edac_dev->mod_name, edac_dev->ctl_name, dev_name(edac_dev));
+		"Removed device %d for %s %s: DEV %s\n",
+		edac_dev->dev_idx,
+		edac_dev->mod_name, edac_dev->ctl_name, dev_name(edac_dev));
 
 	return edac_dev;
 }
@@ -536,7 +536,7 @@ static inline int edac_device_get_log_ue
 }
 
 static inline int edac_device_get_panic_on_ue(struct edac_device_ctl_info
-					      *edac_dev)
+					*edac_dev)
 {
 	return edac_dev->panic_on_ue;
 }
@@ -546,16 +546,16 @@ static inline int edac_device_get_panic_
  *	perform a common output and handling of an 'edac_dev' CE event
  */
 void edac_device_handle_ce(struct edac_device_ctl_info *edac_dev,
-			   int inst_nr, int block_nr, const char *msg)
+			int inst_nr, int block_nr, const char *msg)
 {
 	struct edac_device_instance *instance;
 	struct edac_device_block *block = NULL;
 
 	if ((inst_nr >= edac_dev->nr_instances) || (inst_nr < 0)) {
 		edac_device_printk(edac_dev, KERN_ERR,
-				   "INTERNAL ERROR: 'instance' out of range "
-				   "(%d >= %d)\n", inst_nr,
-				   edac_dev->nr_instances);
+				"INTERNAL ERROR: 'instance' out of range "
+				"(%d >= %d)\n", inst_nr,
+				edac_dev->nr_instances);
 		return;
 	}
 
@@ -563,9 +563,10 @@ void edac_device_handle_ce(struct edac_d
 
 	if ((block_nr >= instance->nr_blocks) || (block_nr < 0)) {
 		edac_device_printk(edac_dev, KERN_ERR,
-				   "INTERNAL ERROR: instance %d 'block' out of range "
-				   "(%d >= %d)\n", inst_nr, block_nr,
-				   instance->nr_blocks);
+				"INTERNAL ERROR: instance %d 'block' "
+				"out of range (%d >= %d)\n",
+				inst_nr, block_nr,
+				instance->nr_blocks);
 		return;
 	}
 
@@ -580,9 +581,9 @@ void edac_device_handle_ce(struct edac_d
 
 	if (edac_device_get_log_ce(edac_dev))
 		edac_device_printk(edac_dev, KERN_WARNING,
-				   "CE: %s instance: %s block: %s '%s'\n",
-				   edac_dev->ctl_name, instance->name,
-				   block ? block->name : "N/A", msg);
+				"CE: %s instance: %s block: %s '%s'\n",
+				edac_dev->ctl_name, instance->name,
+				block ? block->name : "N/A", msg);
 }
 
 EXPORT_SYMBOL_GPL(edac_device_handle_ce);
@@ -592,16 +593,16 @@ EXPORT_SYMBOL_GPL(edac_device_handle_ce)
  *	perform a common output and handling of an 'edac_dev' UE event
  */
 void edac_device_handle_ue(struct edac_device_ctl_info *edac_dev,
-			   int inst_nr, int block_nr, const char *msg)
+			int inst_nr, int block_nr, const char *msg)
 {
 	struct edac_device_instance *instance;
 	struct edac_device_block *block = NULL;
 
 	if ((inst_nr >= edac_dev->nr_instances) || (inst_nr < 0)) {
 		edac_device_printk(edac_dev, KERN_ERR,
-				   "INTERNAL ERROR: 'instance' out of range "
-				   "(%d >= %d)\n", inst_nr,
-				   edac_dev->nr_instances);
+				"INTERNAL ERROR: 'instance' out of range "
+				"(%d >= %d)\n", inst_nr,
+				edac_dev->nr_instances);
 		return;
 	}
 
@@ -609,9 +610,10 @@ void edac_device_handle_ue(struct edac_d
 
 	if ((block_nr >= instance->nr_blocks) || (block_nr < 0)) {
 		edac_device_printk(edac_dev, KERN_ERR,
-				   "INTERNAL ERROR: instance %d 'block' out of range "
-				   "(%d >= %d)\n", inst_nr, block_nr,
-				   instance->nr_blocks);
+				"INTERNAL ERROR: instance %d 'block' "
+				"out of range (%d >= %d)\n",
+				inst_nr, block_nr,
+				instance->nr_blocks);
 		return;
 	}
 
@@ -626,14 +628,14 @@ void edac_device_handle_ue(struct edac_d
 
 	if (edac_device_get_log_ue(edac_dev))
 		edac_device_printk(edac_dev, KERN_EMERG,
-				   "UE: %s instance: %s block: %s '%s'\n",
-				   edac_dev->ctl_name, instance->name,
-				   block ? block->name : "N/A", msg);
+				"UE: %s instance: %s block: %s '%s'\n",
+				edac_dev->ctl_name, instance->name,
+				block ? block->name : "N/A", msg);
 
 	if (edac_device_get_panic_on_ue(edac_dev))
 		panic("EDAC %s: UE instance: %s block %s '%s'\n",
-		      edac_dev->ctl_name, instance->name,
-		      block ? block->name : "N/A", msg);
+			edac_dev->ctl_name, instance->name,
+			block ? block->name : "N/A", msg);
 }
 
 EXPORT_SYMBOL_GPL(edac_device_handle_ue);
diff -puN drivers/edac/edac_device_sysfs.c~drivers-edac-cleanup-spaces-gotos-after-lindent-messup drivers/edac/edac_device_sysfs.c
--- a/drivers/edac/edac_device_sysfs.c~drivers-edac-cleanup-spaces-gotos-after-lindent-messup
+++ a/drivers/edac/edac_device_sysfs.c
@@ -27,14 +27,14 @@
 
 /* 'log_ue' */
 static ssize_t edac_device_ctl_log_ue_show(struct edac_device_ctl_info
-					   *ctl_info, char *data)
+					*ctl_info, char *data)
 {
 	return sprintf(data, "%u\n", ctl_info->log_ue);
 }
 
 static ssize_t edac_device_ctl_log_ue_store(struct edac_device_ctl_info
-					    *ctl_info, const char *data,
-					    size_t count)
+					*ctl_info, const char *data,
+					size_t count)
 {
 	/* if parameter is zero, turn off flag, if non-zero turn on flag */
 	ctl_info->log_ue = (simple_strtoul(data, NULL, 0) != 0);
@@ -44,14 +44,14 @@ static ssize_t edac_device_ctl_log_ue_st
 
 /* 'log_ce' */
 static ssize_t edac_device_ctl_log_ce_show(struct edac_device_ctl_info
-					   *ctl_info, char *data)
+					*ctl_info, char *data)
 {
 	return sprintf(data, "%u\n", ctl_info->log_ce);
 }
 
 static ssize_t edac_device_ctl_log_ce_store(struct edac_device_ctl_info
-					    *ctl_info, const char *data,
-					    size_t count)
+					*ctl_info, const char *data,
+					size_t count)
 {
 	/* if parameter is zero, turn off flag, if non-zero turn on flag */
 	ctl_info->log_ce = (simple_strtoul(data, NULL, 0) != 0);
@@ -78,14 +78,14 @@ static ssize_t edac_device_ctl_panic_on_
 
 /* 'poll_msec' show and store functions*/
 static ssize_t edac_device_ctl_poll_msec_show(struct edac_device_ctl_info
-					      *ctl_info, char *data)
+					*ctl_info, char *data)
 {
 	return sprintf(data, "%u\n", ctl_info->poll_msec);
 }
 
 static ssize_t edac_device_ctl_poll_msec_store(struct edac_device_ctl_info
-					       *ctl_info, const char *data,
-					       size_t count)
+					*ctl_info, const char *data,
+					size_t count)
 {
 	unsigned long value;
 
@@ -112,7 +112,7 @@ struct ctl_info_attribute {
 
 /* Function to 'show' fields from the edac_dev 'ctl_info' structure */
 static ssize_t edac_dev_ctl_info_show(struct kobject *kobj,
-				      struct attribute *attr, char *buffer)
+				struct attribute *attr, char *buffer)
 {
 	struct edac_device_ctl_info *edac_dev = to_ctl_info(kobj);
 	struct ctl_info_attribute *ctl_info_attr = to_ctl_info_attr(attr);
@@ -124,8 +124,8 @@ static ssize_t edac_dev_ctl_info_show(st
 
 /* Function to 'store' fields into the edac_dev 'ctl_info' structure */
 static ssize_t edac_dev_ctl_info_store(struct kobject *kobj,
-				       struct attribute *attr,
-				       const char *buffer, size_t count)
+				struct attribute *attr,
+				const char *buffer, size_t count)
 {
 	struct edac_device_ctl_info *edac_dev = to_ctl_info(kobj);
 	struct ctl_info_attribute *ctl_info_attr = to_ctl_info_attr(attr);
@@ -143,21 +143,21 @@ static struct sysfs_ops device_ctl_info_
 
 #define CTL_INFO_ATTR(_name,_mode,_show,_store)        \
 static struct ctl_info_attribute attr_ctl_info_##_name = {      \
-        .attr = {.name = __stringify(_name), .mode = _mode },   \
-        .show   = _show,                                        \
-        .store  = _store,                                       \
+	.attr = {.name = __stringify(_name), .mode = _mode },   \
+	.show   = _show,                                        \
+	.store  = _store,                                       \
 };
 
 /* Declare the various ctl_info attributes here and their respective ops */
 CTL_INFO_ATTR(log_ue, S_IRUGO | S_IWUSR,
-	      edac_device_ctl_log_ue_show, edac_device_ctl_log_ue_store);
+	edac_device_ctl_log_ue_show, edac_device_ctl_log_ue_store);
 CTL_INFO_ATTR(log_ce, S_IRUGO | S_IWUSR,
-	      edac_device_ctl_log_ce_show, edac_device_ctl_log_ce_store);
+	edac_device_ctl_log_ce_show, edac_device_ctl_log_ce_store);
 CTL_INFO_ATTR(panic_on_ue, S_IRUGO | S_IWUSR,
-	      edac_device_ctl_panic_on_ue_show,
-	      edac_device_ctl_panic_on_ue_store);
+	edac_device_ctl_panic_on_ue_show,
+	edac_device_ctl_panic_on_ue_store);
 CTL_INFO_ATTR(poll_msec, S_IRUGO | S_IWUSR,
-	      edac_device_ctl_poll_msec_show, edac_device_ctl_poll_msec_store);
+	edac_device_ctl_poll_msec_show, edac_device_ctl_poll_msec_store);
 
 /* Base Attributes of the EDAC_DEVICE ECC object */
 static struct ctl_info_attribute *device_ctrl_attr[] = {
@@ -242,7 +242,7 @@ static int edac_device_register_main_kob
  *	the '..../edac/<name>' kobject
  */
 static void edac_device_unregister_main_kobj(struct edac_device_ctl_info
-					     *edac_dev)
+					*edac_dev)
 {
 	debugf0("%s()\n", __func__);
 	debugf1("%s() name of kobject is: %s\n",
@@ -264,13 +264,13 @@ static void edac_device_unregister_main_
  * Set of low-level instance attribute show functions
  */
 static ssize_t instance_ue_count_show(struct edac_device_instance *instance,
-				      char *data)
+				char *data)
 {
 	return sprintf(data, "%u\n", instance->counters.ue_count);
 }
 
 static ssize_t instance_ce_count_show(struct edac_device_instance *instance,
-				      char *data)
+				char *data)
 {
 	return sprintf(data, "%u\n", instance->counters.ce_count);
 }
@@ -298,7 +298,7 @@ struct instance_attribute {
 
 /* Function to 'show' fields from the edac_dev 'instance' structure */
 static ssize_t edac_dev_instance_show(struct kobject *kobj,
-				      struct attribute *attr, char *buffer)
+				struct attribute *attr, char *buffer)
 {
 	struct edac_device_instance *instance = to_instance(kobj);
 	struct instance_attribute *instance_attr = to_instance_attr(attr);
@@ -310,8 +310,8 @@ static ssize_t edac_dev_instance_show(st
 
 /* Function to 'store' fields into the edac_dev 'instance' structure */
 static ssize_t edac_dev_instance_store(struct kobject *kobj,
-				       struct attribute *attr,
-				       const char *buffer, size_t count)
+				struct attribute *attr,
+				const char *buffer, size_t count)
 {
 	struct edac_device_instance *instance = to_instance(kobj);
 	struct instance_attribute *instance_attr = to_instance_attr(attr);
@@ -329,9 +329,9 @@ static struct sysfs_ops device_instance_
 
 #define INSTANCE_ATTR(_name,_mode,_show,_store)        \
 static struct instance_attribute attr_instance_##_name = {      \
-        .attr = {.name = __stringify(_name), .mode = _mode },   \
-        .show   = _show,                                        \
-        .store  = _store,                                       \
+	.attr = {.name = __stringify(_name), .mode = _mode },   \
+	.show   = _show,                                        \
+	.store  = _store,                                       \
 };
 
 /*
@@ -394,7 +394,7 @@ struct block_attribute {
 
 /* Function to 'show' fields from the edac_dev 'block' structure */
 static ssize_t edac_dev_block_show(struct kobject *kobj,
-				   struct attribute *attr, char *buffer)
+				struct attribute *attr, char *buffer)
 {
 	struct edac_device_block *block = to_block(kobj);
 	struct block_attribute *block_attr = to_block_attr(attr);
@@ -406,8 +406,8 @@ static ssize_t edac_dev_block_show(struc
 
 /* Function to 'store' fields into the edac_dev 'block' structure */
 static ssize_t edac_dev_block_store(struct kobject *kobj,
-				    struct attribute *attr,
-				    const char *buffer, size_t count)
+				struct attribute *attr,
+				const char *buffer, size_t count)
 {
 	struct edac_device_block *block = to_block(kobj);
 	struct block_attribute *block_attr = to_block_attr(attr);
@@ -425,9 +425,9 @@ static struct sysfs_ops device_block_ops
 
 #define BLOCK_ATTR(_name,_mode,_show,_store)        \
 static struct block_attribute attr_block_##_name = {                       \
-        .attr = {.name = __stringify(_name), .mode = _mode },   \
-        .show   = _show,                                        \
-        .store  = _store,                                       \
+	.attr = {.name = __stringify(_name), .mode = _mode },   \
+	.show   = _show,                                        \
+	.store  = _store,                                       \
 };
 
 BLOCK_ATTR(ce_count, S_IRUGO, block_ce_count_show, NULL);
@@ -453,8 +453,8 @@ static struct kobj_type ktype_block_ctrl
  * edac_device_create_block
  */
 static int edac_device_create_block(struct edac_device_ctl_info *edac_dev,
-				    struct edac_device_instance *instance,
-				    int idx)
+				struct edac_device_instance *instance,
+				int idx)
 {
 	int err;
 	struct edac_device_block *block;
@@ -487,8 +487,8 @@ static int edac_device_create_block(stru
  * edac_device_delete_block(edac_dev,j);
  */
 static void edac_device_delete_block(struct edac_device_ctl_info *edac_dev,
-				     struct edac_device_instance *instance,
-				     int idx)
+				struct edac_device_instance *instance,
+				int idx)
 {
 	struct edac_device_block *block;
 
@@ -507,7 +507,7 @@ static void edac_device_delete_block(str
  *	create just one instance of an edac_device 'instance'
  */
 static int edac_device_create_instance(struct edac_device_ctl_info *edac_dev,
-				       int idx)
+				int idx)
 {
 	int i, j;
 	int err;
@@ -627,22 +627,22 @@ static int edac_device_add_sysfs_attribu
 			struct edac_device_ctl_info *edac_dev)
 {
 	int err;
-        struct edac_dev_sysfs_attribute *sysfs_attrib;
+	struct edac_dev_sysfs_attribute *sysfs_attrib;
 
-        /* point to the start of the array and iterate over it
-         * adding each attribute listed to this mci instance's kobject
-         */
-        sysfs_attrib = edac_dev->sysfs_attributes;
-
-        while (sysfs_attrib->attr.name != NULL) {
-                err = sysfs_create_file(&edac_dev->kobj,
-                                        (struct attribute*) sysfs_attrib);
-                if (err) {
-                        return err;
-                }
+	/* point to the start of the array and iterate over it
+	 * adding each attribute listed to this mci instance's kobject
+	 */
+	sysfs_attrib = edac_dev->sysfs_attributes;
+
+	while (sysfs_attrib->attr.name != NULL) {
+		err = sysfs_create_file(&edac_dev->kobj,
+				(struct attribute*) sysfs_attrib);
+		if (err) {
+			return err;
+		}
 
-                sysfs_attrib++;
-        }
+		sysfs_attrib++;
+	}
 
 	return 0;
 }
diff -puN drivers/edac/edac_mc.c~drivers-edac-cleanup-spaces-gotos-after-lindent-messup drivers/edac/edac_mc.c
--- a/drivers/edac/edac_mc.c~drivers-edac-cleanup-spaces-gotos-after-lindent-messup
+++ a/drivers/edac/edac_mc.c
@@ -129,7 +129,7 @@ char *edac_align_ptr(void *ptr, unsigned
  *	struct mem_ctl_info pointer
  */
 struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
-				   unsigned nr_chans)
+				unsigned nr_chans)
 {
 	struct mem_ctl_info *mci;
 	struct csrow_info *csi, *csrow;
@@ -146,7 +146,7 @@ struct mem_ctl_info *edac_mc_alloc(unsig
 	mci = (struct mem_ctl_info *)0;
 	csi = (struct csrow_info *)edac_align_ptr(&mci[1], sizeof(*csi));
 	chi = (struct channel_info *)
-	    edac_align_ptr(&csi[nr_csrows], sizeof(*chi));
+		edac_align_ptr(&csi[nr_csrows], sizeof(*chi));
 	pvt = edac_align_ptr(&chi[nr_chans * nr_csrows], sz_pvt);
 	size = ((unsigned long)pvt) + sz_pvt;
 
@@ -256,7 +256,7 @@ static void edac_mc_workq_function(struc
 
 	/* Reschedule */
 	queue_delayed_work(edac_workqueue, &mci->work,
-			   msecs_to_jiffies(edac_mc_get_poll_msec()));
+			msecs_to_jiffies(edac_mc_get_poll_msec()));
 }
 
 /*
@@ -334,16 +334,16 @@ static int add_mc_to_global_list(struct 
 	atomic_inc(&edac_handlers);
 	return 0;
 
-      fail0:
+fail0:
 	edac_printk(KERN_WARNING, EDAC_MC,
-		    "%s (%s) %s %s already assigned %d\n", p->dev->bus_id,
-		    dev_name(mci), p->mod_name, p->ctl_name, p->mc_idx);
+		"%s (%s) %s %s already assigned %d\n", p->dev->bus_id,
+		dev_name(mci), p->mod_name, p->ctl_name, p->mc_idx);
 	return 1;
 
-      fail1:
+fail1:
 	edac_printk(KERN_WARNING, EDAC_MC,
-		    "bug in low-level driver: attempt to assign\n"
-		    "    duplicate mc_idx %d in %s()\n", p->mc_idx, __func__);
+		"bug in low-level driver: attempt to assign\n"
+		"    duplicate mc_idx %d in %s()\n", p->mc_idx, __func__);
 	return 1;
 }
 
@@ -423,7 +423,7 @@ int edac_mc_add_mc(struct mem_ctl_info *
 			edac_mc_dump_csrow(&mci->csrows[i]);
 			for (j = 0; j < mci->csrows[i].nr_channels; j++)
 				edac_mc_dump_channel(&mci->csrows[i].
-						     channels[j]);
+						channels[j]);
 		}
 	}
 #endif
@@ -437,7 +437,7 @@ int edac_mc_add_mc(struct mem_ctl_info *
 
 	if (edac_create_sysfs_mci_device(mci)) {
 		edac_mc_printk(mci, KERN_WARNING,
-			       "failed to create sysfs device\n");
+			"failed to create sysfs device\n");
 		goto fail1;
 	}
 
@@ -453,15 +453,15 @@ int edac_mc_add_mc(struct mem_ctl_info *
 
 	/* Report action taken */
 	edac_mc_printk(mci, KERN_INFO, "Giving out device to %s %s: DEV %s\n",
-		       mci->mod_name, mci->ctl_name, dev_name(mci));
+		mci->mod_name, mci->ctl_name, dev_name(mci));
 
 	mutex_unlock(&mem_ctls_mutex);
 	return 0;
 
-      fail1:
+fail1:
 	del_mc_from_global_list(mci);
 
-      fail0:
+fail0:
 	mutex_unlock(&mem_ctls_mutex);
 	return 1;
 }
@@ -497,8 +497,8 @@ struct mem_ctl_info *edac_mc_del_mc(stru
 	del_mc_from_global_list(mci);
 	mutex_unlock(&mem_ctls_mutex);
 	edac_printk(KERN_INFO, EDAC_MC,
-		    "Removed device %d for %s %s: DEV %s\n", mci->mc_idx,
-		    mci->mod_name, mci->ctl_name, dev_name(mci));
+		"Removed device %d for %s %s: DEV %s\n", mci->mc_idx,
+		mci->mod_name, mci->ctl_name, dev_name(mci));
 	return mci;
 }
 
@@ -566,8 +566,8 @@ int edac_mc_find_csrow_by_page(struct me
 
 	if (row == -1)
 		edac_mc_printk(mci, KERN_ERR,
-			       "could not look up page error address %lx\n",
-			       (unsigned long)page);
+			"could not look up page error address %lx\n",
+			(unsigned long)page);
 
 	return row;
 }
@@ -577,9 +577,9 @@ EXPORT_SYMBOL_GPL(edac_mc_find_csrow_by_
 /* FIXME - setable log (warning/emerg) levels */
 /* FIXME - integrate with evlog: http://evlog.sourceforge.net/ */
 void edac_mc_handle_ce(struct mem_ctl_info *mci,
-		       unsigned long page_frame_number,
-		       unsigned long offset_in_page, unsigned long syndrome,
-		       int row, int channel, const char *msg)
+		unsigned long page_frame_number,
+		unsigned long offset_in_page, unsigned long syndrome,
+		int row, int channel, const char *msg)
 {
 	unsigned long remapped_page;
 
@@ -589,8 +589,8 @@ void edac_mc_handle_ce(struct mem_ctl_in
 	if (row >= mci->nr_csrows || row < 0) {
 		/* something is wrong */
 		edac_mc_printk(mci, KERN_ERR,
-			       "INTERNAL ERROR: row out of range "
-			       "(%d >= %d)\n", row, mci->nr_csrows);
+			"INTERNAL ERROR: row out of range "
+			"(%d >= %d)\n", row, mci->nr_csrows);
 		edac_mc_handle_ce_no_info(mci, "INTERNAL ERROR");
 		return;
 	}
@@ -598,9 +598,9 @@ void edac_mc_handle_ce(struct mem_ctl_in
 	if (channel >= mci->csrows[row].nr_channels || channel < 0) {
 		/* something is wrong */
 		edac_mc_printk(mci, KERN_ERR,
-			       "INTERNAL ERROR: channel out of range "
-			       "(%d >= %d)\n", channel,
-			       mci->csrows[row].nr_channels);
+			"INTERNAL ERROR: channel out of range "
+			"(%d >= %d)\n", channel,
+			mci->csrows[row].nr_channels);
 		edac_mc_handle_ce_no_info(mci, "INTERNAL ERROR");
 		return;
 	}
@@ -608,11 +608,11 @@ void edac_mc_handle_ce(struct mem_ctl_in
 	if (edac_mc_get_log_ce())
 		/* FIXME - put in DIMM location */
 		edac_mc_printk(mci, KERN_WARNING,
-			       "CE page 0x%lx, offset 0x%lx, grain %d, syndrome "
-			       "0x%lx, row %d, channel %d, label \"%s\": %s\n",
-			       page_frame_number, offset_in_page,
-			       mci->csrows[row].grain, syndrome, row, channel,
-			       mci->csrows[row].channels[channel].label, msg);
+			"CE page 0x%lx, offset 0x%lx, grain %d, syndrome "
+			"0x%lx, row %d, channel %d, label \"%s\": %s\n",
+			page_frame_number, offset_in_page,
+			mci->csrows[row].grain, syndrome, row, channel,
+			mci->csrows[row].channels[channel].label, msg);
 
 	mci->ce_count++;
 	mci->csrows[row].ce_count++;
@@ -629,11 +629,11 @@ void edac_mc_handle_ce(struct mem_ctl_in
 		 * page - which can then be scrubbed.
 		 */
 		remapped_page = mci->ctl_page_to_phys ?
-		    mci->ctl_page_to_phys(mci, page_frame_number) :
-		    page_frame_number;
+			mci->ctl_page_to_phys(mci, page_frame_number) :
+			page_frame_number;
 
 		edac_mc_scrub_block(remapped_page, offset_in_page,
-				    mci->csrows[row].grain);
+				mci->csrows[row].grain);
 	}
 }
 
@@ -643,7 +643,7 @@ void edac_mc_handle_ce_no_info(struct me
 {
 	if (edac_mc_get_log_ce())
 		edac_mc_printk(mci, KERN_WARNING,
-			       "CE - no information available: %s\n", msg);
+			"CE - no information available: %s\n", msg);
 
 	mci->ce_noinfo_count++;
 	mci->ce_count++;
@@ -652,8 +652,8 @@ void edac_mc_handle_ce_no_info(struct me
 EXPORT_SYMBOL_GPL(edac_mc_handle_ce_no_info);
 
 void edac_mc_handle_ue(struct mem_ctl_info *mci,
-		       unsigned long page_frame_number,
-		       unsigned long offset_in_page, int row, const char *msg)
+		unsigned long page_frame_number,
+		unsigned long offset_in_page, int row, const char *msg)
 {
 	int len = EDAC_MC_LABEL_LEN * 4;
 	char labels[len + 1];
@@ -667,8 +667,8 @@ void edac_mc_handle_ue(struct mem_ctl_in
 	if (row >= mci->nr_csrows || row < 0) {
 		/* something is wrong */
 		edac_mc_printk(mci, KERN_ERR,
-			       "INTERNAL ERROR: row out of range "
-			       "(%d >= %d)\n", row, mci->nr_csrows);
+			"INTERNAL ERROR: row out of range "
+			"(%d >= %d)\n", row, mci->nr_csrows);
 		edac_mc_handle_ue_no_info(mci, "INTERNAL ERROR");
 		return;
 	}
@@ -679,7 +679,7 @@ void edac_mc_handle_ue(struct mem_ctl_in
 	pos += chars;
 
 	for (chan = 1; (chan < mci->csrows[row].nr_channels) && (len > 0);
-	     chan++) {
+		chan++) {
 		chars = snprintf(pos, len + 1, ":%s",
 				 mci->csrows[row].channels[chan].label);
 		len -= chars;
@@ -688,16 +688,16 @@ void edac_mc_handle_ue(struct mem_ctl_in
 
 	if (edac_mc_get_log_ue())
 		edac_mc_printk(mci, KERN_EMERG,
-			       "UE page 0x%lx, offset 0x%lx, grain %d, row %d, "
-			       "labels \"%s\": %s\n", page_frame_number,
-			       offset_in_page, mci->csrows[row].grain, row,
-			       labels, msg);
+			"UE page 0x%lx, offset 0x%lx, grain %d, row %d, "
+			"labels \"%s\": %s\n", page_frame_number,
+			offset_in_page, mci->csrows[row].grain, row,
+			labels, msg);
 
 	if (edac_mc_get_panic_on_ue())
 		panic("EDAC MC%d: UE page 0x%lx, offset 0x%lx, grain %d, "
-		      "row %d, labels \"%s\": %s\n", mci->mc_idx,
-		      page_frame_number, offset_in_page,
-		      mci->csrows[row].grain, row, labels, msg);
+			"row %d, labels \"%s\": %s\n", mci->mc_idx,
+			page_frame_number, offset_in_page,
+			mci->csrows[row].grain, row, labels, msg);
 
 	mci->ue_count++;
 	mci->csrows[row].ue_count++;
@@ -712,7 +712,7 @@ void edac_mc_handle_ue_no_info(struct me
 
 	if (edac_mc_get_log_ue())
 		edac_mc_printk(mci, KERN_WARNING,
-			       "UE - no information available: %s\n", msg);
+			"UE - no information available: %s\n", msg);
 	mci->ue_noinfo_count++;
 	mci->ue_count++;
 }
@@ -724,9 +724,9 @@ EXPORT_SYMBOL_GPL(edac_mc_handle_ue_no_i
  * called to process UE events
  */
 void edac_mc_handle_fbd_ue(struct mem_ctl_info *mci,
-			   unsigned int csrow,
-			   unsigned int channela,
-			   unsigned int channelb, char *msg)
+			unsigned int csrow,
+			unsigned int channela,
+			unsigned int channelb, char *msg)
 {
 	int len = EDAC_MC_LABEL_LEN * 4;
 	char labels[len + 1];
@@ -736,8 +736,8 @@ void edac_mc_handle_fbd_ue(struct mem_ct
 	if (csrow >= mci->nr_csrows) {
 		/* something is wrong */
 		edac_mc_printk(mci, KERN_ERR,
-			       "INTERNAL ERROR: row out of range (%d >= %d)\n",
-			       csrow, mci->nr_csrows);
+			"INTERNAL ERROR: row out of range (%d >= %d)\n",
+			csrow, mci->nr_csrows);
 		edac_mc_handle_ue_no_info(mci, "INTERNAL ERROR");
 		return;
 	}
@@ -745,9 +745,9 @@ void edac_mc_handle_fbd_ue(struct mem_ct
 	if (channela >= mci->csrows[csrow].nr_channels) {
 		/* something is wrong */
 		edac_mc_printk(mci, KERN_ERR,
-			       "INTERNAL ERROR: channel-a out of range "
-			       "(%d >= %d)\n",
-			       channela, mci->csrows[csrow].nr_channels);
+			"INTERNAL ERROR: channel-a out of range "
+			"(%d >= %d)\n",
+			channela, mci->csrows[csrow].nr_channels);
 		edac_mc_handle_ue_no_info(mci, "INTERNAL ERROR");
 		return;
 	}
@@ -755,9 +755,9 @@ void edac_mc_handle_fbd_ue(struct mem_ct
 	if (channelb >= mci->csrows[csrow].nr_channels) {
 		/* something is wrong */
 		edac_mc_printk(mci, KERN_ERR,
-			       "INTERNAL ERROR: channel-b out of range "
-			       "(%d >= %d)\n",
-			       channelb, mci->csrows[csrow].nr_channels);
+			"INTERNAL ERROR: channel-b out of range "
+			"(%d >= %d)\n",
+			channelb, mci->csrows[csrow].nr_channels);
 		edac_mc_handle_ue_no_info(mci, "INTERNAL ERROR");
 		return;
 	}
@@ -775,14 +775,14 @@ void edac_mc_handle_fbd_ue(struct mem_ct
 
 	if (edac_mc_get_log_ue())
 		edac_mc_printk(mci, KERN_EMERG,
-			       "UE row %d, channel-a= %d channel-b= %d "
-			       "labels \"%s\": %s\n", csrow, channela, channelb,
-			       labels, msg);
+			"UE row %d, channel-a= %d channel-b= %d "
+			"labels \"%s\": %s\n", csrow, channela, channelb,
+			labels, msg);
 
 	if (edac_mc_get_panic_on_ue())
 		panic("UE row %d, channel-a= %d channel-b= %d "
-		      "labels \"%s\": %s\n", csrow, channela,
-		      channelb, labels, msg);
+			"labels \"%s\": %s\n", csrow, channela,
+			channelb, labels, msg);
 }
 
 EXPORT_SYMBOL(edac_mc_handle_fbd_ue);
@@ -792,23 +792,23 @@ EXPORT_SYMBOL(edac_mc_handle_fbd_ue);
  * called to process CE events
  */
 void edac_mc_handle_fbd_ce(struct mem_ctl_info *mci,
-			   unsigned int csrow, unsigned int channel, char *msg)
+			unsigned int csrow, unsigned int channel, char *msg)
 {
 
 	/* Ensure boundary values */
 	if (csrow >= mci->nr_csrows) {
 		/* something is wrong */
 		edac_mc_printk(mci, KERN_ERR,
-			       "INTERNAL ERROR: row out of range (%d >= %d)\n",
-			       csrow, mci->nr_csrows);
+			"INTERNAL ERROR: row out of range (%d >= %d)\n",
+			csrow, mci->nr_csrows);
 		edac_mc_handle_ce_no_info(mci, "INTERNAL ERROR");
 		return;
 	}
 	if (channel >= mci->csrows[csrow].nr_channels) {
 		/* something is wrong */
 		edac_mc_printk(mci, KERN_ERR,
-			       "INTERNAL ERROR: channel out of range (%d >= %d)\n",
-			       channel, mci->csrows[csrow].nr_channels);
+			"INTERNAL ERROR: channel out of range (%d >= %d)\n",
+			channel, mci->csrows[csrow].nr_channels);
 		edac_mc_handle_ce_no_info(mci, "INTERNAL ERROR");
 		return;
 	}
@@ -816,9 +816,9 @@ void edac_mc_handle_fbd_ce(struct mem_ct
 	if (edac_mc_get_log_ce())
 		/* FIXME - put in DIMM location */
 		edac_mc_printk(mci, KERN_WARNING,
-			       "CE row %d, channel %d, label \"%s\": %s\n",
-			       csrow, channel,
-			       mci->csrows[csrow].channels[channel].label, msg);
+			"CE row %d, channel %d, label \"%s\": %s\n",
+			csrow, channel,
+			mci->csrows[csrow].channels[channel].label, msg);
 
 	mci->ce_count++;
 	mci->csrows[csrow].ce_count++;
diff -puN drivers/edac/edac_mc_sysfs.c~drivers-edac-cleanup-spaces-gotos-after-lindent-messup drivers/edac/edac_mc_sysfs.c
--- a/drivers/edac/edac_mc_sysfs.c~drivers-edac-cleanup-spaces-gotos-after-lindent-messup
+++ a/drivers/edac/edac_mc_sysfs.c
@@ -183,16 +183,16 @@ static struct memctrl_dev_attribute attr
 
 /* csrow<id> control files */
 MEMCTRL_ATTR(edac_mc_panic_on_ue,
-	     S_IRUGO | S_IWUSR, memctrl_int_show, memctrl_int_store);
+	S_IRUGO | S_IWUSR, memctrl_int_show, memctrl_int_store);
 
 MEMCTRL_ATTR(edac_mc_log_ue,
-	     S_IRUGO | S_IWUSR, memctrl_int_show, memctrl_int_store);
+	S_IRUGO | S_IWUSR, memctrl_int_show, memctrl_int_store);
 
 MEMCTRL_ATTR(edac_mc_log_ce,
-	     S_IRUGO | S_IWUSR, memctrl_int_show, memctrl_int_store);
+	S_IRUGO | S_IWUSR, memctrl_int_show, memctrl_int_store);
 
 MEMCTRL_ATTR(edac_mc_poll_msec,
-	     S_IRUGO | S_IWUSR, memctrl_int_show, memctrl_int_store);
+	S_IRUGO | S_IWUSR, memctrl_int_show, memctrl_int_store);
 
 /* Base Attributes of the memory ECC object */
 static struct memctrl_dev_attribute *memctrl_attr[] = {
@@ -281,44 +281,44 @@ void edac_sysfs_memctrl_teardown(void)
 
 /* Set of more default csrow<id> attribute show/store functions */
 static ssize_t csrow_ue_count_show(struct csrow_info *csrow, char *data,
-				   int private)
+				int private)
 {
 	return sprintf(data, "%u\n", csrow->ue_count);
 }
 
 static ssize_t csrow_ce_count_show(struct csrow_info *csrow, char *data,
-				   int private)
+				int private)
 {
 	return sprintf(data, "%u\n", csrow->ce_count);
 }
 
 static ssize_t csrow_size_show(struct csrow_info *csrow, char *data,
-			       int private)
+				int private)
 {
 	return sprintf(data, "%u\n", PAGES_TO_MiB(csrow->nr_pages));
 }
 
 static ssize_t csrow_mem_type_show(struct csrow_info *csrow, char *data,
-				   int private)
+				int private)
 {
 	return sprintf(data, "%s\n", mem_types[csrow->mtype]);
 }
 
 static ssize_t csrow_dev_type_show(struct csrow_info *csrow, char *data,
-				   int private)
+				int private)
 {
 	return sprintf(data, "%s\n", dev_types[csrow->dtype]);
 }
 
 static ssize_t csrow_edac_mode_show(struct csrow_info *csrow, char *data,
-				    int private)
+				int private)
 {
 	return sprintf(data, "%s\n", edac_caps[csrow->edac_mode]);
 }
 
 /* show/store functions for DIMM Label attributes */
 static ssize_t channel_dimm_label_show(struct csrow_info *csrow,
-				       char *data, int channel)
+				char *data, int channel)
 {
 	return snprintf(data, EDAC_MC_LABEL_LEN, "%s",
 			csrow->channels[channel].label);
@@ -339,7 +339,7 @@ static ssize_t channel_dimm_label_store(
 
 /* show function for dynamic chX_ce_count attribute */
 static ssize_t channel_ce_count_show(struct csrow_info *csrow,
-				     char *data, int channel)
+				char *data, int channel)
 {
 	return sprintf(data, "%u\n", csrow->channels[channel].ce_count);
 }
@@ -357,27 +357,27 @@ struct csrowdev_attribute {
 
 /* Set of show/store higher level functions for default csrow attributes */
 static ssize_t csrowdev_show(struct kobject *kobj,
-			     struct attribute *attr, char *buffer)
+			struct attribute *attr, char *buffer)
 {
 	struct csrow_info *csrow = to_csrow(kobj);
 	struct csrowdev_attribute *csrowdev_attr = to_csrowdev_attr(attr);
 
 	if (csrowdev_attr->show)
 		return csrowdev_attr->show(csrow,
-					   buffer, csrowdev_attr->private);
+					buffer, csrowdev_attr->private);
 	return -EIO;
 }
 
 static ssize_t csrowdev_store(struct kobject *kobj, struct attribute *attr,
-			      const char *buffer, size_t count)
+			const char *buffer, size_t count)
 {
 	struct csrow_info *csrow = to_csrow(kobj);
 	struct csrowdev_attribute *csrowdev_attr = to_csrowdev_attr(attr);
 
 	if (csrowdev_attr->store)
 		return csrowdev_attr->store(csrow,
-					    buffer,
-					    count, csrowdev_attr->private);
+					buffer,
+					count, csrowdev_attr->private);
 	return -EIO;
 }
 
@@ -415,17 +415,17 @@ static struct csrowdev_attribute *defaul
 
 /* possible dynamic channel DIMM Label attribute files */
 CSROWDEV_ATTR(ch0_dimm_label, S_IRUGO | S_IWUSR,
-	      channel_dimm_label_show, channel_dimm_label_store, 0);
+	channel_dimm_label_show, channel_dimm_label_store, 0);
 CSROWDEV_ATTR(ch1_dimm_label, S_IRUGO | S_IWUSR,
-	      channel_dimm_label_show, channel_dimm_label_store, 1);
+	channel_dimm_label_show, channel_dimm_label_store, 1);
 CSROWDEV_ATTR(ch2_dimm_label, S_IRUGO | S_IWUSR,
-	      channel_dimm_label_show, channel_dimm_label_store, 2);
+	channel_dimm_label_show, channel_dimm_label_store, 2);
 CSROWDEV_ATTR(ch3_dimm_label, S_IRUGO | S_IWUSR,
-	      channel_dimm_label_show, channel_dimm_label_store, 3);
+	channel_dimm_label_show, channel_dimm_label_store, 3);
 CSROWDEV_ATTR(ch4_dimm_label, S_IRUGO | S_IWUSR,
-	      channel_dimm_label_show, channel_dimm_label_store, 4);
+	channel_dimm_label_show, channel_dimm_label_store, 4);
 CSROWDEV_ATTR(ch5_dimm_label, S_IRUGO | S_IWUSR,
-	      channel_dimm_label_show, channel_dimm_label_store, 5);
+	channel_dimm_label_show, channel_dimm_label_store, 5);
 
 /* Total possible dynamic DIMM Label attribute file table */
 static struct csrowdev_attribute *dynamic_csrow_dimm_attr[] = {
@@ -501,7 +501,7 @@ static struct kobj_type ktype_csrow = {
 
 /* Create a CSROW object under specifed edac_mc_device */
 static int edac_create_csrow_object(struct kobject *edac_mci_kobj,
-				    struct csrow_info *csrow, int index)
+				struct csrow_info *csrow, int index)
 {
 	int err = 0;
 	int chan;
@@ -531,7 +531,7 @@ static int edac_create_csrow_object(stru
 		}
 	}
 
-      error_exit:
+error_exit:
 	return err;
 }
 
@@ -563,7 +563,7 @@ static ssize_t mci_reset_counters_store(
 
 /* memory scrubbing */
 static ssize_t mci_sdram_scrub_rate_store(struct mem_ctl_info *mci,
-					  const char *data, size_t count)
+					const char *data, size_t count)
 {
 	u32 bandwidth = -1;
 
@@ -573,18 +573,18 @@ static ssize_t mci_sdram_scrub_rate_stor
 
 		if (!(*mci->set_sdram_scrub_rate) (mci, &bandwidth)) {
 			edac_printk(KERN_DEBUG, EDAC_MC,
-				    "Scrub rate set successfully, applied: %d\n",
-				    bandwidth);
+				"Scrub rate set successfully, applied: %d\n",
+				bandwidth);
 		} else {
 			/* FIXME: error codes maybe? */
 			edac_printk(KERN_DEBUG, EDAC_MC,
-				    "Scrub rate set FAILED, could not apply: %d\n",
-				    bandwidth);
+				"Scrub rate set FAILED, could not apply: %d\n",
+				bandwidth);
 		}
 	} else {
 		/* FIXME: produce "not implemented" ERROR for user-side. */
 		edac_printk(KERN_WARNING, EDAC_MC,
-			    "Memory scrubbing 'set'control is not implemented!\n");
+			"Memory scrubbing 'set'control is not implemented!\n");
 	}
 	return count;
 }
@@ -596,18 +596,18 @@ static ssize_t mci_sdram_scrub_rate_show
 	if (mci->get_sdram_scrub_rate) {
 		if (!(*mci->get_sdram_scrub_rate) (mci, &bandwidth)) {
 			edac_printk(KERN_DEBUG, EDAC_MC,
-				    "Scrub rate successfully, fetched: %d\n",
-				    bandwidth);
+				"Scrub rate successfully, fetched: %d\n",
+				bandwidth);
 		} else {
 			/* FIXME: error codes maybe? */
 			edac_printk(KERN_DEBUG, EDAC_MC,
-				    "Scrub rate fetch FAILED, got: %d\n",
-				    bandwidth);
+				"Scrub rate fetch FAILED, got: %d\n",
+				bandwidth);
 		}
 	} else {
 		/* FIXME: produce "not implemented" ERROR for user-side.  */
 		edac_printk(KERN_WARNING, EDAC_MC,
-			    "Memory scrubbing 'get' control is not implemented\n");
+			"Memory scrubbing 'get' control is not implemented\n");
 	}
 	return sprintf(data, "%d\n", bandwidth);
 }
@@ -648,7 +648,7 @@ static ssize_t mci_size_mb_show(struct m
 	int total_pages, csrow_idx;
 
 	for (total_pages = csrow_idx = 0; csrow_idx < mci->nr_csrows;
-	     csrow_idx++) {
+		csrow_idx++) {
 		struct csrow_info *csrow = &mci->csrows[csrow_idx];
 
 		if (!csrow->nr_pages)
@@ -665,7 +665,7 @@ static ssize_t mci_size_mb_show(struct m
 
 /* MCI show/store functions for top most object */
 static ssize_t mcidev_show(struct kobject *kobj, struct attribute *attr,
-			   char *buffer)
+			char *buffer)
 {
 	struct mem_ctl_info *mem_ctl_info = to_mci(kobj);
 	struct mcidev_sysfs_attribute *mcidev_attr = to_mcidev_attr(attr);
@@ -677,7 +677,7 @@ static ssize_t mcidev_show(struct kobjec
 }
 
 static ssize_t mcidev_store(struct kobject *kobj, struct attribute *attr,
-			    const char *buffer, size_t count)
+			const char *buffer, size_t count)
 {
 	struct mem_ctl_info *mem_ctl_info = to_mci(kobj);
 	struct mcidev_sysfs_attribute *mcidev_attr = to_mcidev_attr(attr);
@@ -714,7 +714,7 @@ MCIDEV_ATTR(ce_count, S_IRUGO, mci_ce_co
 
 /* memory scrubber attribute file */
 MCIDEV_ATTR(sdram_scrub_rate, S_IRUGO | S_IWUSR, mci_sdram_scrub_rate_show,
-	    mci_sdram_scrub_rate_store);
+	mci_sdram_scrub_rate_store);
 
 static struct mcidev_sysfs_attribute *mci_attr[] = {
 	&mci_attr_reset_counters,
@@ -841,7 +841,7 @@ int edac_create_sysfs_mci_device(struct 
 	return 0;
 
 	/* CSROW error: backout what has already been registered,  */
-      fail1:
+fail1:
 	for (i--; i >= 0; i--) {
 		if (csrow->nr_pages > 0) {
 			init_completion(&csrow->kobj_complete);
@@ -850,7 +850,7 @@ int edac_create_sysfs_mci_device(struct 
 		}
 	}
 
-      fail0:
+fail0:
 	init_completion(&mci->kobj_complete);
 	kobject_unregister(edac_mci_kobj);
 	wait_for_completion(&mci->kobj_complete);
diff -puN drivers/edac/edac_module.c~drivers-edac-cleanup-spaces-gotos-after-lindent-messup drivers/edac/edac_module.c
--- a/drivers/edac/edac_module.c~drivers-edac-cleanup-spaces-gotos-after-lindent-messup
+++ a/drivers/edac/edac_module.c
@@ -157,7 +157,7 @@ static int __init edac_init(void)
 	 */
 	if (edac_register_sysfs_edac_name()) {
 		edac_printk(KERN_ERR, EDAC_MC,
-			    "Error initializing 'edac' kobject\n");
+			"Error initializing 'edac' kobject\n");
 		err = -ENODEV;
 		goto error;
 	}
@@ -166,7 +166,7 @@ static int __init edac_init(void)
 	 */
 	if (edac_sysfs_memctrl_setup()) {
 		edac_printk(KERN_ERR, EDAC_MC,
-			    "Error initializing sysfs code\n");
+			"Error initializing sysfs code\n");
 		err = -ENODEV;
 		goto error_sysfs;
 	}
@@ -181,11 +181,11 @@ static int __init edac_init(void)
 	return 0;
 
 	/* Error teardown stack */
-      error_mem:
+error_mem:
 	edac_sysfs_memctrl_teardown();
-      error_sysfs:
+error_sysfs:
 	edac_unregister_sysfs_edac_name();
-      error:
+error:
 	return err;
 }
 
diff -puN drivers/edac/edac_pci.c~drivers-edac-cleanup-spaces-gotos-after-lindent-messup drivers/edac/edac_pci.c
--- a/drivers/edac/edac_pci.c~drivers-edac-cleanup-spaces-gotos-after-lindent-messup
+++ a/drivers/edac/edac_pci.c
@@ -47,7 +47,7 @@ static inline void edac_unlock_pci_list(
  * edac_pci it is going to control/register with the EDAC CORE.
  */
 struct edac_pci_ctl_info *edac_pci_alloc_ctl_info(unsigned int sz_pvt,
-						  const char *edac_pci_name)
+						const char *edac_pci_name)
 {
 	struct edac_pci_ctl_info *pci;
 	void *pvt;
@@ -140,18 +140,18 @@ static int add_edac_pci_to_global_list(s
 	list_add_tail_rcu(&pci->link, insert_before);
 	return 0;
 
-      fail0:
+fail0:
 	edac_printk(KERN_WARNING, EDAC_PCI,
-		    "%s (%s) %s %s already assigned %d\n",
-		    rover->dev->bus_id, dev_name(rover),
-		    rover->mod_name, rover->ctl_name, rover->pci_idx);
+		"%s (%s) %s %s already assigned %d\n",
+		rover->dev->bus_id, dev_name(rover),
+		rover->mod_name, rover->ctl_name, rover->pci_idx);
 	return 1;
 
-      fail1:
+fail1:
 	edac_printk(KERN_WARNING, EDAC_PCI,
-		    "but in low-level driver: attempt to assign\n"
-		    "\tduplicate pci_idx %d in %s()\n", rover->pci_idx,
-		    __func__);
+		"but in low-level driver: attempt to assign\n"
+		"\tduplicate pci_idx %d in %s()\n", rover->pci_idx,
+		__func__);
 	return 1;
 }
 
@@ -222,14 +222,14 @@ static void edac_pci_workq_function(stru
 	edac_lock_pci_list();
 
 	if ((pci->op_state == OP_RUNNING_POLL) &&
-	    (pci->edac_check != NULL) && (edac_pci_get_check_errors()))
+		(pci->edac_check != NULL) && (edac_pci_get_check_errors()))
 		pci->edac_check(pci);
 
 	edac_unlock_pci_list();
 
 	/* Reschedule */
 	queue_delayed_work(edac_workqueue, &pci->work,
-			   msecs_to_jiffies(edac_pci_get_poll_msec()));
+			msecs_to_jiffies(edac_pci_get_poll_msec()));
 }
 
 /*
@@ -244,7 +244,7 @@ static void edac_pci_workq_setup(struct 
 
 	INIT_DELAYED_WORK(&pci->work, edac_pci_workq_function);
 	queue_delayed_work(edac_workqueue, &pci->work,
-			   msecs_to_jiffies(edac_pci_get_poll_msec()));
+			msecs_to_jiffies(edac_pci_get_poll_msec()));
 }
 
 /*
@@ -326,9 +326,9 @@ int edac_pci_add_device(struct edac_pci_
 	edac_unlock_pci_list();
 	return 0;
 
-      fail1:
+fail1:
 	del_edac_pci_from_global_list(pci);
-      fail0:
+fail0:
 	edac_unlock_pci_list();
 	return 1;
 }
@@ -372,8 +372,8 @@ struct edac_pci_ctl_info *edac_pci_del_d
 	edac_unlock_pci_list();
 
 	edac_printk(KERN_INFO, EDAC_PCI,
-		    "Removed device %d for %s %s: DEV %s\n",
-		    pci->pci_idx, pci->mod_name, pci->ctl_name, dev_name(pci));
+		"Removed device %d for %s %s: DEV %s\n",
+		pci->pci_idx, pci->mod_name, pci->ctl_name, dev_name(pci));
 
 	return pci;
 }
@@ -393,7 +393,7 @@ struct edac_pci_gen_data {
 };
 
 struct edac_pci_ctl_info *edac_pci_create_generic_ctl(struct device *dev,
-						      const char *mod_name)
+						const char *mod_name)
 {
 	struct edac_pci_ctl_info *pci;
 	struct edac_pci_gen_data *pdata;
diff -puN drivers/edac/edac_pci_sysfs.c~drivers-edac-cleanup-spaces-gotos-after-lindent-messup drivers/edac/edac_pci_sysfs.c
--- a/drivers/edac/edac_pci_sysfs.c~drivers-edac-cleanup-spaces-gotos-after-lindent-messup
+++ a/drivers/edac/edac_pci_sysfs.c
@@ -61,7 +61,7 @@ static ssize_t instance_pe_count_show(st
 }
 
 static ssize_t instance_npe_count_show(struct edac_pci_ctl_info *pci,
-				       char *data)
+				char *data)
 {
 	return sprintf(data, "%u\n", atomic_read(&pci->counters.npe_count));
 }
@@ -89,7 +89,7 @@ struct instance_attribute {
 
 /* Function to 'show' fields from the edac_pci 'instance' structure */
 static ssize_t edac_pci_instance_show(struct kobject *kobj,
-				      struct attribute *attr, char *buffer)
+				struct attribute *attr, char *buffer)
 {
 	struct edac_pci_ctl_info *pci = to_instance(kobj);
 	struct instance_attribute *instance_attr = to_instance_attr(attr);
@@ -101,8 +101,8 @@ static ssize_t edac_pci_instance_show(st
 
 /* Function to 'store' fields into the edac_pci 'instance' structure */
 static ssize_t edac_pci_instance_store(struct kobject *kobj,
-				       struct attribute *attr,
-				       const char *buffer, size_t count)
+				struct attribute *attr,
+				const char *buffer, size_t count)
 {
 	struct edac_pci_ctl_info *pci = to_instance(kobj);
 	struct instance_attribute *instance_attr = to_instance_attr(attr);
@@ -212,8 +212,8 @@ static ssize_t edac_pci_dev_show(struct 
 }
 
 static ssize_t edac_pci_dev_store(struct kobject *kobj,
-				  struct attribute *attr, const char *buffer,
-				  size_t count)
+				struct attribute *attr, const char *buffer,
+				size_t count)
 {
 	struct edac_pci_dev_attribute *edac_pci_dev;
 	edac_pci_dev = (struct edac_pci_dev_attribute *)attr;
@@ -246,13 +246,13 @@ static struct edac_pci_dev_attribute eda
 
 /* PCI Parity control files */
 EDAC_PCI_ATTR(check_pci_errors, S_IRUGO | S_IWUSR, edac_pci_int_show,
-	      edac_pci_int_store);
+	edac_pci_int_store);
 EDAC_PCI_ATTR(edac_pci_log_pe, S_IRUGO | S_IWUSR, edac_pci_int_show,
-	      edac_pci_int_store);
+	edac_pci_int_store);
 EDAC_PCI_ATTR(edac_pci_log_npe, S_IRUGO | S_IWUSR, edac_pci_int_show,
-	      edac_pci_int_store);
+	edac_pci_int_store);
 EDAC_PCI_ATTR(edac_pci_panic_on_pe, S_IRUGO | S_IWUSR, edac_pci_int_show,
-	      edac_pci_int_store);
+	edac_pci_int_store);
 EDAC_PCI_ATTR(pci_parity_count, S_IRUGO, edac_pci_int_show, NULL);
 EDAC_PCI_ATTR(pci_nonparity_count, S_IRUGO, edac_pci_int_show, NULL);
 
@@ -405,7 +405,7 @@ static u16 get_pci_parity_status(struct 
 	}
 
 	status &= PCI_STATUS_DETECTED_PARITY | PCI_STATUS_SIG_SYSTEM_ERROR |
-	    PCI_STATUS_PARITY;
+		PCI_STATUS_PARITY;
 
 	if (status)
 		/* reset only the bits we are interested in */
@@ -449,23 +449,23 @@ static void edac_pci_dev_parity_test(str
 	if (status) {
 		if (status & (PCI_STATUS_SIG_SYSTEM_ERROR)) {
 			edac_printk(KERN_CRIT, EDAC_PCI,
-				    "Signaled System Error on %s\n",
-				    pci_name(dev));
+				"Signaled System Error on %s\n",
+				pci_name(dev));
 			atomic_inc(&pci_nonparity_count);
 		}
 
 		if (status & (PCI_STATUS_PARITY)) {
 			edac_printk(KERN_CRIT, EDAC_PCI,
-				    "Master Data Parity Error on %s\n",
-				    pci_name(dev));
+				"Master Data Parity Error on %s\n",
+				pci_name(dev));
 
 			atomic_inc(&pci_parity_count);
 		}
 
 		if (status & (PCI_STATUS_DETECTED_PARITY)) {
 			edac_printk(KERN_CRIT, EDAC_PCI,
-				    "Detected Parity Error on %s\n",
-				    pci_name(dev));
+				"Detected Parity Error on %s\n",
+				pci_name(dev));
 
 			atomic_inc(&pci_parity_count);
 		}
@@ -486,23 +486,23 @@ static void edac_pci_dev_parity_test(str
 		if (status) {
 			if (status & (PCI_STATUS_SIG_SYSTEM_ERROR)) {
 				edac_printk(KERN_CRIT, EDAC_PCI, "Bridge "
-					    "Signaled System Error on %s\n",
-					    pci_name(dev));
+					"Signaled System Error on %s\n",
+					pci_name(dev));
 				atomic_inc(&pci_nonparity_count);
 			}
 
 			if (status & (PCI_STATUS_PARITY)) {
 				edac_printk(KERN_CRIT, EDAC_PCI, "Bridge "
-					    "Master Data Parity Error on "
-					    "%s\n", pci_name(dev));
+					"Master Data Parity Error on "
+					"%s\n", pci_name(dev));
 
 				atomic_inc(&pci_parity_count);
 			}
 
 			if (status & (PCI_STATUS_DETECTED_PARITY)) {
 				edac_printk(KERN_CRIT, EDAC_PCI, "Bridge "
-					    "Detected Parity Error on %s\n",
-					    pci_name(dev));
+					"Detected Parity Error on %s\n",
+					pci_name(dev));
 
 				atomic_inc(&pci_parity_count);
 			}
diff -puN drivers/edac/i3000_edac.c~drivers-edac-cleanup-spaces-gotos-after-lindent-messup drivers/edac/i3000_edac.c
--- a/drivers/edac/i3000_edac.c~drivers-edac-cleanup-spaces-gotos-after-lindent-messup
+++ a/drivers/edac/i3000_edac.c
@@ -148,7 +148,7 @@ struct i3000_error_info {
 
 static const struct i3000_dev_info i3000_devs[] = {
 	[I3000] = {
-		   .ctl_name = "i3000"},
+		.ctl_name = "i3000"},
 };
 
 static struct pci_dev *mci_pdev = NULL;
@@ -195,8 +195,8 @@ static void i3000_get_error_info(struct 
 }
 
 static int i3000_process_error_info(struct mem_ctl_info *mci,
-				    struct i3000_error_info *info,
-				    int handle_errors)
+				struct i3000_error_info *info,
+				int handle_errors)
 {
 	int row, multi_chan;
 	int pfn, offset, channel;
@@ -224,7 +224,7 @@ static int i3000_process_error_info(stru
 		edac_mc_handle_ue(mci, pfn, offset, row, "i3000 UE");
 	else
 		edac_mc_handle_ce(mci, pfn, offset, info->derrsyn, row,
-				  multi_chan ? channel : 0, "i3000 CE");
+				multi_chan ? channel : 0, "i3000 CE");
 
 	return 1;
 }
@@ -250,7 +250,8 @@ static int i3000_is_interleaved(const un
 	 */
 	for (i = 0; i < I3000_RANKS_PER_CHANNEL / 2; i++)
 		if (ODD_RANK_ATTRIB(c0dra[i]) != ODD_RANK_ATTRIB(c1dra[i]) ||
-		    EVEN_RANK_ATTRIB(c0dra[i]) != EVEN_RANK_ATTRIB(c1dra[i]))
+			EVEN_RANK_ATTRIB(c0dra[i]) !=
+						EVEN_RANK_ATTRIB(c1dra[i]))
 			return 0;
 
 	/* If the rank boundaries for the two channels are different
@@ -283,7 +284,7 @@ static int i3000_probe1(struct pci_dev *
 	window = ioremap_nocache(mchbar, I3000_MMR_WINDOW_SIZE);
 	if (!window) {
 		printk(KERN_ERR "i3000: cannot map mmio space at 0x%lx\n",
-		       mchbar);
+			mchbar);
 		return -ENODEV;
 	}
 
@@ -398,7 +399,7 @@ static int i3000_probe1(struct pci_dev *
 
 /* returns count (>= 0), or negative on error */
 static int __devinit i3000_init_one(struct pci_dev *pdev,
-				    const struct pci_device_id *ent)
+				const struct pci_device_id *ent)
 {
 	int rc;
 
@@ -459,7 +460,7 @@ static int __init i3000_init(void)
 	if (mci_pdev == NULL) {
 		i3000_registered = 0;
 		mci_pdev = pci_get_device(PCI_VENDOR_ID_INTEL,
-					  PCI_DEVICE_ID_INTEL_3000_HB, NULL);
+					PCI_DEVICE_ID_INTEL_3000_HB, NULL);
 		if (!mci_pdev) {
 			debugf0("i3000 pci_get_device fail\n");
 			pci_rc = -ENODEV;
@@ -476,10 +477,10 @@ static int __init i3000_init(void)
 
 	return 0;
 
-      fail1:
+fail1:
 	pci_unregister_driver(&i3000_driver);
 
-      fail0:
+fail0:
 	if (mci_pdev)
 		pci_dev_put(mci_pdev);
 
diff -puN drivers/edac/i5000_edac.c~drivers-edac-cleanup-spaces-gotos-after-lindent-messup drivers/edac/i5000_edac.c
--- a/drivers/edac/i5000_edac.c~drivers-edac-cleanup-spaces-gotos-after-lindent-messup
+++ a/drivers/edac/i5000_edac.c
@@ -77,7 +77,7 @@
 #define			FERR_FAT_M3ERR	0x00000004
 #define			FERR_FAT_M2ERR	0x00000002
 #define			FERR_FAT_M1ERR	0x00000001
-#define			FERR_FAT_MASK	  (FERR_FAT_M1ERR | \
+#define			FERR_FAT_MASK	(FERR_FAT_M1ERR | \
 						FERR_FAT_M2ERR | \
 						FERR_FAT_M3ERR)
 
@@ -119,7 +119,7 @@
 #define			FERR_NF_UNCORRECTABLE	(FERR_NF_M12ERR | \
 							FERR_NF_M11ERR | \
 							FERR_NF_M10ERR | \
-		       					FERR_NF_M8ERR | \
+							FERR_NF_M8ERR | \
 							FERR_NF_M7ERR | \
 							FERR_NF_M6ERR | \
 							FERR_NF_M5ERR | \
@@ -131,7 +131,7 @@
 #define			FERR_NF_DIMM_SPARE	(FERR_NF_M27ERR | \
 							FERR_NF_M28ERR)
 #define			FERR_NF_THERMAL		(FERR_NF_M26ERR | \
-	       						FERR_NF_M25ERR | \
+							FERR_NF_M25ERR | \
 							FERR_NF_M24ERR | \
 							FERR_NF_M23ERR)
 #define			FERR_NF_SPD_PROTOCOL	(FERR_NF_M22ERR)
@@ -317,9 +317,9 @@ struct i5000_dev_info {
 /* Table of devices attributes supported by this driver */
 static const struct i5000_dev_info i5000_devs[] = {
 	[I5000P] = {
-		    .ctl_name = "I5000",
-		    .fsb_mapping_errors = PCI_DEVICE_ID_INTEL_I5000_DEV16,
-		    },
+		.ctl_name = "I5000",
+		.fsb_mapping_errors = PCI_DEVICE_ID_INTEL_I5000_DEV16,
+	},
 };
 
 struct i5000_dimm_info {
@@ -411,15 +411,15 @@ static void i5000_get_error_info(struct 
 
 		/* harvest the various error data we need */
 		pci_read_config_dword(pvt->branchmap_werrors,
-				      NERR_FAT_FBD, &info->nerr_fat_fbd);
+				NERR_FAT_FBD, &info->nerr_fat_fbd);
 		pci_read_config_word(pvt->branchmap_werrors,
-				     NRECMEMA, &info->nrecmema);
+				NRECMEMA, &info->nrecmema);
 		pci_read_config_word(pvt->branchmap_werrors,
-				     NRECMEMB, &info->nrecmemb);
+				NRECMEMB, &info->nrecmemb);
 
 		/* Clear the error bits, by writing them back */
 		pci_write_config_dword(pvt->branchmap_werrors,
-				       FERR_FAT_FBD, value);
+				FERR_FAT_FBD, value);
 	} else {
 		info->ferr_fat_fbd = 0;
 		info->nerr_fat_fbd = 0;
@@ -437,17 +437,17 @@ static void i5000_get_error_info(struct 
 
 		/* harvest the various error data we need */
 		pci_read_config_dword(pvt->branchmap_werrors,
-				      NERR_NF_FBD, &info->nerr_nf_fbd);
+				NERR_NF_FBD, &info->nerr_nf_fbd);
 		pci_read_config_word(pvt->branchmap_werrors,
-				     RECMEMA, &info->recmema);
+				RECMEMA, &info->recmema);
 		pci_read_config_dword(pvt->branchmap_werrors,
-				      RECMEMB, &info->recmemb);
+				RECMEMB, &info->recmemb);
 		pci_read_config_dword(pvt->branchmap_werrors,
-				      REDMEMB, &info->redmemb);
+				REDMEMB, &info->redmemb);
 
 		/* Clear the error bits, by writing them back */
 		pci_write_config_dword(pvt->branchmap_werrors,
-				       FERR_NF_FBD, value);
+				FERR_NF_FBD, value);
 	} else {
 		info->ferr_nf_fbd = 0;
 		info->nerr_nf_fbd = 0;
@@ -465,8 +465,8 @@ static void i5000_get_error_info(struct 
  *	handle the Intel FATAL errors, if any
  */
 static void i5000_process_fatal_error_info(struct mem_ctl_info *mci,
-					   struct i5000_error_info * info,
-					   int handle_errors)
+					struct i5000_error_info * info,
+					int handle_errors)
 {
 	char msg[EDAC_MC_LABEL_LEN + 1 + 90];
 	u32 allErrors;
@@ -532,14 +532,14 @@ static void i5000_process_fatal_error_in
 
 /******************************************************************************
  * i5000_process_fatal_error_info(struct mem_ctl_info *mci,
- * 				  struct i5000_error_info *info,
- * 				  int handle_errors);
+ * 				struct i5000_error_info *info,
+ * 				int handle_errors);
  *
  *	handle the Intel NON-FATAL errors, if any
  */
 static void i5000_process_nonfatal_error_info(struct mem_ctl_info *mci,
-					      struct i5000_error_info * info,
-					      int handle_errors)
+					struct i5000_error_info * info,
+					int handle_errors)
 {
 	char msg[EDAC_MC_LABEL_LEN + 1 + 90];
 	u32 allErrors;
@@ -576,10 +576,10 @@ static void i5000_process_nonfatal_error
 		cas = NREC_CAS(info->nrecmemb);
 
 		debugf0
-		    ("\t\tCSROW= %d  Channels= %d,%d  (Branch= %d "
-		     "DRAM Bank= %d rdwr= %s ras= %d cas= %d)\n",
-		     rank, channel, channel + 1, branch >> 1, bank,
-		     rdwr ? "Write" : "Read", ras, cas);
+			("\t\tCSROW= %d  Channels= %d,%d  (Branch= %d "
+			"DRAM Bank= %d rdwr= %s ras= %d cas= %d)\n",
+			rank, channel, channel + 1, branch >> 1, bank,
+			rdwr ? "Write" : "Read", ras, cas);
 
 		/* Form out message */
 		snprintf(msg, sizeof(msg),
@@ -632,37 +632,37 @@ static void i5000_process_nonfatal_error
 	misc_errors = allErrors & FERR_NF_THERMAL;
 	if (misc_errors) {
 		i5000_printk(KERN_WARNING, "\tTHERMAL Error, bits= 0x%x\n",
-			     misc_errors);
+			misc_errors);
 	}
 
 	/* See if any of the thermal errors have fired */
 	misc_errors = allErrors & FERR_NF_NON_RETRY;
 	if (misc_errors) {
 		i5000_printk(KERN_WARNING, "\tNON-Retry  Errors, bits= 0x%x\n",
-			     misc_errors);
+			misc_errors);
 	}
 
 	/* See if any of the thermal errors have fired */
 	misc_errors = allErrors & FERR_NF_NORTH_CRC;
 	if (misc_errors) {
 		i5000_printk(KERN_WARNING,
-			     "\tNORTHBOUND CRC  Error, bits= 0x%x\n",
-			     misc_errors);
+			"\tNORTHBOUND CRC  Error, bits= 0x%x\n",
+			misc_errors);
 	}
 
 	/* See if any of the thermal errors have fired */
 	misc_errors = allErrors & FERR_NF_SPD_PROTOCOL;
 	if (misc_errors) {
 		i5000_printk(KERN_WARNING,
-			     "\tSPD Protocol  Error, bits= 0x%x\n",
-			     misc_errors);
+			"\tSPD Protocol  Error, bits= 0x%x\n",
+			misc_errors);
 	}
 
 	/* See if any of the thermal errors have fired */
 	misc_errors = allErrors & FERR_NF_DIMM_SPARE;
 	if (misc_errors) {
 		i5000_printk(KERN_WARNING, "\tDIMM-Spare  Error, bits= 0x%x\n",
-			     misc_errors);
+			misc_errors);
 	}
 }
 
@@ -671,8 +671,8 @@ static void i5000_process_nonfatal_error
  *	in the 'info' structure, previously retrieved from hardware
  */
 static void i5000_process_error_info(struct mem_ctl_info *mci,
-				     struct i5000_error_info * info,
-				     int handle_errors)
+				struct i5000_error_info * info,
+				int handle_errors)
 {
 	/* First handle any fatal errors that occurred */
 	i5000_process_fatal_error_info(mci, info, handle_errors);
@@ -724,17 +724,17 @@ static int i5000_get_devices(struct mem_
 	pdev = NULL;
 	while (1) {
 		pdev = pci_get_device(PCI_VENDOR_ID_INTEL,
-				      PCI_DEVICE_ID_INTEL_I5000_DEV16, pdev);
+				PCI_DEVICE_ID_INTEL_I5000_DEV16, pdev);
 
 		/* End of list, leave */
 		if (pdev == NULL) {
 			i5000_printk(KERN_ERR,
-				     "'system address,Process Bus' "
-				     "device not found:"
-				     "vendor 0x%x device 0x%x FUNC 1 "
-				     "(broken BIOS?)\n",
-				     PCI_VENDOR_ID_INTEL,
-				     PCI_DEVICE_ID_INTEL_I5000_DEV16);
+				"'system address,Process Bus' "
+				"device not found:"
+				"vendor 0x%x device 0x%x FUNC 1 "
+				"(broken BIOS?)\n",
+				PCI_VENDOR_ID_INTEL,
+				PCI_DEVICE_ID_INTEL_I5000_DEV16);
 
 			return 1;
 		}
@@ -750,16 +750,16 @@ static int i5000_get_devices(struct mem_
 	pdev = NULL;
 	while (1) {
 		pdev = pci_get_device(PCI_VENDOR_ID_INTEL,
-				      PCI_DEVICE_ID_INTEL_I5000_DEV16, pdev);
+				PCI_DEVICE_ID_INTEL_I5000_DEV16, pdev);
 
 		if (pdev == NULL) {
 			i5000_printk(KERN_ERR,
-				     "MC: 'branchmap,control,errors' "
-				     "device not found:"
-				     "vendor 0x%x device 0x%x Func 2 "
-				     "(broken BIOS?)\n",
-				     PCI_VENDOR_ID_INTEL,
-				     PCI_DEVICE_ID_INTEL_I5000_DEV16);
+				"MC: 'branchmap,control,errors' "
+				"device not found:"
+				"vendor 0x%x device 0x%x Func 2 "
+				"(broken BIOS?)\n",
+				PCI_VENDOR_ID_INTEL,
+				PCI_DEVICE_ID_INTEL_I5000_DEV16);
 
 			pci_dev_put(pvt->branchmap_werrors);
 			return 1;
@@ -784,13 +784,13 @@ static int i5000_get_devices(struct mem_
 
 	pdev = NULL;
 	pdev = pci_get_device(PCI_VENDOR_ID_INTEL,
-			      PCI_DEVICE_ID_I5000_BRANCH_0, pdev);
+			PCI_DEVICE_ID_I5000_BRANCH_0, pdev);
 
 	if (pdev == NULL) {
 		i5000_printk(KERN_ERR,
-			     "MC: 'BRANCH 0' device not found:"
-			     "vendor 0x%x device 0x%x Func 0 (broken BIOS?)\n",
-			     PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_I5000_BRANCH_0);
+			"MC: 'BRANCH 0' device not found:"
+			"vendor 0x%x device 0x%x Func 0 (broken BIOS?)\n",
+			PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_I5000_BRANCH_0);
 
 		pci_dev_put(pvt->branchmap_werrors);
 		pci_dev_put(pvt->fsb_error_regs);
@@ -805,15 +805,15 @@ static int i5000_get_devices(struct mem_
 	if (pvt->maxch >= CHANNELS_PER_BRANCH) {
 		pdev = NULL;
 		pdev = pci_get_device(PCI_VENDOR_ID_INTEL,
-				      PCI_DEVICE_ID_I5000_BRANCH_1, pdev);
+				PCI_DEVICE_ID_I5000_BRANCH_1, pdev);
 
 		if (pdev == NULL) {
 			i5000_printk(KERN_ERR,
-				     "MC: 'BRANCH 1' device not found:"
-				     "vendor 0x%x device 0x%x Func 0 "
-				     "(broken BIOS?)\n",
-				     PCI_VENDOR_ID_INTEL,
-				     PCI_DEVICE_ID_I5000_BRANCH_1);
+				"MC: 'BRANCH 1' device not found:"
+				"vendor 0x%x device 0x%x Func 0 "
+				"(broken BIOS?)\n",
+				PCI_VENDOR_ID_INTEL,
+				PCI_DEVICE_ID_I5000_BRANCH_1);
 
 			pci_dev_put(pvt->branchmap_werrors);
 			pci_dev_put(pvt->fsb_error_regs);
@@ -917,7 +917,7 @@ static void decode_mtr(int slot_row, u16
 }
 
 static void handle_channel(struct i5000_pvt *pvt, int csrow, int channel,
-			   struct i5000_dimm_info *dinfo)
+			struct i5000_dimm_info *dinfo)
 {
 	int mtr;
 	int amb_present_reg;
@@ -932,7 +932,7 @@ static void handle_channel(struct i5000_
 			dinfo->dual_rank = MTR_DIMM_RANK(mtr);
 
 			if (!((dinfo->dual_rank == 0) &&
-			      ((csrow & 0x1) == 0x1))) {
+				((csrow & 0x1) == 0x1))) {
 				/* Start with the number of bits for a Bank
 				 * on the DRAM */
 				addrBits = MTR_DRAM_BANKS_ADDR_BITS(mtr);
@@ -970,7 +970,7 @@ static void calculate_dimm_size(struct i
 	mem_buffer = p = kmalloc(space, GFP_KERNEL);
 	if (p == NULL) {
 		i5000_printk(KERN_ERR, "MC: %s:%s() kmalloc() failed\n",
-			     __FILE__, __func__);
+			__FILE__, __func__);
 		return;
 	}
 
@@ -990,7 +990,7 @@ static void calculate_dimm_size(struct i
 		 * then reset the message buffer  */
 		if (csrow & 0x1) {
 			n = snprintf(p, space, "---------------------------"
-				     "--------------------------------");
+				"--------------------------------");
 			p += n;
 			space -= n;
 			debugf2("%s\n", mem_buffer);
@@ -1015,7 +1015,7 @@ static void calculate_dimm_size(struct i
 
 	/* Output the last bottom 'boundary' marker */
 	n = snprintf(p, space, "---------------------------"
-		     "--------------------------------\n");
+		"--------------------------------\n");
 	p += n;
 	space -= n;
 
@@ -1056,9 +1056,9 @@ static void i5000_get_mc_regs(struct mem
 	pvt = (struct i5000_pvt *)mci->pvt_info;
 
 	pci_read_config_dword(pvt->system_address, AMBASE,
-			      (u32 *) & pvt->ambase);
+			(u32 *) & pvt->ambase);
 	pci_read_config_dword(pvt->system_address, AMBASE + sizeof(u32),
-			      ((u32 *) & pvt->ambase) + sizeof(u32));
+			((u32 *) & pvt->ambase) + sizeof(u32));
 
 	maxdimmperch = pvt->maxdimmperch;
 	maxch = pvt->maxch;
@@ -1098,14 +1098,14 @@ static void i5000_get_mc_regs(struct mem
 		int where = MTR0 + (slot_row * sizeof(u32));
 
 		pci_read_config_word(pvt->branch_0, where,
-				     &pvt->b0_mtr[slot_row]);
+				&pvt->b0_mtr[slot_row]);
 
 		debugf2("MTR%d where=0x%x B0 value=0x%x\n", slot_row, where,
 			pvt->b0_mtr[slot_row]);
 
 		if (pvt->maxch >= CHANNELS_PER_BRANCH) {
 			pci_read_config_word(pvt->branch_1, where,
-					     &pvt->b1_mtr[slot_row]);
+					&pvt->b1_mtr[slot_row]);
 			debugf2("MTR%d where=0x%x B1 value=0x%x\n", slot_row,
 				where, pvt->b0_mtr[slot_row]);
 		} else {
@@ -1120,10 +1120,10 @@ static void i5000_get_mc_regs(struct mem
 		decode_mtr(slot_row, pvt->b0_mtr[slot_row]);
 	}
 	pci_read_config_word(pvt->branch_0, AMB_PRESENT_0,
-			     &pvt->b0_ambpresent0);
+			&pvt->b0_ambpresent0);
 	debugf2("\t\tAMB-Branch 0-present0 0x%x:\n", pvt->b0_ambpresent0);
 	pci_read_config_word(pvt->branch_0, AMB_PRESENT_1,
-			     &pvt->b0_ambpresent1);
+			&pvt->b0_ambpresent1);
 	debugf2("\t\tAMB-Branch 0-present1 0x%x:\n", pvt->b0_ambpresent1);
 
 	/* Only if we have 2 branchs (4 channels) */
@@ -1137,11 +1137,11 @@ static void i5000_get_mc_regs(struct mem
 			decode_mtr(slot_row, pvt->b1_mtr[slot_row]);
 		}
 		pci_read_config_word(pvt->branch_1, AMB_PRESENT_0,
-				     &pvt->b1_ambpresent0);
+				&pvt->b1_ambpresent0);
 		debugf2("\t\tAMB-Branch 1-present0 0x%x:\n",
 			pvt->b1_ambpresent0);
 		pci_read_config_word(pvt->branch_1, AMB_PRESENT_1,
-				     &pvt->b1_ambpresent1);
+				&pvt->b1_ambpresent1);
 		debugf2("\t\tAMB-Branch 1-present1 0x%x:\n",
 			pvt->b1_ambpresent1);
 	}
@@ -1234,13 +1234,13 @@ static void i5000_enable_error_reporting
 
 	/* Read the FBD Error Mask Register */
 	pci_read_config_dword(pvt->branchmap_werrors, EMASK_FBD,
-			      &fbd_error_mask);
+			&fbd_error_mask);
 
 	/* Enable with a '0' */
 	fbd_error_mask &= ~(ENABLE_EMASK_ALL);
 
 	pci_write_config_dword(pvt->branchmap_werrors, EMASK_FBD,
-			       fbd_error_mask);
+			fbd_error_mask);
 }
 
 /******************************************************************************
@@ -1250,8 +1250,8 @@ static void i5000_enable_error_reporting
  *	 as well
  */
 static void i5000_get_dimm_and_channel_counts(struct pci_dev *pdev,
-					      int *num_dimms_per_channel,
-					      int *num_channels)
+					int *num_dimms_per_channel,
+					int *num_channels)
 {
 	u8 value;
 
@@ -1313,7 +1313,7 @@ static int i5000_probe1(struct pci_dev *
 	 * some fancy mobo determination.
 	 */
 	i5000_get_dimm_and_channel_counts(pdev, &num_dimms_per_channel,
-					  &num_channels);
+					&num_channels);
 	num_csrows = num_dimms_per_channel * 2;
 
 	debugf0("MC: %s(): Number of - Channels= %d  DIMMS= %d  CSROWS= %d\n",
@@ -1392,11 +1392,11 @@ static int i5000_probe1(struct pci_dev *
 	return 0;
 
 	/* Error exit unwinding stack */
-      fail1:
+fail1:
 
 	i5000_put_devices(mci);
 
-      fail0:
+fail0:
 	edac_mc_free(mci);
 	return -ENODEV;
 }
@@ -1409,7 +1409,7 @@ static int i5000_probe1(struct pci_dev *
  *		count (>= 0)
  */
 static int __devinit i5000_init_one(struct pci_dev *pdev,
-				    const struct pci_device_id *id)
+				const struct pci_device_id *id)
 {
 	int rc;
 
@@ -1503,6 +1503,6 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR
     ("Linux Networx (http://lnxi.com) Doug Thompson <norsk5@xmission.com>");
 MODULE_DESCRIPTION("MC Driver for Intel I5000 memory controllers - "
-		   I5000_REVISION);
+		I5000_REVISION);
 module_param(edac_op_state, int, 0444);
 MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state: 0=Poll,1=NMI");
diff -puN drivers/edac/i82443bxgx_edac.c~drivers-edac-cleanup-spaces-gotos-after-lindent-messup drivers/edac/i82443bxgx_edac.c
--- a/drivers/edac/i82443bxgx_edac.c~drivers-edac-cleanup-spaces-gotos-after-lindent-messup
+++ a/drivers/edac/i82443bxgx_edac.c
@@ -114,8 +114,8 @@ struct i82443bxgx_edacmc_error_info {
 static struct edac_pci_ctl_info *i82443bxgx_pci;
 
 static void i82443bxgx_edacmc_get_error_info(struct mem_ctl_info *mci,
-					     struct i82443bxgx_edacmc_error_info
-					     *info)
+				struct i82443bxgx_edacmc_error_info
+				*info)
 {
 	struct pci_dev *pdev;
 	pdev = to_pci_dev(mci->dev);
@@ -151,17 +151,18 @@ static int i82443bxgx_edacmc_process_err
 		error_found = 1;
 		if (handle_errors)
 			edac_mc_handle_ce(mci, page, pageoffset,
-					  /* 440BX/GX don't make syndrome information available */
-					  0, edac_mc_find_csrow_by_page(mci, page), 0,	/* channel */
-					  mci->ctl_name);
+				/* 440BX/GX don't make syndrome information
+				 * available */
+				0, edac_mc_find_csrow_by_page(mci, page), 0,
+				mci->ctl_name);
 	}
 
 	if (info->eap & I82443BXGX_EAP_OFFSET_MBE) {
 		error_found = 1;
 		if (handle_errors)
 			edac_mc_handle_ue(mci, page, pageoffset,
-					  edac_mc_find_csrow_by_page(mci, page),
-					  mci->ctl_name);
+					edac_mc_find_csrow_by_page(mci, page),
+					mci->ctl_name);
 	}
 
 	return error_found;
@@ -177,9 +178,9 @@ static void i82443bxgx_edacmc_check(stru
 }
 
 static void i82443bxgx_init_csrows(struct mem_ctl_info *mci,
-				   struct pci_dev *pdev,
-				   enum edac_type edac_mode,
-				   enum mem_type mtype)
+				struct pci_dev *pdev,
+				enum edac_type edac_mode,
+				enum mem_type mtype)
 {
 	struct csrow_info *csrow;
 	int index;
@@ -233,7 +234,8 @@ static int i82443bxgx_edacmc_probe1(stru
 	debugf0("MC: " __FILE__ ": %s()\n", __func__);
 
 	/* Something is really hosed if PCI config space reads from
-	   the MC aren't working.  */
+	 * the MC aren't working.
+	 */
 	if (pci_read_config_dword(pdev, I82443BXGX_NBXCFG, &nbxcfg))
 		return -EIO;
 
@@ -258,8 +260,8 @@ static int i82443bxgx_edacmc_probe1(stru
 		mtype = MEM_RDR;
 		break;
 	default:
-		debugf0
-		    ("Unknown/reserved DRAM type value in DRAMC register!\n");
+		debugf0("Unknown/reserved DRAM type value "
+			"in DRAMC register!\n");
 		mtype = -MEM_UNKNOWN;
 	}
 
@@ -271,10 +273,10 @@ static int i82443bxgx_edacmc_probe1(stru
 	mci->scrub_cap = SCRUB_FLAG_HW_SRC;
 	pci_read_config_dword(pdev, I82443BXGX_NBXCFG, &nbxcfg);
 	ecc_mode = ((nbxcfg >> I82443BXGX_NBXCFG_OFFSET_DRAM_INTEGRITY) &
-		    (BIT(0) | BIT(1)));
+		(BIT(0) | BIT(1)));
 
 	mci->scrub_mode = (ecc_mode == I82443BXGX_NBXCFG_INTEGRITY_SCRUB)
-	    ? SCRUB_HW_SRC : SCRUB_NONE;
+		? SCRUB_HW_SRC : SCRUB_NONE;
 
 	switch (ecc_mode) {
 	case I82443BXGX_NBXCFG_INTEGRITY_NONE:
@@ -288,9 +290,8 @@ static int i82443bxgx_edacmc_probe1(stru
 		edac_mode = EDAC_SECDED;
 		break;
 	default:
-		debugf0
-		    ("%s(): Unknown/reserved ECC state in NBXCFG register!\n",
-		     __func__);
+		debugf0("%s(): Unknown/reserved ECC state "
+			"in NBXCFG register!\n", __func__);
 		edac_mode = EDAC_UNKNOWN;
 		break;
 	}
@@ -301,10 +302,10 @@ static int i82443bxgx_edacmc_probe1(stru
 	 * here, or we get "phantom" errors occuring at module-load
 	 * time. */
 	pci_write_bits32(pdev, I82443BXGX_EAP,
-			 (I82443BXGX_EAP_OFFSET_SBE |
-			  I82443BXGX_EAP_OFFSET_MBE),
-			 (I82443BXGX_EAP_OFFSET_SBE |
-			  I82443BXGX_EAP_OFFSET_MBE));
+			(I82443BXGX_EAP_OFFSET_SBE |
+				I82443BXGX_EAP_OFFSET_MBE),
+			(I82443BXGX_EAP_OFFSET_SBE |
+				I82443BXGX_EAP_OFFSET_MBE));
 
 	mci->mod_name = EDAC_MOD_STR;
 	mci->mod_ver = I82443_REVISION;
@@ -332,7 +333,7 @@ static int i82443bxgx_edacmc_probe1(stru
 	debugf3("MC: " __FILE__ ": %s(): success\n", __func__);
 	return 0;
 
-      fail:
+fail:
 	edac_mc_free(mci);
 	return -ENODEV;
 }
diff -puN drivers/edac/i82860_edac.c~drivers-edac-cleanup-spaces-gotos-after-lindent-messup drivers/edac/i82860_edac.c
--- a/drivers/edac/i82860_edac.c~drivers-edac-cleanup-spaces-gotos-after-lindent-messup
+++ a/drivers/edac/i82860_edac.c
@@ -54,7 +54,7 @@ struct i82860_error_info {
 
 static const struct i82860_dev_info i82860_devs[] = {
 	[I82860] = {
-		    .ctl_name = "i82860"},
+		.ctl_name = "i82860"},
 };
 
 static struct pci_dev *mci_pdev = NULL;	/* init dev: in case that AGP code
@@ -63,7 +63,7 @@ static struct pci_dev *mci_pdev = NULL;	
 static struct edac_pci_ctl_info *i82860_pci;
 
 static void i82860_get_error_info(struct mem_ctl_info *mci,
-				  struct i82860_error_info *info)
+				struct i82860_error_info *info)
 {
 	struct pci_dev *pdev;
 
@@ -96,8 +96,8 @@ static void i82860_get_error_info(struct
 }
 
 static int i82860_process_error_info(struct mem_ctl_info *mci,
-				     struct i82860_error_info *info,
-				     int handle_errors)
+				struct i82860_error_info *info,
+				int handle_errors)
 {
 	int row;
 
@@ -119,7 +119,7 @@ static int i82860_process_error_info(str
 		edac_mc_handle_ue(mci, info->eap, 0, row, "i82860 UE");
 	else
 		edac_mc_handle_ce(mci, info->eap, 0, info->derrsyn, row, 0,
-				  "i82860 UE");
+				"i82860 UE");
 
 	return 1;
 }
@@ -155,7 +155,7 @@ static void i82860_init_csrows(struct me
 		csrow = &mci->csrows[index];
 		pci_read_config_word(pdev, I82860_GBA + index * 2, &value);
 		cumul_size = (value & I82860_GBA_MASK) <<
-		    (I82860_GBA_SHIFT - PAGE_SHIFT);
+			(I82860_GBA_SHIFT - PAGE_SHIFT);
 		debugf3("%s(): (%d) cumul_size 0x%x\n", __func__, index,
 			cumul_size);
 
@@ -230,14 +230,14 @@ static int i82860_probe1(struct pci_dev 
 
 	return 0;
 
-      fail:
+fail:
 	edac_mc_free(mci);
 	return -ENODEV;
 }
 
 /* returns count (>= 0), or negative on error */
 static int __devinit i82860_init_one(struct pci_dev *pdev,
-				     const struct pci_device_id *ent)
+				const struct pci_device_id *ent)
 {
 	int rc;
 
@@ -299,7 +299,7 @@ static int __init i82860_init(void)
 
 	if (!mci_pdev) {
 		mci_pdev = pci_get_device(PCI_VENDOR_ID_INTEL,
-					  PCI_DEVICE_ID_INTEL_82860_0, NULL);
+					PCI_DEVICE_ID_INTEL_82860_0, NULL);
 
 		if (mci_pdev == NULL) {
 			debugf0("860 pci_get_device fail\n");
@@ -318,10 +318,10 @@ static int __init i82860_init(void)
 
 	return 0;
 
-      fail1:
+fail1:
 	pci_unregister_driver(&i82860_driver);
 
-      fail0:
+fail0:
 	if (mci_pdev != NULL)
 		pci_dev_put(mci_pdev);
 
@@ -343,5 +343,5 @@ module_exit(i82860_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com) "
-	      "Ben Woodard <woodard@redhat.com>");
+		"Ben Woodard <woodard@redhat.com>");
 MODULE_DESCRIPTION("ECC support for Intel 82860 memory hub controllers");
diff -puN drivers/edac/i82875p_edac.c~drivers-edac-cleanup-spaces-gotos-after-lindent-messup drivers/edac/i82875p_edac.c
--- a/drivers/edac/i82875p_edac.c~drivers-edac-cleanup-spaces-gotos-after-lindent-messup
+++ a/drivers/edac/i82875p_edac.c
@@ -174,7 +174,7 @@ struct i82875p_error_info {
 
 static const struct i82875p_dev_info i82875p_devs[] = {
 	[I82875P] = {
-		     .ctl_name = "i82875p"},
+		.ctl_name = "i82875p"},
 };
 
 static struct pci_dev *mci_pdev = NULL;	/* init dev: in case that AGP code has
@@ -186,7 +186,7 @@ static int i82875p_registered = 1;
 static struct edac_pci_ctl_info *i82875p_pci;
 
 static void i82875p_get_error_info(struct mem_ctl_info *mci,
-				   struct i82875p_error_info *info)
+				struct i82875p_error_info *info)
 {
 	struct pci_dev *pdev;
 
@@ -222,8 +222,8 @@ static void i82875p_get_error_info(struc
 }
 
 static int i82875p_process_error_info(struct mem_ctl_info *mci,
-				      struct i82875p_error_info *info,
-				      int handle_errors)
+				struct i82875p_error_info *info,
+				int handle_errors)
 {
 	int row, multi_chan;
 
@@ -247,8 +247,8 @@ static int i82875p_process_error_info(st
 		edac_mc_handle_ue(mci, info->eap, 0, row, "i82875p UE");
 	else
 		edac_mc_handle_ce(mci, info->eap, 0, info->derrsyn, row,
-				  multi_chan ? (info->des & 0x1) : 0,
-				  "i82875p CE");
+				multi_chan ? (info->des & 0x1) : 0,
+				"i82875p CE");
 
 	return 1;
 }
@@ -264,8 +264,8 @@ static void i82875p_check(struct mem_ctl
 
 /* Return 0 on success or 1 on failure. */
 static int i82875p_setup_overfl_dev(struct pci_dev *pdev,
-				    struct pci_dev **ovrfl_pdev,
-				    void __iomem ** ovrfl_window)
+				struct pci_dev **ovrfl_pdev,
+				void __iomem **ovrfl_window)
 {
 	struct pci_dev *dev;
 	void __iomem *window;
@@ -293,7 +293,7 @@ static int i82875p_setup_overfl_dev(stru
 
 	if (pci_enable_device(dev)) {
 		i82875p_printk(KERN_ERR, "%s(): Failed to enable overflow "
-			       "device\n", __func__);
+			"device\n", __func__);
 		return 1;
 	}
 
@@ -309,18 +309,18 @@ static int i82875p_setup_overfl_dev(stru
 
 	if (window == NULL) {
 		i82875p_printk(KERN_ERR, "%s(): Failed to ioremap bar6\n",
-			       __func__);
+			__func__);
 		goto fail1;
 	}
 
 	*ovrfl_window = window;
 	return 0;
 
-      fail1:
+fail1:
 	pci_release_regions(dev);
 
 #ifdef CORRECT_BIOS
-      fail0:
+fail0:
 	pci_disable_device(dev);
 #endif
 	/* NOTE: the ovrfl proc entry and pci_dev are intentionally left */
@@ -393,7 +393,7 @@ static int i82875p_probe1(struct pci_dev
 	drc = readl(ovrfl_window + I82875P_DRC);
 	nr_chans = dual_channel_active(drc) + 1;
 	mci = edac_mc_alloc(sizeof(*pvt), I82875P_NR_CSROWS(nr_chans),
-			    nr_chans);
+			nr_chans);
 
 	if (!mci) {
 		rc = -ENOMEM;
@@ -441,10 +441,10 @@ static int i82875p_probe1(struct pci_dev
 	debugf3("%s(): success\n", __func__);
 	return 0;
 
-      fail1:
+fail1:
 	edac_mc_free(mci);
 
-      fail0:
+fail0:
 	iounmap(ovrfl_window);
 	pci_release_regions(ovrfl_pdev);
 
@@ -455,7 +455,7 @@ static int i82875p_probe1(struct pci_dev
 
 /* returns count (>= 0), or negative on error */
 static int __devinit i82875p_init_one(struct pci_dev *pdev,
-				      const struct pci_device_id *ent)
+				const struct pci_device_id *ent)
 {
 	int rc;
 
@@ -532,7 +532,7 @@ static int __init i82875p_init(void)
 
 	if (mci_pdev == NULL) {
 		mci_pdev = pci_get_device(PCI_VENDOR_ID_INTEL,
-					  PCI_DEVICE_ID_INTEL_82875_0, NULL);
+					PCI_DEVICE_ID_INTEL_82875_0, NULL);
 
 		if (!mci_pdev) {
 			debugf0("875p pci_get_device fail\n");
@@ -551,10 +551,10 @@ static int __init i82875p_init(void)
 
 	return 0;
 
-      fail1:
+fail1:
 	pci_unregister_driver(&i82875p_driver);
 
-      fail0:
+fail0:
 	if (mci_pdev != NULL)
 		pci_dev_put(mci_pdev);
 
diff -puN drivers/edac/r82600_edac.c~drivers-edac-cleanup-spaces-gotos-after-lindent-messup drivers/edac/r82600_edac.c
--- a/drivers/edac/r82600_edac.c~drivers-edac-cleanup-spaces-gotos-after-lindent-messup
+++ a/drivers/edac/r82600_edac.c
@@ -136,7 +136,7 @@ static unsigned int disable_hardware_scr
 static struct edac_pci_ctl_info *r82600_pci;
 
 static void r82600_get_error_info(struct mem_ctl_info *mci,
-				  struct r82600_error_info *info)
+				struct r82600_error_info *info)
 {
 	struct pci_dev *pdev;
 
@@ -157,8 +157,8 @@ static void r82600_get_error_info(struct
 }
 
 static int r82600_process_error_info(struct mem_ctl_info *mci,
-				     struct r82600_error_info *info,
-				     int handle_errors)
+				struct r82600_error_info *info,
+				int handle_errors)
 {
 	int error_found;
 	u32 eapaddr, page;
@@ -180,8 +180,9 @@ static int r82600_process_error_info(str
 
 		if (handle_errors)
 			edac_mc_handle_ce(mci, page, 0,	/* not avail */
-					  syndrome, edac_mc_find_csrow_by_page(mci, page), 0,	/* channel */
-					  mci->ctl_name);
+					syndrome,
+					edac_mc_find_csrow_by_page(mci, page),
+					0, mci->ctl_name);
 	}
 
 	if (info->eapr & BIT(1)) {	/* UE? */
@@ -190,8 +191,8 @@ static int r82600_process_error_info(str
 		if (handle_errors)
 			/* 82600 doesn't give enough info */
 			edac_mc_handle_ue(mci, page, 0,
-					  edac_mc_find_csrow_by_page(mci, page),
-					  mci->ctl_name);
+					edac_mc_find_csrow_by_page(mci, page),
+					mci->ctl_name);
 	}
 
 	return error_found;
@@ -212,7 +213,7 @@ static inline int ecc_enabled(u8 dramcr)
 }
 
 static void r82600_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
-			       u8 dramcr)
+			u8 dramcr)
 {
 	struct csrow_info *csrow;
 	int index;
@@ -342,14 +343,14 @@ static int r82600_probe1(struct pci_dev 
 	debugf3("%s(): success\n", __func__);
 	return 0;
 
-      fail:
+fail:
 	edac_mc_free(mci);
 	return -ENODEV;
 }
 
 /* returns count (>= 0), or negative on error */
 static int __devinit r82600_init_one(struct pci_dev *pdev,
-				     const struct pci_device_id *ent)
+				const struct pci_device_id *ent)
 {
 	debugf0("%s()\n", __func__);
 
@@ -405,7 +406,7 @@ module_exit(r82600_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Tim Small <tim@buttersideup.com> - WPAD Ltd. "
-	      "on behalf of EADS Astrium");
+		"on behalf of EADS Astrium");
 MODULE_DESCRIPTION("MC support for Radisys 82600 memory controllers");
 
 module_param(disable_hardware_scrub, bool, 0644);
_

Patches currently in -mm which might be from dougthompson@xmission.com are

origin.patch

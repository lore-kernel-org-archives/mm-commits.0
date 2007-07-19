From: akpm@linux-foundation.org
Subject: - drivers-edac-lindent-e752x.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:06:26 -0700
Message-ID: <200707192006.l6JK6Qgj020137@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43652 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760310AbXGSUVF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:21:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djiang@mvista.com, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: Lindent e752x
has been removed from the -mm tree.  Its filename was
     drivers-edac-lindent-e752x.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: Lindent e752x
From: Dave Jiang <djiang@mvista.com>

Run e752x_edac.c file through Lindent for cleanup

Signed-off-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/e752x_edac.c |  328 +++++++++++++++++-------------------
 1 file changed, 158 insertions(+), 170 deletions(-)

diff -puN drivers/edac/e752x_edac.c~drivers-edac-lindent-e752x drivers/edac/e752x_edac.c
--- a/drivers/edac/e752x_edac.c~drivers-edac-lindent-e752x
+++ a/drivers/edac/e752x_edac.c
@@ -204,27 +204,24 @@ struct e752x_error_info {
 
 static const struct e752x_dev_info e752x_devs[] = {
 	[E7520] = {
-		.err_dev = PCI_DEVICE_ID_INTEL_7520_1_ERR,
-		.ctl_dev = PCI_DEVICE_ID_INTEL_7520_0,
-		.ctl_name = "E7520"
-	},
+		   .err_dev = PCI_DEVICE_ID_INTEL_7520_1_ERR,
+		   .ctl_dev = PCI_DEVICE_ID_INTEL_7520_0,
+		   .ctl_name = "E7520"},
 	[E7525] = {
-		.err_dev = PCI_DEVICE_ID_INTEL_7525_1_ERR,
-		.ctl_dev = PCI_DEVICE_ID_INTEL_7525_0,
-		.ctl_name = "E7525"
-	},
+		   .err_dev = PCI_DEVICE_ID_INTEL_7525_1_ERR,
+		   .ctl_dev = PCI_DEVICE_ID_INTEL_7525_0,
+		   .ctl_name = "E7525"},
 	[E7320] = {
-		.err_dev = PCI_DEVICE_ID_INTEL_7320_1_ERR,
-		.ctl_dev = PCI_DEVICE_ID_INTEL_7320_0,
-		.ctl_name = "E7320"
-	},
+		   .err_dev = PCI_DEVICE_ID_INTEL_7320_1_ERR,
+		   .ctl_dev = PCI_DEVICE_ID_INTEL_7320_0,
+		   .ctl_name = "E7320"},
 };
 
 static unsigned long ctl_page_to_phys(struct mem_ctl_info *mci,
-		unsigned long page)
+				      unsigned long page)
 {
 	u32 remap;
-	struct e752x_pvt *pvt = (struct e752x_pvt *) mci->pvt_info;
+	struct e752x_pvt *pvt = (struct e752x_pvt *)mci->pvt_info;
 
 	debugf3("%s()\n", __func__);
 
@@ -244,13 +241,13 @@ static unsigned long ctl_page_to_phys(st
 }
 
 static void do_process_ce(struct mem_ctl_info *mci, u16 error_one,
-		u32 sec1_add, u16 sec1_syndrome)
+			  u32 sec1_add, u16 sec1_syndrome)
 {
 	u32 page;
 	int row;
 	int channel;
 	int i;
-	struct e752x_pvt *pvt = (struct e752x_pvt *) mci->pvt_info;
+	struct e752x_pvt *pvt = (struct e752x_pvt *)mci->pvt_info;
 
 	debugf3("%s()\n", __func__);
 
@@ -262,9 +259,10 @@ static void do_process_ce(struct mem_ctl
 		/* chip select are bits 14 & 13 */
 		row = ((page >> 1) & 3);
 		e752x_printk(KERN_WARNING,
-			"Test row %d Table %d %d %d %d %d %d %d %d\n", row,
-			pvt->map[0], pvt->map[1], pvt->map[2], pvt->map[3],
-			pvt->map[4], pvt->map[5], pvt->map[6], pvt->map[7]);
+			     "Test row %d Table %d %d %d %d %d %d %d %d\n", row,
+			     pvt->map[0], pvt->map[1], pvt->map[2], pvt->map[3],
+			     pvt->map[4], pvt->map[5], pvt->map[6],
+			     pvt->map[7]);
 
 		/* test for channel remapping */
 		for (i = 0; i < 8; i++) {
@@ -278,7 +276,8 @@ static void do_process_ce(struct mem_ctl
 			row = i;
 		else
 			e752x_mc_printk(mci, KERN_WARNING,
-				"row %d not found in remap table\n", row);
+					"row %d not found in remap table\n",
+					row);
 	} else
 		row = edac_mc_find_csrow_by_page(mci, page);
 
@@ -290,12 +289,12 @@ static void do_process_ce(struct mem_ctl
 
 	/* e752x mc reads 34:6 of the DRAM linear address */
 	edac_mc_handle_ce(mci, page, offset_in_page(sec1_add << 4),
-			sec1_syndrome, row, channel, "e752x CE");
+			  sec1_syndrome, row, channel, "e752x CE");
 }
 
 static inline void process_ce(struct mem_ctl_info *mci, u16 error_one,
-		u32 sec1_add, u16 sec1_syndrome, int *error_found,
-		int handle_error)
+			      u32 sec1_add, u16 sec1_syndrome, int *error_found,
+			      int handle_error)
 {
 	*error_found = 1;
 
@@ -304,11 +303,11 @@ static inline void process_ce(struct mem
 }
 
 static void do_process_ue(struct mem_ctl_info *mci, u16 error_one,
-		u32 ded_add, u32 scrb_add)
+			  u32 ded_add, u32 scrb_add)
 {
 	u32 error_2b, block_page;
 	int row;
-	struct e752x_pvt *pvt = (struct e752x_pvt *) mci->pvt_info;
+	struct e752x_pvt *pvt = (struct e752x_pvt *)mci->pvt_info;
 
 	debugf3("%s()\n", __func__);
 
@@ -319,14 +318,14 @@ static void do_process_ue(struct mem_ctl
 		block_page = error_2b >> (PAGE_SHIFT - 4);
 
 		row = pvt->mc_symmetric ?
-			/* chip select are bits 14 & 13 */
-			((block_page >> 1) & 3) :
-			edac_mc_find_csrow_by_page(mci, block_page);
+		    /* chip select are bits 14 & 13 */
+		    ((block_page >> 1) & 3) :
+		    edac_mc_find_csrow_by_page(mci, block_page);
 
 		/* e752x mc reads 34:6 of the DRAM linear address */
 		edac_mc_handle_ue(mci, block_page,
-					offset_in_page(error_2b << 4),
-					row, "e752x UE from Read");
+				  offset_in_page(error_2b << 4),
+				  row, "e752x UE from Read");
 	}
 	if (error_one & 0x0404) {
 		error_2b = scrb_add;
@@ -335,19 +334,20 @@ static void do_process_ue(struct mem_ctl
 		block_page = error_2b >> (PAGE_SHIFT - 4);
 
 		row = pvt->mc_symmetric ?
-			/* chip select are bits 14 & 13 */
-			((block_page >> 1) & 3) :
-			edac_mc_find_csrow_by_page(mci, block_page);
+		    /* chip select are bits 14 & 13 */
+		    ((block_page >> 1) & 3) :
+		    edac_mc_find_csrow_by_page(mci, block_page);
 
 		/* e752x mc reads 34:6 of the DRAM linear address */
 		edac_mc_handle_ue(mci, block_page,
-					offset_in_page(error_2b << 4),
-					row, "e752x UE from Scruber");
+				  offset_in_page(error_2b << 4),
+				  row, "e752x UE from Scruber");
 	}
 }
 
 static inline void process_ue(struct mem_ctl_info *mci, u16 error_one,
-		u32 ded_add, u32 scrb_add, int *error_found, int handle_error)
+			      u32 ded_add, u32 scrb_add, int *error_found,
+			      int handle_error)
 {
 	*error_found = 1;
 
@@ -356,7 +356,7 @@ static inline void process_ue(struct mem
 }
 
 static inline void process_ue_no_info_wr(struct mem_ctl_info *mci,
-		int *error_found, int handle_error)
+					 int *error_found, int handle_error)
 {
 	*error_found = 1;
 
@@ -368,24 +368,24 @@ static inline void process_ue_no_info_wr
 }
 
 static void do_process_ded_retry(struct mem_ctl_info *mci, u16 error,
-		u32 retry_add)
+				 u32 retry_add)
 {
 	u32 error_1b, page;
 	int row;
-	struct e752x_pvt *pvt = (struct e752x_pvt *) mci->pvt_info;
+	struct e752x_pvt *pvt = (struct e752x_pvt *)mci->pvt_info;
 
 	error_1b = retry_add;
-	page = error_1b >> (PAGE_SHIFT - 4); /* convert the addr to 4k page */
-	row = pvt->mc_symmetric ?
-		((page >> 1) & 3) : /* chip select are bits 14 & 13 */
-		edac_mc_find_csrow_by_page(mci, page);
+	page = error_1b >> (PAGE_SHIFT - 4);	/* convert the addr to 4k page */
+	row = pvt->mc_symmetric ? ((page >> 1) & 3) :	/* chip select are bits 14 & 13 */
+	    edac_mc_find_csrow_by_page(mci, page);
 	e752x_mc_printk(mci, KERN_WARNING,
-		"CE page 0x%lx, row %d : Memory read retry\n",
-		(long unsigned int) page, row);
+			"CE page 0x%lx, row %d : Memory read retry\n",
+			(long unsigned int)page, row);
 }
 
 static inline void process_ded_retry(struct mem_ctl_info *mci, u16 error,
-		u32 retry_add, int *error_found, int handle_error)
+				     u32 retry_add, int *error_found,
+				     int handle_error)
 {
 	*error_found = 1;
 
@@ -394,7 +394,7 @@ static inline void process_ded_retry(str
 }
 
 static inline void process_threshold_ce(struct mem_ctl_info *mci, u16 error,
-		int *error_found, int handle_error)
+					int *error_found, int handle_error)
 {
 	*error_found = 1;
 
@@ -418,12 +418,12 @@ static void do_global_error(int fatal, u
 	for (i = 0; i < 11; i++) {
 		if (errors & (1 << i))
 			e752x_printk(KERN_WARNING, "%sError %s\n",
-				fatal_message[fatal], global_message[i]);
+				     fatal_message[fatal], global_message[i]);
 	}
 }
 
 static inline void global_error(int fatal, u32 errors, int *error_found,
-		int handle_error)
+				int handle_error)
 {
 	*error_found = 1;
 
@@ -445,12 +445,12 @@ static void do_hub_error(int fatal, u8 e
 	for (i = 0; i < 7; i++) {
 		if (errors & (1 << i))
 			e752x_printk(KERN_WARNING, "%sError %s\n",
-				fatal_message[fatal], hub_message[i]);
+				     fatal_message[fatal], hub_message[i]);
 	}
 }
 
 static inline void hub_error(int fatal, u8 errors, int *error_found,
-		int handle_error)
+			     int handle_error)
 {
 	*error_found = 1;
 
@@ -472,7 +472,7 @@ static void do_membuf_error(u8 errors)
 	for (i = 0; i < 4; i++) {
 		if (errors & (1 << i))
 			e752x_printk(KERN_WARNING, "Non-Fatal Error %s\n",
-				membuf_message[i]);
+				     membuf_message[i]);
 	}
 }
 
@@ -503,12 +503,12 @@ static void do_sysbus_error(int fatal, u
 	for (i = 0; i < 10; i++) {
 		if (errors & (1 << i))
 			e752x_printk(KERN_WARNING, "%sError System Bus %s\n",
-				fatal_message[fatal], sysbus_message[i]);
+				     fatal_message[fatal], sysbus_message[i]);
 	}
 }
 
 static inline void sysbus_error(int fatal, u32 errors, int *error_found,
-		int handle_error)
+				int handle_error)
 {
 	*error_found = 1;
 
@@ -517,7 +517,7 @@ static inline void sysbus_error(int fata
 }
 
 static void e752x_check_hub_interface(struct e752x_error_info *info,
-		int *error_found, int handle_error)
+				      int *error_found, int handle_error)
 {
 	u8 stat8;
 
@@ -525,33 +525,32 @@ static void e752x_check_hub_interface(st
 
 	stat8 = info->hi_ferr;
 
-	if(stat8 & 0x7f) { /* Error, so process */
+	if (stat8 & 0x7f) {	/* Error, so process */
 		stat8 &= 0x7f;
 
-		if(stat8 & 0x2b)
+		if (stat8 & 0x2b)
 			hub_error(1, stat8 & 0x2b, error_found, handle_error);
 
-		if(stat8 & 0x54)
+		if (stat8 & 0x54)
 			hub_error(0, stat8 & 0x54, error_found, handle_error);
 	}
-
 	//pci_read_config_byte(dev,E752X_HI_NERR,&stat8);
 
 	stat8 = info->hi_nerr;
 
-	if(stat8 & 0x7f) { /* Error, so process */
+	if (stat8 & 0x7f) {	/* Error, so process */
 		stat8 &= 0x7f;
 
 		if (stat8 & 0x2b)
 			hub_error(1, stat8 & 0x2b, error_found, handle_error);
 
-		if(stat8 & 0x54)
+		if (stat8 & 0x54)
 			hub_error(0, stat8 & 0x54, error_found, handle_error);
 	}
 }
 
 static void e752x_check_sysbus(struct e752x_error_info *info,
-		int *error_found, int handle_error)
+			       int *error_found, int handle_error)
 {
 	u32 stat32, error32;
 
@@ -559,47 +558,47 @@ static void e752x_check_sysbus(struct e7
 	stat32 = info->sysbus_ferr + (info->sysbus_nerr << 16);
 
 	if (stat32 == 0)
-		return;  /* no errors */
+		return;		/* no errors */
 
 	error32 = (stat32 >> 16) & 0x3ff;
 	stat32 = stat32 & 0x3ff;
 
-	if(stat32 & 0x087)
+	if (stat32 & 0x087)
 		sysbus_error(1, stat32 & 0x087, error_found, handle_error);
 
-	if(stat32 & 0x378)
+	if (stat32 & 0x378)
 		sysbus_error(0, stat32 & 0x378, error_found, handle_error);
 
-	if(error32 & 0x087)
+	if (error32 & 0x087)
 		sysbus_error(1, error32 & 0x087, error_found, handle_error);
 
-	if(error32 & 0x378)
+	if (error32 & 0x378)
 		sysbus_error(0, error32 & 0x378, error_found, handle_error);
 }
 
-static void e752x_check_membuf (struct e752x_error_info *info,
-		int *error_found, int handle_error)
+static void e752x_check_membuf(struct e752x_error_info *info,
+			       int *error_found, int handle_error)
 {
 	u8 stat8;
 
 	stat8 = info->buf_ferr;
 
-	if (stat8 & 0x0f) { /* Error, so process */
+	if (stat8 & 0x0f) {	/* Error, so process */
 		stat8 &= 0x0f;
 		membuf_error(stat8, error_found, handle_error);
 	}
 
 	stat8 = info->buf_nerr;
 
-	if (stat8 & 0x0f) { /* Error, so process */
+	if (stat8 & 0x0f) {	/* Error, so process */
 		stat8 &= 0x0f;
 		membuf_error(stat8, error_found, handle_error);
 	}
 }
 
-static void e752x_check_dram (struct mem_ctl_info *mci,
-		struct e752x_error_info *info, int *error_found,
-		int handle_error)
+static void e752x_check_dram(struct mem_ctl_info *mci,
+			     struct e752x_error_info *info, int *error_found,
+			     int handle_error)
 {
 	u16 error_one, error_next;
 
@@ -607,94 +606,90 @@ static void e752x_check_dram (struct mem
 	error_next = info->dram_nerr;
 
 	/* decode and report errors */
-	if(error_one & 0x0101)  /* check first error correctable */
+	if (error_one & 0x0101)	/* check first error correctable */
 		process_ce(mci, error_one, info->dram_sec1_add,
-			   info->dram_sec1_syndrome, error_found,
-			   handle_error);
+			   info->dram_sec1_syndrome, error_found, handle_error);
 
-	if(error_next & 0x0101)  /* check next error correctable */
+	if (error_next & 0x0101)	/* check next error correctable */
 		process_ce(mci, error_next, info->dram_sec2_add,
-			   info->dram_sec2_syndrome, error_found,
-			   handle_error);
+			   info->dram_sec2_syndrome, error_found, handle_error);
 
-	if(error_one & 0x4040)
+	if (error_one & 0x4040)
 		process_ue_no_info_wr(mci, error_found, handle_error);
 
-	if(error_next & 0x4040)
+	if (error_next & 0x4040)
 		process_ue_no_info_wr(mci, error_found, handle_error);
 
-	if(error_one & 0x2020)
+	if (error_one & 0x2020)
 		process_ded_retry(mci, error_one, info->dram_retr_add,
 				  error_found, handle_error);
 
-	if(error_next & 0x2020)
+	if (error_next & 0x2020)
 		process_ded_retry(mci, error_next, info->dram_retr_add,
 				  error_found, handle_error);
 
-	if(error_one & 0x0808)
-		process_threshold_ce(mci, error_one, error_found,
-				     handle_error);
+	if (error_one & 0x0808)
+		process_threshold_ce(mci, error_one, error_found, handle_error);
 
-	if(error_next & 0x0808)
+	if (error_next & 0x0808)
 		process_threshold_ce(mci, error_next, error_found,
 				     handle_error);
 
-	if(error_one & 0x0606)
+	if (error_one & 0x0606)
 		process_ue(mci, error_one, info->dram_ded_add,
 			   info->dram_scrb_add, error_found, handle_error);
 
-	if(error_next & 0x0606)
+	if (error_next & 0x0606)
 		process_ue(mci, error_next, info->dram_ded_add,
 			   info->dram_scrb_add, error_found, handle_error);
 }
 
-static void e752x_get_error_info (struct mem_ctl_info *mci,
-		struct e752x_error_info *info)
+static void e752x_get_error_info(struct mem_ctl_info *mci,
+				 struct e752x_error_info *info)
 {
 	struct pci_dev *dev;
 	struct e752x_pvt *pvt;
 
 	memset(info, 0, sizeof(*info));
-	pvt = (struct e752x_pvt *) mci->pvt_info;
+	pvt = (struct e752x_pvt *)mci->pvt_info;
 	dev = pvt->dev_d0f1;
 	pci_read_config_dword(dev, E752X_FERR_GLOBAL, &info->ferr_global);
 
 	if (info->ferr_global) {
 		pci_read_config_byte(dev, E752X_HI_FERR, &info->hi_ferr);
 		pci_read_config_word(dev, E752X_SYSBUS_FERR,
-				&info->sysbus_ferr);
+				     &info->sysbus_ferr);
 		pci_read_config_byte(dev, E752X_BUF_FERR, &info->buf_ferr);
-		pci_read_config_word(dev, E752X_DRAM_FERR,
-				&info->dram_ferr);
+		pci_read_config_word(dev, E752X_DRAM_FERR, &info->dram_ferr);
 		pci_read_config_dword(dev, E752X_DRAM_SEC1_ADD,
-				&info->dram_sec1_add);
+				      &info->dram_sec1_add);
 		pci_read_config_word(dev, E752X_DRAM_SEC1_SYNDROME,
-				&info->dram_sec1_syndrome);
+				     &info->dram_sec1_syndrome);
 		pci_read_config_dword(dev, E752X_DRAM_DED_ADD,
-				&info->dram_ded_add);
+				      &info->dram_ded_add);
 		pci_read_config_dword(dev, E752X_DRAM_SCRB_ADD,
-				&info->dram_scrb_add);
+				      &info->dram_scrb_add);
 		pci_read_config_dword(dev, E752X_DRAM_RETR_ADD,
-				&info->dram_retr_add);
+				      &info->dram_retr_add);
 
 		if (info->hi_ferr & 0x7f)
 			pci_write_config_byte(dev, E752X_HI_FERR,
-					info->hi_ferr);
+					      info->hi_ferr);
 
 		if (info->sysbus_ferr)
 			pci_write_config_word(dev, E752X_SYSBUS_FERR,
-					info->sysbus_ferr);
+					      info->sysbus_ferr);
 
 		if (info->buf_ferr & 0x0f)
 			pci_write_config_byte(dev, E752X_BUF_FERR,
-					info->buf_ferr);
+					      info->buf_ferr);
 
 		if (info->dram_ferr)
 			pci_write_bits16(pvt->bridge_ck, E752X_DRAM_FERR,
-					info->dram_ferr, info->dram_ferr);
+					 info->dram_ferr, info->dram_ferr);
 
 		pci_write_config_dword(dev, E752X_FERR_GLOBAL,
-				info->ferr_global);
+				       info->ferr_global);
 	}
 
 	pci_read_config_dword(dev, E752X_NERR_GLOBAL, &info->nerr_global);
@@ -702,38 +697,38 @@ static void e752x_get_error_info (struct
 	if (info->nerr_global) {
 		pci_read_config_byte(dev, E752X_HI_NERR, &info->hi_nerr);
 		pci_read_config_word(dev, E752X_SYSBUS_NERR,
-				&info->sysbus_nerr);
+				     &info->sysbus_nerr);
 		pci_read_config_byte(dev, E752X_BUF_NERR, &info->buf_nerr);
-		pci_read_config_word(dev, E752X_DRAM_NERR,
-				&info->dram_nerr);
+		pci_read_config_word(dev, E752X_DRAM_NERR, &info->dram_nerr);
 		pci_read_config_dword(dev, E752X_DRAM_SEC2_ADD,
-				&info->dram_sec2_add);
+				      &info->dram_sec2_add);
 		pci_read_config_word(dev, E752X_DRAM_SEC2_SYNDROME,
-				&info->dram_sec2_syndrome);
+				     &info->dram_sec2_syndrome);
 
 		if (info->hi_nerr & 0x7f)
 			pci_write_config_byte(dev, E752X_HI_NERR,
-					info->hi_nerr);
+					      info->hi_nerr);
 
 		if (info->sysbus_nerr)
 			pci_write_config_word(dev, E752X_SYSBUS_NERR,
-					info->sysbus_nerr);
+					      info->sysbus_nerr);
 
 		if (info->buf_nerr & 0x0f)
 			pci_write_config_byte(dev, E752X_BUF_NERR,
-					info->buf_nerr);
+					      info->buf_nerr);
 
 		if (info->dram_nerr)
 			pci_write_bits16(pvt->bridge_ck, E752X_DRAM_NERR,
-					info->dram_nerr, info->dram_nerr);
+					 info->dram_nerr, info->dram_nerr);
 
 		pci_write_config_dword(dev, E752X_NERR_GLOBAL,
-				info->nerr_global);
+				       info->nerr_global);
 	}
 }
 
-static int e752x_process_error_info (struct mem_ctl_info *mci,
-		struct e752x_error_info *info, int handle_errors)
+static int e752x_process_error_info(struct mem_ctl_info *mci,
+				    struct e752x_error_info *info,
+				    int handle_errors)
 {
 	u32 error32, stat32;
 	int error_found;
@@ -780,25 +775,25 @@ static inline int dual_channel_active(u1
 }
 
 static void e752x_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
-		u16 ddrcsr)
+			      u16 ddrcsr)
 {
 	struct csrow_info *csrow;
 	unsigned long last_cumul_size;
 	int index, mem_dev, drc_chan;
-	int drc_drbg;  /* DRB granularity 0=64mb, 1=128mb */
-	int drc_ddim;  /* DRAM Data Integrity Mode 0=none, 2=edac */
+	int drc_drbg;		/* DRB granularity 0=64mb, 1=128mb */
+	int drc_ddim;		/* DRAM Data Integrity Mode 0=none, 2=edac */
 	u8 value;
 	u32 dra, drc, cumul_size;
 
 	dra = 0;
-	for (index=0; index < 4; index++) {
+	for (index = 0; index < 4; index++) {
 		u8 dra_reg;
-		pci_read_config_byte(pdev, E752X_DRA+index, &dra_reg);
+		pci_read_config_byte(pdev, E752X_DRA + index, &dra_reg);
 		dra |= dra_reg << (index * 8);
 	}
 	pci_read_config_dword(pdev, E752X_DRC, &drc);
 	drc_chan = dual_channel_active(ddrcsr);
-	drc_drbg = drc_chan + 1;  /* 128 in dual mode, 64 in single */
+	drc_drbg = drc_chan + 1;	/* 128 in dual mode, 64 in single */
 	drc_ddim = (drc >> 20) & 0x3;
 
 	/* The dram row boundary (DRB) reg values are boundary address for
@@ -846,7 +841,7 @@ static void e752x_init_csrows(struct mem
 }
 
 static void e752x_init_mem_map_table(struct pci_dev *pdev,
-		struct e752x_pvt *pvt)
+				     struct e752x_pvt *pvt)
 {
 	int index;
 	u8 value, last, row, stat8;
@@ -861,7 +856,7 @@ static void e752x_init_mem_map_table(str
 			/* no dimm in the slot, so flag it as empty */
 			pvt->map[index] = 0xff;
 			pvt->map[index + 1] = 0xff;
-		} else {        /* there is a dimm in the slot */
+		} else {	/* there is a dimm in the slot */
 			pvt->map[index] = row;
 			row++;
 			last = value;
@@ -870,10 +865,9 @@ static void e752x_init_mem_map_table(str
 			 */
 			pci_read_config_byte(pdev, E752X_DRB + index + 1,
 					     &value);
-			pvt->map[index + 1] = (value == last) ?
-			    0xff :      /* the dimm is single sided,
-					   so flag as empty */
-			    row;        /* this is a double sided dimm
+			pvt->map[index + 1] = (value == last) ? 0xff :	/* the dimm is single sided,
+									   so flag as empty */
+			    row;	/* this is a double sided dimm
 					   to save the next row # */
 			row++;
 			last = value;
@@ -887,13 +881,12 @@ static void e752x_init_mem_map_table(str
 
 /* Return 0 on success or 1 on failure. */
 static int e752x_get_devs(struct pci_dev *pdev, int dev_idx,
-		struct e752x_pvt *pvt)
+			  struct e752x_pvt *pvt)
 {
 	struct pci_dev *dev;
 
 	pvt->bridge_ck = pci_get_device(PCI_VENDOR_ID_INTEL,
-					pvt->dev_info->err_dev,
-					pvt->bridge_ck);
+					pvt->dev_info->err_dev, pvt->bridge_ck);
 
 	if (pvt->bridge_ck == NULL)
 		pvt->bridge_ck = pci_scan_single_device(pdev->bus,
@@ -901,8 +894,8 @@ static int e752x_get_devs(struct pci_dev
 
 	if (pvt->bridge_ck == NULL) {
 		e752x_printk(KERN_ERR, "error reporting device not found:"
-		       "vendor %x device 0x%x (broken BIOS?)\n",
-		       PCI_VENDOR_ID_INTEL, e752x_devs[dev_idx].err_dev);
+			     "vendor %x device 0x%x (broken BIOS?)\n",
+			     PCI_VENDOR_ID_INTEL, e752x_devs[dev_idx].err_dev);
 		return 1;
 	}
 
@@ -917,7 +910,7 @@ static int e752x_get_devs(struct pci_dev
 
 	return 0;
 
-fail:
+      fail:
 	pci_dev_put(pvt->bridge_ck);
 	return 1;
 }
@@ -945,20 +938,20 @@ static int e752x_probe1(struct pci_dev *
 	struct mem_ctl_info *mci;
 	struct e752x_pvt *pvt;
 	u16 ddrcsr;
-	int drc_chan;	/* Number of channels 0=1chan,1=2chan */
+	int drc_chan;		/* Number of channels 0=1chan,1=2chan */
 	struct e752x_error_info discard;
 
 	debugf0("%s(): mci\n", __func__);
 	debugf0("Starting Probe1\n");
 
 	/* make sure error reporting method is sane */
-	switch(edac_op_state) {
-		case EDAC_OPSTATE_POLL:
-		case EDAC_OPSTATE_NMI:
-			break;
-		default:
-			edac_op_state = EDAC_OPSTATE_POLL;
-			break;
+	switch (edac_op_state) {
+	case EDAC_OPSTATE_POLL:
+	case EDAC_OPSTATE_NMI:
+		break;
+	default:
+		edac_op_state = EDAC_OPSTATE_POLL;
+		break;
 	}
 
 	/* check to see if device 0 function 1 is enabled; if it isn't, we
@@ -968,7 +961,7 @@ static int e752x_probe1(struct pci_dev *
 	pci_read_config_byte(pdev, E752X_DEVPRES1, &stat8);
 	if (!force_function_unhide && !(stat8 & (1 << 5))) {
 		printk(KERN_INFO "Contact your BIOS vendor to see if the "
-			"E752x error registers can be safely un-hidden\n");
+		       "E752x error registers can be safely un-hidden\n");
 		return -ENOMEM;
 	}
 	stat8 |= (1 << 5);
@@ -995,7 +988,7 @@ static int e752x_probe1(struct pci_dev *
 	mci->dev = &pdev->dev;
 
 	debugf3("%s(): init pvt\n", __func__);
-	pvt = (struct e752x_pvt *) mci->pvt_info;
+	pvt = (struct e752x_pvt *)mci->pvt_info;
 	pvt->dev_info = &e752x_devs[dev_idx];
 	pvt->mc_symmetric = ((ddrcsr & 0x10) != 0);
 
@@ -1028,36 +1021,34 @@ static int e752x_probe1(struct pci_dev *
 	pci_read_config_word(pdev, E752X_REMAPLIMIT, &pci_data);
 	pvt->remaplimit = ((u32) pci_data) << 14;
 	e752x_printk(KERN_INFO,
-		"tolm = %x, remapbase = %x, remaplimit = %x\n", pvt->tolm,
-		pvt->remapbase, pvt->remaplimit);
+		     "tolm = %x, remapbase = %x, remaplimit = %x\n", pvt->tolm,
+		     pvt->remapbase, pvt->remaplimit);
 
 	/* Here we assume that we will never see multiple instances of this
 	 * type of memory controller.  The ID is therefore hardcoded to 0.
 	 */
-	if (edac_mc_add_mc(mci,0)) {
+	if (edac_mc_add_mc(mci, 0)) {
 		debugf3("%s(): failed edac_mc_add_mc()\n", __func__);
 		goto fail;
 	}
 
 	e752x_init_error_reporting_regs(pvt);
-	e752x_get_error_info(mci, &discard); /* clear other MCH errors */
+	e752x_get_error_info(mci, &discard);	/* clear other MCH errors */
 
 	/* allocating generic PCI control info */
 	e752x_pci = edac_pci_create_generic_ctl(&pdev->dev, EDAC_MOD_STR);
 	if (!e752x_pci) {
 		printk(KERN_WARNING
-			"%s(): Unable to create PCI control\n",
-			__func__);
+		       "%s(): Unable to create PCI control\n", __func__);
 		printk(KERN_WARNING
-			"%s(): PCI error report via EDAC not setup\n",
-			__func__);
+		       "%s(): PCI error report via EDAC not setup\n", __func__);
 	}
 
 	/* get this far and it's successful */
 	debugf3("%s(): success\n", __func__);
 	return 0;
 
-fail:
+      fail:
 	pci_dev_put(pvt->dev_d0f0);
 	pci_dev_put(pvt->dev_d0f1);
 	pci_dev_put(pvt->bridge_ck);
@@ -1068,12 +1059,12 @@ fail:
 
 /* returns count (>= 0), or negative on error */
 static int __devinit e752x_init_one(struct pci_dev *pdev,
-		const struct pci_device_id *ent)
+				    const struct pci_device_id *ent)
 {
 	debugf0("%s()\n", __func__);
 
 	/* wake up and enable device */
-	if(pci_enable_device(pdev) < 0)
+	if (pci_enable_device(pdev) < 0)
 		return -EIO;
 
 	return e752x_probe1(pdev, ent->driver_data);
@@ -1092,7 +1083,7 @@ static void __devexit e752x_remove_one(s
 	if ((mci = edac_mc_del_mc(&pdev->dev)) == NULL)
 		return;
 
-	pvt = (struct e752x_pvt *) mci->pvt_info;
+	pvt = (struct e752x_pvt *)mci->pvt_info;
 	pci_dev_put(pvt->dev_d0f0);
 	pci_dev_put(pvt->dev_d0f1);
 	pci_dev_put(pvt->bridge_ck);
@@ -1101,20 +1092,17 @@ static void __devexit e752x_remove_one(s
 
 static const struct pci_device_id e752x_pci_tbl[] __devinitdata = {
 	{
-		PCI_VEND_DEV(INTEL, 7520_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		E7520
-	},
+	 PCI_VEND_DEV(INTEL, 7520_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	 E7520},
 	{
-		PCI_VEND_DEV(INTEL, 7525_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		E7525
-	},
+	 PCI_VEND_DEV(INTEL, 7525_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	 E7525},
 	{
-		PCI_VEND_DEV(INTEL, 7320_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		E7320
-	},
+	 PCI_VEND_DEV(INTEL, 7320_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	 E7320},
 	{
-		0,
-	}	/* 0 terminated list. */
+	 0,
+	 }			/* 0 terminated list. */
 };
 
 MODULE_DEVICE_TABLE(pci, e752x_pci_tbl);
@@ -1150,6 +1138,6 @@ MODULE_DESCRIPTION("MC support for Intel
 
 module_param(force_function_unhide, int, 0444);
 MODULE_PARM_DESC(force_function_unhide, "if BIOS sets Dev0:Fun1 up as hidden:"
-" 1=force unhide and hope BIOS doesn't fight driver for Dev0:Fun1 access");
+		 " 1=force unhide and hope BIOS doesn't fight driver for Dev0:Fun1 access");
 module_param(edac_op_state, int, 0444);
 MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state: 0=Poll,1=NMI");
_

Patches currently in -mm which might be from djiang@mvista.com are

origin.patch

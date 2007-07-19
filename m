From: akpm@linux-foundation.org
Subject: - drivers-edac-fix-e752x-reversed-csrows.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:07:09 -0700
Message-ID: <200707192007.l6JK79C9020236@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37251 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761314AbXGSUQY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgrondona@llnl.gov, dougthompson@xmission.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: fix e752x reversed csrows
has been removed from the -mm tree.  Its filename was
     drivers-edac-fix-e752x-reversed-csrows.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: fix e752x reversed csrows
From: Mark Grondona <mgrondona@llnl.gov>

Found a 'reversal' decoding bug in the driver.  This patch fixes that mapping
to correctly display the CSROW entries in their proper order.  Users will be
enable to correctly identifiy the failing DIMM with this fix.

[akpm@linux-foundation.org: unneeded (and undesirable) cast of void*]
Cc: Alan Cox alan@lxorguk.ukuu.org.uk
Signed-off-by: Mark Grondona <mgrondona@llnl.gov>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/e752x_edac.c |   34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff -puN drivers/edac/e752x_edac.c~drivers-edac-fix-e752x-reversed-csrows drivers/edac/e752x_edac.c
--- a/drivers/edac/e752x_edac.c~drivers-edac-fix-e752x-reversed-csrows
+++ a/drivers/edac/e752x_edac.c
@@ -284,9 +284,6 @@ static void do_process_ce(struct mem_ctl
 	/* 0 = channel A, 1 = channel B */
 	channel = !(error_one & 1);
 
-	if (!pvt->map_type)
-		row = 7 - row;
-
 	/* e752x mc reads 34:6 of the DRAM linear address */
 	edac_mc_handle_ce(mci, page, offset_in_page(sec1_add << 4),
 			sec1_syndrome, row, channel, "e752x CE");
@@ -774,6 +771,18 @@ static inline int dual_channel_active(u1
 	return (((ddrcsr >> 12) & 3) == 3);
 }
 
+/* Remap csrow index numbers if map_type is "reverse"
+ */
+static inline int remap_csrow_index(struct mem_ctl_info *mci, int index)
+{
+	struct e752x_pvt *pvt = mci->pvt_info;
+
+	if (!pvt->map_type)
+		return (7 - index);
+
+	return (index);
+}
+
 static void e752x_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 			u16 ddrcsr)
 {
@@ -804,7 +813,7 @@ static void e752x_init_csrows(struct mem
 	for (last_cumul_size = index = 0; index < mci->nr_csrows; index++) {
 		/* mem_dev 0=x8, 1=x4 */
 		mem_dev = (dra >> (index * 4 + 2)) & 0x3;
-		csrow = &mci->csrows[index];
+		csrow = &mci->csrows[remap_csrow_index(mci, index)];
 
 		mem_dev = (mem_dev == 2);
 		pci_read_config_byte(pdev, E752X_DRB + index, &value);
@@ -844,7 +853,7 @@ static void e752x_init_mem_map_table(str
 				struct e752x_pvt *pvt)
 {
 	int index;
-	u8 value, last, row, stat8;
+	u8 value, last, row;
 
 	last = 0;
 	row = 0;
@@ -873,10 +882,6 @@ static void e752x_init_mem_map_table(str
 			last = value;
 		}
 	}
-
-	/* set the map type.  1 = normal, 0 = reversed */
-	pci_read_config_byte(pdev, E752X_DRM, &stat8);
-	pvt->map_type = ((stat8 & 0x0f) > ((stat8 >> 4) & 0x0f));
 }
 
 /* Return 0 on success or 1 on failure. */
@@ -1003,13 +1008,16 @@ static int e752x_probe1(struct pci_dev *
 	mci->edac_check = e752x_check;
 	mci->ctl_page_to_phys = ctl_page_to_phys;
 
-	e752x_init_csrows(mci, pdev, ddrcsr);
-	e752x_init_mem_map_table(pdev, pvt);
-
-	/* set the map type.  1 = normal, 0 = reversed */
+	/* set the map type.  1 = normal, 0 = reversed
+	 * Must be set before e752x_init_csrows in case csrow mapping
+	 * is reversed.
+	 */
 	pci_read_config_byte(pdev, E752X_DRM, &stat8);
 	pvt->map_type = ((stat8 & 0x0f) > ((stat8 >> 4) & 0x0f));
 
+	e752x_init_csrows(mci, pdev, ddrcsr);
+	e752x_init_mem_map_table(pdev, pvt);
+
 	mci->edac_cap |= EDAC_FLAG_NONE;
 	debugf3("%s(): tolm, remapbase, remaplimit\n", __func__);
 
_

Patches currently in -mm which might be from mgrondona@llnl.gov are

origin.patch

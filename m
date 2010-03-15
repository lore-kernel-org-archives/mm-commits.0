From: akpm@linux-foundation.org
Subject: [merged] edac-e752x-add-dram-scrubbing-support.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:02:13 -0400
Message-ID: <201003150702.o2F72koX016883@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935892Ab0COHCu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:02:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ptyser@xes-inc.com, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     edac: e752x: add dram scrubbing support
has been removed from the -mm tree.  Its filename was
     edac-e752x-add-dram-scrubbing-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: e752x: add dram scrubbing support
From: Peter Tyser <ptyser@xes-inc.com>

Add support to scrub DRAM using the e752x integrated memory scrubbing
engine.  The e7320/7520/e7525 chipsets support scrubbing at one rate while
the i3100 chipset supports a normal and fast rate.

A similar patch was originally sent back in 2008:
http://sourceforge.net/mailarchive/forum.php?thread_name=1204835866.25206.70.camel@localhost.localdomain&forum_name=bluesmoke-devel

This version has the following updates:
- Use 16-bit PCI config cycles to access MCHSCRB register
    e7320/7520/e7525 docs say register is 16bits wide, i3100 says 8.  I
    tested 16bits on the i3100 to be safe.
- Recalcuate and round actual scrub rates

The changes have been tested on an i3100-based board.

Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/e752x_edac.c |  107 ++++++++++++++++++++++++++++++++++++
 1 file changed, 107 insertions(+)

diff -puN drivers/edac/e752x_edac.c~edac-e752x-add-dram-scrubbing-support drivers/edac/e752x_edac.c
--- a/drivers/edac/e752x_edac.c~edac-e752x-add-dram-scrubbing-support
+++ a/drivers/edac/e752x_edac.c
@@ -75,6 +75,14 @@ static struct edac_pci_ctl_info *e752x_p
 #define E752X_NR_CSROWS		8	/* number of csrows */
 
 /* E752X register addresses - device 0 function 0 */
+#define E752X_MCHSCRB		0x52	/* Memory Scrub register (16b) */
+					/*
+					 * 6:5     Scrub Completion Count
+					 * 3:2     Scrub Rate (i3100 only)
+					 *      01=fast 10=normal
+					 * 1:0     Scrub Mode enable
+					 *      00=off 10=on
+					 */
 #define E752X_DRB		0x60	/* DRAM row boundary register (8b) */
 #define E752X_DRA		0x70	/* DRAM row attribute register (8b) */
 					/*
@@ -240,6 +248,41 @@ static const struct e752x_dev_info e752x
 		.ctl_name = "3100"},
 };
 
+/* Valid scrub rates for the e752x/3100 hardware memory scrubber. We
+ * map the scrubbing bandwidth to a hardware register value. The 'set'
+ * operation finds the 'matching or higher value'.  Note that scrubbing
+ * on the e752x can only be enabled/disabled.  The 3100 supports
+ * a normal and fast mode.
+ */
+
+#define SDRATE_EOT 0xFFFFFFFF
+
+struct scrubrate {
+	u32 bandwidth;	/* bandwidth consumed by scrubbing in bytes/sec */
+	u16 scrubval;	/* register value for scrub rate */
+};
+
+/* Rate below assumes same performance as i3100 using PC3200 DDR2 in
+ * normal mode.  e752x bridges don't support choosing normal or fast mode,
+ * so the scrubbing bandwidth value isn't all that important - scrubbing is
+ * either on or off.
+ */
+static const struct scrubrate scrubrates_e752x[] = {
+	{0,		0x00},	/* Scrubbing Off */
+	{500000,	0x02},	/* Scrubbing On */
+	{SDRATE_EOT,	0x00}	/* End of Table */
+};
+
+/* Fast mode: 2 GByte PC3200 DDR2 scrubbed in 33s = 63161283 bytes/s
+ * Normal mode: 125 (32000 / 256) times slower than fast mode.
+ */
+static const struct scrubrate scrubrates_i3100[] = {
+	{0,		0x00},	/* Scrubbing Off */
+	{500000,	0x0a},	/* Normal mode - 32k clocks */
+	{62500000,	0x06},	/* Fast mode - 256 clocks */
+	{SDRATE_EOT,	0x00}	/* End of Table */
+};
+
 static unsigned long ctl_page_to_phys(struct mem_ctl_info *mci,
 				unsigned long page)
 {
@@ -915,6 +958,68 @@ static void e752x_check(struct mem_ctl_i
 	e752x_process_error_info(mci, &info, 1);
 }
 
+/* Program byte/sec bandwidth scrub rate to hardware */
+static int set_sdram_scrub_rate(struct mem_ctl_info *mci, u32 *new_bw)
+{
+	const struct scrubrate *scrubrates;
+	struct e752x_pvt *pvt = (struct e752x_pvt *) mci->pvt_info;
+	struct pci_dev *pdev = pvt->dev_d0f0;
+	int i;
+
+	if (pvt->dev_info->ctl_dev == PCI_DEVICE_ID_INTEL_3100_0)
+		scrubrates = scrubrates_i3100;
+	else
+		scrubrates = scrubrates_e752x;
+
+	/* Translate the desired scrub rate to a e752x/3100 register value.
+	 * Search for the bandwidth that is equal or greater than the
+	 * desired rate and program the cooresponding register value.
+	 */
+	for (i = 0; scrubrates[i].bandwidth != SDRATE_EOT; i++)
+		if (scrubrates[i].bandwidth >= *new_bw)
+			break;
+
+	if (scrubrates[i].bandwidth == SDRATE_EOT)
+		return -1;
+
+	pci_write_config_word(pdev, E752X_MCHSCRB, scrubrates[i].scrubval);
+
+	return 0;
+}
+
+/* Convert current scrub rate value into byte/sec bandwidth */
+static int get_sdram_scrub_rate(struct mem_ctl_info *mci, u32 *bw)
+{
+	const struct scrubrate *scrubrates;
+	struct e752x_pvt *pvt = (struct e752x_pvt *) mci->pvt_info;
+	struct pci_dev *pdev = pvt->dev_d0f0;
+	u16 scrubval;
+	int i;
+
+	if (pvt->dev_info->ctl_dev == PCI_DEVICE_ID_INTEL_3100_0)
+		scrubrates = scrubrates_i3100;
+	else
+		scrubrates = scrubrates_e752x;
+
+	/* Find the bandwidth matching the memory scrubber configuration */
+	pci_read_config_word(pdev, E752X_MCHSCRB, &scrubval);
+	scrubval = scrubval & 0x0f;
+
+	for (i = 0; scrubrates[i].bandwidth != SDRATE_EOT; i++)
+		if (scrubrates[i].scrubval == scrubval)
+			break;
+
+	if (scrubrates[i].bandwidth == SDRATE_EOT) {
+		e752x_printk(KERN_WARNING,
+			"Invalid sdram scrub control value: 0x%x\n", scrubval);
+		return -1;
+	}
+
+	*bw = scrubrates[i].bandwidth;
+
+	return 0;
+}
+
 /* Return 1 if dual channel mode is active.  Else return 0. */
 static inline int dual_channel_active(u16 ddrcsr)
 {
@@ -1181,6 +1286,8 @@ static int e752x_probe1(struct pci_dev *
 	mci->dev_name = pci_name(pdev);
 	mci->edac_check = e752x_check;
 	mci->ctl_page_to_phys = ctl_page_to_phys;
+	mci->set_sdram_scrub_rate = set_sdram_scrub_rate;
+	mci->get_sdram_scrub_rate = get_sdram_scrub_rate;
 
 	/* set the map type.  1 = normal, 0 = reversed
 	 * Must be set before e752x_init_csrows in case csrow mapping
_

Patches currently in -mm which might be from ptyser@xes-inc.com are

origin.patch


From: akpm@osdl.org
Subject: + edac-add-fully-buffered-dimm-apis-to-core.patch added to -mm tree
Date: Thu, 14 Dec 2006 12:58:44 -0800
Message-ID: <200612142058.kBEKwisk024729@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57606 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657AbWLNU6w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 15:58:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ericw@xmtp.net, alan@redhat.com, norsk5@xmission.com


The patch titled
     EDAC: Add Fully-Buffered DIMM APIs to core
has been added to the -mm tree.  Its filename is
     edac-add-fully-buffered-dimm-apis-to-core.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: EDAC: Add Fully-Buffered DIMM APIs to core
From: eric wollesen <ericw@xmtp.net>

Eric Wollesen ported the Bluesmoke Memory Controller driver for the Intel
5000X/V/P (Blackford/Greencreek) chipset to the in kernel EDAC model.

This patch incorporates those required changes to the edac_mc.c and edac_mc.h
core files by added new Fully Buffered DIMM interface to the EDAC Core module.

Signed-off-by: eric wollesen <ericw@xmtp.net>
Signed-off-by: doug thompson <norsk5@xmission.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/edac/edac_mc.c |  120 +++++++++++++++++++++++++++++++++++++--
 drivers/edac/edac_mc.h |   16 ++++-
 2 files changed, 130 insertions(+), 6 deletions(-)

diff -puN drivers/edac/edac_mc.c~edac-add-fully-buffered-dimm-apis-to-core drivers/edac/edac_mc.c
--- a/drivers/edac/edac_mc.c~edac-add-fully-buffered-dimm-apis-to-core
+++ a/drivers/edac/edac_mc.c
@@ -1497,11 +1497,11 @@ int edac_mc_add_mc(struct mem_ctl_info *
 	/* set load time so that error rate can be tracked */
 	mci->start_time = jiffies;
 
-        if (edac_create_sysfs_mci_device(mci)) {
-                edac_mc_printk(mci, KERN_WARNING,
+	if (edac_create_sysfs_mci_device(mci)) {
+		edac_mc_printk(mci, KERN_WARNING,
 			"failed to create sysfs device\n");
-                goto fail1;
-        }
+		goto fail1;
+	}
 
 	/* Report action taken */
 	edac_mc_printk(mci, KERN_INFO, "Giving out device to %s %s: DEV %s\n",
@@ -1758,6 +1758,116 @@ void edac_mc_handle_ue_no_info(struct me
 EXPORT_SYMBOL_GPL(edac_mc_handle_ue_no_info);
 
 
+/*************************************************************
+ * On Fully Buffered DIMM modules, this help function is
+ * called to process UE events
+ */
+void edac_mc_handle_fbd_ue(struct mem_ctl_info *mci,
+				unsigned int csrow,
+				unsigned int channela,
+				unsigned int channelb,
+				char *msg)
+{
+	int len = EDAC_MC_LABEL_LEN * 4;
+	char labels[len + 1];
+	char *pos = labels;
+	int chars;
+
+	if (csrow >= mci->nr_csrows) {
+		/* something is wrong */
+		edac_mc_printk(mci, KERN_ERR,
+			"INTERNAL ERROR: row out of range (%d >= %d)\n",
+			csrow, mci->nr_csrows);
+		edac_mc_handle_ue_no_info(mci, "INTERNAL ERROR");
+		return;
+	}
+
+	if (channela >= mci->csrows[csrow].nr_channels) {
+		/* something is wrong */
+		edac_mc_printk(mci, KERN_ERR,
+			"INTERNAL ERROR: channel-a out of range "
+			"(%d >= %d)\n",
+			channela, mci->csrows[csrow].nr_channels);
+		edac_mc_handle_ue_no_info(mci, "INTERNAL ERROR");
+		return;
+	}
+
+	if (channelb >= mci->csrows[csrow].nr_channels) {
+		/* something is wrong */
+		edac_mc_printk(mci, KERN_ERR,
+			"INTERNAL ERROR: channel-b out of range "
+			"(%d >= %d)\n",
+			channelb, mci->csrows[csrow].nr_channels);
+		edac_mc_handle_ue_no_info(mci, "INTERNAL ERROR");
+		return;
+	}
+
+	mci->ue_count++;
+	mci->csrows[csrow].ue_count++;
+
+	/* Generate the DIMM labels from the specified channels */
+	chars = snprintf(pos, len + 1, "%s",
+			 mci->csrows[csrow].channels[channela].label);
+	len -= chars; pos += chars;
+	chars = snprintf(pos, len + 1, "-%s",
+			 mci->csrows[csrow].channels[channelb].label);
+
+	if (log_ue)
+		edac_mc_printk(mci, KERN_EMERG,
+			"UE row %d, channel-a= %d channel-b= %d "
+			"labels \"%s\": %s\n", csrow, channela, channelb,
+			labels, msg);
+
+	if (panic_on_ue)
+		panic("UE row %d, channel-a= %d channel-b= %d "
+				"labels \"%s\": %s\n", csrow, channela,
+				channelb, labels, msg);
+}
+EXPORT_SYMBOL(edac_mc_handle_fbd_ue);
+
+/*************************************************************
+ * On Fully Buffered DIMM modules, this help function is
+ * called to process CE events
+ */
+void edac_mc_handle_fbd_ce(struct mem_ctl_info *mci,
+			   unsigned int csrow,
+			   unsigned int channel,
+			   char *msg)
+{
+
+	/* Ensure boundary values */
+	if (csrow >= mci->nr_csrows) {
+		/* something is wrong */
+		edac_mc_printk(mci, KERN_ERR,
+			"INTERNAL ERROR: row out of range (%d >= %d)\n",
+			csrow, mci->nr_csrows);
+		edac_mc_handle_ce_no_info(mci, "INTERNAL ERROR");
+		return;
+	}
+	if (channel >= mci->csrows[csrow].nr_channels) {
+		/* something is wrong */
+		edac_mc_printk(mci, KERN_ERR,
+			"INTERNAL ERROR: channel out of range (%d >= %d)\n",
+			channel, mci->csrows[csrow].nr_channels);
+		edac_mc_handle_ce_no_info(mci, "INTERNAL ERROR");
+		return;
+	}
+
+	if (log_ce)
+		/* FIXME - put in DIMM location */
+		edac_mc_printk(mci, KERN_WARNING,
+			"CE row %d, channel %d, label \"%s\": %s\n",
+			csrow, channel,
+			mci->csrows[csrow].channels[channel].label,
+			msg);
+
+	mci->ce_count++;
+	mci->csrows[csrow].ce_count++;
+	mci->csrows[csrow].channels[channel].ce_count++;
+}
+EXPORT_SYMBOL(edac_mc_handle_fbd_ce);
+
+
 /*
  * Iterate over all MC instances and check for ECC, et al, errors
  */
@@ -1861,7 +1971,7 @@ static void __exit edac_mc_exit(void)
 	debugf0("%s()\n", __func__);
 	kthread_stop(edac_thread);
 
-        /* tear down the sysfs device */
+	/* tear down the sysfs device */
 	edac_sysfs_memctrl_teardown();
 	edac_sysfs_pci_teardown();
 }
diff -puN drivers/edac/edac_mc.h~edac-add-fully-buffered-dimm-apis-to-core drivers/edac/edac_mc.h
--- a/drivers/edac/edac_mc.h~edac-add-fully-buffered-dimm-apis-to-core
+++ a/drivers/edac/edac_mc.h
@@ -123,7 +123,9 @@ enum mem_type {
 	MEM_RDR,		/* Registered single data rate SDRAM */
 	MEM_DDR,		/* Double data rate SDRAM */
 	MEM_RDDR,		/* Registered Double data rate SDRAM */
-	MEM_RMBS		/* Rambus DRAM */
+	MEM_RMBS,		/* Rambus DRAM */
+	MEM_DDR2,               /* DDR2 RAM */
+	MEM_FB_DDR2,            /* fully buffered DDR2 */
 };
 
 #define MEM_FLAG_EMPTY		BIT(MEM_EMPTY)
@@ -137,6 +139,8 @@ enum mem_type {
 #define MEM_FLAG_DDR		BIT(MEM_DDR)
 #define MEM_FLAG_RDDR		BIT(MEM_RDDR)
 #define MEM_FLAG_RMBS		BIT(MEM_RMBS)
+#define MEM_FLAG_DDR2           BIT(MEM_DDR2)
+#define MEM_FLAG_FB_DDR2        BIT(MEM_FB_DDR2)
 
 /* chipset Error Detection and Correction capabilities and mode */
 enum edac_type {
@@ -329,6 +333,7 @@ struct mem_ctl_info {
 
 	/* pointer to edac checking routine */
 	void (*edac_check) (struct mem_ctl_info * mci);
+
 	/*
 	 * Remaps memory pages: controller pages to physical pages.
 	 * For most MC's, this will be NULL.
@@ -453,6 +458,15 @@ extern void edac_mc_handle_ue(struct mem
 		int row, const char *msg);
 extern void edac_mc_handle_ue_no_info(struct mem_ctl_info *mci,
 		const char *msg);
+extern void edac_mc_handle_fbd_ue(struct mem_ctl_info *mci,
+		unsigned int csrow,
+		unsigned int channel0,
+		unsigned int channel1,
+		char *msg);
+extern void edac_mc_handle_fbd_ce(struct mem_ctl_info *mci,
+		unsigned int csrow,
+		unsigned int channel,
+		char *msg);
 
 /*
  * This kmalloc's and initializes all the structures.
_

Patches currently in -mm which might be from ericw@xmtp.net are

edac-add-fully-buffered-dimm-apis-to-core.patch


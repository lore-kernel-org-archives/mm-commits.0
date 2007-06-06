From: akpm@linux-foundation.org
Subject: + drivers-edac-core-make-functions-static.patch added to -mm tree
Date: Tue, 05 Jun 2007 18:50:26 -0700
Message-ID: <200706060150.l561oQ2I007423@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60585 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932676AbXFFBul (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2007 21:50:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, norsk5@xmission.com


The patch titled
     drivers-edac: core: make functions static
has been added to the -mm tree.  Its filename is
     drivers-edac-core-make-functions-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers-edac: core: make functions static
From: Adrian Bunk <bunk@stusta.de>

This patch makes needlessly global code static, in the edac core

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Doug Thompson <norsk5@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_mc.c |   25 +++++++++++--------------
 drivers/edac/edac_mc.h |    8 --------
 2 files changed, 11 insertions(+), 22 deletions(-)

diff -puN drivers/edac/edac_mc.c~drivers-edac-core-make-functions-static drivers/edac/edac_mc.c
--- a/drivers/edac/edac_mc.c~drivers-edac-core-make-functions-static
+++ a/drivers/edac/edac_mc.c
@@ -178,7 +178,7 @@ static struct sysfs_ops memctrlfs_ops = 
 };
 
 #define MEMCTRL_ATTR(_name,_mode,_show,_store)			\
-struct memctrl_dev_attribute attr_##_name = {			\
+static struct memctrl_dev_attribute attr_##_name = {			\
 	.attr = {.name = __stringify(_name), .mode = _mode },	\
 	.value  = &_name,					\
 	.show   = _show,					\
@@ -186,7 +186,7 @@ struct memctrl_dev_attribute attr_##_nam
 };
 
 #define MEMCTRL_STRING_ATTR(_name,_data,_mode,_show,_store)	\
-struct memctrl_dev_attribute attr_##_name = {			\
+static struct memctrl_dev_attribute attr_##_name = {			\
 	.attr = {.name = __stringify(_name), .mode = _mode },	\
 	.value  = _data,					\
 	.show   = _show,					\
@@ -343,7 +343,7 @@ static struct sysfs_ops edac_pci_sysfs_o
 };
 
 #define EDAC_PCI_ATTR(_name,_mode,_show,_store)			\
-struct edac_pci_dev_attribute edac_pci_attr_##_name = {		\
+static struct edac_pci_dev_attribute edac_pci_attr_##_name = {		\
 	.attr = {.name = __stringify(_name), .mode = _mode },	\
 	.value  = &_name,					\
 	.show   = _show,					\
@@ -351,7 +351,7 @@ struct edac_pci_dev_attribute edac_pci_a
 };
 
 #define EDAC_PCI_STRING_ATTR(_name,_data,_mode,_show,_store)	\
-struct edac_pci_dev_attribute edac_pci_attr_##_name = {		\
+static struct edac_pci_dev_attribute edac_pci_attr_##_name = {		\
 	.attr = {.name = __stringify(_name), .mode = _mode },	\
 	.value  = _data,					\
 	.show   = _show,					\
@@ -722,7 +722,7 @@ static struct sysfs_ops csrowfs_ops = {
 };
 
 #define CSROWDEV_ATTR(_name,_mode,_show,_store,_private)	\
-struct csrowdev_attribute attr_##_name = {			\
+static struct csrowdev_attribute attr_##_name = {			\
 	.attr = {.name = __stringify(_name), .mode = _mode },	\
 	.show   = _show,					\
 	.store  = _store,					\
@@ -1066,7 +1066,7 @@ static struct sysfs_ops mci_ops = {
 };
 
 #define MCIDEV_ATTR(_name,_mode,_show,_store)			\
-struct mcidev_attribute mci_attr_##_name = {			\
+static struct mcidev_attribute mci_attr_##_name = {			\
 	.attr = {.name = __stringify(_name), .mode = _mode },	\
 	.show   = _show,					\
 	.store  = _store,					\
@@ -1220,7 +1220,7 @@ static void edac_remove_sysfs_mci_device
 
 #ifdef CONFIG_EDAC_DEBUG
 
-void edac_mc_dump_channel(struct channel_info *chan)
+static void edac_mc_dump_channel(struct channel_info *chan)
 {
 	debugf4("\tchannel = %p\n", chan);
 	debugf4("\tchannel->chan_idx = %d\n", chan->chan_idx);
@@ -1228,9 +1228,8 @@ void edac_mc_dump_channel(struct channel
 	debugf4("\tchannel->label = '%s'\n", chan->label);
 	debugf4("\tchannel->csrow = %p\n\n", chan->csrow);
 }
-EXPORT_SYMBOL_GPL(edac_mc_dump_channel);
 
-void edac_mc_dump_csrow(struct csrow_info *csrow)
+static void edac_mc_dump_csrow(struct csrow_info *csrow)
 {
 	debugf4("\tcsrow = %p\n", csrow);
 	debugf4("\tcsrow->csrow_idx = %d\n", csrow->csrow_idx);
@@ -1244,9 +1243,8 @@ void edac_mc_dump_csrow(struct csrow_inf
 	debugf4("\tcsrow->channels = %p\n", csrow->channels);
 	debugf4("\tcsrow->mci = %p\n\n", csrow->mci);
 }
-EXPORT_SYMBOL_GPL(edac_mc_dump_csrow);
 
-void edac_mc_dump_mci(struct mem_ctl_info *mci)
+static void edac_mc_dump_mci(struct mem_ctl_info *mci)
 {
 	debugf3("\tmci = %p\n", mci);
 	debugf3("\tmci->mtype_cap = %lx\n", mci->mtype_cap);
@@ -1260,7 +1258,6 @@ void edac_mc_dump_mci(struct mem_ctl_inf
 		mci->mod_name, mci->ctl_name);
 	debugf3("\tpvt_info = %p\n\n", mci->pvt_info);
 }
-EXPORT_SYMBOL_GPL(edac_mc_dump_mci);
 
 #endif  /* CONFIG_EDAC_DEBUG */
 
@@ -1576,7 +1573,8 @@ struct mem_ctl_info * edac_mc_del_mc(str
 }
 EXPORT_SYMBOL_GPL(edac_mc_del_mc);
 
-void edac_mc_scrub_block(unsigned long page, unsigned long offset, u32 size)
+static void edac_mc_scrub_block(unsigned long page, unsigned long offset,
+				u32 size)
 {
 	struct page *pg;
 	void *virt_addr;
@@ -1605,7 +1603,6 @@ void edac_mc_scrub_block(unsigned long p
 	if (PageHighMem(pg))
 		local_irq_restore(flags);
 }
-EXPORT_SYMBOL_GPL(edac_mc_scrub_block);
 
 /* FIXME - should return -1 */
 int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci, unsigned long page)
diff -puN drivers/edac/edac_mc.h~drivers-edac-core-make-functions-static drivers/edac/edac_mc.h
--- a/drivers/edac/edac_mc.h~drivers-edac-core-make-functions-static
+++ a/drivers/edac/edac_mc.h
@@ -424,19 +424,11 @@ static inline void pci_write_bits32(stru
 
 #endif /* CONFIG_PCI */
 
-#ifdef CONFIG_EDAC_DEBUG
-void edac_mc_dump_channel(struct channel_info *chan);
-void edac_mc_dump_mci(struct mem_ctl_info *mci);
-void edac_mc_dump_csrow(struct csrow_info *csrow);
-#endif  /* CONFIG_EDAC_DEBUG */
-
 extern struct mem_ctl_info * edac_mc_find(int idx);
 extern int edac_mc_add_mc(struct mem_ctl_info *mci,int mc_idx);
 extern struct mem_ctl_info * edac_mc_del_mc(struct device *dev);
 extern int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci,
 					unsigned long page);
-extern void edac_mc_scrub_block(unsigned long page, unsigned long offset,
-		u32 size);
 
 /*
  * The no info errors are used when error overflows are reported.
_

Patches currently in -mm which might be from bunk@stusta.de are

git-acpi.patch
make-drivers-char-hvc_consoleckhvcd-static.patch
fix-2-gregkh-driver-dmi-based-module-autoloading.patch
git-dvb-fix-the-tea5761-tuner-support.patch
git-input-make-xpad_play_effect-static.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
drivers-mtd-maps-nettelc-possible-cleanups.patch
git-battery.patch
unexport-pci_proc_attach_device.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-wd33c93c-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
scsi-lpfc-lpfc_initc-remove-unused-variable.patch
git-unionfs.patch
git-wireless.patch
git-ipwireless_cs.patch
fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
i386-remove-support-for-the-rise-cpu.patch
i386-make-arch-i386-mm-pgtablecpgd_cdtor-static.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
more-scheduled-oss-driver-removal.patch
remove-sonypi_camera_command.patch
ext2-reservations.patch
revoke-core-code.patch
oss-trident-fix-locking-around-write_voice_regs.patch
pm3fb-possible-cleanups.patch
vt8623fbc-make-code-static.patch
drivers-edac-core-make-functions-static.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch

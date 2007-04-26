From: akpm@linux-foundation.org
Subject: - drivers-edac-make-code-static.patch removed from -mm tree
Date: Thu, 26 Apr 2007 14:05:47 -0700
Message-ID: <200704262105.l3QL5lTY011501@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755085AbXDZVF7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Apr 2007 17:05:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, norsk5@xmission.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac/: make code static
has been removed from the -mm tree.  Its filename was
     drivers-edac-make-code-static.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: drivers/edac/: make code static
From: Adrian Bunk <bunk@stusta.de>

This patch makes needlessly global code static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Doug Thompson <norsk5@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/edac/edac_mc.c |   25 +++++++++++--------------
 drivers/edac/edac_mc.h |    8 --------
 drivers/edac/k8_edac.c |    2 +-
 3 files changed, 12 insertions(+), 23 deletions(-)

diff -puN drivers/edac/edac_mc.c~drivers-edac-make-code-static drivers/edac/edac_mc.c
--- a/drivers/edac/edac_mc.c~drivers-edac-make-code-static
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
diff -puN drivers/edac/edac_mc.h~drivers-edac-make-code-static drivers/edac/edac_mc.h
--- a/drivers/edac/edac_mc.h~drivers-edac-make-code-static
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
diff -puN drivers/edac/k8_edac.c~drivers-edac-make-code-static drivers/edac/k8_edac.c
--- a/drivers/edac/k8_edac.c~drivers-edac-make-code-static
+++ a/drivers/edac/k8_edac.c
@@ -1863,7 +1863,7 @@ static struct pci_driver k8_driver = {
 	.id_table = k8_pci_tbl,
 };
 
-int __init k8_init(void)
+static int __init k8_init(void)
 {
 	return pci_module_init(&k8_driver);
 }
_

Patches currently in -mm which might be from bunk@stusta.de are

git-acpi.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma-fix.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
git-ubi.patch
git-netdev-all.patch
drivers-net-vioc-possible-cleanups.patch
git-net.patch
net-possible-cleanups.patch
fs-ocfs2-make-3-functions-static.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
git-ipwireless_cs.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
maps2-add-proc-kpagemap-interface-fix.patch
lumpy-reclaim-v4.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
the-scheduled-removal-of-obsolete_oss-options.patch
drivers-macintosh-mac_hidc-make-code-static.patch
add-file-position-info-to-proc-fix.patch
more-scheduled-oss-driver-removal.patch
schedule-obsolete-oss-drivers-for-removal-4th-round.patch
make-remove_inode_dquot_ref-static.patch
unexport-pci_proc_attach_device.patch
fix-race-between-rmmod-and-cat-proc-kallsyms-fix.patch
the-scheduled-einval-for-invalid-timevals-in-setitimer.patch
ext2-reservations.patch
drivers-edac-make-code-static.patch
make-drivers-isdn-capi-capiutilccdebbuf_alloc-static.patch
remove-nfs4_acl_add_ace.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
no-longer-include-asm-kdebugh.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
readahead-events-accounting.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
fbdev-display-class-fix.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-hecuba-framebuffer-driver-fix.patch
slim-main-patch.patch
slim-debug-output.patch
mutex-subsystem-synchro-test-module.patch

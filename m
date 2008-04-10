From: akpm@linux-foundation.org
Subject: + edac-remove-unneeded-functions-and-add-static-accessor.patch added to -mm tree
Date: Thu, 10 Apr 2008 13:50:50 -0700
Message-ID: <200804102050.m3AKoq5x016868@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756970AbYDJUvQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Apr 2008 16:51:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, alan@lxorguk.ukuu.org.uk, dougthompson@xmission.com


The patch titled
     edac: remove unneeded functions and add static accessor
has been added to the -mm tree.  Its filename is
     edac-remove-unneeded-functions-and-add-static-accessor.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: remove unneeded functions and add static accessor
From:Adrian Bunk <bunk@kernel.org>

Collection of patches, merged into one, from Adrian that do the following:

1) This patch makes the following needlessly global functions static:
- edac_pci_get_log_pe()
- edac_pci_get_log_npe()
- edac_pci_get_panic_on_pe()
- edac_pci_unregister_sysfs_instance_kobj()
- edac_pci_main_kobj_setup()

2) Remove unneeded function edac_device_find()

3) Added #if 0 around function  edac_pci_find()

4) make the needlessly global edac_pci_generic_check() static

5) Removed function edac_check_mc_devices()

Doug Thompson modified Adrian's patches, to bettern represent
the direction of EDAC, and make them one patch.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_device.c    |   31 -------------------------------
 drivers/edac/edac_mc.c        |   21 ---------------------
 drivers/edac/edac_module.h    |    1 -
 drivers/edac/edac_pci.c       |    6 +++++-
 drivers/edac/edac_pci_sysfs.c |   11 ++++++-----
 5 files changed, 11 insertions(+), 59 deletions(-)

diff -puN drivers/edac/edac_device.c~edac-remove-unneeded-functions-and-add-static-accessor drivers/edac/edac_device.c
--- a/drivers/edac/edac_device.c~edac-remove-unneeded-functions-and-add-static-accessor
+++ a/drivers/edac/edac_device.c
@@ -375,37 +375,6 @@ static void del_edac_device_from_global_
 	wait_for_completion(&edac_device->removal_complete);
 }
 
-/**
- * edac_device_find
- *	Search for a edac_device_ctl_info structure whose index is 'idx'.
- *
- * If found, return a pointer to the structure.
- * Else return NULL.
- *
- * Caller must hold device_ctls_mutex.
- */
-struct edac_device_ctl_info *edac_device_find(int idx)
-{
-	struct list_head *item;
-	struct edac_device_ctl_info *edac_dev;
-
-	/* Iterate over list, looking for exact match of ID */
-	list_for_each(item, &edac_device_list) {
-		edac_dev = list_entry(item, struct edac_device_ctl_info, link);
-
-		if (edac_dev->dev_idx >= idx) {
-			if (edac_dev->dev_idx == idx)
-				return edac_dev;
-
-			/* not on list, so terminate early */
-			break;
-		}
-	}
-
-	return NULL;
-}
-EXPORT_SYMBOL_GPL(edac_device_find);
-
 /*
  * edac_device_workq_function
  *	performs the operation scheduled by a workq request
diff -puN drivers/edac/edac_mc.c~edac-remove-unneeded-functions-and-add-static-accessor drivers/edac/edac_mc.c
--- a/drivers/edac/edac_mc.c~edac-remove-unneeded-functions-and-add-static-accessor
+++ a/drivers/edac/edac_mc.c
@@ -886,24 +886,3 @@ void edac_mc_handle_fbd_ce(struct mem_ct
 	mci->csrows[csrow].channels[channel].ce_count++;
 }
 EXPORT_SYMBOL(edac_mc_handle_fbd_ce);
-
-/*
- * Iterate over all MC instances and check for ECC, et al, errors
- */
-void edac_check_mc_devices(void)
-{
-	struct list_head *item;
-	struct mem_ctl_info *mci;
-
-	debugf3("%s()\n", __func__);
-	mutex_lock(&mem_ctls_mutex);
-
-	list_for_each(item, &mc_devices) {
-		mci = list_entry(item, struct mem_ctl_info, link);
-
-		if (mci->edac_check != NULL)
-			mci->edac_check(mci);
-	}
-
-	mutex_unlock(&mem_ctls_mutex);
-}
diff -puN drivers/edac/edac_module.h~edac-remove-unneeded-functions-and-add-static-accessor drivers/edac/edac_module.h
--- a/drivers/edac/edac_module.h~edac-remove-unneeded-functions-and-add-static-accessor
+++ a/drivers/edac/edac_module.h
@@ -27,7 +27,6 @@ extern int edac_mc_register_sysfs_main_k
 extern void edac_mc_unregister_sysfs_main_kobj(struct mem_ctl_info *mci);
 extern int edac_create_sysfs_mci_device(struct mem_ctl_info *mci);
 extern void edac_remove_sysfs_mci_device(struct mem_ctl_info *mci);
-extern void edac_check_mc_devices(void);
 extern int edac_get_log_ue(void);
 extern int edac_get_log_ce(void);
 extern int edac_get_panic_on_ue(void);
diff -puN drivers/edac/edac_pci.c~edac-remove-unneeded-functions-and-add-static-accessor drivers/edac/edac_pci.c
--- a/drivers/edac/edac_pci.c~edac-remove-unneeded-functions-and-add-static-accessor
+++ a/drivers/edac/edac_pci.c
@@ -189,6 +189,9 @@ static void del_edac_pci_from_global_lis
 	wait_for_completion(&pci->complete);
 }
 
+#if 0
+/* Older code, but might use in the future */
+
 /*
  * edac_pci_find()
  * 	Search for an edac_pci_ctl_info structure whose index is 'idx'
@@ -219,6 +222,7 @@ struct edac_pci_ctl_info *edac_pci_find(
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(edac_pci_find);
+#endif
 
 /*
  * edac_pci_workq_function()
@@ -422,7 +426,7 @@ EXPORT_SYMBOL_GPL(edac_pci_del_device);
  *
  *	a Generic parity check API
  */
-void edac_pci_generic_check(struct edac_pci_ctl_info *pci)
+static void edac_pci_generic_check(struct edac_pci_ctl_info *pci)
 {
 	debugf4("%s()\n", __func__);
 	edac_pci_do_parity_check();
diff -puN drivers/edac/edac_pci_sysfs.c~edac-remove-unneeded-functions-and-add-static-accessor drivers/edac/edac_pci_sysfs.c
--- a/drivers/edac/edac_pci_sysfs.c~edac-remove-unneeded-functions-and-add-static-accessor
+++ a/drivers/edac/edac_pci_sysfs.c
@@ -37,17 +37,17 @@ int edac_pci_get_check_errors(void)
 	return check_pci_errors;
 }
 
-int edac_pci_get_log_pe(void)
+static int edac_pci_get_log_pe(void)
 {
 	return edac_pci_log_pe;
 }
 
-int edac_pci_get_log_npe(void)
+static int edac_pci_get_log_npe(void)
 {
 	return edac_pci_log_npe;
 }
 
-int edac_pci_get_panic_on_pe(void)
+static int edac_pci_get_panic_on_pe(void)
 {
 	return edac_pci_panic_on_pe;
 }
@@ -197,7 +197,8 @@ error_out:
  *
  *	unregister the kobj for the EDAC PCI instance
  */
-void edac_pci_unregister_sysfs_instance_kobj(struct edac_pci_ctl_info *pci)
+static void edac_pci_unregister_sysfs_instance_kobj(
+			struct edac_pci_ctl_info *pci)
 {
 	debugf0("%s()\n", __func__);
 
@@ -337,7 +338,7 @@ static struct kobj_type ktype_edac_pci_m
  *	setup the sysfs for EDAC PCI attributes
  *	assumes edac_class has already been initialized
  */
-int edac_pci_main_kobj_setup(void)
+static int edac_pci_main_kobj_setup(void)
 {
 	int err;
 	struct sysdev_class *edac_class;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-x86.patch
git-dvb.patch
git-gfs2-nmw.patch
git-dlm.patch
git-hid.patch
git-ieee1394.patch
mtdoopsc-make-struct-oops_cxt-static-again.patch
make-mtd-nand-cs553x_nandcpart_probes-static.patch
git-udf.patch
git-net.patch
git-nfsd.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-selinux.patch
pci_alloc_child_bus-mustnt-be-__devinit.patch
pci_scan_device-mustnt-be-__devinit.patch
pci_bus_size_cardbus-mustnt-be-__devinit.patch
pci_setup_bridge-mustnt-be-__devinit.patch
git-scsi-misc.patch
if-0-ses_match_host.patch
git-watchdog.patch
make-swap_pte_to_pagemap_entry-static.patch
fs-ramfs-extern-cleanup.patch
fs-hfsplus-proper-externs.patch
fs-freevxfs-proper-externs.patch
make-__put_super-static.patch
make-vfs_ioctl-static.patch
fs-fs-writeback-make-2-functions-static.patch
fs-drop_cachesc-make-2-functions-static.patch
fs-aioc-make-3-functions-static.patch
let-log_buf_shift-default-to-17.patch
fs-timerfdc-should-include-linux-syscallsh.patch
remove-generic_commit_write.patch
make-fs-bufferccont_expand_zero-static.patch
make-binfmt_flat-a-bool.patch
remove-mca_is_adapter_used.patch
ipwireless-remove-dead-code.patch
proper-__do_softirq-prototype.patch
proper-extern-for-late_time_init.patch
remove-ecryptfs_header_cache_0.patch
make-ds1511_rtc_readset_time-static.patch
pnp-skip-dev-protocol-null-checks.patch
make-ext3_xattr_list-static.patch
make-cgroup_enable_task_cg_lists-static.patch
cgroups-kernel-ns_cgroupc-should-include-linux-nsproxyh.patch
kernel-cpusetc-make-3-functions-static.patch
include-linux-sysctlh-remove-empty-else.patch
remove-aoedev_isbusy.patch
make-marker_debug-static.patch
edac-remove-unneeded-functions-and-add-static-accessor.patch
reiser4.patch


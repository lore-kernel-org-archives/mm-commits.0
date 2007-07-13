From: akpm@linux-foundation.org
Subject: + drivers-edac-fix-edac_device-init-apis.patch added to -mm tree
Date: Fri, 13 Jul 2007 11:30:47 -0700
Message-ID: <200707131830.l6DIUl7K011038@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60845 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932843AbXGMSb0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 14:31:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dougthompson@xmission.com, greg@kroah.com


The patch titled
     drivers edac: fix edac_device init apis
has been added to the -mm tree.  Its filename is
     drivers-edac-fix-edac_device-init-apis.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers edac: fix edac_device init apis
From: Doug Thompson <dougthompson@xmission.com>

Refactoring of sysfs code necessitated the refactoring of the
edac_device_alloc() and edac_device_add_device() apis, of moving the index
value to the alloc() function.  This patch alters the in tree drivers to
utilize this new api signature.

Having the index value performed later created a chicken-and-the-egg issue. 
Moving it to the alloc() function allows for creating the necessary sysfs
entries with the proper index number

Cc: Alan Cox alan@lxorguk.ukuu.org.uk
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_core.h   |    6 +++---
 drivers/edac/edac_device.c |    8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/edac/edac_core.h~drivers-edac-fix-edac_device-init-apis drivers/edac/edac_core.h
--- a/drivers/edac/edac_core.h~drivers-edac-fix-edac_device-init-apis
+++ a/drivers/edac/edac_core.h
@@ -634,7 +634,8 @@ extern struct edac_device_ctl_info *edac
 		char *edac_block_name, unsigned nr_blocks,
 		unsigned offset_value,
 		struct edac_dev_sysfs_block_attribute *block_attributes,
-		unsigned nr_attribs);
+		unsigned nr_attribs,
+		int device_index);
 
 /* The offset value can be:
  *	-1 indicating no offset value
@@ -806,8 +807,7 @@ extern void edac_mc_handle_fbd_ce(struct
 /*
  * edac_device APIs
  */
-extern int edac_device_add_device(struct edac_device_ctl_info *edac_dev,
-				int dev_idx);
+extern int edac_device_add_device(struct edac_device_ctl_info *edac_dev);
 extern struct edac_device_ctl_info *edac_device_del_device(struct device *dev);
 extern void edac_device_handle_ue(struct edac_device_ctl_info *edac_dev,
 				int inst_nr, int block_nr, const char *msg);
diff -puN drivers/edac/edac_device.c~drivers-edac-fix-edac_device-init-apis drivers/edac/edac_device.c
--- a/drivers/edac/edac_device.c~drivers-edac-fix-edac_device-init-apis
+++ a/drivers/edac/edac_device.c
@@ -67,7 +67,8 @@ struct edac_device_ctl_info *edac_device
 	char *edac_device_name, unsigned nr_instances,
 	char *edac_block_name, unsigned nr_blocks,
 	unsigned offset_value,		/* zero, 1, or other based offset */
-	struct edac_dev_sysfs_block_attribute *attrib_spec, unsigned nr_attrib)
+	struct edac_dev_sysfs_block_attribute *attrib_spec, unsigned nr_attrib,
+	int device_index)
 {
 	struct edac_device_ctl_info *dev_ctl;
 	struct edac_device_instance *dev_inst, *inst;
@@ -145,6 +146,7 @@ struct edac_device_ctl_info *edac_device
 	pvt = sz_private ? (((char *)dev_ctl) + ((unsigned long)pvt)) : NULL;
 
 	/* Begin storing the information into the control info structure */
+	dev_ctl->dev_idx = device_index;
 	dev_ctl->nr_instances = nr_instances;
 	dev_ctl->instances = dev_inst;
 	dev_ctl->pvt_info = pvt;
@@ -441,18 +443,16 @@ void edac_device_reset_delay_period(stru
  * edac_device global list and create sysfs entries associated with
  * edac_device structure.
  * @edac_device: pointer to the edac_device structure to be added to the list
- * @edac_idx: A unique numeric identifier to be assigned to the
  * 'edac_device' structure.
  *
  * Return:
  *	0	Success
  *	!0	Failure
  */
-int edac_device_add_device(struct edac_device_ctl_info *edac_dev, int edac_idx)
+int edac_device_add_device(struct edac_device_ctl_info *edac_dev)
 {
 	debugf0("%s()\n", __func__);
 
-	edac_dev->dev_idx = edac_idx;
 #ifdef CONFIG_EDAC_DEBUG
 	if (edac_debug_level >= 3)
 		edac_device_dump_device(edac_dev);
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
drivers-edac-new-i82443bxgz-mc-driver-broken.patch
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
drivers-edac-fix-edac_device-semaphore-to-mutex.patch
drivers-edac-fix-e752x-reversed-csrows.patch
drivers-edac-new-pasemi-driver.patch
drivers-edac-fix-leaf-sysfs-attribute.patch
drivers-edac-fix-edac_mc-init-apis.patch
drivers-edac-fix-edac_device-init-apis.patch
drivers-edac-fix-edac_mc-sysfs-completion-code.patch
drivers-edac-fix-edac_device-sysfs-completion-code.patch

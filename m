From: akpm@linux-foundation.org
Subject: + driver-edac-mod-edac_align_ptr-function.patch added to -mm tree
Date: Tue, 12 Jun 2007 12:55:29 -0700
Message-ID: <200706121955.l5CJtTZw019986@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60557 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753096AbXFLT4F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 15:56:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dougthompson@xmission.com


The patch titled
     drivers/edac: mod edac_align_ptr function
has been added to the -mm tree.  Its filename is
     driver-edac-mod-edac_align_ptr-function.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/edac: mod edac_align_ptr function
From: Douglas Thompson <dougthompson@xmission.com>

Refactor the edac_align_ptr() function to reduce the noise of casting the
aligned pointer to the various types of data objects and modified its callers
to its new signature

Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_core.h   |    2 --
 drivers/edac/edac_device.c |    9 +++------
 drivers/edac/edac_mc.c     |    9 ++++-----
 drivers/edac/edac_module.h |    1 +
 4 files changed, 8 insertions(+), 13 deletions(-)

diff -puN drivers/edac/edac_core.h~driver-edac-mod-edac_align_ptr-function drivers/edac/edac_core.h
--- a/drivers/edac/edac_core.h~driver-edac-mod-edac_align_ptr-function
+++ a/drivers/edac/edac_core.h
@@ -211,8 +211,6 @@ enum scrub_type {
 #define OP_RUNNING_POLL_INTR	0x203
 #define OP_OFFLINE		0x300
 
-extern char *edac_align_ptr(void *ptr, unsigned size);
-
 /*
  * There are several things to be aware of that aren't at all obvious:
  *
diff -puN drivers/edac/edac_device.c~driver-edac-mod-edac_align_ptr-function drivers/edac/edac_device.c
--- a/drivers/edac/edac_device.c~driver-edac-mod-edac_align_ptr-function
+++ a/drivers/edac/edac_device.c
@@ -89,17 +89,14 @@ struct edac_device_ctl_info *edac_device
 	dev_ctl = (struct edac_device_ctl_info *)NULL;
 
 	/* Calc the 'end' offset past the ctl_info structure */
-	dev_inst = (struct edac_device_instance *)
-		edac_align_ptr(&dev_ctl[1], sizeof(*dev_inst));
+	dev_inst = edac_align_ptr(&dev_ctl[1], sizeof(*dev_inst));
 
 	/* Calc the 'end' offset past the instance array */
-	dev_blk = (struct edac_device_block *)
-		edac_align_ptr(&dev_inst[nr_instances], sizeof(*dev_blk));
+	dev_blk = edac_align_ptr(&dev_inst[nr_instances], sizeof(*dev_blk));
 
 	/* Calc the 'end' offset past the dev_blk array */
 	count = nr_instances * nr_blocks;
-	dev_attrib = (struct edac_attrib *)
-		edac_align_ptr(&dev_blk[count], sizeof(*dev_attrib));
+	dev_attrib = edac_align_ptr(&dev_blk[count], sizeof(*dev_attrib));
 
 	/* Check for case of NO attributes specified */
 	if (nr_attribs > 0)
diff -puN drivers/edac/edac_mc.c~driver-edac-mod-edac_align_ptr-function drivers/edac/edac_mc.c
--- a/drivers/edac/edac_mc.c~driver-edac-mod-edac_align_ptr-function
+++ a/drivers/edac/edac_mc.c
@@ -85,7 +85,7 @@ static void edac_mc_dump_mci(struct mem_
  * If 'size' is a constant, the compiler will optimize this whole function
  * down to either a no-op or the addition of a constant to the value of 'ptr'.
  */
-char *edac_align_ptr(void *ptr, unsigned size)
+void *edac_align_ptr(void *ptr, unsigned size)
 {
 	unsigned align, r;
 
@@ -109,7 +109,7 @@ char *edac_align_ptr(void *ptr, unsigned
 	if (r == 0)
 		return (char *)ptr;
 
-	return (char *)(((unsigned long)ptr) + align - r);
+	return (void *)(((unsigned long)ptr) + align - r);
 }
 
 /**
@@ -144,9 +144,8 @@ struct mem_ctl_info *edac_mc_alloc(unsig
 	 * hardcode everything into a single struct.
 	 */
 	mci = (struct mem_ctl_info *)0;
-	csi = (struct csrow_info *)edac_align_ptr(&mci[1], sizeof(*csi));
-	chi = (struct channel_info *)
-		edac_align_ptr(&csi[nr_csrows], sizeof(*chi));
+	csi = edac_align_ptr(&mci[1], sizeof(*csi));
+	chi = edac_align_ptr(&csi[nr_csrows], sizeof(*chi));
 	pvt = edac_align_ptr(&chi[nr_chans * nr_csrows], sz_pvt);
 	size = ((unsigned long)pvt) + sz_pvt;
 
diff -puN drivers/edac/edac_module.h~driver-edac-mod-edac_align_ptr-function drivers/edac/edac_module.h
--- a/drivers/edac/edac_module.h~driver-edac-mod-edac_align_ptr-function
+++ a/drivers/edac/edac_module.h
@@ -44,6 +44,7 @@ extern void edac_device_workq_setup(stru
 extern void edac_device_workq_teardown(struct edac_device_ctl_info *edac_dev);
 extern void edac_device_reset_delay_period(struct edac_device_ctl_info
 					   *edac_dev, unsigned long value);
+extern void *edac_align_ptr(void *ptr, unsigned size);
 
 /*
  * EDAC PCI functions
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

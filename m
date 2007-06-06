From: akpm@linux-foundation.org
Subject: + drivers-edac-device-output-clenaup.patch added to -mm tree
Date: Tue, 05 Jun 2007 18:51:28 -0700
Message-ID: <200706060151.l561pSFL007524@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41575 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933934AbXFFB40 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2007 21:56:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dougthompson@xmission.com


The patch titled
     drivers-edac: device output clenaup
has been added to the -mm tree.  Its filename is
     drivers-edac-device-output-clenaup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers-edac: device output clenaup
From: Douglas Thompson <dougthompson@xmission.com>

The error handling output strings needed to be refactored for better
displaying of the error informaton.

Also needed to added offset_value for output as well

Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_device.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/edac/edac_device.c~drivers-edac-device-output-clenaup drivers/edac/edac_device.c
--- a/drivers/edac/edac_device.c~drivers-edac-device-output-clenaup
+++ a/drivers/edac/edac_device.c
@@ -158,7 +158,7 @@ struct edac_device_ctl_info *edac_device
 			attrib_p = &dev_attrib[block * nr_attribs];
 			blk->attribs = attrib_p;
 			snprintf(blk->name, sizeof(blk->name),
-				 "%s%d", edac_block_name, block + 1);
+				 "%s%d", edac_block_name, block+offset_value);
 			blk->name[sizeof(blk->name) - 1] = '\0';
 
 			debugf1("%s() instance=%d block=%d name=%s\n",
@@ -580,7 +580,7 @@ void edac_device_handle_ce(struct edac_d
 
 	if (edac_device_get_log_ce(edac_dev))
 		edac_device_printk(edac_dev, KERN_WARNING,
-				   "CE ctl: %s, instance: %s, block: %s: %s\n",
+				   "CE: %s instance: %s block: %s '%s'\n",
 				   edac_dev->ctl_name, instance->name,
 				   block ? block->name : "N/A", msg);
 }
@@ -626,12 +626,12 @@ void edac_device_handle_ue(struct edac_d
 
 	if (edac_device_get_log_ue(edac_dev))
 		edac_device_printk(edac_dev, KERN_EMERG,
-				   "UE ctl: %s, instance: %s, block: %s: %s\n",
+				   "UE: %s instance: %s block: %s '%s'\n",
 				   edac_dev->ctl_name, instance->name,
 				   block ? block->name : "N/A", msg);
 
 	if (edac_device_get_panic_on_ue(edac_dev))
-		panic("EDAC %s: UE instance: %s, block %s: %s\n",
+		panic("EDAC %s: UE instance: %s block %s '%s'\n",
 		      edac_dev->ctl_name, instance->name,
 		      block ? block->name : "N/A", msg);
 }
_

Patches currently in -mm which might be from dougthompson@xmission.com are

drivers-edac-remove-depends-on-x86.patch
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

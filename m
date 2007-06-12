From: akpm@linux-foundation.org
Subject: + driver-edac-mod-edac_opt_state_to_string-function.patch added to -mm tree
Date: Tue, 12 Jun 2007 12:55:31 -0700
Message-ID: <200706121955.l5CJtVHY019989@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51316 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753252AbXFLT4H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 15:56:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dougthompson@xmission.com


The patch titled
     drivers/edac: mod edac_opt_state_to_string function
has been added to the -mm tree.  Its filename is
     driver-edac-mod-edac_opt_state_to_string-function.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/edac: mod edac_opt_state_to_string function
From: Douglas Thompson <dougthompson@xmission.com>

Refactored the function edac_op_state_toString() to be edac_op_state_to_string()
for consistent style, and its callers

Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_core.h   |    2 +-
 drivers/edac/edac_device.c |    2 +-
 drivers/edac/edac_module.c |    4 ++--
 drivers/edac/edac_pci.c    |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/edac/edac_core.h~driver-edac-mod-edac_opt_state_to_string-function drivers/edac/edac_core.h
--- a/drivers/edac/edac_core.h~driver-edac-mod-edac_opt_state_to_string-function
+++ a/drivers/edac/edac_core.h
@@ -845,6 +845,6 @@ extern void edac_pci_remove_sysfs(struct
 /*
  * edac misc APIs
  */
-extern char *edac_op_state_toString(int op_state);
+extern char *edac_op_state_to_string(int op_state);
 
 #endif				/* _EDAC_CORE_H_ */
diff -puN drivers/edac/edac_device.c~driver-edac-mod-edac_opt_state_to_string-function drivers/edac/edac_device.c
--- a/drivers/edac/edac_device.c~driver-edac-mod-edac_opt_state_to_string-function
+++ a/drivers/edac/edac_device.c
@@ -461,7 +461,7 @@ int edac_device_add_device(struct edac_d
 				edac_dev->mod_name,
 				edac_dev->ctl_name,
 				dev_name(edac_dev),
-				edac_op_state_toString(edac_dev->op_state));
+				edac_op_state_to_string(edac_dev->op_state));
 
 	up(&device_ctls_mutex);
 	return 0;
diff -puN drivers/edac/edac_module.c~driver-edac-mod-edac_opt_state_to_string-function drivers/edac/edac_module.c
--- a/drivers/edac/edac_module.c~driver-edac-mod-edac_opt_state_to_string-function
+++ a/drivers/edac/edac_module.c
@@ -35,9 +35,9 @@ static struct sysdev_class edac_class = 
 static int edac_class_valid;
 
 /*
- * edac_op_state_toString()
+ * edac_op_state_to_string()
  */
-char *edac_op_state_toString(int opstate)
+char *edac_op_state_to_string(int opstate)
 {
 	if (opstate == OP_RUNNING_POLL)
 		return "POLLED";
diff -puN drivers/edac/edac_pci.c~driver-edac-mod-edac_opt_state_to_string-function drivers/edac/edac_pci.c
--- a/drivers/edac/edac_pci.c~driver-edac-mod-edac_opt_state_to_string-function
+++ a/drivers/edac/edac_pci.c
@@ -321,7 +321,7 @@ int edac_pci_add_device(struct edac_pci_
 			" DEV '%s' (%s)\n",
 			pci->mod_name,
 			pci->ctl_name,
-			dev_name(pci), edac_op_state_toString(pci->op_state));
+			dev_name(pci), edac_op_state_to_string(pci->op_state));
 
 	edac_unlock_pci_list();
 	return 0;
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

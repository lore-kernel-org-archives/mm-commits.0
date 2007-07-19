From: akpm@linux-foundation.org
Subject: - driver-edac-mod-edac_opt_state_to_string-function.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:07:03 -0700
Message-ID: <200707192007.l6JK73mm020226@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52794 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757217AbXGSUPJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: mod edac_opt_state_to_string function
has been removed from the -mm tree.  Its filename was
     driver-edac-mod-edac_opt_state_to_string-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

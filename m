From: akpm@linux-foundation.org
Subject: + drivers-edac-code-tidying-on-export-gpl.patch added to -mm tree
Date: Tue, 17 Jul 2007 17:32:45 -0700
Message-ID: <200707180032.l6I0WjhG015652@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57700 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934605AbXGRAcz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 20:32:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com


The patch titled
     drivers/edac: code tidying on export-gpl
has been added to the -mm tree.  Its filename is
     drivers-edac-code-tidying-on-export-gpl.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/edac: code tidying on export-gpl
From: Doug Thompson <dougthompson@xmission.com>

Change EXPORT_SYMBOLs to EXPORT_SYMBOLS_GPL
Tidy changes: blank lines, inline removal, add comment

Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_module.c |    9 +++++----
 drivers/edac/edac_stub.c   |   20 +++++++++++---------
 2 files changed, 16 insertions(+), 13 deletions(-)

diff -puN drivers/edac/edac_module.c~drivers-edac-code-tidying-on-export-gpl drivers/edac/edac_module.c
--- a/drivers/edac/edac_module.c~drivers-edac-code-tidying-on-export-gpl
+++ a/drivers/edac/edac_module.c
@@ -1,12 +1,13 @@
 /*
  * edac_module.c
  *
- * (C) 2007 www.douglaskthompson.com
+ * (C) 2007 www.softwarebitmaker.com
+ *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
  * warranty of any kind, whether express or implied.
  *
- * Author: Doug Thompson <norsk5@xmission.com>
+ * Author: Doug Thompson <dougthompson@xmission.com>
  *
  */
 #include <linux/edac.h>
@@ -14,7 +15,7 @@
 #include "edac_core.h"
 #include "edac_module.h"
 
-#define EDAC_MC_VERSION "Ver: 2.0.5 " __DATE__
+#define EDAC_VERSION "Ver: 2.1.0 " __DATE__
 
 #ifdef CONFIG_EDAC_DEBUG
 /* Values of 0 to 4 will generate output */
@@ -141,7 +142,7 @@ static int __init edac_init(void)
 {
 	int err = 0;
 
-	edac_printk(KERN_INFO, EDAC_MC, EDAC_MC_VERSION "\n");
+	edac_printk(KERN_INFO, EDAC_MC, EDAC_VERSION "\n");
 
 	/*
 	 * Harvest and clear any boot/initialization PCI parity errors
diff -puN drivers/edac/edac_stub.c~drivers-edac-code-tidying-on-export-gpl drivers/edac/edac_stub.c
--- a/drivers/edac/edac_stub.c~drivers-edac-code-tidying-on-export-gpl
+++ a/drivers/edac/edac_stub.c
@@ -15,30 +15,32 @@
 #include <asm/edac.h>
 
 int edac_op_state = EDAC_OPSTATE_INVAL;
-EXPORT_SYMBOL(edac_op_state);
+EXPORT_SYMBOL_GPL(edac_op_state);
 
 atomic_t edac_handlers = ATOMIC_INIT(0);
-EXPORT_SYMBOL(edac_handlers);
+EXPORT_SYMBOL_GPL(edac_handlers);
 
 int edac_err_assert = 0;
-EXPORT_SYMBOL(edac_err_assert);
+EXPORT_SYMBOL_GPL(edac_err_assert);
 
-inline int edac_handler_set(void)
+/*
+ * called to determine if there is an EDAC driver interested in
+ * knowing an event (such as NMI) occurred
+ */
+int edac_handler_set(void)
 {
 	if (edac_op_state == EDAC_OPSTATE_POLL)
 		return 0;
 
 	return atomic_read(&edac_handlers);
 }
-
-EXPORT_SYMBOL(edac_handler_set);
+EXPORT_SYMBOL_GPL(edac_handler_set);
 
 /*
  * handler for NMI type of interrupts to assert error
  */
-inline void edac_atomic_assert_error(void)
+void edac_atomic_assert_error(void)
 {
 	edac_err_assert++;
 }
-
-EXPORT_SYMBOL(edac_atomic_assert_error);
+EXPORT_SYMBOL_GPL(edac_atomic_assert_error);
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
drivers-edac-fix-e752x-reversed-csrows-fix.patch
drivers-edac-new-pasemi-driver.patch
drivers-edac-new-pasemi-driver-fix.patch
drivers-edac-fix-leaf-sysfs-attribute.patch
drivers-edac-fix-edac_mc-init-apis.patch
drivers-edac-fix-edac_device-init-apis.patch
drivers-edac-fix-edac_mc-sysfs-completion-code.patch
drivers-edac-fix-edac_device-sysfs-completion-code.patch
drivers-edac-code-tidying-on-export-gpl.patch
drivers-edac-fix-workq-reset-deadlock.patch
drivers-edac-new-i82975x-driver.patch
drivers-edac-new-i82975x-driver-fix.patch
drivers-edac-add-to-maintainers-new-info.patch
drivers-edac-fix-edac_device-sysfs-corner-case-bug.patch
drivers-edac-add-to-edac-docs.patch

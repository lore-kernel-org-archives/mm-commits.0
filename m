From: akpm@linux-foundation.org
Subject: - drivers-edac-code-tidying-on-export-gpl.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:07:26 -0700
Message-ID: <200707192007.l6JK7Qoh020262@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34823 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754829AbXGSUQT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: code tidying on export-gpl
has been removed from the -mm tree.  Its filename was
     drivers-edac-code-tidying-on-export-gpl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

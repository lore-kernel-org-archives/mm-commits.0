From: akpm@linux-foundation.org
Subject: + drivers-edac-mod-assert_error-check.patch added to -mm tree
Date: Tue, 05 Jun 2007 18:50:57 -0700
Message-ID: <200706060150.l561ovfV007473@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43220 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933711AbXFFBvR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2007 21:51:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djiang@mvista.com, dougthompson@xmission.com


The patch titled
     drivers-edac: mod assert_error check
has been added to the -mm tree.  Its filename is
     drivers-edac-mod-assert_error-check.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers-edac: mod assert_error check
From: Dave Jiang <djiang@mvista.com>

Change error check and clear variable from an atomic to an int

Signed-off-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Douglas Thompson <dougthompson@xmission.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_mc.c   |   11 ++++-------
 drivers/edac/edac_stub.c |    4 ++--
 include/linux/edac.h     |    2 +-
 3 files changed, 7 insertions(+), 10 deletions(-)

diff -puN drivers/edac/edac_mc.c~drivers-edac-mod-assert_error-check drivers/edac/edac_mc.c
--- a/drivers/edac/edac_mc.c~drivers-edac-mod-assert_error-check
+++ a/drivers/edac/edac_mc.c
@@ -222,18 +222,15 @@ static struct mem_ctl_info *find_mci_by_
  */
 static int edac_mc_assert_error_check_and_clear(void)
 {
-	int vreg;
+	int old_state;
 
 	if(edac_op_state == EDAC_OPSTATE_POLL)
 		return 1;
 
-	vreg = atomic_read(&edac_err_assert);
-	if(vreg) {
-		atomic_set(&edac_err_assert, 0);
-		return 1;
-	}
+	old_state = edac_err_assert;
+	edac_err_assert = 0;
 
-	return 0;
+	return old_state;
 }
 
 /*
diff -puN drivers/edac/edac_stub.c~drivers-edac-mod-assert_error-check drivers/edac/edac_stub.c
--- a/drivers/edac/edac_stub.c~drivers-edac-mod-assert_error-check
+++ a/drivers/edac/edac_stub.c
@@ -20,7 +20,7 @@ EXPORT_SYMBOL(edac_op_state);
 atomic_t edac_handlers = ATOMIC_INIT(0);
 EXPORT_SYMBOL(edac_handlers);
 
-atomic_t edac_err_assert = ATOMIC_INIT(0);
+int edac_err_assert = 0;
 EXPORT_SYMBOL(edac_err_assert);
 
 inline int edac_handler_set(void)
@@ -37,6 +37,6 @@ EXPORT_SYMBOL(edac_handler_set);
  */
 inline void edac_atomic_assert_error(void)
 {
-	atomic_set(&edac_err_assert, 1);
+	edac_err_assert++;
 }
 EXPORT_SYMBOL(edac_atomic_assert_error);
diff -puN include/linux/edac.h~drivers-edac-mod-assert_error-check include/linux/edac.h
--- a/include/linux/edac.h~drivers-edac-mod-assert_error-check
+++ a/include/linux/edac.h
@@ -20,8 +20,8 @@
 #define EDAC_OPSTATE_INT	2
 
 extern int edac_op_state;
+extern int edac_err_assert;
 extern atomic_t edac_handlers;
-extern atomic_t edac_err_assert;
 
 extern int edac_handler_set(void);
 extern void edac_atomic_assert_error(void);
_

Patches currently in -mm which might be from djiang@mvista.com are

drivers-edac-mc-sysfs-add-missing-mem-types.patch
drivers-edac-add-new-nmi-rescan.patch
drivers-edac-add-dev_name-getter-function.patch
drivers-edac-mod-mc-to-use-workq-instead-of-kthread.patch
drivers-edac-updated-pci-monitoring.patch
drivers-edac-mod-assert_error-check.patch
drivers-edac-mod-pci-poll-names.patch
drivers-edac-core-lindent-cleanup.patch
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

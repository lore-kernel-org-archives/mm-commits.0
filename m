From: akpm@linux-foundation.org
Subject: - driver-edac-remove-null-from-statics.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:06:55 -0700
Message-ID: <200707192006.l6JK6tsm020208@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39287 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756469AbXGSUPL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: remove null from statics
has been removed from the -mm tree.  Its filename was
     driver-edac-remove-null-from-statics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: remove null from statics
From: Douglas Thompson <dougthompson@xmission.com>

Patches to conform to coding style, namely static don't need to be initialized
to NULL nor '0', as that is the default

Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_mc_sysfs.c  |    2 +-
 drivers/edac/edac_module.c    |    2 +-
 drivers/edac/edac_pci.c       |    2 +-
 drivers/edac/edac_pci_sysfs.c |    4 ++--
 drivers/edac/i3000_edac.c     |    2 +-
 drivers/edac/i82860_edac.c    |    2 +-
 drivers/edac/i82875p_edac.c   |    2 +-
 drivers/edac/r82600_edac.c    |    2 +-
 8 files changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/edac/edac_mc_sysfs.c~driver-edac-remove-null-from-statics drivers/edac/edac_mc_sysfs.c
--- a/drivers/edac/edac_mc_sysfs.c~driver-edac-remove-null-from-statics
+++ a/drivers/edac/edac_mc_sysfs.c
@@ -17,7 +17,7 @@
 /* MC EDAC Controls, setable by module parameter, and sysfs */
 static int edac_mc_log_ue = 1;
 static int edac_mc_log_ce = 1;
-static int edac_mc_panic_on_ue = 0;
+static int edac_mc_panic_on_ue;
 static int edac_mc_poll_msec = 1000;
 
 /* Getter functions for above */
diff -puN drivers/edac/edac_module.c~driver-edac-remove-null-from-statics drivers/edac/edac_module.c
--- a/drivers/edac/edac_module.c~driver-edac-remove-null-from-statics
+++ a/drivers/edac/edac_module.c
@@ -32,7 +32,7 @@ struct workqueue_struct *edac_workqueue;
 static struct sysdev_class edac_class = {
 	set_kset_name("edac"),
 };
-static int edac_class_valid = 0;
+static int edac_class_valid;
 
 /*
  * edac_op_state_toString()
diff -puN drivers/edac/edac_pci.c~driver-edac-remove-null-from-statics drivers/edac/edac_pci.c
--- a/drivers/edac/edac_pci.c~driver-edac-remove-null-from-statics
+++ a/drivers/edac/edac_pci.c
@@ -385,7 +385,7 @@ void edac_pci_generic_check(struct edac_
 	edac_pci_do_parity_check();
 }
 
-static int edac_pci_idx = 0;
+static int edac_pci_idx;
 #define EDAC_PCI_GENCTL_NAME	"EDAC PCI controller"
 
 struct edac_pci_gen_data {
diff -puN drivers/edac/edac_pci_sysfs.c~driver-edac-remove-null-from-statics drivers/edac/edac_pci_sysfs.c
--- a/drivers/edac/edac_pci_sysfs.c~driver-edac-remove-null-from-statics
+++ a/drivers/edac/edac_pci_sysfs.c
@@ -17,8 +17,8 @@
 
 #define EDAC_PCI_SYMLINK	"device"
 
-static int check_pci_errors = 0;	/* default YES check PCI parity */
-static int edac_pci_panic_on_pe = 0;	/* default no panic on PCI Parity */
+static int check_pci_errors;	/* default YES check PCI parity */
+static int edac_pci_panic_on_pe;	/* default no panic on PCI Parity */
 static int edac_pci_log_pe = 1;	/* log PCI parity errors */
 static int edac_pci_log_npe = 1;	/* log PCI non-parity error errors */
 static atomic_t pci_parity_count = ATOMIC_INIT(0);
diff -puN drivers/edac/i3000_edac.c~driver-edac-remove-null-from-statics drivers/edac/i3000_edac.c
--- a/drivers/edac/i3000_edac.c~driver-edac-remove-null-from-statics
+++ a/drivers/edac/i3000_edac.c
@@ -151,7 +151,7 @@ static const struct i3000_dev_info i3000
 		.ctl_name = "i3000"},
 };
 
-static struct pci_dev *mci_pdev = NULL;
+static struct pci_dev *mci_pdev;
 static int i3000_registered = 1;
 static struct edac_pci_ctl_info *i3000_pci;
 
diff -puN drivers/edac/i82860_edac.c~driver-edac-remove-null-from-statics drivers/edac/i82860_edac.c
--- a/drivers/edac/i82860_edac.c~driver-edac-remove-null-from-statics
+++ a/drivers/edac/i82860_edac.c
@@ -57,7 +57,7 @@ static const struct i82860_dev_info i828
 		.ctl_name = "i82860"},
 };
 
-static struct pci_dev *mci_pdev = NULL;	/* init dev: in case that AGP code
+static struct pci_dev *mci_pdev;	/* init dev: in case that AGP code
 					 * has already registered driver
 					 */
 static struct edac_pci_ctl_info *i82860_pci;
diff -puN drivers/edac/i82875p_edac.c~driver-edac-remove-null-from-statics drivers/edac/i82875p_edac.c
--- a/drivers/edac/i82875p_edac.c~driver-edac-remove-null-from-statics
+++ a/drivers/edac/i82875p_edac.c
@@ -177,7 +177,7 @@ static const struct i82875p_dev_info i82
 		.ctl_name = "i82875p"},
 };
 
-static struct pci_dev *mci_pdev = NULL;	/* init dev: in case that AGP code has
+static struct pci_dev *mci_pdev;	/* init dev: in case that AGP code has
 					 * already registered driver
 					 */
 
diff -puN drivers/edac/r82600_edac.c~driver-edac-remove-null-from-statics drivers/edac/r82600_edac.c
--- a/drivers/edac/r82600_edac.c~driver-edac-remove-null-from-statics
+++ a/drivers/edac/r82600_edac.c
@@ -131,7 +131,7 @@ struct r82600_error_info {
 	u32 eapr;
 };
 
-static unsigned int disable_hardware_scrub = 0;
+static unsigned int disable_hardware_scrub;
 
 static struct edac_pci_ctl_info *r82600_pci;
 
_

Patches currently in -mm which might be from dougthompson@xmission.com are

origin.patch

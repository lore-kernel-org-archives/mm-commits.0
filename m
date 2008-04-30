From: akpm@linux-foundation.org
Subject: - edac-fix-module-initialization-on-several-modules-2nd-time.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:48:48 -0700
Message-ID: <200804300548.m3U5mmxw029915@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54586 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758730AbYD3Ft1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:49:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: h.mitake@gmail.com, alan@lxorguk.ukuu.org.uk, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     edac: fix module initialization on several modules 2nd time
has been removed from the -mm tree.  Its filename was
     edac-fix-module-initialization-on-several-modules-2nd-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: fix module initialization on several modules 2nd time
From: Hitoshi Mitake <h.mitake@gmail.com>

I implemented opstate_init() as a inline function in linux/edac.h.

added calling opstate_init() to:
	i82443bxgx_edac.c
	i82860_edac.c
	i82875p_edac.c
	i82975x_edac.c

I wrote a fixed patch of
edac-fix-module-initialization-on-several-modules.patch,
and tested building 2.6.25-rc7 with applying this. It was succeed.
I think the patch is now correct.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Hitoshi Mitake <h.mitake@gmail.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/amd76x_edac.c     |    7 +++++++
 drivers/edac/e752x_edac.c      |   15 +++++----------
 drivers/edac/e7xxx_edac.c      |   13 +++----------
 drivers/edac/i3000_edac.c      |   13 ++++---------
 drivers/edac/i5000_edac.c      |   14 ++++----------
 drivers/edac/i82443bxgx_edac.c |    7 +++++++
 drivers/edac/i82860_edac.c     |    7 +++++++
 drivers/edac/i82875p_edac.c    |    9 +++++++++
 drivers/edac/i82975x_edac.c    |    8 +++++++-
 drivers/edac/pasemi_edac.c     |    6 ++++++
 drivers/edac/r82600_edac.c     |    7 +++++++
 include/linux/edac.h           |   14 +++++++++++++-
 12 files changed, 79 insertions(+), 41 deletions(-)

diff -puN drivers/edac/amd76x_edac.c~edac-fix-module-initialization-on-several-modules-2nd-time drivers/edac/amd76x_edac.c
--- a/drivers/edac/amd76x_edac.c~edac-fix-module-initialization-on-several-modules-2nd-time
+++ a/drivers/edac/amd76x_edac.c
@@ -17,6 +17,7 @@
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
+#include <linux/edac.h>
 #include "edac_core.h"
 
 #define AMD76X_REVISION	" Ver: 2.0.2 "  __DATE__
@@ -344,6 +345,9 @@ static struct pci_driver amd76x_driver =
 
 static int __init amd76x_init(void)
 {
+       /* Ensure that the OPSTATE is set correctly for POLL or NMI */
+       opstate_init();
+
 	return pci_register_driver(&amd76x_driver);
 }
 
@@ -358,3 +362,6 @@ module_exit(amd76x_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Linux Networx (http://lnxi.com) Thayne Harbaugh");
 MODULE_DESCRIPTION("MC support for AMD 76x memory controllers");
+
+module_param(edac_op_state, int, 0444);
+MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state: 0=Poll,1=NMI");
diff -puN drivers/edac/e752x_edac.c~edac-fix-module-initialization-on-several-modules-2nd-time drivers/edac/e752x_edac.c
--- a/drivers/edac/e752x_edac.c~edac-fix-module-initialization-on-several-modules-2nd-time
+++ a/drivers/edac/e752x_edac.c
@@ -1117,16 +1117,6 @@ static int e752x_probe1(struct pci_dev *
 	debugf0("%s(): mci\n", __func__);
 	debugf0("Starting Probe1\n");
 
-	/* make sure error reporting method is sane */
-	switch (edac_op_state) {
-	case EDAC_OPSTATE_POLL:
-	case EDAC_OPSTATE_NMI:
-		break;
-	default:
-		edac_op_state = EDAC_OPSTATE_POLL;
-		break;
-	}
-
 	/* check to see if device 0 function 1 is enabled; if it isn't, we
 	 * assume the BIOS has reserved it for a reason and is expecting
 	 * exclusive access, we take care not to violate that assumption and
@@ -1303,6 +1293,10 @@ static int __init e752x_init(void)
 	int pci_rc;
 
 	debugf3("%s()\n", __func__);
+
+       /* Ensure that the OPSTATE is set correctly for POLL or NMI */
+       opstate_init();
+
 	pci_rc = pci_register_driver(&e752x_driver);
 	return (pci_rc < 0) ? pci_rc : 0;
 }
@@ -1323,6 +1317,7 @@ MODULE_DESCRIPTION("MC support for Intel
 module_param(force_function_unhide, int, 0444);
 MODULE_PARM_DESC(force_function_unhide, "if BIOS sets Dev0:Fun1 up as hidden:"
 		 " 1=force unhide and hope BIOS doesn't fight driver for Dev0:Fun1 access");
+
 module_param(edac_op_state, int, 0444);
 MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state: 0=Poll,1=NMI");
 
diff -puN drivers/edac/e7xxx_edac.c~edac-fix-module-initialization-on-several-modules-2nd-time drivers/edac/e7xxx_edac.c
--- a/drivers/edac/e7xxx_edac.c~edac-fix-module-initialization-on-several-modules-2nd-time
+++ a/drivers/edac/e7xxx_edac.c
@@ -414,16 +414,6 @@ static int e7xxx_probe1(struct pci_dev *
 
 	debugf0("%s(): mci\n", __func__);
 
-	/* make sure error reporting method is sane */
-	switch (edac_op_state) {
-	case EDAC_OPSTATE_POLL:
-	case EDAC_OPSTATE_NMI:
-		break;
-	default:
-		edac_op_state = EDAC_OPSTATE_POLL;
-		break;
-	}
-
 	pci_read_config_dword(pdev, E7XXX_DRC, &drc);
 
 	drc_chan = dual_channel_active(drc, dev_idx);
@@ -565,6 +555,9 @@ static struct pci_driver e7xxx_driver = 
 
 static int __init e7xxx_init(void)
 {
+       /* Ensure that the OPSTATE is set correctly for POLL or NMI */
+       opstate_init();
+
 	return pci_register_driver(&e7xxx_driver);
 }
 
diff -puN drivers/edac/i3000_edac.c~edac-fix-module-initialization-on-several-modules-2nd-time drivers/edac/i3000_edac.c
--- a/drivers/edac/i3000_edac.c~edac-fix-module-initialization-on-several-modules-2nd-time
+++ a/drivers/edac/i3000_edac.c
@@ -326,15 +326,6 @@ static int i3000_probe1(struct pci_dev *
 		return -ENODEV;
 	}
 
-	switch (edac_op_state) {
-	case EDAC_OPSTATE_POLL:
-	case EDAC_OPSTATE_NMI:
-		break;
-	default:
-		edac_op_state = EDAC_OPSTATE_POLL;
-		break;
-	}
-
 	c0dra[0] = readb(window + I3000_C0DRA + 0);	/* ranks 0,1 */
 	c0dra[1] = readb(window + I3000_C0DRA + 1);	/* ranks 2,3 */
 	c1dra[0] = readb(window + I3000_C1DRA + 0);	/* ranks 0,1 */
@@ -503,6 +494,10 @@ static int __init i3000_init(void)
 	int pci_rc;
 
 	debugf3("MC: %s()\n", __func__);
+
+       /* Ensure that the OPSTATE is set correctly for POLL or NMI */
+       opstate_init();
+
 	pci_rc = pci_register_driver(&i3000_driver);
 	if (pci_rc < 0)
 		goto fail0;
diff -puN drivers/edac/i5000_edac.c~edac-fix-module-initialization-on-several-modules-2nd-time drivers/edac/i5000_edac.c
--- a/drivers/edac/i5000_edac.c~edac-fix-module-initialization-on-several-modules-2nd-time
+++ a/drivers/edac/i5000_edac.c
@@ -1286,16 +1286,6 @@ static int i5000_probe1(struct pci_dev *
 	if (PCI_FUNC(pdev->devfn) != 0)
 		return -ENODEV;
 
-	/* make sure error reporting method is sane */
-	switch (edac_op_state) {
-	case EDAC_OPSTATE_POLL:
-	case EDAC_OPSTATE_NMI:
-		break;
-	default:
-		edac_op_state = EDAC_OPSTATE_POLL;
-		break;
-	}
-
 	/* Ask the devices for the number of CSROWS and CHANNELS so
 	 * that we can calculate the memory resources, etc
 	 *
@@ -1478,6 +1468,9 @@ static int __init i5000_init(void)
 
 	debugf2("MC: " __FILE__ ": %s()\n", __func__);
 
+       /* Ensure that the OPSTATE is set correctly for POLL or NMI */
+       opstate_init();
+
 	pci_rc = pci_register_driver(&i5000_driver);
 
 	return (pci_rc < 0) ? pci_rc : 0;
@@ -1501,5 +1494,6 @@ MODULE_AUTHOR
     ("Linux Networx (http://lnxi.com) Doug Thompson <norsk5@xmission.com>");
 MODULE_DESCRIPTION("MC Driver for Intel I5000 memory controllers - "
 		I5000_REVISION);
+
 module_param(edac_op_state, int, 0444);
 MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state: 0=Poll,1=NMI");
diff -puN drivers/edac/i82443bxgx_edac.c~edac-fix-module-initialization-on-several-modules-2nd-time drivers/edac/i82443bxgx_edac.c
--- a/drivers/edac/i82443bxgx_edac.c~edac-fix-module-initialization-on-several-modules-2nd-time
+++ a/drivers/edac/i82443bxgx_edac.c
@@ -29,6 +29,7 @@
 
 #include <linux/slab.h>
 
+#include <linux/edac.h>
 #include "edac_core.h"
 
 #define I82443_REVISION	"0.1"
@@ -386,6 +387,9 @@ static struct pci_driver i82443bxgx_edac
 
 static int __init i82443bxgx_edacmc_init(void)
 {
+       /* Ensure that the OPSTATE is set correctly for POLL or NMI */
+       opstate_init();
+
 	return pci_register_driver(&i82443bxgx_edacmc_driver);
 }
 
@@ -400,3 +404,6 @@ module_exit(i82443bxgx_edacmc_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Tim Small <tim@buttersideup.com> - WPAD");
 MODULE_DESCRIPTION("EDAC MC support for Intel 82443BX/GX memory controllers");
+
+module_param(edac_op_state, int, 0444);
+MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state: 0=Poll,1=NMI");
diff -puN drivers/edac/i82860_edac.c~edac-fix-module-initialization-on-several-modules-2nd-time drivers/edac/i82860_edac.c
--- a/drivers/edac/i82860_edac.c~edac-fix-module-initialization-on-several-modules-2nd-time
+++ a/drivers/edac/i82860_edac.c
@@ -14,6 +14,7 @@
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
+#include <linux/edac.h>
 #include "edac_core.h"
 
 #define  I82860_REVISION " Ver: 2.0.2 " __DATE__
@@ -294,6 +295,9 @@ static int __init i82860_init(void)
 
 	debugf3("%s()\n", __func__);
 
+       /* Ensure that the OPSTATE is set correctly for POLL or NMI */
+       opstate_init();
+
 	if ((pci_rc = pci_register_driver(&i82860_driver)) < 0)
 		goto fail0;
 
@@ -345,3 +349,6 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com) "
 		"Ben Woodard <woodard@redhat.com>");
 MODULE_DESCRIPTION("ECC support for Intel 82860 memory hub controllers");
+
+module_param(edac_op_state, int, 0444);
+MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state: 0=Poll,1=NMI");
diff -puN drivers/edac/i82875p_edac.c~edac-fix-module-initialization-on-several-modules-2nd-time drivers/edac/i82875p_edac.c
--- a/drivers/edac/i82875p_edac.c~edac-fix-module-initialization-on-several-modules-2nd-time
+++ a/drivers/edac/i82875p_edac.c
@@ -18,6 +18,7 @@
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
+#include <linux/edac.h>
 #include "edac_core.h"
 
 #define I82875P_REVISION	" Ver: 2.0.2 " __DATE__
@@ -393,6 +394,7 @@ static int i82875p_probe1(struct pci_dev
 	struct i82875p_error_info discard;
 
 	debugf0("%s()\n", __func__);
+
 	ovrfl_pdev = pci_get_device(PCI_VEND_DEV(INTEL, 82875_6), NULL);
 
 	if (i82875p_setup_overfl_dev(pdev, &ovrfl_pdev, &ovrfl_window))
@@ -532,6 +534,10 @@ static int __init i82875p_init(void)
 	int pci_rc;
 
 	debugf3("%s()\n", __func__);
+
+       /* Ensure that the OPSTATE is set correctly for POLL or NMI */
+       opstate_init();
+
 	pci_rc = pci_register_driver(&i82875p_driver);
 
 	if (pci_rc < 0)
@@ -586,3 +592,6 @@ module_exit(i82875p_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Linux Networx (http://lnxi.com) Thayne Harbaugh");
 MODULE_DESCRIPTION("MC support for Intel 82875 memory hub controllers");
+
+module_param(edac_op_state, int, 0444);
+MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state: 0=Poll,1=NMI");
diff -puN drivers/edac/i82975x_edac.c~edac-fix-module-initialization-on-several-modules-2nd-time drivers/edac/i82975x_edac.c
--- a/drivers/edac/i82975x_edac.c~edac-fix-module-initialization-on-several-modules-2nd-time
+++ a/drivers/edac/i82975x_edac.c
@@ -14,7 +14,7 @@
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
-
+#include <linux/edac.h>
 #include "edac_core.h"
 
 #define I82975X_REVISION	" Ver: 1.0.0 " __DATE__
@@ -611,6 +611,9 @@ static int __init i82975x_init(void)
 
 	debugf3("%s()\n", __func__);
 
+       /* Ensure that the OPSTATE is set correctly for POLL or NMI */
+       opstate_init();
+
 	pci_rc = pci_register_driver(&i82975x_driver);
 	if (pci_rc < 0)
 		goto fail0;
@@ -664,3 +667,6 @@ module_exit(i82975x_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Arvind R. <arvind@acarlab.com>");
 MODULE_DESCRIPTION("MC support for Intel 82975 memory hub controllers");
+
+module_param(edac_op_state, int, 0444);
+MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state: 0=Poll,1=NMI");
diff -puN drivers/edac/pasemi_edac.c~edac-fix-module-initialization-on-several-modules-2nd-time drivers/edac/pasemi_edac.c
--- a/drivers/edac/pasemi_edac.c~edac-fix-module-initialization-on-several-modules-2nd-time
+++ a/drivers/edac/pasemi_edac.c
@@ -284,6 +284,9 @@ static struct pci_driver pasemi_edac_dri
 
 static int __init pasemi_edac_init(void)
 {
+       /* Ensure that the OPSTATE is set correctly for POLL or NMI */
+       opstate_init();
+
 	return pci_register_driver(&pasemi_edac_driver);
 }
 
@@ -298,3 +301,6 @@ module_exit(pasemi_edac_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Egor Martovetsky <egor@pasemi.com>");
 MODULE_DESCRIPTION("MC support for PA Semi PWRficient memory controller");
+module_param(edac_op_state, int, 0444);
+MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state: 0=Poll,1=NMI");
+
diff -puN drivers/edac/r82600_edac.c~edac-fix-module-initialization-on-several-modules-2nd-time drivers/edac/r82600_edac.c
--- a/drivers/edac/r82600_edac.c~edac-fix-module-initialization-on-several-modules-2nd-time
+++ a/drivers/edac/r82600_edac.c
@@ -20,6 +20,7 @@
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
+#include <linux/edac.h>
 #include "edac_core.h"
 
 #define R82600_REVISION	" Ver: 2.0.2 " __DATE__
@@ -393,6 +394,9 @@ static struct pci_driver r82600_driver =
 
 static int __init r82600_init(void)
 {
+       /* Ensure that the OPSTATE is set correctly for POLL or NMI */
+       opstate_init();
+
 	return pci_register_driver(&r82600_driver);
 }
 
@@ -412,3 +416,6 @@ MODULE_DESCRIPTION("MC support for Radis
 module_param(disable_hardware_scrub, bool, 0644);
 MODULE_PARM_DESC(disable_hardware_scrub,
 		 "If set, disable the chipset's automatic scrub for CEs");
+
+module_param(edac_op_state, int, 0444);
+MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state: 0=Poll,1=NMI");
diff -puN include/linux/edac.h~edac-fix-module-initialization-on-several-modules-2nd-time include/linux/edac.h
--- a/include/linux/edac.h~edac-fix-module-initialization-on-several-modules-2nd-time
+++ a/include/linux/edac.h
@@ -3,7 +3,7 @@
  *
  * Author: Dave Jiang <djiang@mvista.com>
  *
- * 2006-2007 (c) MontaVista Software, Inc. This file is licensed under
+ * 2006-2008 (c) MontaVista Software, Inc. This file is licensed under
  * the terms of the GNU General Public License version 2. This program
  * is licensed "as is" without any warranty of any kind, whether express
  * or implied.
@@ -26,4 +26,16 @@ extern atomic_t edac_handlers;
 extern int edac_handler_set(void);
 extern void edac_atomic_assert_error(void);
 
+static inline void opstate_init(void)
+{
+	switch (edac_op_state) {
+	case EDAC_OPSTATE_POLL:
+	case EDAC_OPSTATE_NMI:
+		break;
+	default:
+		edac_op_state = EDAC_OPSTATE_POLL;
+	}
+	return;
+}
+
 #endif
_

Patches currently in -mm which might be from h.mitake@gmail.com are

origin.patch


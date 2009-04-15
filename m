From: akpm@linux-foundation.org
Subject: [to-be-updated] input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch removed from -mm tree
Date: Wed, 15 Apr 2009 10:56:25 -0700
Message-ID: <200904151756.n3FHuPwu005967@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754430AbZDOSAB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Apr 2009 14:00:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     input: add a DMI table for the i8042.reset option; make MSI Wind U-100 work
has been removed from the -mm tree.  Its filename was
     input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: add a DMI table for the i8042.reset option; make MSI Wind U-100 work
From: Arjan van de Ven <arjan@linux.intel.com>

There are several DMI tables in the i8042 (keyboard) driver already, but
not one for the i8042.reset option.  This patch adds such an option (which
also sets the nonfatal flag so that if the reset fails, the keyboard still
works).

Two users for this table are added as well, the MSI Wind U-100 and the LG
X110.  The MSI Wind also needs to be in the "don't trust the pnp data" for
the touchpad to work on my machine.

[akpm@linux-foundation.org: fix build warning]
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/serio/i8042-x86ia64io.h |   63 ++++++++++++++++--------
 1 file changed, 43 insertions(+), 20 deletions(-)

diff -puN drivers/input/serio/i8042-x86ia64io.h~input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work drivers/input/serio/i8042-x86ia64io.h
--- a/drivers/input/serio/i8042-x86ia64io.h~input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work
+++ a/drivers/input/serio/i8042-x86ia64io.h
@@ -395,26 +395,6 @@ static struct dmi_system_id __initdata i
 	{ }
 };
 
-#ifdef CONFIG_PNP
-static struct dmi_system_id __initdata i8042_dmi_nopnp_table[] = {
-	{
-		.ident = "Intel MBO Desktop D845PESV",
-		.matches = {
-			DMI_MATCH(DMI_BOARD_NAME, "D845PESV"),
-			DMI_MATCH(DMI_BOARD_VENDOR, "Intel Corporation"),
-		},
-	},
-	{
-		.ident = "MSI Wind U-100",
-		.matches = {
-			DMI_MATCH(DMI_BOARD_NAME, "U-100"),
-			DMI_MATCH(DMI_BOARD_VENDOR, "MICRO-STAR INTERNATIONAL CO., LTD"),
-		},
-	},
-	{ }
-};
-#endif
-
 /*
  * Some Wistron based laptops need us to explicitly enable the 'Dritek
  * keyboard extension' to make their extra keys start generating scancodes.
@@ -499,6 +479,44 @@ static int i8042_pnp_aux_irq;
 static char i8042_pnp_kbd_name[32];
 static char i8042_pnp_aux_name[32];
 
+#ifdef CONFIG_X86
+static struct dmi_system_id __initdata i8042_dmi_nopnp_table[] = {
+	{
+		.ident = "Intel MBO Desktop D845PESV",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "D845PESV"),
+			DMI_MATCH(DMI_BOARD_VENDOR, "Intel Corporation"),
+		},
+	},
+	{
+		.ident = "MSI Wind U-100",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "U-100"),
+			DMI_MATCH(DMI_BOARD_VENDOR, "MICRO-STAR INTERNATIONAL CO., LTD"),
+		},
+	},
+	{ }
+};
+
+static struct dmi_system_id __initdata i8042_dmi_reset_table[] = {
+	{
+		.ident = "MSI Wind U-100",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "U-100"),
+			DMI_MATCH(DMI_BOARD_VENDOR, "MICRO-STAR INTERNATIONAL CO., LTD"),
+		},
+	},
+	{
+		.ident = "LG Electronics X110",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "X110"),
+			DMI_MATCH(DMI_BOARD_VENDOR, "LG Electronics Inc."),
+		},
+	},
+	{ }
+};
+#endif
+
 static int i8042_pnp_kbd_probe(struct pnp_dev *dev, const struct pnp_device_id *did)
 {
 	if (pnp_port_valid(dev, 0) && pnp_port_len(dev, 0) == 1)
@@ -595,6 +613,11 @@ static int __init i8042_pnp_init(void)
 #ifdef CONFIG_X86
 	if (dmi_check_system(i8042_dmi_nopnp_table))
 		i8042_nopnp = 1;
+
+	if (dmi_check_system(i8042_dmi_reset_table)) {
+		i8042_reset = 1;
+		i8042_nonfatal = 1;
+	}
 #endif
 
 	if (i8042_nopnp) {
_

Patches currently in -mm which might be from arjan@linux.intel.com are

origin.patch
linux-next.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
pci-use-pci_ioremap_bar-in-drivers-serial.patch


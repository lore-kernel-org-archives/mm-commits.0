From: akpm@linux-foundation.org
Subject: + input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch added to -mm tree
Date: Thu, 05 Feb 2009 13:54:42 -0800
Message-ID: <200902052154.n15LsgCv000749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752254AbZBEVzH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2009 16:55:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com, dtor@mail.ru


The patch titled
     input: add a DMI table for the i8042.reset option; make MSI Wind U-100 work
has been added to the -mm tree.  Its filename is
     input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/serio/i8042-x86ia64io.h |   31 ++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff -puN drivers/input/serio/i8042-x86ia64io.h~input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work drivers/input/serio/i8042-x86ia64io.h
--- a/drivers/input/serio/i8042-x86ia64io.h~input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work
+++ a/drivers/input/serio/i8042-x86ia64io.h
@@ -378,6 +378,13 @@ static struct dmi_system_id __initdata i
 			DMI_MATCH(DMI_BOARD_VENDOR, "Intel Corporation"),
 		},
 	},
+	{
+		.ident = "MSI Wind U-100",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "U-100"),
+			DMI_MATCH(DMI_BOARD_VENDOR, "MICRO-STAR INTERNATIONAL CO., LTD"),
+		},
+	},
 	{ }
 };
 #endif
@@ -448,6 +455,25 @@ static struct dmi_system_id __initdata i
 	{ }
 };
 
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
+
+
 #endif /* CONFIG_X86 */
 
 #ifdef CONFIG_PNP
@@ -564,6 +590,11 @@ static int __init i8042_pnp_init(void)
 		i8042_nopnp = 1;
 #endif
 
+	if (dmi_check_system(i8042_dmi_reset_table)) {
+		i8042_reset = 1;
+		i8042_nonfatal = 1;
+	}
+
 	if (i8042_nopnp) {
 		printk(KERN_INFO "i8042: PNP detection disabled\n");
 		return 0;
_

Patches currently in -mm which might be from arjan@linux.intel.com are

origin.patch
linux-next.patch
drivers-consolidate-driver_probe_done-loops-into-one-place.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
resume-wait-for-device-probing-to-finish.patch
input-introduce-a-tougher-i8042reset.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
pci-use-pci_ioremap_bar-in-drivers-serial.patch


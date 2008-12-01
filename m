From: akpm@linux-foundation.org
Subject: - acpi-suspend-blacklist-boxes-that-require-us-to-set-sci_en-directly-on-resume.patch removed from -mm tree
Date: Mon, 01 Dec 2008 11:49:12 -0800
Message-ID: <200812011949.mB1JnCsu025131@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752649AbYLATuK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Dec 2008 14:50:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, lenb@kernel.org, me@bobcopeland.com, tino.keitel@gmx.de, mm-commits@vger.kernel.org


The patch titled
     acpi suspend: blacklist boxes that require us to set SCI_EN directly on resume
has been removed from the -mm tree.  Its filename was
     acpi-suspend-blacklist-boxes-that-require-us-to-set-sci_en-directly-on-resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi suspend: blacklist boxes that require us to set SCI_EN directly on resume
From: Rafael J. Wysocki <rjw@sisk.pl>

Some Apple boxes evidently require us to set SCI_EN on resume directly,
because if we don't do that, they hung somewhere in the resume code path. 
Moreover, on these boxes it is not sufficient to use acpi_enable() to turn
ACPI on during resume.  All of this is against the ACPI specification
which states that (1) the BIOS is supposed to return from the S3 sleep
state with ACPI enabled (SCI_EN set) and (2) the SCI_EN bit is owned by
the hardware and we are not supposed to change it.

For this reason, blacklist the affected systems so that the SCI_EN bit is
set during resume on them.

[NOTE: Unconditional setting SCI_EN for all system on resume doesn't
 work, because it makes some other systems crash (that's to be
 expected).  Also, it is not entirely clear right now if all of the
 Apple boxes require this workaround.]

This patch fixes the recent regression tracked as
http://bugzilla.kernel.org/show_bug.cgi?id=12038

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Tested-by: Tino Keitel <tino.keitel@gmx.de>
Tested-by: Bob Copeland <me@bobcopeland.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sleep/main.c |   40 +++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff -puN drivers/acpi/sleep/main.c~acpi-suspend-blacklist-boxes-that-require-us-to-set-sci_en-directly-on-resume drivers/acpi/sleep/main.c
--- a/drivers/acpi/sleep/main.c~acpi-suspend-blacklist-boxes-that-require-us-to-set-sci_en-directly-on-resume
+++ a/drivers/acpi/sleep/main.c
@@ -104,6 +104,18 @@ void __init acpi_s4_no_nvs(void)
 	s4_no_nvs = true;
 }
 
+/*
+ * According to the ACPI specification the BIOS should make sure that ACPI is
+ * enabled and SCI_EN bit is set on wake-up from S1 - S3 sleep states.  Still,
+ * some BIOSes don't do that and therefore we use acpi_enable() to enable ACPI
+ * on such systems during resume.  Unfortunately that doesn't help in
+ * particularly pathological cases in which SCI_EN has to be set directly on
+ * resume, although the specification states very clearly that this flag is
+ * owned by the hardware.  The set_sci_en_on_resume variable will be set in such
+ * cases.
+ */
+static bool set_sci_en_on_resume;
+
 /**
  *	acpi_pm_disable_gpes - Disable the GPEs.
  */
@@ -249,7 +261,11 @@ static int acpi_suspend_enter(suspend_st
 	}
 
 	/* If ACPI is not enabled by the BIOS, we need to enable it here. */
-	acpi_enable();
+	if (set_sci_en_on_resume)
+		acpi_set_register(ACPI_BITREG_SCI_ENABLE, 1);
+	else
+		acpi_enable();
+
 	/* Reprogram control registers and execute _BFS */
 	acpi_leave_sleep_state_prep(acpi_state);
 
@@ -337,6 +353,12 @@ static int __init init_old_suspend_order
 	return 0;
 }
 
+static int __init init_set_sci_en_on_resume(const struct dmi_system_id *d)
+{
+	set_sci_en_on_resume = true;
+	return 0;
+}
+
 static struct dmi_system_id __initdata acpisleep_dmi_table[] = {
 	{
 	.callback = init_old_suspend_ordering,
@@ -354,6 +376,22 @@ static struct dmi_system_id __initdata a
 		DMI_MATCH(DMI_PRODUCT_NAME, "HP xw4600 Workstation"),
 		},
 	},
+	{
+	.callback = init_set_sci_en_on_resume,
+	.ident = "Apple MacBook 1,1",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Apple Computer, Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "MacBook1,1"),
+		},
+	},
+	{
+	.callback = init_set_sci_en_on_resume,
+	.ident = "Apple MacMini 1,1",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Apple Computer, Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Macmini1,1"),
+		},
+	},
 	{},
 };
 #endif /* CONFIG_SUSPEND */
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
radeonfb-fix-problem-with-color-expansion-alignment.patch
linux-next.patch
pnpacpi-enable-power-management.patch
vfs-fix-switch_names-breakage-in-short-to-short-case.patch
shrink_slab-handle-bad-shrinkers.patch


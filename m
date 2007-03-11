From: akpm@linux-foundation.org
Subject: + acpi-repair-nvidia-early-quirk-breakage-on-x86_64.patch added to -mm tree
Date: Sun, 11 Mar 2007 01:19:33 -0800
Message-ID: <200703110919.l2B9JXGX008601@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41053 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbXCKJU6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 05:20:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lenb@kernel.org, ak@muc.de, len.brown@intel.com


The patch titled
     ACPI: repair nvidia early quirk breakage on x86_64
has been added to the -mm tree.  Its filename is
     acpi-repair-nvidia-early-quirk-breakage-on-x86_64.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ACPI: repair nvidia early quirk breakage on x86_64
From: Len Brown <lenb@kernel.org>

x86_64 nvidia_bugs() broke when we bailed out on not finding the HPET. 
However, the quirk works by checking for _not_ finding the HPET...

Delete the nvidia_hpet_detected flag and simply test for not finding the
HPET, which is simple to do now that acpi_table_parse returns 1 on failure.

Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Andi Kleen <ak@muc.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/acpi/earlyquirk.c |    7 +------
 arch/x86_64/kernel/early-quirks.c  |    9 +--------
 2 files changed, 2 insertions(+), 14 deletions(-)

diff -puN arch/i386/kernel/acpi/earlyquirk.c~acpi-repair-nvidia-early-quirk-breakage-on-x86_64 arch/i386/kernel/acpi/earlyquirk.c
--- a/arch/i386/kernel/acpi/earlyquirk.c~acpi-repair-nvidia-early-quirk-breakage-on-x86_64
+++ a/arch/i386/kernel/acpi/earlyquirk.c
@@ -13,11 +13,8 @@
 
 #ifdef CONFIG_ACPI
 
-static int nvidia_hpet_detected __initdata;
-
 static int __init nvidia_hpet_check(struct acpi_table_header *header)
 {
-	nvidia_hpet_detected = 1;
 	return 0;
 }
 #endif
@@ -28,9 +25,7 @@ static int __init check_bridge(int vendo
 	/* According to Nvidia all timer overrides are bogus unless HPET
 	   is enabled. */
 	if (!acpi_use_timer_override && vendor == PCI_VENDOR_ID_NVIDIA) {
-		nvidia_hpet_detected = 0;
-		acpi_table_parse(ACPI_SIG_HPET, nvidia_hpet_check);
-		if (nvidia_hpet_detected == 0) {
+		if (acpi_table_parse(ACPI_SIG_HPET, nvidia_hpet_check) {
 			acpi_skip_timer_override = 1;
 			  printk(KERN_INFO "Nvidia board "
                        "detected. Ignoring ACPI "
diff -puN arch/x86_64/kernel/early-quirks.c~acpi-repair-nvidia-early-quirk-breakage-on-x86_64 arch/x86_64/kernel/early-quirks.c
--- a/arch/x86_64/kernel/early-quirks.c~acpi-repair-nvidia-early-quirk-breakage-on-x86_64
+++ a/arch/x86_64/kernel/early-quirks.c
@@ -30,11 +30,8 @@ static void __init via_bugs(void)
 
 #ifdef CONFIG_ACPI
 
-static int nvidia_hpet_detected __initdata;
-
 static int __init nvidia_hpet_check(struct acpi_table_header *header)
 {
-	nvidia_hpet_detected = 1;
 	return 0;
 }
 #endif
@@ -52,11 +49,7 @@ static void __init nvidia_bugs(void)
 	if (acpi_use_timer_override)
 		return;
 
-	nvidia_hpet_detected = 0;
-	if (acpi_table_parse(ACPI_SIG_HPET, nvidia_hpet_check))
-		return;
-
-	if (nvidia_hpet_detected == 0) {
+	if (acpi_table_parse(ACPI_SIG_HPET, nvidia_hpet_check)) {
 		acpi_skip_timer_override = 1;
 		printk(KERN_INFO "Nvidia board "
 		       "detected. Ignoring ACPI "
_

Patches currently in -mm which might be from lenb@kernel.org are

exit-acpi-processor-module-gracefully-if-acpi-is-disabled.patch
acpi-disabled-due-to-dmi-failure-or-blacklisted-year-should-be-noted-as-is-done-with-other-acpi-blacklisting.patch
i386-irq-kill-irq-compression.patch
i386-modpost-apic-related-warning-fixes.patch
acpi-repair-nvidia-early-quirk-breakage-on-x86_64.patch

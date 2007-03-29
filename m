From: akpm@linux-foundation.org
Subject: - prevent-acpi-quirk-warning-mass-spamming-in-logs.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:39:04 -0700
Message-ID: <200703292339.l2TNd47N015404@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43271 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934396AbXC2Xka (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:40:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tvignaud@mandriva.com, ak@suse.de, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     prevent ACPI quirk warning mass spamming in logs
has been removed from the -mm tree.  Its filename was
     prevent-acpi-quirk-warning-mass-spamming-in-logs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: prevent ACPI quirk warning mass spamming in logs
From: Thierry Vignaud <tvignaud@mandriva.com>

The following patch prevent this warning to be displayed again & again (eg:
nine times on my NForce2 motherboard) and thus improve signal to noise
ratio in logs.

The ATI quirk below probably needs a similar "fix" but I don't have
the hardware to test.

Btw arch/x86_64/kernel/early-quirks.c::nvidia_bugs() would probably need to
be synced (but I don't have an x86_64 NVidia motherboard to boot test it). 
Still it shows the usefullity of the recent x86 merge thread.

[akpm@linux-foundation.org: cleanup]
Signed-off-by: Thierry Vignaud <tvignaud@mandriva.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/acpi/earlyquirk.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/acpi/earlyquirk.c~prevent-acpi-quirk-warning-mass-spamming-in-logs arch/i386/kernel/acpi/earlyquirk.c
--- a/arch/i386/kernel/acpi/earlyquirk.c~prevent-acpi-quirk-warning-mass-spamming-in-logs
+++ a/arch/i386/kernel/acpi/earlyquirk.c
@@ -21,11 +21,14 @@ static int __init nvidia_hpet_check(stru
 
 static int __init check_bridge(int vendor, int device)
 {
+	static int warned;
 #ifdef CONFIG_ACPI
 	/* According to Nvidia all timer overrides are bogus unless HPET
 	   is enabled. */
 	if (!acpi_use_timer_override && vendor == PCI_VENDOR_ID_NVIDIA) {
-		if (acpi_table_parse(ACPI_SIG_HPET, nvidia_hpet_check)) {
+		if (!warned && acpi_table_parse(ACPI_SIG_HPET,
+						nvidia_hpet_check)) {
+			warned = 1;
 			acpi_skip_timer_override = 1;
 			  printk(KERN_INFO "Nvidia board "
                        "detected. Ignoring ACPI "
_

Patches currently in -mm which might be from tvignaud@mandriva.com are

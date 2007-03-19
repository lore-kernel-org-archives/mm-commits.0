From: akpm@linux-foundation.org
Subject: + prevent-acpi-quirk-warning-mass-spamming-in-logs.patch added to -mm tree
Date: Mon, 19 Mar 2007 14:24:51 -0700
Message-ID: <200703192124.l2JLOpRt017667@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57219 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964960AbXCSV0I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Mar 2007 17:26:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tvignaud@mandriva.com, ak@suse.de, lenb@kernel.org


The patch titled
     prevent ACPI quirk warning mass spamming in logs
has been added to the -mm tree.  Its filename is
     prevent-acpi-quirk-warning-mass-spamming-in-logs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Thierry Vignaud <tvignaud@mandriva.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/acpi/earlyquirk.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/acpi/earlyquirk.c~prevent-acpi-quirk-warning-mass-spamming-in-logs arch/i386/kernel/acpi/earlyquirk.c
--- a/arch/i386/kernel/acpi/earlyquirk.c~prevent-acpi-quirk-warning-mass-spamming-in-logs
+++ a/arch/i386/kernel/acpi/earlyquirk.c
@@ -21,11 +21,13 @@ static int __init nvidia_hpet_check(stru
 
 static int __init check_bridge(int vendor, int device)
 {
+	static int warned = 0;
 #ifdef CONFIG_ACPI
 	/* According to Nvidia all timer overrides are bogus unless HPET
 	   is enabled. */
 	if (!acpi_use_timer_override && vendor == PCI_VENDOR_ID_NVIDIA) {
-		if (acpi_table_parse(ACPI_SIG_HPET, nvidia_hpet_check)) {
+		if (!warned && acpi_table_parse(ACPI_SIG_HPET, nvidia_hpet_check)) {
+			warned = 1;
 			acpi_skip_timer_override = 1;
 			  printk(KERN_INFO "Nvidia board "
                        "detected. Ignoring ACPI "
_

Patches currently in -mm which might be from tvignaud@mandriva.com are

prevent-acpi-quirk-warning-mass-spamming-in-logs.patch
prevent-acpi-quirk-warning-mass-spamming-in-logs-tidy.patch

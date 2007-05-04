From: akpm@linux-foundation.org
Subject: + blacklist-dell-optiplex-320-from-using-the-hpet.patch added to -mm tree
Date: Fri, 04 May 2007 14:44:15 -0700
Message-ID: <200705042144.l44LiFb1016050@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031714AbXEDVpt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 17:45:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, ak@suse.de, guilherme@centralinf.com.br, stable@kernel.org, tglx@linutronix.de


The patch titled
     Blacklist Dell Optiplex 320 from using the HPET
has been added to the -mm tree.  Its filename is
     blacklist-dell-optiplex-320-from-using-the-hpet.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Blacklist Dell Optiplex 320 from using the HPET
From: john stultz <johnstul@us.ibm.com>

One of the 2.6.21 regressions was Guilherme's problem seeing his box lock
up when the system detected an unstable TSC and dropped back to using the
HPET.

In digging deeper, we found the HPET is not actually incrementing on this
system.  And in fact, the reason why this issue just cropped up was because
of Thomas's clocksource watchdog code was comparing the TSC to the HPET
(which wasn't moving) and thought the TSC was broken.

Anyway, Guliherme checked for a BIOS update and did not find one, so I've
added a DMI blacklist against his system so the HPET is not used.

Many thanks to Guilherme for the slow and laborious testing that finally
narrowed down this issue.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: "Guilherme M. Schroeder" <guilherme@centralinf.com.br>
Cc: Andi Kleen <ak@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/hpet.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+)

diff -puN arch/i386/kernel/hpet.c~blacklist-dell-optiplex-320-from-using-the-hpet arch/i386/kernel/hpet.c
--- a/arch/i386/kernel/hpet.c~blacklist-dell-optiplex-320-from-using-the-hpet
+++ a/arch/i386/kernel/hpet.c
@@ -5,6 +5,7 @@
 #include <linux/init.h>
 #include <linux/sysdev.h>
 #include <linux/pm.h>
+#include <linux/dmi.h>
 
 #include <asm/hpet.h>
 #include <asm/io.h>
@@ -48,6 +49,31 @@ static int __init hpet_setup(char* str)
 }
 __setup("hpet=", hpet_setup);
 
+
+/* DMI Blacklist for bad HPETs */
+static int __init dmi_mark_hpet_broken(struct dmi_system_id *d)
+{
+	printk(KERN_NOTICE "%s detected: HPET does not function.\n",
+		       d->ident);
+	boot_hpet_disable = 1;
+	return 0;
+}
+
+/* List of systems that have known HPETproblems */
+static struct dmi_system_id bad_hpet_dmi_table[] = {
+	{
+	 .callback = dmi_mark_hpet_broken,
+	 .ident = "Dell OptiPlex 320",
+	 .matches = {
+		     DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 320"),
+		     DMI_MATCH(DMI_BOARD_VENDOR, "Dell Inc."),
+		     DMI_MATCH(DMI_BOARD_NAME, "0UT237"),
+		     },
+	 },
+	 {}
+};
+
+
 static inline int is_hpet_capable(void)
 {
 	return (!boot_hpet_disable && hpet_address);
@@ -228,6 +254,8 @@ int __init hpet_enable(void)
 	uint64_t hpet_freq;
 	u64 tmp;
 
+	dmi_check_system(bad_hpet_dmi_table);
+
 	if (!is_hpet_capable())
 		return 0;
 
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

convert-h8-300-to-generic-timekeeping.patch
v850-generic-timekeeping-conversion.patch
optimize-timespec_trunc.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
move-timekeeping-code-to-timekeepingc.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
introduce-a-handy-list_first_entry-macro-v2.patch
blacklist-dell-optiplex-320-from-using-the-hpet.patch
blacklist-dell-optiplex-320-from-using-the-hpet-fix.patch
declare-struct-ktime.patch
clocksource-fix-resume-logic.patch
acpi-keep-tsc-stable-when-lapic_timer_c2_ok-is-set.patch
acpi-keep-tsc-stable-when-lapic_timer_c2_ok-is-set-vs-x86_64-mm-log-reason-why-tsc-was-marked-unstable.patch
clockevents-fix-resume-logic.patch

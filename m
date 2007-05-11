From: akpm@linux-foundation.org
Subject: - blacklist-dell-optiplex-320-from-using-the-hpet.patch removed from -mm tree
Date: Thu, 10 May 2007 23:28:28 -0700
Message-ID: <200705110628.l4B6SSf9008745@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38439 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755641AbXEKGaC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 02:30:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnstul@us.ibm.com, ak@suse.de, guilherme@centralinf.com.br, stable@kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Blacklist Dell Optiplex 320 from using the HPET
has been removed from the -mm tree.  Its filename was
     blacklist-dell-optiplex-320-from-using-the-hpet.patch

This patch was dropped because an updated version will be merged

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

[akpm@linux-foundation.org: section fix]
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: "Guilherme M. Schroeder" <guilherme@centralinf.com.br>
Cc: Andi Kleen <ak@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/hpet.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

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
@@ -48,6 +49,30 @@ static int __init hpet_setup(char* str)
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
+static struct dmi_system_id __initdata bad_hpet_dmi_table[] = {
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
 static inline int is_hpet_capable(void)
 {
 	return (!boot_hpet_disable && hpet_address);
@@ -228,6 +253,8 @@ int __init hpet_enable(void)
 	uint64_t hpet_freq;
 	u64 tmp;
 
+	dmi_check_system(bad_hpet_dmi_table);
+
 	if (!is_hpet_capable())
 		return 0;
 
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

origin.patch
blacklist-dell-optiplex-320-from-using-the-hpet.patch
introduce-boot-based-time.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
use-boot-based-time-for-uptime-in-proc.patch

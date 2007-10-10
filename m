From: akpm@linux-foundation.org
Subject: - longhaul-add-auto-enabled-revid_errata-option.patch removed from -mm tree
Date: Wed, 10 Oct 2007 14:09:55 -0700
Message-ID: <200710102109.l9AL9t4K025812@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45657 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756546AbXJJVKQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Oct 2007 17:10:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rafalbilski@interia.pl, davej@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Longhaul: add auto enabled "revid_errata" option
has been removed from the -mm tree.  Its filename was
     longhaul-add-auto-enabled-revid_errata-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Longhaul: add auto enabled "revid_errata" option
From: Rafal Bilski <rafalbilski@interia.pl>

VIA C3 Ezra-T has RevisionID equal to 1, but it needs RevisionKey to be 0
or CPU will ignore new frequency and will continue to work at old
frequency.  New "revid_errata" option will force RevisionKey to be set to
0, whatever RevisionID is.

Additionaly "Longhaul" will not silently ignore unsuccessful transition. 
It will try to check if "revid_errata" or "disable_acpi_c3" options need to
be enabled for this processor/system.

Same for Longhaul ver.  2 support.  It will be disabled if none of above
options will work.

 Best case scenario (with patch apllied and v2 enabled):
 longhaul: VIA C3 'Ezra' [C5C] CPU detected.  Longhaul v2 supported.
 longhaul: Using northbridge support.
 longhaul: VRM 8.5
 longhaul: Max VID=1.350  Min VID=1.050, 13 possible voltage scales
 longhaul: f: 300000 kHz, index: 0, vid: 1050 mV
 [...]
 longhaul: Voltage scaling enabled.
 Worst case scenario:
 longhaul: VIA C3 'Ezra-T' [C5M] CPU detected.  Powersaver supported.
 longhaul: Using northbridge support.
 longhaul: Using ACPI support.
 longhaul: VRM 8.5
 longhaul: Claims to support voltage scaling but min & max are both 1.250. Voltage scaling disabled
 longhaul: Failed to set requested frequency!
 longhaul: Enabling "Ignore Revision ID" option.
 longhaul: Failed to set requested frequency!
 longhaul: Disabling ACPI C3 support.
 longhaul: Disabling "Ignore Revision ID" option.
 longhaul: Failed to set requested frequency!
 longhaul: Enabling "Ignore Revision ID" option.

[akpm@linux-foundation.org: coding-style cleanups]
Signed-off-by: Rafal Bilski <rafalbilski@interia.pl>
Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/cpufreq/longhaul.c |   60 ++++++++++++++++++++--
 1 file changed, 57 insertions(+), 3 deletions(-)

diff -puN arch/i386/kernel/cpu/cpufreq/longhaul.c~longhaul-add-auto-enabled-revid_errata-option arch/i386/kernel/cpu/cpufreq/longhaul.c
--- a/arch/i386/kernel/cpu/cpufreq/longhaul.c~longhaul-add-auto-enabled-revid_errata-option
+++ a/arch/i386/kernel/cpu/cpufreq/longhaul.c
@@ -76,6 +76,7 @@ static unsigned int longhaul_index;
 /* Module parameters */
 static int scale_voltage;
 static int disable_acpi_c3;
+static int revid_errata;
 
 #define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "longhaul", msg)
 
@@ -168,7 +169,10 @@ static void do_powersaver(int cx_address
 
 	rdmsrl(MSR_VIA_LONGHAUL, longhaul.val);
 	/* Setup new frequency */
-	longhaul.bits.RevisionKey = longhaul.bits.RevisionID;
+	if (!revid_errata)
+		longhaul.bits.RevisionKey = longhaul.bits.RevisionID;
+	else
+		longhaul.bits.RevisionKey = 0;
 	longhaul.bits.SoftBusRatio = clock_ratio_index & 0xf;
 	longhaul.bits.SoftBusRatio4 = (clock_ratio_index & 0x10) >> 4;
 	/* Setup new voltage */
@@ -272,7 +276,7 @@ static void longhaul_setstate(unsigned i
 
 	dprintk ("Setting to FSB:%dMHz Mult:%d.%dx (%s)\n",
 			fsb, mult/10, mult%10, print_speed(speed/1000));
-
+retry_loop:
 	preempt_disable();
 	local_irq_save(flags);
 
@@ -344,6 +348,47 @@ static void longhaul_setstate(unsigned i
 	preempt_enable();
 
 	freqs.new = calc_speed(longhaul_get_cpu_mult());
+	/* Check if requested frequency is set. */
+	if (unlikely(freqs.new != speed)) {
+		printk(KERN_INFO PFX "Failed to set requested frequency!\n");
+		/* Revision ID = 1 but processor is expecting revision key
+		 * equal to 0. Jumpers at the bottom of processor will change
+		 * multiplier and FSB, but will not change bits in Longhaul
+		 * MSR nor enable voltage scaling. */
+		if (!revid_errata) {
+			printk(KERN_INFO PFX "Enabling \"Ignore Revision ID\" "
+						"option.\n");
+			revid_errata = 1;
+			msleep(200);
+			goto retry_loop;
+		}
+		/* Why ACPI C3 sometimes doesn't work is a mystery for me.
+		 * But it does happen. Processor is entering ACPI C3 state,
+		 * but it doesn't change frequency. I tried poking various
+		 * bits in northbridge registers, but without success. */
+		if (longhaul_flags & USE_ACPI_C3) {
+			printk(KERN_INFO PFX "Disabling ACPI C3 support.\n");
+			longhaul_flags &= ~USE_ACPI_C3;
+			if (revid_errata) {
+				printk(KERN_INFO PFX "Disabling \"Ignore "
+						"Revision ID\" option.\n");
+				revid_errata = 0;
+			}
+			msleep(200);
+			goto retry_loop;
+		}
+		/* This shouldn't happen. Longhaul ver. 2 was reported not
+		 * working on processors without voltage scaling, but with
+		 * RevID = 1. RevID errata will make things right. Just
+		 * to be 100% sure. */
+		if (longhaul_version == TYPE_LONGHAUL_V2) {
+			printk(KERN_INFO PFX "Switching to Longhaul ver. 1\n");
+			longhaul_version = TYPE_LONGHAUL_V1;
+			msleep(200);
+			goto retry_loop;
+		}
+	}
+	/* Report true CPU frequency */
 	cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 
 	if (!bm_timeout)
@@ -956,11 +1001,20 @@ static void __exit longhaul_exit(void)
 	kfree(longhaul_table);
 }
 
+/* Even if BIOS is exporting ACPI C3 state, and it is used
+ * with success when CPU is idle, this state doesn't
+ * trigger frequency transition in some cases. */
 module_param (disable_acpi_c3, int, 0644);
 MODULE_PARM_DESC(disable_acpi_c3, "Don't use ACPI C3 support");
-
+/* Change CPU voltage with frequency. Very usefull to save
+ * power, but most VIA C3 processors aren't supporting it. */
 module_param (scale_voltage, int, 0644);
 MODULE_PARM_DESC(scale_voltage, "Scale voltage of processor");
+/* Force revision key to 0 for processors which doesn't
+ * support voltage scaling, but are introducing itself as
+ * such. */
+module_param(revid_errata, int, 0644);
+MODULE_PARM_DESC(revid_errata, "Ignore CPU Revision ID");
 
 MODULE_AUTHOR ("Dave Jones <davej@codemonkey.org.uk>");
 MODULE_DESCRIPTION ("Longhaul driver for VIA Cyrix processors.");
_

Patches currently in -mm which might be from rafalbilski@interia.pl are

git-cpufreq.patch

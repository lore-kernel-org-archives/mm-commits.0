From: akpm@linux-foundation.org
Subject: [merged] cpufreq-powernow-k8-cleanup-msg-if-bios-does-not-export-acpi-_pss-cpufreq-data.patch removed from -mm tree
Date: Wed, 27 May 2009 13:55:33 -0700
Message-ID: <200905272055.n4RKtXAp025805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37861 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758749AbZE0U4b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 May 2009 16:56:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: trenn@suse.de, davej@codemonkey.org.uk, lmilano@gmx.net, mark.langsdorf@amd.com, mingo@elte.hu, rui.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     cpufreq: powernow-k8 cleanup msg if BIOS does not export ACPI _PSS cpufreq data
has been removed from the -mm tree.  Its filename was
     cpufreq-powernow-k8-cleanup-msg-if-bios-does-not-export-acpi-_pss-cpufreq-data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpufreq: powernow-k8 cleanup msg if BIOS does not export ACPI _PSS cpufreq data
From: Thomas Renninger <trenn@suse.de>

- Make the message shorter and easier to grep for
- Use printk_once instead of WARN_ONCE (functionality of these was mixed up)

Also see bug: http://bugzilla.kernel.org/show_bug.cgi?id=13146 for
reference.

(akpm: the kernel warning is misleading - change it to blame sthe BIOS
vendor and not us ;)

Signed-off-by: Thomas Renninger <trenn@suse.de>
Cc: Langsdorf, Mark <mark.langsdorf@amd.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Leo Milano <lmilano@gmx.net>
Cc: "Zhang, Rui" <rui.zhang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff -puN arch/x86/kernel/cpu/cpufreq/powernow-k8.c~cpufreq-powernow-k8-cleanup-msg-if-bios-does-not-export-acpi-_pss-cpufreq-data arch/x86/kernel/cpu/cpufreq/powernow-k8.c
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c~cpufreq-powernow-k8-cleanup-msg-if-bios-does-not-export-acpi-_pss-cpufreq-data
+++ a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1215,13 +1215,16 @@ static int powernowk8_verify(struct cpuf
 	return cpufreq_frequency_table_verify(pol, data->powernow_table);
 }
 
+static const char ACPI_PSS_BIOS_BUG_MSG[] =
+	KERN_ERR FW_BUG PFX "No compatible ACPI _PSS objects found.\n"
+	KERN_ERR FW_BUG PFX "Try again with latest BIOS.\n";
+
 /* per CPU init entry point to the driver */
 static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 {
 	struct powernow_k8_data *data;
 	cpumask_t oldmask;
 	int rc;
-	static int print_once;
 
 	if (!cpu_online(pol->cpu))
 		return -ENODEV;
@@ -1244,19 +1247,7 @@ static int __cpuinit powernowk8_cpu_init
 		 * an UP version, and is deprecated by AMD.
 		 */
 		if (num_online_cpus() != 1) {
-			/*
-			 * Replace this one with print_once as soon as such a
-			 * thing gets introduced
-			 */
-			if (!print_once) {
-				WARN_ONCE(1, KERN_ERR FW_BUG PFX "Your BIOS "
-					"does not provide ACPI _PSS objects "
-					"in a way that Linux understands. "
-					"Please report this to the Linux ACPI"
-					" maintainers and complain to your "
-					"BIOS vendor.\n");
-				print_once++;
-			}
+			printk_once(ACPI_PSS_BIOS_BUG_MSG);
 			goto err_out;
 		}
 		if (pol->cpu != 0) {
_

Patches currently in -mm which might be from trenn@suse.de are

origin.patch
linux-next.patch
cpufreq-powernow-k8-cleanup-msg-if-bios-does-not-export-acpi-_pss-cpufreq-data-cleanup.patch


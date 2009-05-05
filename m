From: akpm@linux-foundation.org
Subject: + cpufreq-powernow-k8-cleanup-msg-if-bios-does-not-export-acpi-_pss-cpufreq-data.patch added to -mm tree
Date: Tue, 05 May 2009 13:39:16 -0700
Message-ID: <200905052039.n45KdGHV020204@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36963 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753625AbZEEUmn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2009 16:42:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: trenn@suse.de, davej@codemonkey.org.uk, mark.langsdorf@amd.com, mingo@elte.hu


The patch titled
     cpufreq: powernow-k8 cleanup msg if BIOS does not export ACPI _PSS cpufreq data
has been added to the -mm tree.  Its filename is
     cpufreq-powernow-k8-cleanup-msg-if-bios-does-not-export-acpi-_pss-cpufreq-data.patch

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
Subject: cpufreq: powernow-k8 cleanup msg if BIOS does not export ACPI _PSS cpufreq data
From: Thomas Renninger <trenn@suse.de>

- Make the message shorter and easier to grep for
- Use printk_once instead of WARN_ONCE (functionality of these was mixed up)

Also see bug: http://bugzilla.kernel.org/show_bug.cgi?id=13146
for reference.

Signed-off-by: Thomas Renninger <trenn@suse.de>
Cc: Langsdorf, Mark <mark.langsdorf@amd.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff -puN arch/x86/kernel/cpu/cpufreq/powernow-k8.c~cpufreq-powernow-k8-cleanup-msg-if-bios-does-not-export-acpi-_pss-cpufreq-data arch/x86/kernel/cpu/cpufreq/powernow-k8.c
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c~cpufreq-powernow-k8-cleanup-msg-if-bios-does-not-export-acpi-_pss-cpufreq-data
+++ a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1234,12 +1234,15 @@ static long __cpuinit powernowk8_cpu_ini
 	return 0;
 }
 
+static const char ACPI_PSS_BIOS_BUG_MSG[] =
+	KERN_ERR FW_BUG PFX "No compatible ACPI _PSS objects found.\n"
+	KERN_ERR FW_BUG PFX "Try again with latest BIOS.\n";
+
 /* per CPU init entry point to the driver */
 static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 {
 	struct powernow_k8_data *data;
 	int rc;
-	static int print_once;
 
 	if (!cpu_online(pol->cpu))
 		return -ENODEV;
@@ -1263,19 +1266,7 @@ static int __cpuinit powernowk8_cpu_init
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

cpufreq-powernow-k8-cleanup-msg-if-bios-does-not-export-acpi-_pss-cpufreq-data.patch
cpufreq-powernow-k8-determine-exact-cpu-frequency-for-hw-pstates.patch


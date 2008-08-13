From: akpm@linux-foundation.org
Subject: - cpu-hotplug-s390-doesnt-support-additional_cpus-anymore.patch removed from -mm tree
Date: Wed, 13 Aug 2008 01:52:15 -0700
Message-ID: <200808130852.m7D8qF7o008191@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752212AbYHMIxu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 04:53:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     cpu hotplug: s390 doesn't support additional_cpus anymore.
has been removed from the -mm tree.  Its filename was
     cpu-hotplug-s390-doesnt-support-additional_cpus-anymore.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpu hotplug: s390 doesn't support additional_cpus anymore.
From: Heiko Carstens <heiko.carstens@de.ibm.com>

s390 doesn't support the additional_cpus kernel parameter anymore since a
long time.  So we better update the code and documentation to reflect
that.

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cpu-hotplug.txt |    5 -----
 kernel/cpu.c                  |    2 +-
 2 files changed, 1 insertion(+), 6 deletions(-)

diff -puN Documentation/cpu-hotplug.txt~cpu-hotplug-s390-doesnt-support-additional_cpus-anymore Documentation/cpu-hotplug.txt
--- a/Documentation/cpu-hotplug.txt~cpu-hotplug-s390-doesnt-support-additional_cpus-anymore
+++ a/Documentation/cpu-hotplug.txt
@@ -59,15 +59,10 @@ apicid values in those tables for disabl
 mark such hot-pluggable cpus as disabled entries, one could use this
 parameter "additional_cpus=x" to represent those cpus in the cpu_possible_map.
 
-s390 uses the number of cpus it detects at IPL time to also the number of bits
-in cpu_possible_map. If it is desired to add additional cpus at a later time
-the number should be specified using this option or the possible_cpus option.
-
 possible_cpus=n		[s390 only] use this to set hotpluggable cpus.
 			This option sets possible_cpus bits in
 			cpu_possible_map. Thus keeping the numbers of bits set
 			constant even if the machine gets rebooted.
-			This option overrides additional_cpus.
 
 CPU maps and such
 -----------------
diff -puN kernel/cpu.c~cpu-hotplug-s390-doesnt-support-additional_cpus-anymore kernel/cpu.c
--- a/kernel/cpu.c~cpu-hotplug-s390-doesnt-support-additional_cpus-anymore
+++ a/kernel/cpu.c
@@ -369,7 +369,7 @@ int __cpuinit cpu_up(unsigned int cpu)
 	if (!cpu_isset(cpu, cpu_possible_map)) {
 		printk(KERN_ERR "can't online cpu %d because it is not "
 			"configured as may-hotadd at boot time\n", cpu);
-#if defined(CONFIG_IA64) || defined(CONFIG_X86_64) || defined(CONFIG_S390)
+#if defined(CONFIG_IA64) || defined(CONFIG_X86_64)
 		printk(KERN_ERR "please check additional_cpus= boot "
 				"parameter\n");
 #endif
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

linux-next.patch


From: akpm@linux-foundation.org
Subject: + x86-use-num_online_nodes-to-get-physical-cpus-numbers-for.patch added to -mm tree
Date: Thu, 23 Aug 2007 16:14:51 -0700
Message-ID: <200708232314.l7NNEpoB031970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41850 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755945AbXHWXOy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 19:14:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Yinghai.Lu@Sun.COM


The patch titled
     x86: use num_online_nodes to get physical cpus numbers for powernow_k8
has been added to the -mm tree.  Its filename is
     x86-use-num_online_nodes-to-get-physical-cpus-numbers-for.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86: use num_online_nodes to get physical cpus numbers for powernow_k8
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

For opteron based system, don't assume all physical cpus have the same
booted cpus even same cores.  esp for downcore case.

Signed-off-by: Yinghai Lu <yinghai.sun.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/cpufreq/powernow-k8.c |    7 +------
 1 files changed, 1 insertion(+), 6 deletions(-)

diff -puN arch/i386/kernel/cpu/cpufreq/powernow-k8.c~x86-use-num_online_nodes-to-get-physical-cpus-numbers-for arch/i386/kernel/cpu/cpufreq/powernow-k8.c
--- a/arch/i386/kernel/cpu/cpufreq/powernow-k8.c~x86-use-num_online_nodes-to-get-physical-cpus-numbers-for
+++ a/arch/i386/kernel/cpu/cpufreq/powernow-k8.c
@@ -1327,21 +1327,16 @@ static struct cpufreq_driver cpufreq_amd
 static int __cpuinit powernowk8_init(void)
 {
 	unsigned int i, supported_cpus = 0;
-	unsigned int booted_cores = 1;
 
 	for_each_online_cpu(i) {
 		if (check_supported_cpu(i))
 			supported_cpus++;
 	}
 
-#ifdef CONFIG_SMP
-	booted_cores = cpu_data[0].booted_cores;
-#endif
-
 	if (supported_cpus == num_online_cpus()) {
 		printk(KERN_INFO PFX "Found %d %s "
 			"processors (%d cpu cores) (" VERSION ")\n",
-			supported_cpus/booted_cores,
+			num_online_nodes(),
 			boot_cpu_data.x86_model_id, supported_cpus);
 		return cpufreq_register_driver(&cpufreq_amd64_driver);
 	}
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

serial-keep-the-dtr-setting-for-serial-console.patch
x86_64-get-mp_bus_to_node-as-early-v3.patch
x86_64-get-mp_bus_to_node-as-early-v3-update.patch
x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch
try-parent-numa_node-at-first-before-using-default.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
x86-make-io-apic-not-connected-pin-print-complete.patch
x86-use-num_online_nodes-to-get-physical-cpus-numbers-for.patch

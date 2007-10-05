From: akpm@linux-foundation.org
Subject: - x86-use-num_online_nodes-to-get-physical-cpus-numbers-for.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:58:31 -0700
Message-ID: <200710051958.l95JwVsN022551@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54502 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761130AbXJEUBC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 16:01:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@Sun.COM, mm-commits@vger.kernel.org


The patch titled
     x86: use num_online_nodes to get physical cpus numbers for powernow_k8
has been removed from the -mm tree.  Its filename was
     x86-use-num_online_nodes-to-get-physical-cpus-numbers-for.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86: use num_online_nodes to get physical cpus numbers for powernow_k8
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

For opteron based system, don't assume all physical cpus have the same
booted cpus even same cores.  esp for downcore case.

Signed-off-by: Yinghai Lu <yinghai.sun.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/cpufreq/powernow-k8.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

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

git-cpufreq.patch
serial-keep-the-dtr-setting-for-serial-console.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
x86-make-io-apic-not-connected-pin-print-complete.patch
x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is.patch
kernel-printkc-concerns-about-the-console-handover.patch

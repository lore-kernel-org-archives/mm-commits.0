From: akpm@linux-foundation.org
Subject: + cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified.patch added to -mm tree
Date: Fri, 28 Sep 2007 15:31:02 -0700
Message-ID: <200709282231.l8SMV2cw020579@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34492 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754937AbXI1WbF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Sep 2007 18:31:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     CPU HOTPLUG: avoid hotadd when proper possible_map isn't specified
has been added to the -mm tree.  Its filename is
     cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: CPU HOTPLUG: avoid hotadd when proper possible_map isn't specified
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

cpu-hot-add should be fail if cpu is not set in cpu_possible_map.  If go
ahead, the system will panic soon.

Especially, arch which requires additional_cpus= parameter should handle
this.  Tested on ia64.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN kernel/cpu.c~cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified kernel/cpu.c
--- a/kernel/cpu.c~cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified
+++ a/kernel/cpu.c
@@ -265,6 +265,14 @@ out_notify:
 int __cpuinit cpu_up(unsigned int cpu)
 {
 	int err = 0;
+	if (!cpu_isset(cpu, cpu_possible_map)) {
+		printk("can't online cpu %d because it is not configured "
+		       "as may-hotadded at boot time\n", cpu);
+#if defined(CONFIG_IA64) || defined (CONFIG_X86_64) || defined(CONFIG_S390)
+		printk("please check additional_cpus= boot parameter\n");
+#endif
+		return -EINVAL;
+	}
 
 	mutex_lock(&cpu_add_remove_lock);
 	if (cpu_hotplug_disabled)
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-for-sparsemem-fix.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support-convert-to-new-helper-based-initialisation.patch
sparc64-sparsemem_vmemmap-support.patch
sparc64-sparsemem_vmemmap-support-vmemmap-convert-to-new-config-options.patch
ppc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support-convert-to-new-config-options.patch
memoryless-nodes-generic-management-of-nodemasks-for-various-purposes.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
update-n_high_memory-node-state-for-memory-hotadd.patch
memoryless-nodes-fix-interleave-behavior-for-memoryless-nodes.patch
memoryless-nodes-oom-use-n_high_memory-map-instead-of-constructing-one-on-the-fly.patch
memoryless-nodes-no-need-for-kswapd.patch
memoryless-nodes-slab-support.patch
memoryless-nodes-slub-support.patch
memoryless-nodes-uncached-allocator-updates.patch
memoryless-nodes-allow-profiling-data-to-fall-back-to-other-nodes.patch
memoryless-nodes-update-memory-policy-and-page-migration.patch
memoryless-nodes-add-n_cpu-node-state.patch
memoryless-nodes-add-n_cpu-node-state-move-setup-of-n_cpu-node-state-mask.patch
memoryless-nodes-drop-one-memoryless-node-boot-warning.patch
memoryless-nodes-fix-gfp_thisnode-behavior.patch
memoryless-nodes-use-n_high_memory-for-cpusets.patch
flush-cache-before-installing-new-page-at-migraton.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix-update.patch
memory-unplug-v7-memory-hotplug-cleanup.patch
memory-unplug-v7-page-isolation.patch
memory-unplug-v7-page-offline.patch
memory-unplug-v7-page-offline-fix.patch
memory-unplug-v7-ia64-interface.patch
fix-memory-hot-remove-not-configured-case.patch
fix-memory-hot-remove-not-configured-case-fix.patch
memory-controller-make-charging-gfp-mask-aware-fix.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified.patch

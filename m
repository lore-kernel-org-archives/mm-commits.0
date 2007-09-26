From: akpm@linux-foundation.org
Subject: + memory-unplug-v7-page-offline-fix.patch added to -mm tree
Date: Tue, 25 Sep 2007 18:55:00 -0700
Message-ID: <200709260155.l8Q1t0HU014795@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57151 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752499AbXIZBzE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Sep 2007 21:55:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, y-goto@jp.fujitsu.com


The patch titled
     memory-unplug-v7-page-offline fix
has been added to the -mm tree.  Its filename is
     memory-unplug-v7-page-offline-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: memory-unplug-v7-page-offline fix
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

MEMORY_HOTREMOVE config option is selectable even it arch doesn't support it.
This fix it.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/Kconfig |    3 +++
 mm/Kconfig        |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN arch/ia64/Kconfig~memory-unplug-v7-page-offline-fix arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~memory-unplug-v7-page-offline-fix
+++ a/arch/ia64/Kconfig
@@ -305,6 +305,9 @@ config HOTPLUG_CPU
 config ARCH_ENABLE_MEMORY_HOTPLUG
 	def_bool y
 
+config ARCH_ENABLE_MEMORY_HOTREMOVE
+	def_bool y
+
 config SCHED_SMT
 	bool "SMT scheduler support"
 	depends on SMP
diff -puN mm/Kconfig~memory-unplug-v7-page-offline-fix mm/Kconfig
--- a/mm/Kconfig~memory-unplug-v7-page-offline-fix
+++ a/mm/Kconfig
@@ -141,7 +141,7 @@ config MEMORY_HOTPLUG_SPARSE
 
 config MEMORY_HOTREMOVE
 	bool "Allow for memory hot remove"
-	depends on MEMORY_HOTPLUG
+	depends on MEMORY_HOTPLUG && ARCH_ENABLE_MEMORY_HOTREMOVE
 	depends on MIGRATION
 
 # Heavily threaded applications may benefit from splitting the mm-wide
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

git-net.patch
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

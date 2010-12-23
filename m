From: akpm@linux-foundation.org
Subject: [to-be-updated] numa-hotplug-emulator-add-numa=possible-option.patch removed from -mm tree
Date: Thu, 23 Dec 2010 15:17:21 -0800
Message-ID: <201012232350.oBNNoU2A018252@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39284 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751481Ab0LWXwU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Dec 2010 18:52:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, dave@linux.vnet.ibm.com, emunson@mgebm.net, gregkh@suse.de, haicheng.li@intel.com, hpa@zytor.com, len.brown@intel.com, lethal@linux-sh.org, mingo@elte.hu, randy.d


The patch titled
     NUMA hotplug emulator: add numa=possible option
has been removed from the -mm tree.  Its filename was
     numa-hotplug-emulator-add-numa=possible-option.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: NUMA hotplug emulator: add numa=possible option
From: David Rientjes <rientjes@google.com>

Adds a numa=possible=<N> command line option to set an additional N nodes
as being possible for memory hotplug.  This set of possible nodes controls
nr_node_ids and the sizes of several dynamically allocated node arrays.

This allows memory hotplug to create new nodes for newly added memory
rather than binding it to existing nodes.

The first use-case for this will be node hotplug emulation which will use
these possible nodes to create new nodes to test the memory hotplug
callbacks and surrounding memory hotplug code.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Shaohui Zheng <shaohui.zheng@intel.com>
Reviewed-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Haicheng Li <haicheng.li@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/x86/x86_64/boot-options.txt |    4 ++++
 arch/x86/mm/numa_64.c                     |   18 +++++++++++++++---
 2 files changed, 19 insertions(+), 3 deletions(-)

diff -puN Documentation/x86/x86_64/boot-options.txt~numa-hotplug-emulator-add-numa=possible-option Documentation/x86/x86_64/boot-options.txt
--- a/Documentation/x86/x86_64/boot-options.txt~numa-hotplug-emulator-add-numa=possible-option
+++ a/Documentation/x86/x86_64/boot-options.txt
@@ -174,6 +174,10 @@ NUMA
 		If given as an integer, fills all system RAM with N fake nodes
 		interleaved over physical nodes.
 
+  numa=possible=<N>
+		Sets an additional N nodes as being possible for memory
+		hotplug.
+
 ACPI
 
   acpi=off	Don't enable ACPI
diff -puN arch/x86/mm/numa_64.c~numa-hotplug-emulator-add-numa=possible-option arch/x86/mm/numa_64.c
--- a/arch/x86/mm/numa_64.c~numa-hotplug-emulator-add-numa=possible-option
+++ a/arch/x86/mm/numa_64.c
@@ -33,6 +33,7 @@ s16 apicid_to_node[MAX_LOCAL_APIC] __cpu
 int numa_off __initdata;
 static unsigned long __initdata nodemap_addr;
 static unsigned long __initdata nodemap_size;
+static unsigned long __initdata numa_possible_nodes;
 
 /*
  * Map cpu index to node index
@@ -611,7 +612,7 @@ void __init initmem_init(unsigned long s
 
 #ifdef CONFIG_NUMA_EMU
 	if (cmdline && !numa_emulation(start_pfn, last_pfn, acpi, amd))
-		return;
+		goto out;
 	nodes_clear(node_possible_map);
 	nodes_clear(node_online_map);
 #endif
@@ -619,14 +620,14 @@ void __init initmem_init(unsigned long s
 #ifdef CONFIG_ACPI_NUMA
 	if (!numa_off && acpi && !acpi_scan_nodes(start_pfn << PAGE_SHIFT,
 						  last_pfn << PAGE_SHIFT))
-		return;
+		goto out;
 	nodes_clear(node_possible_map);
 	nodes_clear(node_online_map);
 #endif
 
 #ifdef CONFIG_AMD_NUMA
 	if (!numa_off && amd && !amd_scan_nodes())
-		return;
+		goto out;
 	nodes_clear(node_possible_map);
 	nodes_clear(node_online_map);
 #endif
@@ -646,6 +647,15 @@ void __init initmem_init(unsigned long s
 		numa_set_node(i, 0);
 	memblock_x86_register_active_regions(0, start_pfn, last_pfn);
 	setup_node_bootmem(0, start_pfn << PAGE_SHIFT, last_pfn << PAGE_SHIFT);
+out: __maybe_unused
+	for (i = 0; i < numa_possible_nodes; i++) {
+		int nid;
+
+		nid = first_unset_node(node_possible_map);
+		if (nid == MAX_NUMNODES)
+			break;
+		node_set(nid, node_possible_map);
+	}
 }
 
 unsigned long __init numa_free_all_bootmem(void)
@@ -675,6 +685,8 @@ static __init int numa_setup(char *opt)
 	if (!strncmp(opt, "noacpi", 6))
 		acpi_numa = -1;
 #endif
+	if (!strncmp(opt, "possible=", 9))
+		numa_possible_nodes = simple_strtoul(opt + 9, NULL, 0);
 	return 0;
 }
 early_param("numa", numa_setup);
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low.patch
mm-remove-unused-get_vm_area_node.patch
mm-remove-gfp-mask-from-pcpu_get_vm_areas.patch
mm-unify-module_alloc-code-for-vmalloc.patch
oom-allow-a-non-cap_sys_resource-proces-to-oom_score_adj-down.patch
thp-transparent-hugepage-sysfs-meminfo.patch
numa-hotplug-emulator-add-node-hotplug-emulation.patch
numa-hotplug-emulator-abstract-cpu-register-functions.patch
numa-hotplug-emulator-support-cpu-probe-release-in-x86_64.patch
numa-hotplug-emulator-fake-cpu-socket-with-logical-cpu-on-x86.patch
numa-hotplug-emulator-implement-per-node-add_memory-debugfs-interface.patch
flex_array-export-symbols-to-modules.patch
jbd-remove-dependency-on-__gfp_nofail.patch
memcg-fix-unit-mismatch-in-memcg-oom-limit-calculation.patch
proc-use-single_open-correctly.patch


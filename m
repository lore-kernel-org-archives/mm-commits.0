From: akpm@osdl.org
Subject: + virtual-memmap-on-sparsemem-v3-static-virtual.patch added to -mm tree
Date: Fri, 08 Dec 2006 16:30:43 -0800
Message-ID: <200612090030.kB90UhuD011054@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57149 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947586AbWLIAb2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 19:31:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, apw@shadowen.org, clameter@engr.sgi.com, haveblue@us.ibm.com, mbligh@google.com, tony.luck@intel.com


The patch titled
     virtual memmap on sparsemem: static virtual  mem_map
has been added to the -mm tree.  Its filename is
     virtual-memmap-on-sparsemem-v3-static-virtual.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: virtual memmap on sparsemem: static virtual  mem_map
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Add support for statically allocated virtual mem_map.  (means virtual address
of mem_map array is defined statically.) This removes reference to
*(&mem_map).

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/mmzone.h |    5 +++++
 mm/Kconfig             |    4 ++++
 mm/memory.c            |    2 ++
 3 files changed, 11 insertions(+)

diff -puN include/linux/mmzone.h~virtual-memmap-on-sparsemem-v3-static-virtual include/linux/mmzone.h
--- a/include/linux/mmzone.h~virtual-memmap-on-sparsemem-v3-static-virtual
+++ a/include/linux/mmzone.h
@@ -693,8 +693,13 @@ extern int __section_nr(struct mem_secti
 #if (((BITS_PER_LONG/4) * PAGES_PER_SECTION) % PAGE_SIZE) != 0
 #error "PAGE_SIZE/SECTION_SIZE relationship is not suitable for vmem_map"
 #endif
+#ifdef CONFIG_SPARSEMEM_VMEMMAP_STATIC
+#include <linux/mm_types.h>
+extern struct page mem_map[];
+#else
 extern struct page* mem_map;
 #endif
+#endif
 
 static inline struct page *__section_mem_map_addr(struct mem_section *section)
 {
diff -puN mm/Kconfig~virtual-memmap-on-sparsemem-v3-static-virtual mm/Kconfig
--- a/mm/Kconfig~virtual-memmap-on-sparsemem-v3-static-virtual
+++ a/mm/Kconfig
@@ -121,6 +121,10 @@ config SPARSEMEM_VMEMMAP
 	  But this consumes huge amount of virtual memory(not physical).
 	  This option is selectable only if your arch supports it.
 
+config SPARSEMEM_VMEMMAP_STATIC
+	def_bool y
+	depends on ARCH_SPARSEMEM_VMEMMAP_STATIC
+
 # eventually, we can have this option just 'select SPARSEMEM'
 config MEMORY_HOTPLUG
 	bool "Allow for memory hot-add"
diff -puN mm/memory.c~virtual-memmap-on-sparsemem-v3-static-virtual mm/memory.c
--- a/mm/memory.c~virtual-memmap-on-sparsemem-v3-static-virtual
+++ a/mm/memory.c
@@ -71,7 +71,9 @@ EXPORT_SYMBOL(mem_map);
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 /* for the virtual mem_map */
+#ifndef CONFIG_SPARSEMEM_VMEMMAP_STATIC
 struct page *mem_map;
+#endif
 EXPORT_SYMBOL(mem_map);
 #endif
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap.patch
virtual-memmap-on-sparsemem-v3-generic-virtual.patch
virtual-memmap-on-sparsemem-v3-static-virtual.patch
virtual-memmap-on-sparsemem-v3-ia64-support.patch
sched-avoid-taking-rq-lock-in-wake_priority_sleeper.patch
sched-remove-staggering-of-load-balancing.patch
sched-disable-interrupts-for-locking-in-load_balance.patch
sched-extract-load-calculation-from-rebalance_tick.patch
sched-move-idle-status-calculation-into-rebalance_tick.patch
sched-use-softirq-for-load-balancing.patch
sched-call-tasklet-less-frequently.patch
sched-add-option-to-serialize-load-balancing.patch
sched-add-option-to-serialize-load-balancing-fix.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
reiser4-hardirq-include-fix.patch


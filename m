From: akpm@linux-foundation.org
Subject: - memory-hotplug-make-alloc_bootmem_section.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:53:57 -0700
Message-ID: <200804282153.m3SLrvNA017945@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51353 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934933AbYD1V7v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:59:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: y-goto@jp.fujitsu.com, pbadari@us.ibm.com, yhlu.kernel@gmail.com, mm-commits@vger.kernel.org


The patch titled
     memory hotplug: make alloc_bootmem_section()
has been removed from the -mm tree.  Its filename was
     memory-hotplug-make-alloc_bootmem_section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory hotplug: make alloc_bootmem_section()
From: Yasunori Goto <y-goto@jp.fujitsu.com>

alloc_bootmem_section() can allocate specified section's area.  This is used
for usemap to keep same section with pgdat by later patch.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem.h |    2 ++
 mm/bootmem.c            |   31 +++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff -puN include/linux/bootmem.h~memory-hotplug-make-alloc_bootmem_section include/linux/bootmem.h
--- a/include/linux/bootmem.h~memory-hotplug-make-alloc_bootmem_section
+++ a/include/linux/bootmem.h
@@ -101,6 +101,8 @@ extern void reserve_bootmem_node(pg_data
 extern void free_bootmem_node(pg_data_t *pgdat,
 			      unsigned long addr,
 			      unsigned long size);
+extern void *alloc_bootmem_section(unsigned long size,
+				   unsigned long section_nr);
 
 #ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
 #define alloc_bootmem_node(pgdat, x) \
diff -puN mm/bootmem.c~memory-hotplug-make-alloc_bootmem_section mm/bootmem.c
--- a/mm/bootmem.c~memory-hotplug-make-alloc_bootmem_section
+++ a/mm/bootmem.c
@@ -545,6 +545,37 @@ void * __init __alloc_bootmem_node(pg_da
 	return __alloc_bootmem(size, align, goal);
 }
 
+#ifdef CONFIG_SPARSEMEM
+void * __init alloc_bootmem_section(unsigned long size,
+				    unsigned long section_nr)
+{
+	void *ptr;
+	unsigned long limit, goal, start_nr, end_nr, pfn;
+	struct pglist_data *pgdat;
+
+	pfn = section_nr_to_pfn(section_nr);
+	goal = PFN_PHYS(pfn);
+	limit = PFN_PHYS(section_nr_to_pfn(section_nr + 1)) - 1;
+	pgdat = NODE_DATA(early_pfn_to_nid(pfn));
+	ptr = __alloc_bootmem_core(pgdat->bdata, size, SMP_CACHE_BYTES, goal,
+				   limit);
+
+	if (!ptr)
+		return NULL;
+
+	start_nr = pfn_to_section_nr(PFN_DOWN(__pa(ptr)));
+	end_nr = pfn_to_section_nr(PFN_DOWN(__pa(ptr) + size));
+	if (start_nr != section_nr || end_nr != section_nr) {
+		printk(KERN_WARNING "alloc_bootmem failed on section %ld.\n",
+		       section_nr);
+		free_bootmem_core(pgdat->bdata, __pa(ptr), size);
+		ptr = NULL;
+	}
+
+	return ptr;
+}
+#endif
+
 #ifndef ARCH_LOW_ADDRESS_LIMIT
 #define ARCH_LOW_ADDRESS_LIMIT	0xffffffffUL
 #endif
_

Patches currently in -mm which might be from y-goto@jp.fujitsu.com are

origin.patch
powerpc-hotplug-memory-notifications-for-ppc.patch
powerpc-update-lmb-for-hotplug-memory-add-remove.patch
powerpc-provide-walk_memory_resource-for-ppc.patch
ipc-scale-msgmni-to-the-amount-of-lowmem.patch
ipc-scale-msgmni-to-the-number-of-ipc-namespaces.patch
ipc-define-the-slab_memory_callback-priority-as-a-constant.patch
ipc-recompute-msgmni-on-memory-add--remove.patch
ipc-invoke-the-ipcns-notifier-chain-as-a-work-item.patch
ipc-recompute-msgmni-on-ipc-namespace-creation-removal.patch
ipc-do-not-recompute-msgmni-anymore-if-explicitly-set-by-user.patch
ipc-re-enable-msgmni-automatic-recomputing-msgmni-if-set-to-negative.patch


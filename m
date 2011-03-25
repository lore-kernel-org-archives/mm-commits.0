From: akpm@linux-foundation.org
Subject: [merged] page_cgroup-reduce-allocation-overhead-for-page_cgroup-array-for-config_sparsemem.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:25:13 -0700
Message-ID: <201103250725.p2P7P7lp025999@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39414 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933939Ab1CYHZV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:25:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, balbir@in.ibm.com, dave@linux.vnet.ibm.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     page_cgroup: reduce allocation overhead for page_cgroup array for CONFIG_SPARSEMEM
has been removed from the -mm tree.  Its filename was
     page_cgroup-reduce-allocation-overhead-for-page_cgroup-array-for-config_sparsemem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page_cgroup: reduce allocation overhead for page_cgroup array for CONFIG_SPARSEMEM
From: Michal Hocko <mhocko@suse.cz>

Currently we are allocating a single page_cgroup array per memory section
(stored in mem_section->base) when CONFIG_SPARSEMEM is selected.  This is
correct but memory inefficient solution because the allocated memory
(unless we fall back to vmalloc) is not kmalloc friendly:

        - 32b - 16384 entries (20B per entry) fit into 327680B so the
          524288B slab cache is used
        - 32b with PAE - 131072 entries with 2621440B fit into 4194304B
        - 64b - 32768 entries (40B per entry) fit into 2097152 cache

This is ~37% wasted space per memory section and it sumps up for the whole
memory.  On a x86_64 machine it is something like 6MB per 1GB of RAM.

We can reduce the internal fragmentation by using alloc_pages_exact which
allocates PAGE_SIZE aligned blocks so we will get down to <4kB wasted
memory per section which is much better.

We still need a fallback to vmalloc because we have no guarantees that we
will have a continuous memory of that size (order-10) later on during the
hotplug events.

[hannes@cmpxchg.org: do not define unused free_page_cgroup() without memory hotplug]
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |   58 +++++++++++++++++++++++++++------------------
 1 file changed, 36 insertions(+), 22 deletions(-)

diff -puN mm/page_cgroup.c~page_cgroup-reduce-allocation-overhead-for-page_cgroup-array-for-config_sparsemem mm/page_cgroup.c
--- a/mm/page_cgroup.c~page_cgroup-reduce-allocation-overhead-for-page_cgroup-array-for-config_sparsemem
+++ a/mm/page_cgroup.c
@@ -130,7 +130,38 @@ struct page *lookup_cgroup_page(struct p
 	return page;
 }
 
-/* __alloc_bootmem...() is protected by !slab_available() */
+static void *__init_refok alloc_page_cgroup(size_t size, int nid)
+{
+	void *addr = NULL;
+
+	addr = alloc_pages_exact(size, GFP_KERNEL | __GFP_NOWARN);
+	if (addr)
+		return addr;
+
+	if (node_state(nid, N_HIGH_MEMORY))
+		addr = vmalloc_node(size, nid);
+	else
+		addr = vmalloc(size);
+
+	return addr;
+}
+
+#ifdef CONFIG_MEMORY_HOTPLUG
+static void free_page_cgroup(void *addr)
+{
+	if (is_vmalloc_addr(addr)) {
+		vfree(addr);
+	} else {
+		struct page *page = virt_to_page(addr);
+		if (!PageReserved(page)) { /* Is bootmem ? */
+			size_t table_size =
+				sizeof(struct page_cgroup) * PAGES_PER_SECTION;
+			free_pages_exact(addr, table_size);
+		}
+	}
+}
+#endif
+
 static int __init_refok init_section_page_cgroup(unsigned long pfn)
 {
 	struct page_cgroup *base, *pc;
@@ -147,17 +178,8 @@ static int __init_refok init_section_pag
 
 	nid = page_to_nid(pfn_to_page(pfn));
 	table_size = sizeof(struct page_cgroup) * PAGES_PER_SECTION;
-	VM_BUG_ON(!slab_is_available());
-	if (node_state(nid, N_HIGH_MEMORY)) {
-		base = kmalloc_node(table_size,
-				    GFP_KERNEL | __GFP_NOWARN, nid);
-		if (!base)
-			base = vmalloc_node(table_size, nid);
-	} else {
-		base = kmalloc(table_size, GFP_KERNEL | __GFP_NOWARN);
-		if (!base)
-			base = vmalloc(table_size);
-	}
+	base = alloc_page_cgroup(table_size, nid);
+
 	/*
 	 * The value stored in section->page_cgroup is (base - pfn)
 	 * and it does not point to the memory block allocated above,
@@ -189,16 +211,8 @@ void __free_page_cgroup(unsigned long pf
 	if (!ms || !ms->page_cgroup)
 		return;
 	base = ms->page_cgroup + pfn;
-	if (is_vmalloc_addr(base)) {
-		vfree(base);
-		ms->page_cgroup = NULL;
-	} else {
-		struct page *page = virt_to_page(base);
-		if (!PageReserved(page)) { /* Is bootmem ? */
-			kfree(base);
-			ms->page_cgroup = NULL;
-		}
-	}
+	free_page_cgroup(base);
+	ms->page_cgroup = NULL;
 }
 
 int __meminit online_page_cgroup(unsigned long start_pfn,
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
memsw-remove-noswapaccount-kernel-parameter.patch


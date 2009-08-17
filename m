From: akpm@linux-foundation.org
Subject: + walk-system-ram-range.patch added to -mm tree
Date: Mon, 17 Aug 2009 14:26:01 -0700
Message-ID: <200908172126.n7HLQ2xO029309@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757985AbZHQV3m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Aug 2009 17:29:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, benh@kernel.crashing.org, ralf@linux-mips.org, xiyou.wangcong@gmail.com


The patch titled
     walk system ram range
has been added to the -mm tree.  Its filename is
     walk-system-ram-range.patch

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
Subject: walk system ram range
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Originally, walk_memory_resource() was introduced to traverse all memory
of "System RAM" for detecting memory hotplug/unplug range.  For doing so,
flags of IORESOUCE_MEM|IORESOURCE_BUSY was used and this was enough for
memory hotplug.

But for using other purpose, /proc/kcore, this may includes some firmware
area marked as IORESOURCE_BUSY | IORESOUCE_MEM.  This patch makes the
check strict to find out busy "System RAM".

Note: PPC64 keeps their own walk_memory_resouce(), which walk through
ppc64's lmb informaton.  Because old kclist_add() is called per lmb, this
patch makes no difference in behavior, finally.

And this patch removes CONFIG_MEMORY_HOTPLUG check from this function. 
Because pfn_valid() just show "there is memmap or not* and cannot be used
for "there is physical memory or not", this function is useful in generic
to scan physical memory range.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/mem.c          |    4 ++--
 drivers/net/ehea/ehea_qmr.c    |    2 +-
 include/linux/ioport.h         |    4 ++++
 include/linux/memory_hotplug.h |    8 --------
 kernel/resource.c              |   23 ++++++++++++++++-------
 mm/memory_hotplug.c            |    6 +++---
 6 files changed, 26 insertions(+), 21 deletions(-)

diff -puN arch/powerpc/mm/mem.c~walk-system-ram-range arch/powerpc/mm/mem.c
--- a/arch/powerpc/mm/mem.c~walk-system-ram-range
+++ a/arch/powerpc/mm/mem.c
@@ -143,8 +143,8 @@ int arch_add_memory(int nid, u64 start, 
  * memory regions, find holes and callback for contiguous regions.
  */
 int
-walk_memory_resource(unsigned long start_pfn, unsigned long nr_pages, void *arg,
-			int (*func)(unsigned long, unsigned long, void *))
+walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
+		void *arg, int (*func)(unsigned long, unsigned long, void *))
 {
 	struct lmb_property res;
 	unsigned long pfn, len;
diff -puN drivers/net/ehea/ehea_qmr.c~walk-system-ram-range drivers/net/ehea/ehea_qmr.c
--- a/drivers/net/ehea/ehea_qmr.c~walk-system-ram-range
+++ a/drivers/net/ehea/ehea_qmr.c
@@ -751,7 +751,7 @@ int ehea_create_busmap(void)
 
 	mutex_lock(&ehea_busmap_mutex);
 	ehea_mr_len = 0;
-	ret = walk_memory_resource(0, 1ULL << MAX_PHYSMEM_BITS, NULL,
+	ret = walk_system_ram_range(0, 1ULL << MAX_PHYSMEM_BITS, NULL,
 				   ehea_create_busmap_callback);
 	mutex_unlock(&ehea_busmap_mutex);
 	return ret;
diff -puN include/linux/ioport.h~walk-system-ram-range include/linux/ioport.h
--- a/include/linux/ioport.h~walk-system-ram-range
+++ a/include/linux/ioport.h
@@ -184,5 +184,9 @@ extern void __devm_release_region(struct
 extern int iomem_map_sanity_check(resource_size_t addr, unsigned long size);
 extern int iomem_is_exclusive(u64 addr);
 
+extern int
+walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
+		void *arg, int (*func)(unsigned long, unsigned long, void *));
+
 #endif /* __ASSEMBLY__ */
 #endif	/* _LINUX_IOPORT_H */
diff -puN include/linux/memory_hotplug.h~walk-system-ram-range include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~walk-system-ram-range
+++ a/include/linux/memory_hotplug.h
@@ -191,14 +191,6 @@ static inline void register_page_bootmem
 
 #endif /* ! CONFIG_MEMORY_HOTPLUG */
 
-/*
- * Walk through all memory which is registered as resource.
- * arg is (start_pfn, nr_pages, private_arg_pointer)
- */
-extern int walk_memory_resource(unsigned long start_pfn,
-			unsigned long nr_pages, void *arg,
-			int (*func)(unsigned long, unsigned long, void *));
-
 #ifdef CONFIG_MEMORY_HOTREMOVE
 
 extern int is_mem_section_removable(unsigned long pfn, unsigned long nr_pages);
diff -puN kernel/resource.c~walk-system-ram-range kernel/resource.c
--- a/kernel/resource.c~walk-system-ram-range
+++ a/kernel/resource.c
@@ -223,13 +223,13 @@ int release_resource(struct resource *ol
 
 EXPORT_SYMBOL(release_resource);
 
-#if defined(CONFIG_MEMORY_HOTPLUG) && !defined(CONFIG_ARCH_HAS_WALK_MEMORY)
+#if !defined(CONFIG_ARCH_HAS_WALK_MEMORY)
 /*
  * Finds the lowest memory reosurce exists within [res->start.res->end)
- * the caller must specify res->start, res->end, res->flags.
+ * the caller must specify res->start, res->end, res->flags and "name".
  * If found, returns 0, res is overwritten, if not found, returns -1.
  */
-static int find_next_system_ram(struct resource *res)
+static int find_next_system_ram(struct resource *res, char *name)
 {
 	resource_size_t start, end;
 	struct resource *p;
@@ -245,6 +245,8 @@ static int find_next_system_ram(struct r
 		/* system ram is just marked as IORESOURCE_MEM */
 		if (p->flags != res->flags)
 			continue;
+		if (name && strcmp(p->name, name))
+			continue;
 		if (p->start > end) {
 			p = NULL;
 			break;
@@ -262,19 +264,26 @@ static int find_next_system_ram(struct r
 		res->end = p->end;
 	return 0;
 }
-int
-walk_memory_resource(unsigned long start_pfn, unsigned long nr_pages, void *arg,
-			int (*func)(unsigned long, unsigned long, void *))
+
+/*
+ * This function calls callback against all memory range of "System RAM"
+ * which are marked as IORESOURCE_MEM and IORESOUCE_BUSY.
+ * Now, this function is only for "System RAM".
+ */
+int walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
+		void *arg, int (*func)(unsigned long, unsigned long, void *))
 {
 	struct resource res;
 	unsigned long pfn, len;
 	u64 orig_end;
 	int ret = -1;
+
 	res.start = (u64) start_pfn << PAGE_SHIFT;
 	res.end = ((u64)(start_pfn + nr_pages) << PAGE_SHIFT) - 1;
 	res.flags = IORESOURCE_MEM | IORESOURCE_BUSY;
 	orig_end = res.end;
-	while ((res.start < res.end) && (find_next_system_ram(&res) >= 0)) {
+	while ((res.start < res.end) &&
+		(find_next_system_ram(&res, "System RAM") >= 0)) {
 		pfn = (unsigned long)(res.start >> PAGE_SHIFT);
 		len = (unsigned long)((res.end + 1 - res.start) >> PAGE_SHIFT);
 		ret = (*func)(pfn, len, arg);
diff -puN mm/memory_hotplug.c~walk-system-ram-range mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~walk-system-ram-range
+++ a/mm/memory_hotplug.c
@@ -410,7 +410,7 @@ int online_pages(unsigned long pfn, unsi
 	if (!populated_zone(zone))
 		need_zonelists_rebuild = 1;
 
-	ret = walk_memory_resource(pfn, nr_pages, &onlined_pages,
+	ret = walk_system_ram_range(pfn, nr_pages, &onlined_pages,
 		online_pages_range);
 	if (ret) {
 		printk(KERN_DEBUG "online_pages %lx at %lx failed\n",
@@ -702,7 +702,7 @@ offline_isolated_pages_cb(unsigned long 
 static void
 offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
 {
-	walk_memory_resource(start_pfn, end_pfn - start_pfn, NULL,
+	walk_system_ram_range(start_pfn, end_pfn - start_pfn, NULL,
 				offline_isolated_pages_cb);
 }
 
@@ -728,7 +728,7 @@ check_pages_isolated(unsigned long start
 	long offlined = 0;
 	int ret;
 
-	ret = walk_memory_resource(start_pfn, end_pfn - start_pfn, &offlined,
+	ret = walk_system_ram_range(start_pfn, end_pfn - start_pfn, &offlined,
 			check_pages_isolated_cb);
 	if (ret < 0)
 		offlined = (long)ret;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

mm-revert-oom-move-oom_adj-value.patch
mm-clean-up-page_remove_rmap.patch
vmscan-throttle-direct-reclaim-when-too-many-pages-are-isolated-already.patch
mm-remove-__addsub_zone_page_state.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
vmalloc-unmap-vmalloc-area-after-hiding-it.patch
kcore-fix-vread-vwrite-to-be-aware-of-holes.patch
kcore-fix-vread-vwrite-to-be-aware-of-holes-update.patch
kcore-proc-kcore-should-use-vread.patch
mm-add_to_swap_cache-must-not-sleep.patch
mm-add_to_swap_cache-does-not-return-eexist.patch
kcore-fix-proc-kcores-statst_size.patch
kcore-use-usual-list-for-kclist.patch
kcore-add-kclist-type.patch
kcore-register-vmalloc-area-in-generic-way.patch
kcore-register-text-area-in-generic-way.patch
walk-system-ram-range.patch
kcore-use-registerd-physmem-information.patch
cgroups-support-named-cgroups-hierarchies.patch
cgroups-move-the-cgroup-debug-subsys-into-cgroupc-to-access-internal-state.patch
cgroups-add-a-back-pointer-from-struct-cg_cgroup_link-to-struct-cgroup.patch
cgroups-allow-cgroup-hierarchies-to-be-created-with-no-bound-subsystems.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
memcg-add-comments-explaining-memory-barriers.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-v5.patch


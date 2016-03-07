From: akpm@linux-foundation.org
Subject: + mm-coalesce-split-strings.patch added to -mm tree
Date: Mon, 07 Mar 2016 10:55:33 -0800
Message-ID: <56ddcea5.1Q8nAuyLq+j5tGd0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60268 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbcCGSze (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2016 13:55:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: coalesce split strings
has been added to the -mm tree.  Its filename is
     mm-coalesce-split-strings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-coalesce-split-strings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-coalesce-split-strings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: mm: coalesce split strings

Kernel style prefers a single string over split strings when the string is
'user-visible'.

Miscellanea:

o Add a missing newline
o Realign arguments

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Tejun Heo <tj@kernel.org>	[percpu]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c        |   10 ++++------
 mm/huge_memory.c    |    3 +--
 mm/kasan/report.c   |    6 ++----
 mm/kmemcheck.c      |    3 +--
 mm/kmemleak.c       |   18 ++++++++----------
 mm/memblock.c       |    3 +--
 mm/memory_hotplug.c |    3 +--
 mm/mempolicy.c      |    4 +---
 mm/mmap.c           |    8 +++-----
 mm/oom_kill.c       |    3 +--
 mm/page_alloc.c     |   37 +++++++++++++++++--------------------
 mm/page_owner.c     |    5 ++---
 mm/percpu.c         |    4 ++--
 mm/slab.c           |   28 ++++++++++------------------
 mm/slab_common.c    |   10 ++++------
 mm/slub.c           |   19 +++++++++----------
 mm/sparse-vmemmap.c |    8 ++++----
 mm/sparse.c         |    8 ++++----
 mm/swapfile.c       |    3 +--
 mm/vmalloc.c        |    4 ++--
 20 files changed, 78 insertions(+), 109 deletions(-)

diff -puN mm/dmapool.c~mm-coalesce-split-strings mm/dmapool.c
--- a/mm/dmapool.c~mm-coalesce-split-strings
+++ a/mm/dmapool.c
@@ -452,13 +452,11 @@ void dma_pool_free(struct dma_pool *pool
 			}
 			spin_unlock_irqrestore(&pool->lock, flags);
 			if (pool->dev)
-				dev_err(pool->dev, "dma_pool_free %s, dma %Lx "
-					"already free\n", pool->name,
-					(unsigned long long)dma);
+				dev_err(pool->dev, "dma_pool_free %s, dma %Lx already free\n",
+					pool->name, (unsigned long long)dma);
 			else
-				printk(KERN_ERR "dma_pool_free %s, dma %Lx "
-					"already free\n", pool->name,
-					(unsigned long long)dma);
+				printk(KERN_ERR "dma_pool_free %s, dma %Lx already free\n",
+					pool->name, (unsigned long long)dma);
 			return;
 		}
 	}
diff -puN mm/huge_memory.c~mm-coalesce-split-strings mm/huge_memory.c
--- a/mm/huge_memory.c~mm-coalesce-split-strings
+++ a/mm/huge_memory.c
@@ -168,8 +168,7 @@ static void set_recommended_min_free_kby
 
 	if (recommended_min > min_free_kbytes) {
 		if (user_min_free_kbytes >= 0)
-			pr_info("raising min_free_kbytes from %d to %lu "
-				"to help transparent hugepage allocations\n",
+			pr_info("raising min_free_kbytes from %d to %lu to help transparent hugepage allocations\n",
 				min_free_kbytes, recommended_min);
 
 		min_free_kbytes = recommended_min;
diff -puN mm/kasan/report.c~mm-coalesce-split-strings mm/kasan/report.c
--- a/mm/kasan/report.c~mm-coalesce-split-strings
+++ a/mm/kasan/report.c
@@ -214,8 +214,7 @@ static void kasan_report_error(struct ka
 	 */
 	kasan_disable_current();
 	spin_lock_irqsave(&report_lock, flags);
-	pr_err("================================="
-		"=================================\n");
+	pr_err("==================================================================\n");
 	if (info->access_addr <
 			kasan_shadow_to_mem((void *)KASAN_SHADOW_START)) {
 		if ((unsigned long)info->access_addr < PAGE_SIZE)
@@ -236,8 +235,7 @@ static void kasan_report_error(struct ka
 		print_address_description(info);
 		print_shadow_for_address(info->first_bad_addr);
 	}
-	pr_err("================================="
-		"=================================\n");
+	pr_err("==================================================================\n");
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 	spin_unlock_irqrestore(&report_lock, flags);
 	kasan_enable_current();
diff -puN mm/kmemcheck.c~mm-coalesce-split-strings mm/kmemcheck.c
--- a/mm/kmemcheck.c~mm-coalesce-split-strings
+++ a/mm/kmemcheck.c
@@ -20,8 +20,7 @@ void kmemcheck_alloc_shadow(struct page
 	shadow = alloc_pages_node(node, flags | __GFP_NOTRACK, order);
 	if (!shadow) {
 		if (printk_ratelimit())
-			printk(KERN_ERR "kmemcheck: failed to allocate "
-				"shadow bitmap\n");
+			printk(KERN_ERR "kmemcheck: failed to allocate shadow bitmap\n");
 		return;
 	}
 
diff -puN mm/kmemleak.c~mm-coalesce-split-strings mm/kmemleak.c
--- a/mm/kmemleak.c~mm-coalesce-split-strings
+++ a/mm/kmemleak.c
@@ -596,8 +596,7 @@ static struct kmemleak_object *create_ob
 		else if (parent->pointer + parent->size <= ptr)
 			link = &parent->rb_node.rb_right;
 		else {
-			kmemleak_stop("Cannot insert 0x%lx into the object "
-				      "search tree (overlaps existing)\n",
+			kmemleak_stop("Cannot insert 0x%lx into the object search tree (overlaps existing)\n",
 				      ptr);
 			/*
 			 * No need for parent->lock here since "parent" cannot
@@ -670,8 +669,8 @@ static void delete_object_part(unsigned
 	object = find_and_remove_object(ptr, 1);
 	if (!object) {
 #ifdef DEBUG
-		kmemleak_warn("Partially freeing unknown object at 0x%08lx "
-			      "(size %zu)\n", ptr, size);
+		kmemleak_warn("Partially freeing unknown object at 0x%08lx (size %zu)\n",
+			      ptr, size);
 #endif
 		return;
 	}
@@ -717,8 +716,8 @@ static void paint_ptr(unsigned long ptr,
 
 	object = find_and_get_object(ptr, 0);
 	if (!object) {
-		kmemleak_warn("Trying to color unknown object "
-			      "at 0x%08lx as %s\n", ptr,
+		kmemleak_warn("Trying to color unknown object at 0x%08lx as %s\n",
+			      ptr,
 			      (color == KMEMLEAK_GREY) ? "Grey" :
 			      (color == KMEMLEAK_BLACK) ? "Black" : "Unknown");
 		return;
@@ -1463,8 +1462,8 @@ static void kmemleak_scan(void)
 	if (new_leaks) {
 		kmemleak_found_leaks = true;
 
-		pr_info("%d new suspected memory leaks (see "
-			"/sys/kernel/debug/kmemleak)\n", new_leaks);
+		pr_info("%d new suspected memory leaks (see /sys/kernel/debug/kmemleak)\n",
+			new_leaks);
 	}
 
 }
@@ -1795,8 +1794,7 @@ static void kmemleak_do_cleanup(struct w
 	if (!kmemleak_found_leaks)
 		__kmemleak_do_cleanup();
 	else
-		pr_info("Kmemleak disabled without freeing internal data. "
-			"Reclaim the memory with \"echo clear > /sys/kernel/debug/kmemleak\"\n");
+		pr_info("Kmemleak disabled without freeing internal data. Reclaim the memory with \"echo clear > /sys/kernel/debug/kmemleak\".\n");
 }
 
 static DECLARE_WORK(cleanup_work, kmemleak_do_cleanup);
diff -puN mm/memblock.c~mm-coalesce-split-strings mm/memblock.c
--- a/mm/memblock.c~mm-coalesce-split-strings
+++ a/mm/memblock.c
@@ -238,8 +238,7 @@ phys_addr_t __init_memblock memblock_fin
 		 * so we use WARN_ONCE() here to see the stack trace if
 		 * fail happens.
 		 */
-		WARN_ONCE(1, "memblock: bottom-up allocation failed, "
-			     "memory hotunplug may be affected\n");
+		WARN_ONCE(1, "memblock: bottom-up allocation failed, memory hotunplug may be affected\n");
 	}
 
 	return __memblock_find_range_top_down(start, end, size, align, nid,
diff -puN mm/memory_hotplug.c~mm-coalesce-split-strings mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-coalesce-split-strings
+++ a/mm/memory_hotplug.c
@@ -1970,8 +1970,7 @@ static int check_memblock_offlined_cb(st
 
 		beginpa = PFN_PHYS(section_nr_to_pfn(mem->start_section_nr));
 		endpa = PFN_PHYS(section_nr_to_pfn(mem->end_section_nr + 1))-1;
-		pr_warn("removing memory fails, because memory "
-			"[%pa-%pa] is onlined\n",
+		pr_warn("removing memory fails, because memory [%pa-%pa] is onlined\n",
 			&beginpa, &endpa);
 	}
 
diff -puN mm/mempolicy.c~mm-coalesce-split-strings mm/mempolicy.c
--- a/mm/mempolicy.c~mm-coalesce-split-strings
+++ a/mm/mempolicy.c
@@ -2559,9 +2559,7 @@ static void __init check_numabalancing_e
 		set_numabalancing_state(numabalancing_override == 1);
 
 	if (num_online_nodes() > 1 && !numabalancing_override) {
-		pr_info("%s automatic NUMA balancing. "
-			"Configure with numa_balancing= or the "
-			"kernel.numa_balancing sysctl",
+		pr_info("%s automatic NUMA balancing. Configure with numa_balancing= or the kernel.numa_balancing sysctl\n",
 			numabalancing_default ? "Enabling" : "Disabling");
 		set_numabalancing_state(numabalancing_default);
 	}
diff -puN mm/mmap.c~mm-coalesce-split-strings mm/mmap.c
--- a/mm/mmap.c~mm-coalesce-split-strings
+++ a/mm/mmap.c
@@ -2517,9 +2517,8 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 	unsigned long ret = -EINVAL;
 	struct file *file;
 
-	pr_warn_once("%s (%d) uses deprecated remap_file_pages() syscall. "
-			"See Documentation/vm/remap_file_pages.txt.\n",
-			current->comm, current->pid);
+	pr_warn_once("%s (%d) uses deprecated remap_file_pages() syscall. See Documentation/vm/remap_file_pages.txt.\n",
+		     current->comm, current->pid);
 
 	if (prot)
 		return ret;
@@ -2885,8 +2884,7 @@ bool may_expand_vm(struct mm_struct *mm,
 	if (is_data_mapping(flags) &&
 	    mm->data_vm + npages > rlimit(RLIMIT_DATA) >> PAGE_SHIFT) {
 		if (ignore_rlimit_data)
-			pr_warn_once("%s (%d): VmData %lu exceed data ulimit "
-				     "%lu. Will be forbidden soon.\n",
+			pr_warn_once("%s (%d): VmData %lu exceed data ulimit %lu. Will be forbidden soon.\n",
 				     current->comm, current->pid,
 				     (mm->data_vm + npages) << PAGE_SHIFT,
 				     rlimit(RLIMIT_DATA));
diff -puN mm/oom_kill.c~mm-coalesce-split-strings mm/oom_kill.c
--- a/mm/oom_kill.c~mm-coalesce-split-strings
+++ a/mm/oom_kill.c
@@ -391,8 +391,7 @@ static void dump_tasks(struct mem_cgroup
 static void dump_header(struct oom_control *oc, struct task_struct *p,
 			struct mem_cgroup *memcg)
 {
-	pr_warn("%s invoked oom-killer: gfp_mask=%#x(%pGg), order=%d, "
-			"oom_score_adj=%hd\n",
+	pr_warn("%s invoked oom-killer: gfp_mask=%#x(%pGg), order=%d, oom_score_adj=%hd\n",
 		current->comm, oc->gfp_mask, &oc->gfp_mask, oc->order,
 		current->signal->oom_score_adj);
 
diff -puN mm/page_alloc.c~mm-coalesce-split-strings mm/page_alloc.c
--- a/mm/page_alloc.c~mm-coalesce-split-strings
+++ a/mm/page_alloc.c
@@ -4074,8 +4074,7 @@ static int __parse_numa_zonelist_order(c
 		user_zonelist_order = ZONELIST_ORDER_ZONE;
 	} else {
 		printk(KERN_WARNING
-			"Ignoring invalid numa_zonelist_order value:  "
-			"%s\n", s);
+		       "Ignoring invalid numa_zonelist_order value:  %s\n", s);
 		return -EINVAL;
 	}
 	return 0;
@@ -4539,12 +4538,11 @@ void __ref build_all_zonelists(pg_data_t
 	else
 		page_group_by_mobility_disabled = 0;
 
-	pr_info("Built %i zonelists in %s order, mobility grouping %s.  "
-		"Total pages: %ld\n",
-			nr_online_nodes,
-			zonelist_order_name[current_zonelist_order],
-			page_group_by_mobility_disabled ? "off" : "on",
-			vm_total_pages);
+	pr_info("Built %i zonelists in %s order, mobility grouping %s.  Total pages: %ld\n",
+		nr_online_nodes,
+		zonelist_order_name[current_zonelist_order],
+		page_group_by_mobility_disabled ? "off" : "on",
+		vm_total_pages);
 #ifdef CONFIG_NUMA
 	pr_info("Policy zone: %s\n", zone_names[policy_zone]);
 #endif
@@ -6142,22 +6140,21 @@ void __init mem_init_print_info(const ch
 
 #undef	adj_init_size
 
-	pr_info("Memory: %luK/%luK available "
-	       "(%luK kernel code, %luK rwdata, %luK rodata, "
-	       "%luK init, %luK bss, %luK reserved, %luK cma-reserved"
+	pr_info("Memory: %luK/%luK available (%luK kernel code, %luK rwdata, %luK rodata, %luK init, %luK bss, %luK reserved, %luK cma-reserved"
 #ifdef	CONFIG_HIGHMEM
-	       ", %luK highmem"
+		", %luK highmem"
 #endif
-	       "%s%s)\n",
-	       nr_free_pages() << (PAGE_SHIFT-10), physpages << (PAGE_SHIFT-10),
-	       codesize >> 10, datasize >> 10, rosize >> 10,
-	       (init_data_size + init_code_size) >> 10, bss_size >> 10,
-	       (physpages - totalram_pages - totalcma_pages) << (PAGE_SHIFT-10),
-	       totalcma_pages << (PAGE_SHIFT-10),
+		"%s%s)\n",
+		nr_free_pages() << (PAGE_SHIFT - 10),
+		physpages << (PAGE_SHIFT - 10),
+		codesize >> 10, datasize >> 10, rosize >> 10,
+		(init_data_size + init_code_size) >> 10, bss_size >> 10,
+		(physpages - totalram_pages - totalcma_pages) << (PAGE_SHIFT - 10),
+		totalcma_pages << (PAGE_SHIFT - 10),
 #ifdef	CONFIG_HIGHMEM
-	       totalhigh_pages << (PAGE_SHIFT-10),
+		totalhigh_pages << (PAGE_SHIFT - 10),
 #endif
-	       str ? ", " : "", str ? str : "");
+		str ? ", " : "", str ? str : "");
 }
 
 /**
diff -puN mm/page_owner.c~mm-coalesce-split-strings mm/page_owner.c
--- a/mm/page_owner.c~mm-coalesce-split-strings
+++ a/mm/page_owner.c
@@ -198,9 +198,8 @@ void __dump_page_owner(struct page *page
 		return;
 	}
 
-	pr_alert("page allocated via order %u, migratetype %s, "
-			"gfp_mask %#x(%pGg)\n", page_ext->order,
-			migratetype_names[mt], gfp_mask, &gfp_mask);
+	pr_alert("page allocated via order %u, migratetype %s, gfp_mask %#x(%pGg)\n",
+		 page_ext->order, migratetype_names[mt], gfp_mask, &gfp_mask);
 	print_stack_trace(&trace, 0);
 
 	if (page_ext->last_migrate_reason != -1)
diff -puN mm/percpu.c~mm-coalesce-split-strings mm/percpu.c
--- a/mm/percpu.c~mm-coalesce-split-strings
+++ a/mm/percpu.c
@@ -888,8 +888,8 @@ static void __percpu *pcpu_alloc(size_t
 	size = ALIGN(size, 2);
 
 	if (unlikely(!size || size > PCPU_MIN_UNIT_SIZE || align > PAGE_SIZE)) {
-		WARN(true, "illegal size (%zu) or align (%zu) for "
-		     "percpu allocation\n", size, align);
+		WARN(true, "illegal size (%zu) or align (%zu) for percpu allocation\n",
+		     size, align);
 		return NULL;
 	}
 
diff -puN mm/slab.c~mm-coalesce-split-strings mm/slab.c
--- a/mm/slab.c~mm-coalesce-split-strings
+++ a/mm/slab.c
@@ -1566,11 +1566,9 @@ static void dump_line(char *data, int of
 	if (bad_count == 1) {
 		error ^= POISON_FREE;
 		if (!(error & (error - 1))) {
-			printk(KERN_ERR "Single bit error detected. Probably "
-					"bad RAM.\n");
+			printk(KERN_ERR "Single bit error detected. Probably bad RAM.\n");
 #ifdef CONFIG_X86
-			printk(KERN_ERR "Run memtest86+ or a similar memory "
-					"test tool.\n");
+			printk(KERN_ERR "Run memtest86+ or a similar memory test tool.\n");
 #else
 			printk(KERN_ERR "Run a memory test tool.\n");
 #endif
@@ -1693,11 +1691,9 @@ static void slab_destroy_debugcheck(stru
 		}
 		if (cachep->flags & SLAB_RED_ZONE) {
 			if (*dbg_redzone1(cachep, objp) != RED_INACTIVE)
-				slab_error(cachep, "start of a freed object "
-					   "was overwritten");
+				slab_error(cachep, "start of a freed object was overwritten");
 			if (*dbg_redzone2(cachep, objp) != RED_INACTIVE)
-				slab_error(cachep, "end of a freed object "
-					   "was overwritten");
+				slab_error(cachep, "end of a freed object was overwritten");
 		}
 	}
 }
@@ -2398,11 +2394,9 @@ static void cache_init_objs_debug(struct
 
 		if (cachep->flags & SLAB_RED_ZONE) {
 			if (*dbg_redzone2(cachep, objp) != RED_INACTIVE)
-				slab_error(cachep, "constructor overwrote the"
-					   " end of an object");
+				slab_error(cachep, "constructor overwrote the end of an object");
 			if (*dbg_redzone1(cachep, objp) != RED_INACTIVE)
-				slab_error(cachep, "constructor overwrote the"
-					   " start of an object");
+				slab_error(cachep, "constructor overwrote the start of an object");
 		}
 		/* need to poison the objs? */
 		if (cachep->flags & SLAB_POISON) {
@@ -2469,8 +2463,8 @@ static void slab_put_obj(struct kmem_cac
 	/* Verify double free bug */
 	for (i = page->active; i < cachep->num; i++) {
 		if (get_free_obj(page, i) == objnr) {
-			printk(KERN_ERR "slab: double free detected in cache "
-					"'%s', objp %p\n", cachep->name, objp);
+			printk(KERN_ERR "slab: double free detected in cache '%s', objp %p\n",
+			       cachep->name, objp);
 			BUG();
 		}
 	}
@@ -2901,8 +2895,7 @@ static void *cache_alloc_debugcheck_afte
 	if (cachep->flags & SLAB_RED_ZONE) {
 		if (*dbg_redzone1(cachep, objp) != RED_INACTIVE ||
 				*dbg_redzone2(cachep, objp) != RED_INACTIVE) {
-			slab_error(cachep, "double free, or memory outside"
-						" object was overwritten");
+			slab_error(cachep, "double free, or memory outside object was overwritten");
 			printk(KERN_ERR
 				"%p: redzone 1:0x%llx, redzone 2:0x%llx\n",
 				objp, *dbg_redzone1(cachep, objp),
@@ -4028,8 +4021,7 @@ void slabinfo_show_stats(struct seq_file
 		unsigned long node_frees = cachep->node_frees;
 		unsigned long overflows = cachep->node_overflow;
 
-		seq_printf(m, " : globalstat %7lu %6lu %5lu %4lu "
-			   "%4lu %4lu %4lu %4lu %4lu",
+		seq_printf(m, " : globalstat %7lu %6lu %5lu %4lu %4lu %4lu %4lu %4lu %4lu",
 			   allocs, high, grown,
 			   reaped, errors, max_freeable, node_allocs,
 			   node_frees, overflows);
diff -puN mm/slab_common.c~mm-coalesce-split-strings mm/slab_common.c
--- a/mm/slab_common.c~mm-coalesce-split-strings
+++ a/mm/slab_common.c
@@ -726,8 +726,8 @@ void kmem_cache_destroy(struct kmem_cach
 		err = shutdown_cache(s, &release, &need_rcu_barrier);
 
 	if (err) {
-		pr_err("kmem_cache_destroy %s: "
-		       "Slab cache still has objects\n", s->name);
+		pr_err("kmem_cache_destroy %s: Slab cache still has objects\n",
+		       s->name);
 		dump_stack();
 	}
 out_unlock:
@@ -1047,13 +1047,11 @@ static void print_slabinfo_header(struct
 #else
 	seq_puts(m, "slabinfo - version: 2.1\n");
 #endif
-	seq_puts(m, "# name            <active_objs> <num_objs> <objsize> "
-		 "<objperslab> <pagesperslab>");
+	seq_puts(m, "# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab>");
 	seq_puts(m, " : tunables <limit> <batchcount> <sharedfactor>");
 	seq_puts(m, " : slabdata <active_slabs> <num_slabs> <sharedavail>");
 #ifdef CONFIG_DEBUG_SLAB
-	seq_puts(m, " : globalstat <listallocs> <maxobjs> <grown> <reaped> "
-		 "<error> <maxfreeable> <nodeallocs> <remotefrees> <alienoverflow>");
+	seq_puts(m, " : globalstat <listallocs> <maxobjs> <grown> <reaped> <error> <maxfreeable> <nodeallocs> <remotefrees> <alienoverflow>");
 	seq_puts(m, " : cpustat <allochit> <allocmiss> <freehit> <freemiss>");
 #endif
 	seq_putc(m, '\n');
diff -puN mm/slub.c~mm-coalesce-split-strings mm/slub.c
--- a/mm/slub.c~mm-coalesce-split-strings
+++ a/mm/slub.c
@@ -950,14 +950,14 @@ static int on_freelist(struct kmem_cache
 		max_objects = MAX_OBJS_PER_PAGE;
 
 	if (page->objects != max_objects) {
-		slab_err(s, page, "Wrong number of objects. Found %d but "
-			"should be %d", page->objects, max_objects);
+		slab_err(s, page, "Wrong number of objects. Found %d but should be %d",
+			 page->objects, max_objects);
 		page->objects = max_objects;
 		slab_fix(s, "Number of objects adjusted.");
 	}
 	if (page->inuse != page->objects - nr) {
-		slab_err(s, page, "Wrong object count. Counter is %d but "
-			"counted were %d", page->inuse, page->objects - nr);
+		slab_err(s, page, "Wrong object count. Counter is %d but counted were %d",
+			 page->inuse, page->objects - nr);
 		page->inuse = page->objects - nr;
 		slab_fix(s, "Object count adjusted.");
 	}
@@ -1117,8 +1117,8 @@ static inline int free_consistency_check
 
 	if (unlikely(s != page->slab_cache)) {
 		if (!PageSlab(page)) {
-			slab_err(s, page, "Attempt to free object(0x%p) "
-				"outside of slab", object);
+			slab_err(s, page, "Attempt to free object(0x%p) outside of slab",
+				 object);
 		} else if (!page->slab_cache) {
 			pr_err("SLUB <none>: no slab for object 0x%p.\n",
 			       object);
@@ -3439,10 +3439,9 @@ static int kmem_cache_open(struct kmem_c
 	free_kmem_cache_nodes(s);
 error:
 	if (flags & SLAB_PANIC)
-		panic("Cannot create slab %s size=%lu realsize=%u "
-			"order=%u offset=%u flags=%lx\n",
-			s->name, (unsigned long)s->size, s->size,
-			oo_order(s->oo), s->offset, flags);
+		panic("Cannot create slab %s size=%lu realsize=%u order=%u offset=%u flags=%lx\n",
+		      s->name, (unsigned long)s->size, s->size,
+		      oo_order(s->oo), s->offset, flags);
 	return -EINVAL;
 }
 
diff -puN mm/sparse-vmemmap.c~mm-coalesce-split-strings mm/sparse-vmemmap.c
--- a/mm/sparse-vmemmap.c~mm-coalesce-split-strings
+++ a/mm/sparse-vmemmap.c
@@ -166,8 +166,8 @@ void __meminit vmemmap_verify(pte_t *pte
 	int actual_node = early_pfn_to_nid(pfn);
 
 	if (node_distance(actual_node, node) > LOCAL_DISTANCE)
-		printk(KERN_WARNING "[%lx-%lx] potential offnode "
-			"page_structs\n", start, end - 1);
+		printk(KERN_WARNING "[%lx-%lx] potential offnode page_structs\n",
+		       start, end - 1);
 }
 
 pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node)
@@ -292,8 +292,8 @@ void __init sparse_mem_maps_populate_nod
 		if (map_map[pnum])
 			continue;
 		ms = __nr_to_section(pnum);
-		printk(KERN_ERR "%s: sparsemem memory map backing failed "
-			"some memory will not be available.\n", __func__);
+		printk(KERN_ERR "%s: sparsemem memory map backing failed some memory will not be available.\n",
+		       __func__);
 		ms->section_mem_map = 0;
 	}
 
diff -puN mm/sparse.c~mm-coalesce-split-strings mm/sparse.c
--- a/mm/sparse.c~mm-coalesce-split-strings
+++ a/mm/sparse.c
@@ -428,8 +428,8 @@ void __init sparse_mem_maps_populate_nod
 		if (map_map[pnum])
 			continue;
 		ms = __nr_to_section(pnum);
-		printk(KERN_ERR "%s: sparsemem memory map backing failed "
-			"some memory will not be available.\n", __func__);
+		printk(KERN_ERR "%s: sparsemem memory map backing failed some memory will not be available.\n",
+		       __func__);
 		ms->section_mem_map = 0;
 	}
 }
@@ -456,8 +456,8 @@ static struct page __init *sparse_early_
 	if (map)
 		return map;
 
-	printk(KERN_ERR "%s: sparsemem memory map backing failed "
-			"some memory will not be available.\n", __func__);
+	printk(KERN_ERR "%s: sparsemem memory map backing failed some memory will not be available.\n",
+	       __func__);
 	ms->section_mem_map = 0;
 	return NULL;
 }
diff -puN mm/swapfile.c~mm-coalesce-split-strings mm/swapfile.c
--- a/mm/swapfile.c~mm-coalesce-split-strings
+++ a/mm/swapfile.c
@@ -2526,8 +2526,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 		  (swap_flags & SWAP_FLAG_PRIO_MASK) >> SWAP_FLAG_PRIO_SHIFT;
 	enable_swap_info(p, prio, swap_map, cluster_info, frontswap_map);
 
-	pr_info("Adding %uk swap on %s.  "
-			"Priority:%d extents:%d across:%lluk %s%s%s%s%s\n",
+	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s%s\n",
 		p->pages<<(PAGE_SHIFT-10), name->name, p->prio,
 		nr_extents, (unsigned long long)span<<(PAGE_SHIFT-10),
 		(p->flags & SWP_SOLIDSTATE) ? "SS" : "",
diff -puN mm/vmalloc.c~mm-coalesce-split-strings mm/vmalloc.c
--- a/mm/vmalloc.c~mm-coalesce-split-strings
+++ a/mm/vmalloc.c
@@ -469,8 +469,8 @@ overflow:
 		goto retry;
 	}
 	if (printk_ratelimit())
-		pr_warn("vmap allocation for size %lu failed: "
-			"use vmalloc=<size> to increase size.\n", size);
+		pr_warn("vmap allocation for size %lu failed: use vmalloc=<size> to increase size\n",
+			size);
 	kfree(va);
 	return ERR_PTR(-EBUSY);
 }
_

Patches currently in -mm which might be from joe@perches.com are

mm-convert-pr_warning-to-pr_warn.patch
mm-coalesce-split-strings.patch
mm-convert-printkkern_level-to-pr_level.patch
mm-percpu-use-pr_fmt-to-prefix-output.patch
checkpatch-exclude-asm-volatile-from-complex-macro-check.patch
kernel-convert-pr_warning-to-pr_warn.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E44367F52
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388598; cv=none; b=abhXKZ7CxBoBxO7hb4GyoS+ZaZbM0T/wXQEQIV9cqKj5B+FjDl6ysIvBoS6Ii1+Ti5pqTqMoIQH5kCNouEqSbnVRabm/7j7uM6icxwYW3tzPrVdx1Bk124rd6Q2K/be2xrKvVfmw1JEsGNojOj00TYU7mRWI9jErjfxGLM28NhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388598; c=relaxed/simple;
	bh=qMJgBFjeUoHIDb27ORI8gxGWF6eeUc+2EsHMfFa2IjU=;
	h=Date:To:From:Subject:Message-Id; b=jFDZLBUs979I0KjoAzhhLUO8P7yu6UtwSGz0WtCUv4mYccMJY5aZryqfTiY7y75zca2o3bNSAdNu3SSkWicT6XU6wjOXAnY+FKqzC/0dprZ7LOYrpovQpE3MLbGj+XRCT+QZ7RkiHj8l/jQca296acjJvj4kSNtM7/h9/DJeRa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WZktR7W9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WZktR7W9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B0B9C19424;
	Tue, 24 Mar 2026 21:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388597;
	bh=qMJgBFjeUoHIDb27ORI8gxGWF6eeUc+2EsHMfFa2IjU=;
	h=Date:To:From:Subject:From;
	b=WZktR7W9Mg5+ySZGG/ot6a6KgEZu98wOggCVEdaS3AMb4Eq9Vy/CupAIc77aYDo7t
	 uYlO/lvk8dJjkRh13WDfdrvgwSsqTi6EFOAAQQsOMcc5xUVulwjLvT/dRo2uyEKhL9
	 CtdpB8n6ujFzRUitIWDTIGpyOoOyXryzPD5sLoDQ=
Date: Tue, 24 Mar 2026 14:43:17 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,urezki@gmail.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-streamline-vmalloc-memory-accounting.patch removed from -mm tree
Message-Id: <20260324214317.7B0B9C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmalloc: streamline vmalloc memory accounting
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-streamline-vmalloc-memory-accounting.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmalloc: streamline vmalloc memory accounting
Date: Mon, 23 Feb 2026 11:01:06 -0500

Use a vmstat counter instead of a custom, open-coded atomic. This has
the added benefit of making the data available per-node, and prepares
for cleaning up the memcg accounting as well.

Link: https://lkml.kernel.org/r/20260223160147.3792777-1-hannes@cmpxchg.org
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/meminfo.c       |    3 ++-
 include/linux/mmzone.h  |    1 +
 include/linux/vmalloc.h |    3 ---
 mm/vmalloc.c            |   19 ++++++++++---------
 mm/vmstat.c             |    1 +
 5 files changed, 14 insertions(+), 13 deletions(-)

--- a/fs/proc/meminfo.c~mm-vmalloc-streamline-vmalloc-memory-accounting
+++ a/fs/proc/meminfo.c
@@ -126,7 +126,8 @@ static int meminfo_proc_show(struct seq_
 	show_val_kb(m, "Committed_AS:   ", committed);
 	seq_printf(m, "VmallocTotal:   %8lu kB\n",
 		   (unsigned long)VMALLOC_TOTAL >> 10);
-	show_val_kb(m, "VmallocUsed:    ", vmalloc_nr_pages());
+	show_val_kb(m, "VmallocUsed:    ",
+		    global_node_page_state(NR_VMALLOC));
 	show_val_kb(m, "VmallocChunk:   ", 0ul);
 	show_val_kb(m, "Percpu:         ", pcpu_nr_pages());
 
--- a/include/linux/mmzone.h~mm-vmalloc-streamline-vmalloc-memory-accounting
+++ a/include/linux/mmzone.h
@@ -220,6 +220,7 @@ enum node_stat_item {
 	NR_KERNEL_MISC_RECLAIMABLE,	/* reclaimable non-slab kernel pages */
 	NR_FOLL_PIN_ACQUIRED,	/* via: pin_user_page(), gup flag: FOLL_PIN */
 	NR_FOLL_PIN_RELEASED,	/* pages returned via unpin_user_page() */
+	NR_VMALLOC,
 	NR_KERNEL_STACK_KB,	/* measured in KiB */
 #if IS_ENABLED(CONFIG_SHADOW_CALL_STACK)
 	NR_KERNEL_SCS_KB,	/* measured in KiB */
--- a/include/linux/vmalloc.h~mm-vmalloc-streamline-vmalloc-memory-accounting
+++ a/include/linux/vmalloc.h
@@ -286,8 +286,6 @@ int unregister_vmap_purge_notifier(struc
 #ifdef CONFIG_MMU
 #define VMALLOC_TOTAL (VMALLOC_END - VMALLOC_START)
 
-unsigned long vmalloc_nr_pages(void);
-
 int vm_area_map_pages(struct vm_struct *area, unsigned long start,
 		      unsigned long end, struct page **pages);
 void vm_area_unmap_pages(struct vm_struct *area, unsigned long start,
@@ -304,7 +302,6 @@ static inline void set_vm_flush_reset_pe
 #else  /* !CONFIG_MMU */
 #define VMALLOC_TOTAL 0UL
 
-static inline unsigned long vmalloc_nr_pages(void) { return 0; }
 static inline void set_vm_flush_reset_perms(void *addr) {}
 #endif /* CONFIG_MMU */
 
--- a/mm/vmalloc.c~mm-vmalloc-streamline-vmalloc-memory-accounting
+++ a/mm/vmalloc.c
@@ -1068,14 +1068,8 @@ static BLOCKING_NOTIFIER_HEAD(vmap_notif
 static void drain_vmap_area_work(struct work_struct *work);
 static DECLARE_WORK(drain_vmap_work, drain_vmap_area_work);
 
-static __cacheline_aligned_in_smp atomic_long_t nr_vmalloc_pages;
 static __cacheline_aligned_in_smp atomic_long_t vmap_lazy_nr;
 
-unsigned long vmalloc_nr_pages(void)
-{
-	return atomic_long_read(&nr_vmalloc_pages);
-}
-
 static struct vmap_area *__find_vmap_area(unsigned long addr, struct rb_root *root)
 {
 	struct rb_node *n = root->rb_node;
@@ -3476,11 +3470,11 @@ void vfree(const void *addr)
 		 * High-order allocs for huge vmallocs are split, so
 		 * can be freed as an array of order-0 allocations
 		 */
+		if (!(vm->flags & VM_MAP_PUT_PAGES))
+			dec_node_page_state(page, NR_VMALLOC);
 		__free_page(page);
 		cond_resched();
 	}
-	if (!(vm->flags & VM_MAP_PUT_PAGES))
-		atomic_long_sub(vm->nr_pages, &nr_vmalloc_pages);
 	kvfree(vm->pages);
 	kfree(vm);
 }
@@ -3668,6 +3662,8 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 			continue;
 		}
 
+		mod_node_page_state(page_pgdat(page), NR_VMALLOC, 1 << large_order);
+
 		split_page(page, large_order);
 		for (i = 0; i < (1U << large_order); i++)
 			pages[nr_allocated + i] = page + i;
@@ -3688,6 +3684,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 	if (!order) {
 		while (nr_allocated < nr_pages) {
 			unsigned int nr, nr_pages_request;
+			int i;
 
 			/*
 			 * A maximum allowed request is hard-coded and is 100
@@ -3711,6 +3708,9 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 							nr_pages_request,
 							pages + nr_allocated);
 
+			for (i = nr_allocated; i < nr_allocated + nr; i++)
+				inc_node_page_state(pages[i], NR_VMALLOC);
+
 			nr_allocated += nr;
 
 			/*
@@ -3735,6 +3735,8 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 		if (unlikely(!page))
 			break;
 
+		mod_node_page_state(page_pgdat(page), NR_VMALLOC, 1 << order);
+
 		/*
 		 * High-order allocations must be able to be treated as
 		 * independent small pages by callers (as they can with
@@ -3877,7 +3879,6 @@ static void *__vmalloc_area_node(struct
 			vmalloc_gfp_adjust(gfp_mask, page_order), node,
 			page_order, nr_small_pages, area->pages);
 
-	atomic_long_add(area->nr_pages, &nr_vmalloc_pages);
 	/* All pages of vm should be charged to same memcg, so use first one. */
 	if (gfp_mask & __GFP_ACCOUNT && area->nr_pages)
 		mod_memcg_page_state(area->pages[0], MEMCG_VMALLOC,
--- a/mm/vmstat.c~mm-vmalloc-streamline-vmalloc-memory-accounting
+++ a/mm/vmstat.c
@@ -1255,6 +1255,7 @@ const char * const vmstat_text[] = {
 	[I(NR_KERNEL_MISC_RECLAIMABLE)]		= "nr_kernel_misc_reclaimable",
 	[I(NR_FOLL_PIN_ACQUIRED)]		= "nr_foll_pin_acquired",
 	[I(NR_FOLL_PIN_RELEASED)]		= "nr_foll_pin_released",
+	[I(NR_VMALLOC)]				= "nr_vmalloc",
 	[I(NR_KERNEL_STACK_KB)]			= "nr_kernel_stack",
 #if IS_ENABLED(CONFIG_SHADOW_CALL_STACK)
 	[I(NR_KERNEL_SCS_KB)]			= "nr_shadow_call_stack",
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-split-out-__obj_cgroup_charge.patch
mm-memcontrol-use-__account_obj_stock-in-the-locked-path.patch
mm-memcg-separate-slab-stat-accounting-from-objcg-charge-cache.patch
mm-list_lru-lock_list_lru_of_memcg-cannot-return-null-if-skip_empty.patch
mm-list_lru-deduplicate-unlock_list_lru.patch
mm-list_lru-move-list-dead-check-to-lock_list_lru_of_memcg.patch
mm-list_lru-deduplicate-lock_list_lru.patch
mm-list_lru-introduce-caller-locking-for-additions-and-deletions.patch
mm-list_lru-introduce-folio_memcg_list_lru_alloc.patch
mm-switch-deferred-split-shrinker-to-list_lru.patch


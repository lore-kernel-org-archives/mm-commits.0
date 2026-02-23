Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FA531A7F6
	for <mm-commits@vger.kernel.org>; Mon, 23 Feb 2026 17:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771867201; cv=none; b=bqslSVJRG7DLlE795CagPozCB+9+OFtHfPrqnpbgHcMr6HnAbxue7GdURsEM2Go6GayNBkNWdcc6nqnc3u8ZUDUIsyXqgWSyZABfM0Snph0MXzx0VmJ6/lvq7Wio3Wf7FGxwvhztu2fiiJjKqAwIi4CsskhmgNsW6EjI0Ky/qQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771867201; c=relaxed/simple;
	bh=TWbFa/VZVCYA4xnXisKHV8/sGLVDuYn/QeAwbPUGtO4=;
	h=Date:To:From:Subject:Message-Id; b=pj6Na+1MnQ3MOhmXH6Rl2YUZMgpR/JbAcvm552e5tacI8NtXIFif7gqBdsS3xEgmQsQzkuwkmCCp5HwuVNZFeS10ODdVDVCe26wFCGIh4pLZFbIy/2ncE+f9NDDJ+fNdH9lS9vldNRws1584P3WHJY/SD/2cdalJkYxpwNB1IiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TqHq5tJI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TqHq5tJI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F30C116C6;
	Mon, 23 Feb 2026 17:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771867200;
	bh=TWbFa/VZVCYA4xnXisKHV8/sGLVDuYn/QeAwbPUGtO4=;
	h=Date:To:From:Subject:From;
	b=TqHq5tJILztVJsmtmRn2qKAIkuPXJ+Nvx6qtp+bOS/2setmM7l5RDibA28sZOO6D5
	 0V9gxDLTQx/P7aScWRMCgixiqKFvt8WoChSQT8t5i9lBaVtJgePor+zhvktA90i+Iu
	 vy5FdtZQd9RQfoaZKhvEpUGmLna3PM1jTPO3/+P4=
Date: Mon, 23 Feb 2026 09:19:59 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-streamline-vmalloc-memory-accounting.patch added to mm-new branch
Message-Id: <20260223172000.83F30C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmalloc: streamline vmalloc memory accounting
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-streamline-vmalloc-memory-accounting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-streamline-vmalloc-memory-accounting.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
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

mm-vmalloc-streamline-vmalloc-memory-accounting.patch
mm-memcontrol-switch-to-native-nr_vmalloc-vmstat-counter.patch


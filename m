From: akpm@linux-foundation.org
Subject: + mm-memcontrol-rewrite-charge-api-fix-3.patch added to -mm tree
Date: Fri, 20 Jun 2014 14:40:52 -0700
Message-ID: <53a4aa64.bnMKJj37Y7LWSU8+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33012 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357AbaFTVkx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jun 2014 17:40:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hannes@cmpxchg.org


The patch titled
     Subject: kernel: uprobes: switch to new memcg charge protocol
has been added to the -mm tree.  Its filename is
     mm-memcontrol-rewrite-charge-api-fix-3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-rewrite-charge-api-fix-3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-rewrite-charge-api-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: kernel: uprobes: switch to new memcg charge protocol

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/uprobes.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN kernel/events/uprobes.c~mm-memcontrol-rewrite-charge-api-fix-3 kernel/events/uprobes.c
--- a/kernel/events/uprobes.c~mm-memcontrol-rewrite-charge-api-fix-3
+++ a/kernel/events/uprobes.c
@@ -167,6 +167,11 @@ static int __replace_page(struct vm_area
 	/* For mmu_notifiers */
 	const unsigned long mmun_start = addr;
 	const unsigned long mmun_end   = addr + PAGE_SIZE;
+	struct mem_cgroup *memcg;
+
+	err = mem_cgroup_try_charge(kpage, vma->vm_mm, GFP_KERNEL, &memcg);
+	if (err)
+		return err;
 
 	/* For try_to_free_swap() and munlock_vma_page() below */
 	lock_page(page);
@@ -179,6 +184,7 @@ static int __replace_page(struct vm_area
 
 	get_page(kpage);
 	page_add_new_anon_rmap(kpage, vma, addr);
+	mem_cgroup_commit_charge(kpage, memcg, false);
 	lru_cache_add_active_or_unevictable(kpage, vma);
 
 	if (!PageAnon(page)) {
@@ -201,6 +207,7 @@ static int __replace_page(struct vm_area
 
 	err = 0;
  unlock:
+	mem_cgroup_cancel_charge(kpage, memcg);
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 	unlock_page(page);
 	return err;
@@ -316,18 +323,11 @@ retry:
 	if (!new_page)
 		goto put_old;
 
-	if (mem_cgroup_charge_anon(new_page, mm, GFP_KERNEL))
-		goto put_new;
-
 	__SetPageUptodate(new_page);
 	copy_highpage(new_page, old_page);
 	copy_to_page(new_page, vaddr, &opcode, UPROBE_SWBP_INSN_SIZE);
 
 	ret = __replace_page(vma, vaddr, old_page, new_page);
-	if (ret)
-		mem_cgroup_uncharge_page(new_page);
-
-put_new:
 	page_cache_release(new_page);
 put_old:
 	put_page(old_page);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

vmalloc-use-rcu-list-iterator-to-reduce-vmap_area_lock-contention.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches.patch
mm-memcontrol-fold-mem_cgroup_do_charge.patch
mm-memcontrol-rearrange-charging-fast-path.patch
mm-memcontrol-reclaim-at-least-once-for-__gfp_noretry.patch
mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages.patch
mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges.patch
mm-memcontrol-remove-explicit-oom-parameter-in-charge-path.patch
mm-memcontrol-simplify-move-precharge-function.patch
mm-memcontrol-catch-root-bypass-in-move-precharge.patch
mm-memcontrol-use-root_mem_cgroup-res_counter.patch
mm-memcontrol-remove-ordering-between-pc-mem_cgroup-and-pagecgroupused.patch
mm-memcontrol-do-not-acquire-page_cgroup-lock-for-kmem-pages.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-charge-api-fix-3.patch
mm-memcontrol-rewrite-charge-api-fix-2.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-rewrite-uncharge-api-fix-2.patch
memcg-deprecate-memoryforce_empty-knob.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch


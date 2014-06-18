From: akpm@linux-foundation.org
Subject: + mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages.patch added to -mm tree
Date: Wed, 18 Jun 2014 16:54:48 -0700
Message-ID: <53a226c8.KqanydfUgJmQYkBu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43322 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555AbaFRXyt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jun 2014 19:54:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vdavydov@parallels.com, tj@kernel.org, mhocko@suse.cz, hughd@google.com, hannes@cmpxchg.org


The patch titled
     Subject: mm: huge_memory: use GFP_TRANSHUGE when charging huge pages
has been added to the -mm tree.  Its filename is
     mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages.patch

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
Subject: mm: huge_memory: use GFP_TRANSHUGE when charging huge pages

Transparent huge page charges prefer falling back to regular pages rather
than spending a lot of time in direct reclaim.

Desired reclaim behavior is usually declared in the gfp mask, but THP
charges use GFP_KERNEL and then rely on the fact that OOM is disabled for
THP charges, and that OOM-disabled charges don't retry reclaim.  Needless
to say, this is anything but obvious and quite error prone.

Convert THP charges to use GFP_TRANSHUGE instead, which implies
__GFP_NORETRY, to indicate the low-latency requirement.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/huge_memory.c~mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages mm/huge_memory.c
--- a/mm/huge_memory.c~mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages
+++ a/mm/huge_memory.c
@@ -827,7 +827,7 @@ int do_huge_pmd_anonymous_page(struct mm
 		count_vm_event(THP_FAULT_FALLBACK);
 		return VM_FAULT_FALLBACK;
 	}
-	if (unlikely(mem_cgroup_charge_anon(page, mm, GFP_KERNEL))) {
+	if (unlikely(mem_cgroup_charge_anon(page, mm, GFP_TRANSHUGE))) {
 		put_page(page);
 		count_vm_event(THP_FAULT_FALLBACK);
 		return VM_FAULT_FALLBACK;
@@ -1132,7 +1132,7 @@ alloc:
 		goto out;
 	}
 
-	if (unlikely(mem_cgroup_charge_anon(new_page, mm, GFP_KERNEL))) {
+	if (unlikely(mem_cgroup_charge_anon(new_page, mm, GFP_TRANSHUGE))) {
 		put_page(new_page);
 		if (page) {
 			split_huge_page(page);
@@ -2399,7 +2399,7 @@ static void collapse_huge_page(struct mm
 	if (!new_page)
 		return;
 
-	if (unlikely(mem_cgroup_charge_anon(new_page, mm, GFP_KERNEL)))
+	if (unlikely(mem_cgroup_charge_anon(new_page, mm, GFP_TRANSHUGE)))
 		return;
 
 	/*
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
mm-memcontrol-rewrite-uncharge-api.patch
memcg-deprecate-memoryforce_empty-knob.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch


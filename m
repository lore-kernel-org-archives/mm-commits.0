From: akpm@linux-foundation.org
Subject: + mm-memcontrol-do-not-iterate-uninitialized-memcgs.patch added
 to -mm tree
Date: Thu, 25 Sep 2014 13:52:59 -0700
Message-ID: <542480ab.J8pI2Zm2ZcDC7MQE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35592 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaIYUxA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Sep 2014 16:53:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.cz, peterz@infradead.org, stable@vger.kernel.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: do not iterate uninitialized memcgs
has been added to the -mm tree.  Its filename is
     mm-memcontrol-do-not-iterate-uninitialized-memcgs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-do-not-iterate-uninitialized-memcgs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-do-not-iterate-uninitialized-memcgs.patch

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
Subject: mm: memcontrol: do not iterate uninitialized memcgs

The cgroup iterators yield css objects that have not yet gone through
css_online(), but they are not complete memcgs at this point and so the
memcg iterators should not return them.  d8ad30559715 ("mm/memcg:
iteration skip memcgs not yet fully initialized") set out to implement
exactly this, but it uses CSS_ONLINE, a cgroup-internal flag that does not
meet the ordering requirements for memcg, and so the iterator may skip
over initialized groups, or return partially initialized memcgs.

The cgroup core can not reasonably provide a clear answer on whether the
object around the css has been fully initialized, as that depends on
controller-specific locking and lifetime rules.  Thus, introduce a
memcg-specific flag that is set after the memcg has been initialized in
css_online(), and read before mem_cgroup_iter() callers access the memcg
members.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@vger.kernel.org>	[3.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   36 +++++++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-do-not-iterate-uninitialized-memcgs mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-do-not-iterate-uninitialized-memcgs
+++ a/mm/memcontrol.c
@@ -292,6 +292,9 @@ struct mem_cgroup {
 	/* vmpressure notifications */
 	struct vmpressure vmpressure;
 
+	/* css_online() has been completed */
+	int initialized;
+
 	/*
 	 * the counter to account for mem+swap usage.
 	 */
@@ -1099,10 +1102,21 @@ skip_node:
 	 * skipping css reference should be safe.
 	 */
 	if (next_css) {
-		if ((next_css == &root->css) ||
-		    ((next_css->flags & CSS_ONLINE) &&
-		     css_tryget_online(next_css)))
-			return mem_cgroup_from_css(next_css);
+		struct mem_cgroup *memcg = mem_cgroup_from_css(next_css);
+
+		if (next_css == &root->css)
+			return memcg;
+
+		if (css_tryget_online(next_css)) {
+			/*
+			 * Make sure the memcg is initialized:
+			 * mem_cgroup_css_online() orders the the
+			 * initialization against setting the flag.
+			 */
+			if (smp_load_acquire(&memcg->initialized))
+				return memcg;
+			css_put(next_css);
+		}
 
 		prev_css = next_css;
 		goto skip_node;
@@ -5549,6 +5563,7 @@ mem_cgroup_css_online(struct cgroup_subs
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 	struct mem_cgroup *parent = mem_cgroup_from_css(css->parent);
+	int ret;
 
 	if (css->id > MEM_CGROUP_ID_MAX)
 		return -ENOSPC;
@@ -5585,7 +5600,18 @@ mem_cgroup_css_online(struct cgroup_subs
 	}
 	mutex_unlock(&memcg_create_mutex);
 
-	return memcg_init_kmem(memcg, &memory_cgrp_subsys);
+	ret = memcg_init_kmem(memcg, &memory_cgrp_subsys);
+	if (ret)
+		return ret;
+
+	/*
+	 * Make sure the memcg is initialized: mem_cgroup_iter()
+	 * orders reading memcg->initialized against its callers
+	 * reading the memcg members.
+	 */
+	smp_store_release(&memcg->initialized, 1);
+
+	return 0;
 }
 
 /*
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page_alloc-fix-zone-allocation-fairness-on-up.patch
mm-memcontrol-do-not-iterate-uninitialized-memcgs.patch
mm-remove-misleading-arch_uses_numa_prot_none.patch
mm-page_alloc-determine-migratetype-only-once.patch
mm-remove-noisy-remainder-of-the-scan_unevictable-interface.patch
mm-page_alloc-avoid-wakeup-kswapd-on-the-unintended-node.patch
mm-clean-up-zone-flags.patch
mm-page_alloc-make-paranoid-check-in-move_freepages-a-vm_bug_on.patch
mm-page_alloc-default-node-ordering-on-64-bit-numa-zone-ordering-on-32-bit-v2.patch
memcg-move-memcg_allocfree_cache_params-to-slab_commonc.patch
memcg-dont-call-memcg_update_all_caches-if-new-cache-id-fits.patch
memcg-move-memcg_update_cache_size-to-slab_commonc.patch
mm-memcontrol-do-not-kill-uncharge-batching-in-free_pages_and_swap_cache.patch
mm-memcontrol-simplify-detecting-when-the-memoryswap-limit-is-hit.patch
mm-memcontrol-fix-transparent-huge-page-allocations-under-pressure.patch
memcg-zap-memcg_can_account_kmem.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch


From: akpm@linux-foundation.org
Subject: +
 mm-memcg-fix-race-condition-between-memcg-teardown-and-swapin.patch added
 to -mm tree
Date: Mon, 09 Dec 2013 14:59:50 -0800
Message-ID: <52a64b66.Es6n1ERQesIAIDM+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54718 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab3LIW7v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Dec 2013 17:59:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@kernel.org, rientjes@google.com, mhocko@suse.cz, hannes@cmpxchg.org

Subject: + mm-memcg-fix-race-condition-between-memcg-teardown-and-swapin.patch added to -mm tree
To: hannes@cmpxchg.org,mhocko@suse.cz,rientjes@google.com,stable@kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Dec 2013 14:59:50 -0800


The patch titled
     Subject: mm: memcg: fix race condition between memcg teardown and swapin
has been added to the -mm tree.  Its filename is
     mm-memcg-fix-race-condition-between-memcg-teardown-and-swapin.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-fix-race-condition-between-memcg-teardown-and-swapin.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-fix-race-condition-between-memcg-teardown-and-swapin.patch

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
Subject: mm: memcg: fix race condition between memcg teardown and swapin

There is a race condition between a memcg being torn down and a swapin
triggered from a different memcg of a page that was recorded to belong to
the exiting memcg on swapout (with CONFIG_MEMCG_SWAP extension).  The
result is unreclaimable pages pointing to dead memcgs, which can lead to
anything from endless loops in later memcg teardown (the page is charged
to all hierarchical parents but is not on any LRU list) or crashes from
following the dangling memcg pointer.

Memcgs with tasks in them can not be torn down and usually charges don't
show up in memcgs without tasks.  Swapin with the CONFIG_MEMCG_SWAP
extension is the notable exception because it charges the cgroup that was
recorded as owner during swapout, which may be empty and in the process of
being torn down when a task in another memcg triggers the swapin:

  teardown:                 swapin:

                            lookup_swap_cgroup_id()
                            rcu_read_lock()
                            mem_cgroup_lookup()
                            css_tryget()
                            rcu_read_unlock()
  disable css_tryget()
  call_rcu()
    offline_css()
      reparent_charges()
                            res_counter_charge() (hierarchical!)
                            css_put()
                              css_free()
                            pc->mem_cgroup = dead memcg
                            add page to dead lru

Add a final reparenting step into css_free() to make sure any such raced
charges are moved out of the memcg before it's finally freed.

In the longer term it would be cleaner to have the css_tryget() and the
res_counter charge under the same RCU lock section so that the charge
reparenting is deferred until the last charge whose tryget succeeded is
visible.  But this will require more invasive changes that will be harder
to evaluate and backport into stable, so better defer them to a separate
change set.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff -puN mm/memcontrol.c~mm-memcg-fix-race-condition-between-memcg-teardown-and-swapin mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-fix-race-condition-between-memcg-teardown-and-swapin
+++ a/mm/memcontrol.c
@@ -6355,6 +6355,42 @@ static void mem_cgroup_css_offline(struc
 static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+	/*
+	 * XXX: css_offline() would be where we should reparent all
+	 * memory to prepare the cgroup for destruction.  However,
+	 * memcg does not do css_tryget() and res_counter charging
+	 * under the same RCU lock region, which means that charging
+	 * could race with offlining.  Offlining only happens to
+	 * cgroups with no tasks in them but charges can show up
+	 * without any tasks from the swapin path when the target
+	 * memcg is looked up from the swapout record and not from the
+	 * current task as it usually is.  A race like this can leak
+	 * charges and put pages with stale cgroup pointers into
+	 * circulation:
+	 *
+	 * #0                        #1
+	 *                           lookup_swap_cgroup_id()
+	 *                           rcu_read_lock()
+	 *                           mem_cgroup_lookup()
+	 *                           css_tryget()
+	 *                           rcu_read_unlock()
+	 * disable css_tryget()
+	 * call_rcu()
+	 *   offline_css()
+	 *     reparent_charges()
+	 *                           res_counter_charge()
+	 *                           css_put()
+	 *                             css_free()
+	 *                           pc->mem_cgroup = dead memcg
+	 *                           add page to lru
+	 *
+	 * The bulk of the charges are still moved in offline_css() to
+	 * avoid pinning a lot of pages in case a long-term reference
+	 * like a swapout record is deferring the css_free() to long
+	 * after offlining.  But this makes sure we catch any charges
+	 * made after offlining:
+	 */
+	mem_cgroup_reparent_charges(memcg);
 
 	memcg_destroy_kmem(memcg);
 	__mem_cgroup_free(memcg);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcg-do-not-declare-oom-from-__gfp_nofail-allocations.patch
mm-memcg-fix-race-condition-between-memcg-teardown-and-swapin.patch
mm-memcg-do-not-allow-task-about-to-oom-kill-to-bypass-the-limit.patch
mm-memcg-avoid-oom-notification-when-current-needs-access-to-memory-reserves.patch
proc-meminfo-provide-estimated-available-memory.patch
mm-mempolicy-remove-unneeded-functions-for-uma-configs.patch
x86-get-pg_data_ts-memory-from-other-node.patch
memblock-numa-introduce-flags-field-into-memblock.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions.patch
memblock-make-memblock_set_node-support-different-memblock_type.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock.patch
acpi-numa-mem_hotplug-mark-all-nodes-the-kernel-resides-un-hotpluggable.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed.patch
x86-numa-acpi-memory-hotplug-make-movable_node-have-higher-priority.patch
memcg-fix-kmem_account_flags-check-in-memcg_can_account_kmem.patch
memcg-make-memcg_update_cache_sizes-static.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch


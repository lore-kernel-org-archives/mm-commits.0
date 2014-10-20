From: akpm@linux-foundation.org
Subject: + mm-memcontrol-micro-optimize-mem_cgroup_update_page_stat.patch
 added to -mm tree
Date: Mon, 20 Oct 2014 14:54:42 -0700
Message-ID: <544584a2.ZwmV+SUq7K2FGUpA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57334 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839AbaJTVym (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Oct 2014 17:54:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: micro-optimize mem_cgroup_update_page_stat()
has been added to the -mm tree.  Its filename is
     mm-memcontrol-micro-optimize-mem_cgroup_update_page_stat.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-micro-optimize-mem_cgroup_update_page_stat.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-micro-optimize-mem_cgroup_update_page_stat.patch

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
Subject: mm: memcontrol: micro-optimize mem_cgroup_update_page_stat()

Do not look up the page_cgroup when the memory controller is
runtime-disabled, but do assert that the locking protocol is followed
under DEBUG_VM regardless.  Also remove the unused flags variable.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-micro-optimize-mem_cgroup_update_page_stat mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-micro-optimize-mem_cgroup_update_page_stat
+++ a/mm/memcontrol.c
@@ -2177,13 +2177,14 @@ void mem_cgroup_update_page_stat(struct
 				 enum mem_cgroup_stat_index idx, int val)
 {
 	struct mem_cgroup *memcg;
-	struct page_cgroup *pc = lookup_page_cgroup(page);
-	unsigned long uninitialized_var(flags);
+	struct page_cgroup *pc;
+
+	VM_BUG_ON(!rcu_read_lock_held());
 
 	if (mem_cgroup_disabled())
 		return;
 
-	VM_BUG_ON(!rcu_read_lock_held());
+	pc = lookup_page_cgroup(page);
 	memcg = pc->mem_cgroup;
 	if (unlikely(!memcg || !PageCgroupUsed(pc)))
 		return;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

cgroup-kmemleak-add-kmemleak_free-for-cgroup-deallocations.patch
mm-memcontrol-lockless-page-counters.patch
mm-memcontrol-lockless-page-counters-fix.patch
mm-memcontrol-lockless-page-counters-fix-fix.patch
mm-memcontrol-lockless-page-counters-fix-2.patch
mm-hugetlb_cgroup-convert-to-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
kernel-res_counter-remove-the-unused-api-fix.patch
kernel-res_counter-remove-the-unused-api-fix-2.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting-fix.patch
mm-memcontrol-take-a-css-reference-for-each-charged-page.patch
mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks.patch
mm-memcontrol-continue-cache-reclaim-from-offlined-groups.patch
mm-memcontrol-remove-synchroneous-stock-draining-code.patch
mm-vmscan-count-only-dirty-pages-as-congested.patch
memcg-simplify-unreclaimable-groups-handling-in-soft-limit-reclaim.patch
mm-memcontrol-update-mem_cgroup_page_lruvec-documentation.patch
mm-memcontrol-clarify-migration-where-old-page-is-uncharged.patch
memcg-remove-activate_kmem_mutex.patch
mm-memcontrol-micro-optimize-mem_cgroup_update_page_stat.patch
mm-memcontrol-uncharge-pages-on-swapout.patch
mm-memcontrol-remove-unnecessary-pcg_memsw-memoryswap-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_mem-memory-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag.patch
debugging-keep-track-of-page-owners.patch


From: akpm@linux-foundation.org
Subject: + mm-memcontrol-uncharge-pages-on-swapout.patch added to -mm tree
Date: Mon, 20 Oct 2014 14:59:54 -0700
Message-ID: <544585da.aQtd3JwfjZjGyzJ1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57358 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbaJTV7z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Oct 2014 17:59:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: uncharge pages on swapout
has been added to the -mm tree.  Its filename is
     mm-memcontrol-uncharge-pages-on-swapout.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-uncharge-pages-on-swapout.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-uncharge-pages-on-swapout.patch

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
Subject: mm: memcontrol: uncharge pages on swapout

This series gets rid of the remaining page_cgroup flags, thus cutting the
memcg per-page overhead down to one pointer.


This patch (of 4):

mem_cgroup_swapout() is called with exclusive access to the page at the
end of the page's lifetime.  Instead of clearing the PCG_MEMSW flag and
deferring the uncharge, just do it right away.  This allows follow-up
patches to simplify the uncharge code.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-uncharge-pages-on-swapout mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-uncharge-pages-on-swapout
+++ a/mm/memcontrol.c
@@ -5769,6 +5769,7 @@ static void __init enable_swap_cgroup(vo
  */
 void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
 {
+	struct mem_cgroup *memcg;
 	struct page_cgroup *pc;
 	unsigned short oldid;
 
@@ -5785,13 +5786,21 @@ void mem_cgroup_swapout(struct page *pag
 		return;
 
 	VM_BUG_ON_PAGE(!(pc->flags & PCG_MEMSW), page);
+	memcg = pc->mem_cgroup;
 
-	oldid = swap_cgroup_record(entry, mem_cgroup_id(pc->mem_cgroup));
+	oldid = swap_cgroup_record(entry, mem_cgroup_id(memcg));
 	VM_BUG_ON_PAGE(oldid, page);
+	mem_cgroup_swap_statistics(memcg, true);
 
-	pc->flags &= ~PCG_MEMSW;
-	css_get(&pc->mem_cgroup->css);
-	mem_cgroup_swap_statistics(pc->mem_cgroup, true);
+	pc->flags = 0;
+
+	if (!mem_cgroup_is_root(memcg))
+		page_counter_uncharge(&memcg->memory, 1);
+
+	local_irq_disable();
+	mem_cgroup_charge_statistics(memcg, page, -1);
+	memcg_check_events(memcg, page);
+	local_irq_enable();
 }
 
 /**
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
mm-memcontrol-micro-optimize-mem_cgroup_split_huge_fixup.patch
mm-memcontrol-uncharge-pages-on-swapout.patch
mm-memcontrol-remove-unnecessary-pcg_memsw-memoryswap-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_mem-memory-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag.patch
debugging-keep-track-of-page-owners.patch


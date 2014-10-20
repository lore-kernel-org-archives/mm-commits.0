From: akpm@linux-foundation.org
Subject: + mm-memcontrol-micro-optimize-mem_cgroup_split_huge_fixup.patch
 added to -mm tree
Date: Mon, 20 Oct 2014 14:56:20 -0700
Message-ID: <54458504.sfT6aJXaeQo3K48x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57340 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbaJTV4U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Oct 2014 17:56:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hannes@cmpxchg.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: micro-optimize mem_cgroup_split_huge_fixup()
has been added to the -mm tree.  Its filename is
     mm-memcontrol-micro-optimize-mem_cgroup_split_huge_fixup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-micro-optimize-mem_cgroup_split_huge_fixup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-micro-optimize-mem_cgroup_split_huge_fixup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm: memcontrol: micro-optimize mem_cgroup_split_huge_fixup()

Don't call lookup_page_cgroup() when memcg is disabled.

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcontrol-micro-optimize-mem_cgroup_split_huge_fixup mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-micro-optimize-mem_cgroup_split_huge_fixup
+++ a/mm/memcontrol.c
@@ -3166,7 +3166,7 @@ static inline void memcg_unregister_all_
  */
 void mem_cgroup_split_huge_fixup(struct page *head)
 {
-	struct page_cgroup *head_pc = lookup_page_cgroup(head);
+	struct page_cgroup *head_pc;
 	struct page_cgroup *pc;
 	struct mem_cgroup *memcg;
 	int i;
@@ -3174,6 +3174,8 @@ void mem_cgroup_split_huge_fixup(struct
 	if (mem_cgroup_disabled())
 		return;
 
+	head_pc = lookup_page_cgroup(head);
+
 	memcg = head_pc->mem_cgroup;
 	for (i = 1; i < HPAGE_PMD_NR; i++) {
 		pc = head_pc + i;
_

Patches currently in -mm which might be from mhocko@suse.cz are

cgroup-kmemleak-add-kmemleak_free-for-cgroup-deallocations.patch
mm-memcontrol-lockless-page-counters.patch
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


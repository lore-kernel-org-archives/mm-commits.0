From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-remove-unnecessary-pcg_mem-memory-charge-flag.patch added to
 -mm tree
Date: Mon, 20 Oct 2014 14:59:56 -0700
Message-ID: <544585dc.4H4EbsT+O2Lc+Xbb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57368 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbaJTV74 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Oct 2014 17:59:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: remove unnecessary PCG_MEM memory charge flag
has been added to the -mm tree.  Its filename is
     mm-memcontrol-remove-unnecessary-pcg_mem-memory-charge-flag.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-remove-unnecessary-pcg_mem-memory-charge-flag.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-remove-unnecessary-pcg_mem-memory-charge-flag.patch

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
Subject: mm: memcontrol: remove unnecessary PCG_MEM memory charge flag

PCG_MEM is a remnant from an earlier version of 0a31bc97c80c ("mm:
memcontrol: rewrite uncharge API"), used to tell whether migration cleared
a charge while leaving pc->mem_cgroup valid and PCG_USED set.  But in the
final version, mem_cgroup_migrate() directly uncharges the source page,
rendering this distinction unnecessary.  Remove it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_cgroup.h |    1 -
 mm/memcontrol.c             |    4 +---
 2 files changed, 1 insertion(+), 4 deletions(-)

diff -puN include/linux/page_cgroup.h~mm-memcontrol-remove-unnecessary-pcg_mem-memory-charge-flag include/linux/page_cgroup.h
--- a/include/linux/page_cgroup.h~mm-memcontrol-remove-unnecessary-pcg_mem-memory-charge-flag
+++ a/include/linux/page_cgroup.h
@@ -4,7 +4,6 @@
 enum {
 	/* flags for mem_cgroup */
 	PCG_USED = 0x01,	/* This page is charged to a memcg */
-	PCG_MEM = 0x02,		/* This page holds a memory charge */
 };
 
 struct pglist_data;
diff -puN mm/memcontrol.c~mm-memcontrol-remove-unnecessary-pcg_mem-memory-charge-flag mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-remove-unnecessary-pcg_mem-memory-charge-flag
+++ a/mm/memcontrol.c
@@ -2606,7 +2606,7 @@ static void commit_charge(struct page *p
 	 *   have the page locked
 	 */
 	pc->mem_cgroup = memcg;
-	pc->flags = PCG_USED | PCG_MEM;
+	pc->flags = PCG_USED;
 
 	if (lrucare)
 		unlock_page_lru(page, isolated);
@@ -6147,8 +6147,6 @@ void mem_cgroup_migrate(struct page *old
 	if (!PageCgroupUsed(pc))
 		return;
 
-	VM_BUG_ON_PAGE(!(pc->flags & PCG_MEM), oldpage);
-
 	if (lrucare)
 		lock_page_lru(oldpage, &isolated);
 
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


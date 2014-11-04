From: akpm@linux-foundation.org
Subject: +
 mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix-2.patch
 added to -mm tree
Date: Tue, 04 Nov 2014 13:16:05 -0800
Message-ID: <54594215.IpXmSJUNjjSYR9+M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47844 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaKDVQF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2014 16:16:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, davem@davemloft.net, iamjoonsoo.kim@lge.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, mhocko@suse.cz, tj@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix-2
has been added to the -mm tree.  Its filename is
     mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix-2.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix-2.patch

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
Subject: mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix-2

Remove obsolete memory saving recommendations from the MEMCG Kconfig
help text.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: David Miller <davem@davemloft.net>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Tejun Heo <tj@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |   12 ------------
 1 file changed, 12 deletions(-)

diff -puN init/Kconfig~mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix-2 init/Kconfig
--- a/init/Kconfig~mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix-2
+++ a/init/Kconfig
@@ -990,18 +990,6 @@ config MEMCG
 	  Provides a memory resource controller that manages both anonymous
 	  memory and page cache. (See Documentation/cgroups/memory.txt)
 
-	  Note that setting this option increases fixed memory overhead
-	  associated with each page of memory in the system. By this,
-	  8(16)bytes/PAGE_SIZE on 32(64)bit system will be occupied by memory
-	  usage tracking struct at boot. Total amount of this is printed out
-	  at boot.
-
-	  Only enable when you're ok with these trade offs and really
-	  sure you need the memory resource controller. Even when you enable
-	  this, you can set "cgroup_disable=memory" at your boot option to
-	  disable memory resource controller and you can avoid overheads.
-	  (and lose benefits of memory resource controller)
-
 config MEMCG_SWAP
 	bool "Memory Resource Controller Swap Extension"
 	depends on MEMCG && SWAP
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page_alloc-fix-incorrect-isolation-behavior-by-rechecking-migratetype.patch
mm-page_alloc-add-freepage-on-isolate-pageblock-to-correct-buddy-list.patch
mm-page_alloc-move-freepage-counting-logic-to-__free_one_page.patch
mm-page_alloc-restrict-max-order-of-merging-on-isolated-pageblock.patch
slab-print-slabinfo-header-in-seq-show.patch
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
mm-memcontrol-micro-optimize-mem_cgroup_split_huge_fixup.patch
mm-memcontrol-uncharge-pages-on-swapout.patch
mm-memcontrol-uncharge-pages-on-swapout-fix.patch
mm-memcontrol-remove-unnecessary-pcg_memsw-memoryswap-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_mem-memory-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mm-memcontrol-inline-memcg-move_lock-locking.patch
mm-memcontrol-dont-pass-a-null-memcg-to-mem_cgroup_end_move.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
memcg-remove-mem_cgroup_reclaimable-check-from-soft-reclaim.patch
memcg-use-generic-slab-iterators-for-showing-slabinfo.patch
mm-memcontrol-shorten-the-page-statistics-update-slowpath.patch
mm-memcontrol-remove-bogus-null-check-after-mem_cgroup_from_task.patch
mm-memcontrol-pull-the-null-check-from-__mem_cgroup_same_or_subtree.patch
mm-memcontrol-drop-bogus-rcu-locking-from-mem_cgroup_same_or_subtree.patch
mm-memcg-fix-potential-undefined-when-for-page-stat-accounting.patch
mm-memcontrol-remove-stale-page_cgroup_lock-comment.patch
mm-embed-the-memcg-pointer-directly-into-struct-page.patch
mm-embed-the-memcg-pointer-directly-into-struct-page-fix.patch
mm-page_cgroup-rename-file-to-mm-swap_cgroupc.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix-2.patch
debugging-keep-track-of-page-owners.patch


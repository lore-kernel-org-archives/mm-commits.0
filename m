From: akpm@linux-foundation.org
Subject: +
 mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages-fix.patch
 added to -mm tree
Date: Fri, 31 May 2013 16:13:19 -0700
Message-ID: <51a92e8f.Sxw+j+c2yyhgRIrb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41284 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756836Ab3EaXNU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 May 2013 19:13:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, liwanp@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz

Subject: + mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages-fix.patch added to -mm tree
To: mhocko@suse.cz,kamezawa.hiroyu@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,rientjes@google.com
From: akpm@linux-foundation.org
Date: Fri, 31 May 2013 16:13:19 -0700


The patch titled
     Subject: mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages-fix
has been added to the -mm tree.  Its filename is
     mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages-fix.patch

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
Subject: mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages-fix

Fix CONFIG_HIGHMEM=n build

Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/page_alloc.c~mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages-fix
+++ a/mm/page_alloc.c
@@ -6196,8 +6196,10 @@ __offline_isolated_pages(unsigned long s
 		list_del(&page->lru);
 		rmv_page_order(page);
 		zone->free_area[order].nr_free--;
+#ifdef CONFIG_HIGHMEM
 		if (PageHighMem(page))
 			totalhigh_pages -= 1 << order;
+#endif
 		for (i = 0; i < (1 << order); i++)
 			SetPageReserved((page+i));
 		pfn += (1 << order);
_

Patches currently in -mm which might be from mhocko@suse.cz are

linux-next.patch
memcg-dont-initialize-kmem-cache-destroying-work-for-root-caches.patch
migrate-add-migrate_entry_wait_huge.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
mm-memcg-dont-take-task_lock-in-task_in_mem_cgroup.patch
mm-vmscan-limit-the-number-of-pages-kswapd-reclaims-at-each-priority.patch
mm-vmscan-obey-proportional-scanning-requirements-for-kswapd.patch
mm-vmscan-flatten-kswapd-priority-loop.patch
mm-vmscan-decide-whether-to-compact-the-pgdat-based-on-reclaim-progress.patch
mm-vmscan-do-not-allow-kswapd-to-scan-at-maximum-priority.patch
mm-vmscan-have-kswapd-writeback-pages-based-on-dirty-pages-encountered-not-priority.patch
mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback.patch
mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix.patch
mm-vmscan-check-if-kswapd-should-writepage-once-per-pgdat-scan.patch
mm-vmscan-move-logic-from-balance_pgdat-to-kswapd_shrink_zone.patch
mm-vmscan-stall-page-reclaim-and-writeback-pages-based-on-dirty-writepage-pages-encountered-v3.patch
mm-vmscan-stall-page-reclaim-after-a-list-of-pages-have-been-processed-v3.patch
mm-vmscan-set-zone-flags-before-blocking.patch
mm-vmscan-move-direct-reclaim-wait_iff_congested-into-shrink_list.patch
mm-vmscan-treat-pages-marked-for-immediate-reclaim-as-zone-congestion.patch
mm-vmscan-take-page-buffers-dirty-and-locked-state-into-account-v3.patch
fs-nfs-inform-the-vm-about-pages-being-committed-or-unstable.patch
memcg-update-todo-list-in-documentation.patch
mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages.patch
mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages-fix.patch
mm-pageblock-remove-get-set_pageblock_flags.patch
mm-hugetlb-remove-hugetlb_prefault.patch
mm-hugetlb-use-already-exist-interface-huge_page_shift.patch
memcg-kconfig-info-update.patch
hugetlbfs-support-split-page-table-lock.patch
mm-parisc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-unicore32-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-parisc-prepare-for-killing-free_all_bootmem_node.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch


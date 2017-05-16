From: akpm@linux-foundation.org
Subject: [merged] hwpoison-memcg-forcibly-uncharge-lru-pages.patch
 removed from -mm tree
Date: Tue, 16 May 2017 10:49:47 -0700
Message-ID: <20170516174947.81cwHcxkU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57372 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750970AbdEPRtt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 May 2017 13:49:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bsingharora@gmail.com, ldufour@linux.vnet.ibm.com, mhocko@suse.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com


The patch titled
     Subject: hwpoison, memcg: forcibly uncharge LRU pages
has been removed from the -mm tree.  Its filename was
     hwpoison-memcg-forcibly-uncharge-lru-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: hwpoison, memcg: forcibly uncharge LRU pages

Laurent Dufour has noticed that hwpoinsoned pages are kept charged.  In
his particular case he has hit a bad_page("page still charged to cgroup")
when onlining a hwpoison page.  While this looks like something that
shouldn't happen in the first place because onlining hwpages and returning
them to the page allocator makes only little sense it shows a real
problem.

hwpoison pages do not get freed usually so we do not uncharge them (at
least not since 0a31bc97c80c ("mm: memcontrol: rewrite uncharge API")). 
Each charge pins memcg (since e8ea14cc6ead ("mm: memcontrol: take a css
reference for each charged page")) as well and so the mem_cgroup and the
associated state will never go away.  Fix this leak by forcibly uncharging
a LRU hwpoisoned page in delete_from_lru_cache().  We also have to tweak
uncharge_list because it cannot rely on zero ref count for these pages.

[akpm@linux-foundation.org: coding-style fixes]
Fixes: 0a31bc97c80c ("mm: memcontrol: rewrite uncharge API")
Link: http://lkml.kernel.org/r/20170502185507.GB19165@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Tested-by: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Reviewed-by: Balbir Singh <bsingharora@gmail.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c     |    2 +-
 mm/memory-failure.c |    7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~hwpoison-memcg-forcibly-uncharge-lru-pages mm/memcontrol.c
--- a/mm/memcontrol.c~hwpoison-memcg-forcibly-uncharge-lru-pages
+++ a/mm/memcontrol.c
@@ -5528,7 +5528,7 @@ static void uncharge_list(struct list_he
 		next = page->lru.next;
 
 		VM_BUG_ON_PAGE(PageLRU(page), page);
-		VM_BUG_ON_PAGE(page_count(page), page);
+		VM_BUG_ON_PAGE(!PageHWPoison(page) && page_count(page), page);
 
 		if (!page->mem_cgroup)
 			continue;
diff -puN mm/memory-failure.c~hwpoison-memcg-forcibly-uncharge-lru-pages mm/memory-failure.c
--- a/mm/memory-failure.c~hwpoison-memcg-forcibly-uncharge-lru-pages
+++ a/mm/memory-failure.c
@@ -539,6 +539,13 @@ static int delete_from_lru_cache(struct
 		 */
 		ClearPageActive(p);
 		ClearPageUnevictable(p);
+
+		/*
+		 * Poisoned page might never drop its ref count to 0 so we have
+		 * to uncharge it manually from its memcg.
+		 */
+		mem_cgroup_uncharge(p);
+
 		/*
 		 * drop the page count elevated by isolate_lru_page()
 		 */
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-remove-return-value-from-init_currently_empty_zone.patch
mm-memory_hotplug-use-node-instead-of-zone-in-can_online_high_movable.patch
mm-drop-page_initialized-check-from-get_nid_for_pfn.patch
mm-memory_hotplug-get-rid-of-is_zone_device_section.patch
mm-memory_hotplug-split-up-register_one_node.patch
mm-memory_hotplug-consider-offline-memblocks-removable.patch
mm-consider-zone-which-is-not-fully-populated-to-have-holes.patch
mm-compaction-skip-over-holes-in-__reset_isolation_suitable.patch
mm-__first_valid_page-skip-over-offline-pages.patch
mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo.patch
mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online.patch
mm-memory_hotplug-replace-for_device-by-want_memblock-in-arch_add_memory.patch
mm-memory_hotplug-fix-the-section-mismatch-warning.patch
mm-memory_hotplug-remove-unused-cruft-after-memory-hotplug-rework.patch


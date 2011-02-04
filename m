From: akpm@linux-foundation.org
Subject: + memcg-remove-direct-page_cgroup-to-page-pointer-fix.patch added to -mm tree
Date: Fri, 04 Feb 2011 13:10:10 -0800
Message-ID: <201102042110.p14LAAbF019078@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752243Ab1BDVKT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Feb 2011 16:10:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg-remove-direct-page_cgroup-to-page-pointer-fix
has been added to the -mm tree.  Its filename is
     memcg-remove-direct-page_cgroup-to-page-pointer-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-remove-direct-page_cgroup-to-page-pointer-fix


Move pc -> page linkage checks to the lookup function itself.  I no longer
plan on removing them again, so there is no point in keeping them visible
at the callsites.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c  |    2 --
 mm/page_cgroup.c |   10 ++++++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-direct-page_cgroup-to-page-pointer-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-direct-page_cgroup-to-page-pointer-fix
+++ a/mm/memcontrol.c
@@ -1055,7 +1055,6 @@ unsigned long mem_cgroup_isolate_pages(u
 			continue;
 
 		page = lookup_cgroup_page(pc);
-		VM_BUG_ON(pc != lookup_page_cgroup(page));
 
 		if (unlikely(!PageLRU(page)))
 			continue;
@@ -3320,7 +3319,6 @@ static int mem_cgroup_force_empty_list(s
 		spin_unlock_irqrestore(&zone->lru_lock, flags);
 
 		page = lookup_cgroup_page(pc);
-		VM_BUG_ON(pc != lookup_page_cgroup(page));
 
 		ret = mem_cgroup_move_parent(page, pc, mem, GFP_KERNEL);
 		if (ret == -ENOMEM)
diff -puN mm/page_cgroup.c~memcg-remove-direct-page_cgroup-to-page-pointer-fix mm/page_cgroup.c
--- a/mm/page_cgroup.c~memcg-remove-direct-page_cgroup-to-page-pointer-fix
+++ a/mm/page_cgroup.c
@@ -45,11 +45,14 @@ struct page_cgroup *lookup_page_cgroup(s
 struct page *lookup_cgroup_page(struct page_cgroup *pc)
 {
 	unsigned long pfn;
+	struct page *page;
 	pg_data_t *pgdat;
 
 	pgdat = NODE_DATA(page_cgroup_array_id(pc));
 	pfn = pc - pgdat->node_page_cgroup + pgdat->node_start_pfn;
-	return pfn_to_page(pfn);
+	page = pfn_to_page(pfn);
+	VM_BUG_ON(pc != lookup_page_cgroup(page));
+	return page;
 }
 
 static int __init alloc_node_page_cgroup(int nid)
@@ -117,11 +120,14 @@ struct page_cgroup *lookup_page_cgroup(s
 struct page *lookup_cgroup_page(struct page_cgroup *pc)
 {
 	struct mem_section *section;
+	struct page *page;
 	unsigned long nr;
 
 	nr = page_cgroup_array_id(pc);
 	section = __nr_to_section(nr);
-	return pfn_to_page(pc - section->page_cgroup);
+	page = pfn_to_page(pc - section->page_cgroup);
+	VM_BUG_ON(pc != lookup_page_cgroup(page));
+	return page;
 }
 
 /* __alloc_bootmem...() is protected by !slab_available() */
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path-fix.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-fix-ugly-initialization-of-return-value-is-in-caller.patch
memcg-soft-limit-reclaim-should-end-at-limit-not-below.patch
memcg-simplify-the-way-memory-limits-are-checked.patch
memcg-remove-unused-page-flag-bitfield-defines.patch
memcg-remove-impossible-conditional-when-committing.patch
memcg-remove-null-check-from-lookup_page_cgroup-result.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update.patch
memcg-no-uncharged-pages-reach-page_cgroup_zoneinfo.patch
memcg-change-page_cgroup_zoneinfo-signature.patch
memcg-fold-__mem_cgroup_move_account-into-caller.patch
memcg-condense-page_cgroup-to-page-lookup-points.patch
memcg-remove-direct-page_cgroup-to-page-pointer.patch
memcg-remove-direct-page_cgroup-to-page-pointer-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch


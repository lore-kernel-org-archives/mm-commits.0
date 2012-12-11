From: akpm@linux-foundation.org
Subject: [folded-merged] memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix.patch removed from -mm tree
Date: Tue, 11 Dec 2012 15:40:16 -0800
Message-ID: <20121211234016.C1D1E82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:58250 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab2LKXkR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Dec 2012 18:40:17 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so6005yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Dec 2012 15:40:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, rientjes@google.com, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make zone_pcp_reset independent of MEMORY_HOTREMOVE
has been removed from the -mm tree.  Its filename was
     memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix.patch

This patch was dropped because it was folded into memory-hotplug-allocate-zones-pcp-before-onlining-pages.patch

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm: make zone_pcp_reset independent of MEMORY_HOTREMOVE

340175b7 (mm/hotplug: free zone->pageset when a zone becomes empty)
introduced zone_pcp_reset and hided it inside CONFIG_MEMORY_HOTREMOVE.
Since "memory-hotplug: allocate zone's pcp before onlining pages" the
function is also called from online_pages which is defined outside
CONFIG_MEMORY_HOTREMOVE which causes a linkage error.

The function, although not used outside of MEMORY_{HOTPLUT,HOTREMOVE},
seems like universal enough so let's keep it at its current location
and only remove the HOTREMOVE guard.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix mm/page_alloc.c
--- a/mm/page_alloc.c~memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix
+++ a/mm/page_alloc.c
@@ -5998,7 +5998,6 @@ void __meminit zone_pcp_update(struct zo
 }
 #endif
 
-#ifdef CONFIG_MEMORY_HOTREMOVE
 void zone_pcp_reset(struct zone *zone)
 {
 	unsigned long flags;
@@ -6018,6 +6017,7 @@ void zone_pcp_reset(struct zone *zone)
 	local_irq_restore(flags);
 }
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
 /*
  * All pages in the range must be isolated before calling this.
  */
_

Patches currently in -mm which might be from mhocko@suse.cz are

mm-memcg-make-mem_cgroup_out_of_memory-static.patch
thp-clean-up-__collapse_huge_page_isolate.patch
mm-introduce-mm_find_pmd.patch
thp-introduce-hugepage_vma_check.patch
thp-cleanup-introduce-mk_huge_pmd.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages.patch
mm-introduce-a-common-interface-for-balloon-pages-mobility-fix.patch
mm-oom-change-type-of-oom_score_adj-to-short.patch
mm-oom-fix-race-when-specifying-a-thread-as-the-oom-origin.patch


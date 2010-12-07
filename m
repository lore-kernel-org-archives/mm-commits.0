From: akpm@linux-foundation.org
Subject: + mm-compactionc-avoid-double-mem_cgroup_del_lru.patch added to -mm tree
Date: Tue, 07 Dec 2010 13:53:09 -0800
Message-ID: <201012072153.oB7Lr9MH010209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58635 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751561Ab0LGVxj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Dec 2010 16:53:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, stable@kernel.org


The patch titled
     mm/compaction.c: avoid double mem_cgroup_del_lru()
has been added to the -mm tree.  Its filename is
     mm-compactionc-avoid-double-mem_cgroup_del_lru.patch

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
Subject: mm/compaction.c: avoid double mem_cgroup_del_lru()
From: Minchan Kim <minchan.kim@gmail.com>

del_page_from_lru_list() already called mem_cgroup_del_lru().  So we must
not call it again.  It breaks memcg stats accounting and can trigger a
VM_BUG_ON().

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/compaction.c~mm-compactionc-avoid-double-mem_cgroup_del_lru mm/compaction.c
--- a/mm/compaction.c~mm-compactionc-avoid-double-mem_cgroup_del_lru
+++ a/mm/compaction.c
@@ -279,7 +279,6 @@ static unsigned long isolate_migratepage
 		/* Successfully isolated */
 		del_page_from_lru_list(zone, page, page_lru(page));
 		list_add(&page->lru, migratelist);
-		mem_cgroup_del_lru(page);
 		cc->nr_migratepages++;
 
 		/* Avoid isolating too much */
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

linux-next.patch
mm-compactionc-avoid-double-mem_cgroup_del_lru.patch
mm-vmap-area-cache.patch
mm-find_get_pages_contig-fixlet.patch
mm-deactivate-invalidated-pages.patch
mm-deactivate-invalidated-pages-fix.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
memcg-create-extensible-page-stat-update-routines.patch
memcg-add-lock-to-synchronize-page-accounting-and-migration.patch
memcg-remove-unnecessary-return-from-void-returning-mem_cgroup_del_lru_list.patch
memcg-use-zalloc-rather-than-mallocmemset.patch


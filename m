From: akpm@linux-foundation.org
Subject: + memcg-remove-unnecessary-return-from-void-returning-mem_cgroup_del_lru_list.patch added to -mm tree
Date: Tue, 07 Dec 2010 13:45:59 -0800
Message-ID: <201012072145.oB7LjxVq009870@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753206Ab0LGVqe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Dec 2010 16:46:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     memcg: remove unnecessary return from void-returning mem_cgroup_del_lru_list()
has been added to the -mm tree.  Its filename is
     memcg-remove-unnecessary-return-from-void-returning-mem_cgroup_del_lru_list.patch

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
Subject: memcg: remove unnecessary return from void-returning mem_cgroup_del_lru_list()
From: Minchan Kim <minchan.kim@gmail.com>

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-remove-unnecessary-return-from-void-returning-mem_cgroup_del_lru_list mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-unnecessary-return-from-void-returning-mem_cgroup_del_lru_list
+++ a/mm/memcontrol.c
@@ -821,7 +821,6 @@ void mem_cgroup_del_lru_list(struct page
 		return;
 	VM_BUG_ON(list_empty(&pc->lru));
 	list_del_init(&pc->lru);
-	return;
 }
 
 void mem_cgroup_del_lru(struct page *page)
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

linux-next.patch
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


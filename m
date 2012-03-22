From: akpm@linux-foundation.org
Subject: [merged] memcg-remove-redundant-returns.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:19:36 -0700
Message-ID: <20120322201936.7E9CEA024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:58075 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759215Ab2CVUTj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:19:39 -0400
Received: by mail-bk0-f74.google.com with SMTP id jm19so134271bkc.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:19:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: remove redundant returns
has been removed from the -mm tree.  Its filename was
     memcg-remove-redundant-returns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: memcg: remove redundant returns

Remove redundant returns from ends of functions, and one blank line.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-redundant-returns mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-redundant-returns
+++ a/mm/memcontrol.c
@@ -1391,7 +1391,6 @@ void mem_cgroup_print_oom_info(struct me
 	if (!memcg || !p)
 		return;
 
-
 	rcu_read_lock();
 
 	mem_cgrp = memcg->css.cgroup;
@@ -1926,7 +1925,6 @@ out:
 	if (unlikely(need_unlock))
 		move_unlock_page_cgroup(pc, &flags);
 	rcu_read_unlock();
-	return;
 }
 EXPORT_SYMBOL(mem_cgroup_update_page_stat);
 
@@ -2912,7 +2910,6 @@ direct_uncharge:
 		res_counter_uncharge(&memcg->memsw, nr_pages * PAGE_SIZE);
 	if (unlikely(batch->memcg != memcg))
 		memcg_oom_recover(memcg);
-	return;
 }
 
 /*
@@ -3937,7 +3934,6 @@ static void memcg_get_hierarchical_limit
 out:
 	*mem_limit = min_limit;
 	*memsw_limit = min_memsw_limit;
-	return;
 }
 
 static int mem_cgroup_reset(struct cgroup *cont, unsigned int event)
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
mm-hugetlb-cleanup-duplicated-code-in-unmapping-vm-range.patch
radix-tree-introduce-bit-optimized-iterator.patch
radix-tree-introduce-bit-optimized-iterator-v3.patch
radix-tree-introduce-bit-optimized-iterator-v3-fix.patch
radix-tree-rewrite-gang-lookup-with-using-iterator.patch
radix-tree-use-iterators-in-find_get_pages-functions.patch
prio_tree-debugging-patch.patch


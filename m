From: akpm@linux-foundation.org
Subject: + memcg-remove-redundant-returns.patch added to -mm tree
Date: Tue, 17 Jan 2012 14:32:28 -0800
Message-ID: <20120117223229.33DB410004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:42415 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469Ab2AQWca (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2012 17:32:30 -0500
Received: by mail-yx0-f202.google.com with SMTP id l12so120180yen.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jan 2012 14:32:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: memcg: remove redundant returns
has been added to the -mm tree.  Its filename is
     memcg-remove-redundant-returns.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 mm/memcontrol.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-redundant-returns mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-redundant-returns
+++ a/mm/memcontrol.c
@@ -1357,7 +1357,6 @@ void mem_cgroup_print_oom_info(struct me
 	if (!memcg || !p)
 		return;
 
-
 	rcu_read_lock();
 
 	mem_cgrp = memcg->css.cgroup;
@@ -1892,7 +1891,6 @@ out:
 	if (unlikely(need_unlock))
 		move_unlock_page_cgroup(pc, &flags);
 	rcu_read_unlock();
-	return;
 }
 EXPORT_SYMBOL(mem_cgroup_update_page_stat);
 
@@ -2686,7 +2684,6 @@ __mem_cgroup_commit_charge_lrucare(struc
 		SetPageLRU(page);
 	}
 	spin_unlock_irqrestore(&zone->lru_lock, flags);
-	return;
 }
 
 int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
@@ -2876,7 +2873,6 @@ direct_uncharge:
 		res_counter_uncharge(&memcg->memsw, nr_pages * PAGE_SIZE);
 	if (unlikely(batch->memcg != memcg))
 		memcg_oom_recover(memcg);
-	return;
 }
 
 /*
@@ -3918,7 +3914,6 @@ static void memcg_get_hierarchical_limit
 out:
 	*mem_limit = min_limit;
 	*memsw_limit = min_memsw_limit;
-	return;
 }
 
 static int mem_cgroup_reset(struct cgroup *cont, unsigned int event)
_
Subject: Subject: memcg: remove redundant returns

Patches currently in -mm which might be from hughd@google.com are

origin.patch
proc-clear_refs-do-not-clear-reserved-pages.patch
mm-memcg-update-the-correct-soft-limit-tree-during-migration.patch
memcg-replace-mem_cont-by-mem_res_ctlr.patch
memcg-replace-mem-and-mem_cont-stragglers.patch
memcg-lru_size-instead-of-mem_cgroup_zstat.patch
memcg-enum-lru_list-lru.patch
memcg-remove-redundant-returns.patch
prio_tree-debugging-patch.patch


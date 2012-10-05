From: akpm@linux-foundation.org
Subject: + mm-memcg-clean-up-mm_match_cgroup-signature.patch added to -mm tree
Date: Fri, 05 Oct 2012 13:53:42 -0700
Message-ID: <20121005205343.2CC3B100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:38335 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932931Ab2JEUxo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:53:44 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so241308ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:53:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, mhocko@suse.cz


The patch titled
     Subject: mm: memcg: clean up mm_match_cgroup() signature
has been added to the -mm tree.  Its filename is
     mm-memcg-clean-up-mm_match_cgroup-signature.patch

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
Subject: mm: memcg: clean up mm_match_cgroup() signature

It really should return a boolean for match/no match.  And since it
takes a memcg, not a cgroup, fix that parameter name as well.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
---
 1 file changed, 7 insertions(+), 7 deletions(-)

index 8686294..7698182 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcg-clean-up-mm_match_cgroup-signature include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcg-clean-up-mm_match_cgroup-signature
+++ a/include/linux/memcontrol.h
@@ -84,14 +84,14 @@ extern struct mem_cgroup *parent_mem_cgr
 extern struct mem_cgroup *mem_cgroup_from_cont(struct cgroup *cont);
 
 static inline
-int mm_match_cgroup(const struct mm_struct *mm, const struct mem_cgroup *cgroup)
+bool mm_match_cgroup(const struct mm_struct *mm, const struct mem_cgroup *memcg)
 {
-	struct mem_cgroup *memcg;
-	int match;
+	struct mem_cgroup *task_memcg;
+	bool match;
 
 	rcu_read_lock();
-	memcg = mem_cgroup_from_task(rcu_dereference((mm)->owner));
-	match = __mem_cgroup_same_or_subtree(cgroup, memcg);
+	task_memcg = mem_cgroup_from_task(rcu_dereference((mm)->owner));
+	match = __mem_cgroup_same_or_subtree(cgroup, task_memcg);
 	rcu_read_unlock();
 	return match;
 }
@@ -258,10 +258,10 @@ static inline struct mem_cgroup *try_get
 	return NULL;
 }
 
-static inline int mm_match_cgroup(struct mm_struct *mm,
+static inline bool mm_match_cgroup(struct mm_struct *mm,
 		struct mem_cgroup *memcg)
 {
-	return 1;
+	return true;
 }
 
 static inline int task_in_mem_cgroup(struct task_struct *task,
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-slab-remove-duplicate-check.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-enable-config_compaction-by-default.patch
mm-fix-up-zone-present-pages.patch
mm-fix-invalidate_complete_page2-lock-ordering.patch
mm-remove-vma-arg-from-page_evictable.patch
mm-clear_page_mlock-in-page_remove_rmap.patch
mm-remove-free_page_mlock.patch
hugetlb-do-not-use-vma_hugecache_offset-for-vma_prio_tree_foreach.patch
mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range.patch
mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range-fix.patch
mm-remove-unevictable_pgs_mlockfreed.patch
mm-thp-fix-mapped-pages-avoiding-unevictable-list-on-mlock.patch
mm-thp-fix-mlock-statistics.patch
mm-thp-fix-mlock-statistics-fix.patch
mm-memcg-clean-up-mm_match_cgroup-signature.patch
mm-memcg-clean-up-mm_match_cgroup-signature-fix.patch


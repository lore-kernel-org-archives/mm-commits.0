From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-clean-up-mm_match_cgroup-signature.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:15:14 -0700
Message-ID: <20121009181514.A32441E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:62033 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab2JISPP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:15:15 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so663107qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:15:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: clean up mm_match_cgroup() signature
has been removed from the -mm tree.  Its filename was
     mm-memcg-clean-up-mm_match_cgroup-signature.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: clean up mm_match_cgroup() signature

It really should return a boolean for match/no match.  And since it takes
a memcg, not a cgroup, fix that parameter name as well.

[akpm@linux-foundation.org: mm_match_cgroup() is not a macro]
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
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
+	task_memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
+	match = __mem_cgroup_same_or_subtree(memcg, task_memcg);
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


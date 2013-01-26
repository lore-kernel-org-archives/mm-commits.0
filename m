From: akpm@linux-foundation.org
Subject: + memcg-fast-hierarchy-aware-child-test.patch added to -mm tree
Date: Fri, 25 Jan 2013 16:02:14 -0800
Message-ID: <20130126000215.412E231C210@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:57629 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab3AZACQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 Jan 2013 19:02:16 -0500
Received: by mail-qe0-f74.google.com with SMTP id 9so45423qea.1
        for <mm-commits@vger.kernel.org>; Fri, 25 Jan 2013 16:02:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyuki@gmail.com, mhocko@suse.cz, tj@kernel.org


The patch titled
     Subject: memcg: fast hierarchy-aware child test
has been added to the -mm tree.  Its filename is
     memcg-fast-hierarchy-aware-child-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: memcg: fast hierarchy-aware child test

Currently, we use cgroups' provided list of children to verify if it is
safe to proceed with any value change that is dependent on the cgroup
being empty.

This is less than ideal, because it enforces a dependency over cgroup core
that we would be better off without.  The solution proposed here is to
iterate over the child cgroups and if any is found that is already online,
we bounce and return: we don't really care how many children we have, only
if we have any.

This is also made to be hierarchy aware.  IOW, cgroups with hierarchy
disabled, while they still exist, will be considered for the purpose of
this interface as having no children.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

diff -puN mm/memcontrol.c~memcg-fast-hierarchy-aware-child-test mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fast-hierarchy-aware-child-test
+++ a/mm/memcontrol.c
@@ -4761,6 +4761,32 @@ static void mem_cgroup_reparent_charges(
 }
 
 /*
+ * this mainly exists for tests during set of use_hierarchy. Since this is
+ * the very setting we are changing, the current hierarchy value is meaningless
+ */
+static inline bool __memcg_has_children(struct mem_cgroup *memcg)
+{
+	struct cgroup *pos;
+
+	/* bounce at first found */
+	cgroup_for_each_child(pos, memcg->css.cgroup)
+		return true;
+	return false;
+}
+
+/*
+ * must be called with cgroup_lock held, unless the cgroup is guaranteed to be
+ * already dead (like in mem_cgroup_force_empty, for instance).  This is
+ * different than mem_cgroup_count_children, in the sense that we don't really
+ * care how many children we have, we only need to know if we have any. It is
+ * also count any memcg without hierarchy as infertile for that matter.
+ */
+static inline bool memcg_has_children(struct mem_cgroup *memcg)
+{
+	return memcg->use_hierarchy && __memcg_has_children(memcg);
+}
+
+/*
  * Reclaims as many pages from the given memcg as possible and moves
  * the rest to the parent.
  *
@@ -4845,7 +4871,7 @@ static int mem_cgroup_hierarchy_write(st
 	 */
 	if ((!parent_memcg || !parent_memcg->use_hierarchy) &&
 				(val == 1 || val == 0)) {
-		if (list_empty(&cont->children))
+		if (!__memcg_has_children(memcg))
 			memcg->use_hierarchy = val;
 		else
 			retval = -EBUSY;
@@ -4962,8 +4988,7 @@ static int memcg_update_kmem_limit(struc
 	cgroup_lock();
 	mutex_lock(&set_limit_mutex);
 	if (!memcg->kmem_account_flags && val != RESOURCE_MAX) {
-		if (cgroup_task_count(cont) || (memcg->use_hierarchy &&
-						!list_empty(&cont->children))) {
+		if (cgroup_task_count(cont) || memcg_has_children(memcg)) {
 			ret = -EBUSY;
 			goto out;
 		}
@@ -5371,8 +5396,7 @@ static int mem_cgroup_swappiness_write(s
 	cgroup_lock();
 
 	/* If under hierarchy, only empty-root can set this value */
-	if ((parent->use_hierarchy) ||
-	    (memcg->use_hierarchy && !list_empty(&cgrp->children))) {
+	if ((parent->use_hierarchy) || memcg_has_children(memcg)) {
 		cgroup_unlock();
 		return -EINVAL;
 	}
_

Patches currently in -mm which might be from glommer@parallels.com are

memcg-fix-typo-in-kmemcg-cache-walk-macro.patch
memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages.patch
memcg-reduce-the-size-of-struct-memcg-244-fold.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
memcg-prevent-changes-to-move_charge_at_immigrate-during-task-attach.patch
memcg-split-part-of-memcg-creation-to-css_online.patch
memcg-fast-hierarchy-aware-child-test.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock.patch
memcg-increment-static-branch-right-after-limit-set.patch
memcg-avoid-dangling-reference-count-in-creation-failure.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch


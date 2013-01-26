From: akpm@linux-foundation.org
Subject: + memcg-prevent-changes-to-move_charge_at_immigrate-during-task-attach.patch added to -mm tree
Date: Fri, 25 Jan 2013 16:02:08 -0800
Message-ID: <20130126000209.474FE5A415E@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:37315 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab3AZACL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 Jan 2013 19:02:11 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so94004vcd.1
        for <mm-commits@vger.kernel.org>; Fri, 25 Jan 2013 16:02:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyuki@gmail.com, mhocko@suse.cz, tj@kernel.org


The patch titled
     Subject: memcg: prevent changes to move_charge_at_immigrate during task attach
has been added to the -mm tree.  Its filename is
     memcg-prevent-changes-to-move_charge_at_immigrate-during-task-attach.patch

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
Subject: memcg: prevent changes to move_charge_at_immigrate during task attach

In memcg, we use the cgroup_lock basically to synchronize against
attaching new children to a cgroup.  We do this because we rely on cgroup
core to provide us with this information.

We need to guarantee that upon child creation, our tunables are
consistent.  For those, the calls to cgroup_lock() all live in handlers
like mem_cgroup_hierarchy_write(), where we change a tunable in the group
that is hierarchy-related.  For instance, the use_hierarchy flag cannot be
changed if the cgroup already have children.

Furthermore, those values are propagated from the parent to the child when
a new child is created.  So if we don't lock like this, we can end up with
the following situation:

A                                   B
 memcg_css_alloc()                       mem_cgroup_hierarchy_write()
 copy use hierarchy from parent          change use hierarchy in parent
 finish creation.

This is mainly because during create, we are still not fully connected to
the css tree.  So all iterators and the such that we could use, will fail
to show that the group has children.

My observation is that all of creation can proceed in parallel with those
tasks, except value assignment.  So what this patch series does is to first
move all value assignment that is dependent on parent values from
css_alloc to css_online, where the iterators all work, and then we lock
only the value assignment.  This will guarantee that parent and children
always have consistent values.  Together with an online test, that can be
derived from the observation that the refcount of an online memcg can be
made to be always positive, we should be able to synchronize our side
without the cgroup lock.



This patch:

Currently, we rely on the cgroup_lock() to prevent changes to
move_charge_at_immigrate during task migration.  However, this is only
needed because the current strategy keeps checking this value throughout
the whole process.  Since all we need is serialization, one needs only to
guarantee that whatever decision we made in the beginning of a specific
migration is respected throughout the process.

We can achieve this by just saving it in mc. By doing this, no kind of
locking is needed.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff -puN mm/memcontrol.c~memcg-prevent-changes-to-move_charge_at_immigrate-during-task-attach mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-prevent-changes-to-move_charge_at_immigrate-during-task-attach
+++ a/mm/memcontrol.c
@@ -416,8 +416,8 @@ static bool memcg_kmem_test_and_clear_de
 
 /* Stuffs for move charges at task migration. */
 /*
- * Types of charges to be moved. "move_charge_at_immitgrate" is treated as a
- * left-shifted bitmap of these types.
+ * Types of charges to be moved. "move_charge_at_immitgrate" and
+ * "immigrate_flags" are treated as a left-shifted bitmap of these types.
  */
 enum move_type {
 	MOVE_CHARGE_TYPE_ANON,	/* private anonymous page and swap of it */
@@ -430,6 +430,7 @@ static struct move_charge_struct {
 	spinlock_t	  lock; /* for from, to */
 	struct mem_cgroup *from;
 	struct mem_cgroup *to;
+	unsigned long immigrate_flags;
 	unsigned long precharge;
 	unsigned long moved_charge;
 	unsigned long moved_swap;
@@ -442,14 +443,12 @@ static struct move_charge_struct {
 
 static bool move_anon(void)
 {
-	return test_bit(MOVE_CHARGE_TYPE_ANON,
-					&mc.to->move_charge_at_immigrate);
+	return test_bit(MOVE_CHARGE_TYPE_ANON, &mc.immigrate_flags);
 }
 
 static bool move_file(void)
 {
-	return test_bit(MOVE_CHARGE_TYPE_FILE,
-					&mc.to->move_charge_at_immigrate);
+	return test_bit(MOVE_CHARGE_TYPE_FILE, &mc.immigrate_flags);
 }
 
 /*
@@ -5191,15 +5190,14 @@ static int mem_cgroup_move_charge_write(
 
 	if (val >= (1 << NR_MOVE_TYPE))
 		return -EINVAL;
+
 	/*
-	 * We check this value several times in both in can_attach() and
-	 * attach(), so we need cgroup lock to prevent this value from being
-	 * inconsistent.
+	 * No kind of locking is needed in here, because ->can_attach() will
+	 * check this value once in the beginning of the process, and then carry
+	 * on with stale data. This means that changes to this value will only
+	 * affect task migrations starting after the change.
 	 */
-	cgroup_lock();
 	memcg->move_charge_at_immigrate = val;
-	cgroup_unlock();
-
 	return 0;
 }
 #else
@@ -6557,8 +6555,15 @@ static int mem_cgroup_can_attach(struct 
 	struct task_struct *p = cgroup_taskset_first(tset);
 	int ret = 0;
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgroup);
+	unsigned long move_charge_at_immigrate;
 
-	if (memcg->move_charge_at_immigrate) {
+	/*
+	 * We are now commited to this value whatever it is. Changes in this
+	 * tunable will only affect upcoming migrations, not the current one.
+	 * So we need to save it, and keep it going.
+	 */
+	move_charge_at_immigrate  = memcg->move_charge_at_immigrate;
+	if (move_charge_at_immigrate) {
 		struct mm_struct *mm;
 		struct mem_cgroup *from = mem_cgroup_from_task(p);
 
@@ -6578,6 +6583,7 @@ static int mem_cgroup_can_attach(struct 
 			spin_lock(&mc.lock);
 			mc.from = from;
 			mc.to = memcg;
+			mc.immigrate_flags = move_charge_at_immigrate;
 			spin_unlock(&mc.lock);
 			/* We set mc.moving_task later */
 
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


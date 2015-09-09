From: akpm@linux-foundation.org
Subject: [merged] memcg-restructure-mem_cgroup_can_attach.patch removed
 from -mm tree
Date: Wed, 09 Sep 2015 12:45:50 -0700
Message-ID: <55f08c6e.ZOUb8N7Po7tXVb3b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39054 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbbIITpv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:45:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: restructure mem_cgroup_can_attach()
has been removed from the -mm tree.  Its filename was
     memcg-restructure-mem_cgroup_can_attach.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: memcg: restructure mem_cgroup_can_attach()

Restructure it to lower nesting level and help the planned threadgroup
leader iteration changes.

This is pure reorganization.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   65 ++++++++++++++++++++++++----------------------
 1 file changed, 34 insertions(+), 31 deletions(-)

diff -puN mm/memcontrol.c~memcg-restructure-mem_cgroup_can_attach mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-restructure-mem_cgroup_can_attach
+++ a/mm/memcontrol.c
@@ -4834,10 +4834,12 @@ static void mem_cgroup_clear_mc(void)
 static int mem_cgroup_can_attach(struct cgroup_subsys_state *css,
 				 struct cgroup_taskset *tset)
 {
-	struct task_struct *p = cgroup_taskset_first(tset);
-	int ret = 0;
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+	struct mem_cgroup *from;
+	struct task_struct *p;
+	struct mm_struct *mm;
 	unsigned long move_flags;
+	int ret = 0;
 
 	/*
 	 * We are now commited to this value whatever it is. Changes in this
@@ -4845,36 +4847,37 @@ static int mem_cgroup_can_attach(struct
 	 * So we need to save it, and keep it going.
 	 */
 	move_flags = READ_ONCE(memcg->move_charge_at_immigrate);
-	if (move_flags) {
-		struct mm_struct *mm;
-		struct mem_cgroup *from = mem_cgroup_from_task(p);
-
-		VM_BUG_ON(from == memcg);
-
-		mm = get_task_mm(p);
-		if (!mm)
-			return 0;
-		/* We move charges only when we move a owner of the mm */
-		if (mm->owner == p) {
-			VM_BUG_ON(mc.from);
-			VM_BUG_ON(mc.to);
-			VM_BUG_ON(mc.precharge);
-			VM_BUG_ON(mc.moved_charge);
-			VM_BUG_ON(mc.moved_swap);
-
-			spin_lock(&mc.lock);
-			mc.from = from;
-			mc.to = memcg;
-			mc.flags = move_flags;
-			spin_unlock(&mc.lock);
-			/* We set mc.moving_task later */
-
-			ret = mem_cgroup_precharge_mc(mm);
-			if (ret)
-				mem_cgroup_clear_mc();
-		}
-		mmput(mm);
+	if (!move_flags)
+		return 0;
+
+	p = cgroup_taskset_first(tset);
+	from = mem_cgroup_from_task(p);
+
+	VM_BUG_ON(from == memcg);
+
+	mm = get_task_mm(p);
+	if (!mm)
+		return 0;
+	/* We move charges only when we move a owner of the mm */
+	if (mm->owner == p) {
+		VM_BUG_ON(mc.from);
+		VM_BUG_ON(mc.to);
+		VM_BUG_ON(mc.precharge);
+		VM_BUG_ON(mc.moved_charge);
+		VM_BUG_ON(mc.moved_swap);
+
+		spin_lock(&mc.lock);
+		mc.from = from;
+		mc.to = memcg;
+		mc.flags = move_flags;
+		spin_unlock(&mc.lock);
+		/* We set mc.moving_task later */
+
+		ret = mem_cgroup_precharge_mc(mm);
+		if (ret)
+			mem_cgroup_clear_mc();
 	}
+	mmput(mm);
 	return ret;
 }
 
_

Patches currently in -mm which might be from tj@kernel.org are



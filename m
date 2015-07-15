From: akpm@linux-foundation.org
Subject: + memcg-restructure-mem_cgroup_can_attach.patch added to -mm tree
Date: Wed, 15 Jul 2015 13:58:31 -0700
Message-ID: <55a6c977.TtsKi6e4GgpoRALE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56183 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbbGOU6c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jul 2015 16:58:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: restructure mem_cgroup_can_attach()
has been added to the -mm tree.  Its filename is
     memcg-restructure-mem_cgroup_can_attach.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-restructure-mem_cgroup_can_attach.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-restructure-mem_cgroup_can_attach.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -4833,10 +4833,12 @@ static void mem_cgroup_clear_mc(void)
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
@@ -4844,36 +4846,37 @@ static int mem_cgroup_can_attach(struct
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

kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
kernel-kthreadc-kthread_create_on_node-clarify-documentation-fix.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
mm-memblock-warn_on-when-nid-differs-from-overlap-region.patch
mm-page-refine-the-calculation-of-highest-possible-node-id.patch
fs-do-not-prefault-sys_write-user-buffer-pages.patch
memcg-export-struct-mem_cgroup.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-get-rid-of-mem_cgroup_root_css-for-config_memcg.patch
memcg-get-rid-of-extern-for-functions-in-memcontrolh.patch
memcg-restructure-mem_cgroup_can_attach.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
mm-swap-zswap-maybe_preload-refactoring.patch
ipc-msgc-msgsnd-use-freezable-blocking-call.patch
msgrcv-use-freezable-blocking-call.patch
linux-next.patch


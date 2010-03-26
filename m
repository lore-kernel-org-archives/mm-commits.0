From: akpm@linux-foundation.org
Subject: [merged] memcg-disable-move-charge-in-no-mmu-case.patch removed from -mm tree
Date: Fri, 26 Mar 2010 12:35:40 -0400
Message-ID: <201003261936.o2QJaeQl016518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44480 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752094Ab0CZTg5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 15:36:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: d-nishimura@mtf.biglobe.ne.jp, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: disable move charge in no mmu case
has been removed from the -mm tree.  Its filename was
     memcg-disable-move-charge-in-no-mmu-case.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: disable move charge in no mmu case
From: Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp>

In commit 02491447 ("memcg: move charges of anonymous swap"), I tried to
disable move charge feature in no mmu case by enclosing all the related
functions with "#ifdef CONFIG_MMU", but the commit places these ifdefs in
wrong place.  (it seems that it's mangled while handling some fixes...)

This patch fixes it up.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff -puN mm/memcontrol.c~memcg-disable-move-charge-in-no-mmu-case mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-disable-move-charge-in-no-mmu-case
+++ a/mm/memcontrol.c
@@ -3946,28 +3946,6 @@ one_by_one:
 	}
 	return ret;
 }
-#else	/* !CONFIG_MMU */
-static int mem_cgroup_can_attach(struct cgroup_subsys *ss,
-				struct cgroup *cgroup,
-				struct task_struct *p,
-				bool threadgroup)
-{
-	return 0;
-}
-static void mem_cgroup_cancel_attach(struct cgroup_subsys *ss,
-				struct cgroup *cgroup,
-				struct task_struct *p,
-				bool threadgroup)
-{
-}
-static void mem_cgroup_move_task(struct cgroup_subsys *ss,
-				struct cgroup *cont,
-				struct cgroup *old_cont,
-				struct task_struct *p,
-				bool threadgroup)
-{
-}
-#endif
 
 /**
  * is_target_pte_for_mc - check a pte whether it is valid for move charge
@@ -4330,6 +4308,28 @@ static void mem_cgroup_move_task(struct 
 	}
 	mem_cgroup_clear_mc();
 }
+#else	/* !CONFIG_MMU */
+static int mem_cgroup_can_attach(struct cgroup_subsys *ss,
+				struct cgroup *cgroup,
+				struct task_struct *p,
+				bool threadgroup)
+{
+	return 0;
+}
+static void mem_cgroup_cancel_attach(struct cgroup_subsys *ss,
+				struct cgroup *cgroup,
+				struct task_struct *p,
+				bool threadgroup)
+{
+}
+static void mem_cgroup_move_task(struct cgroup_subsys *ss,
+				struct cgroup *cont,
+				struct cgroup *old_cont,
+				struct task_struct *p,
+				bool threadgroup)
+{
+}
+#endif
 
 struct cgroup_subsys mem_cgroup_subsys = {
 	.name = "memory",
_

Patches currently in -mm which might be from d-nishimura@mtf.biglobe.ne.jp are

origin.patch


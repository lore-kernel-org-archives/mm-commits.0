From: akpm@linux-foundation.org
Subject: - memcg-check-group-leader-fix.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:48:54 -0800
Message-ID: <200901082248.n08MmswN028186@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761204AbZAHWtf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:49:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: knikanth@suse.de, balbir@in.ibm.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: check group leader fix
has been removed from the -mm tree.  Its filename was
     memcg-check-group-leader-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: check group leader fix
From: Nikanth Karthikesan <knikanth@suse.de>

Remove unnecessary codes (...fragments of not-implemented
functionalilty...)

Reported-by: Nikanth Karthikesan <knikanth@suse.de>
Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff -puN mm/memcontrol.c~memcg-check-group-leader-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-check-group-leader-fix
+++ a/mm/memcontrol.c
@@ -2008,25 +2008,10 @@ static void mem_cgroup_move_task(struct 
 				struct cgroup *old_cont,
 				struct task_struct *p)
 {
-	struct mm_struct *mm;
-	struct mem_cgroup *mem, *old_mem;
-
-	mm = get_task_mm(p);
-	if (mm == NULL)
-		return;
-
-	mem = mem_cgroup_from_cont(cont);
-	old_mem = mem_cgroup_from_cont(old_cont);
-
 	/*
-	 * Only thread group leaders are allowed to migrate, the mm_struct is
-	 * in effect owned by the leader
+	 * FIXME: It's better to move charges of this process from old
+	 * memcg to new memcg. But it's just on TODO-List now.
 	 */
-	if (!thread_group_leader(p))
-		goto out;

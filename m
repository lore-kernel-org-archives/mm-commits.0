From: akpm@linux-foundation.org
Subject: - cgroups-fix-cgroup_iter_next-bug.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:47:30 -0800
Message-ID: <200901082247.n08MlUbI026950@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48201 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763508AbZAHWsM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:48:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     cgroups: fix cgroup_iter_next() bug
has been removed from the -mm tree.  Its filename was
     cgroups-fix-cgroup_iter_next-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: fix cgroup_iter_next() bug
From: Lai Jiangshan <laijs@cn.fujitsu.com>

Ee access res->cgroups without the task_lock(), so res->cgroups may be
changed.  it's unreliable, and "if (l == &res->cgroups->tasks)" may be
false forever.

We don't need add any lock for fixing this bug.  we just access to struct
css_set by struct cg_cgroup_link, not by struct task_struct.

Since we hold css_set_lock, struct cg_cgroup_link is reliable.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Reviewed-by: Paul Menage <menage@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/cgroup.c~cgroups-fix-cgroup_iter_next-bug kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-fix-cgroup_iter_next-bug
+++ a/kernel/cgroup.c
@@ -1808,6 +1808,7 @@ struct task_struct *cgroup_iter_next(str
 {
 	struct task_struct *res;
 	struct list_head *l = it->task;
+	struct cg_cgroup_link *link;
 
 	/* If the iterator cg is NULL, we have no tasks */
 	if (!it->cg_link)
@@ -1815,7 +1816,8 @@ struct task_struct *cgroup_iter_next(str
 	res = list_entry(l, struct task_struct, cg_list);
 	/* Advance iterator to find next entry */
 	l = l->next;
-	if (l == &res->cgroups->tasks) {
+	link = list_entry(it->cg_link, struct cg_cgroup_link, cgrp_link_list);
+	if (l == &link->cg->tasks) {
 		/* We reached the end of this task list - move on to
 		 * the next cg_cgroup_link */
 		cgroup_advance_iter(cgrp, it);
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
linux-next.patch


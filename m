From: akpm@linux-foundation.org
Subject: - cgroups-add-lock-for-child-cgroups-in-cgroup_post_fork.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:47:28 -0800
Message-ID: <200901082247.n08MlSxN026917@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763508AbZAHWsJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:48:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     cgroups: add lock for child->cgroups in cgroup_post_fork()
has been removed from the -mm tree.  Its filename was
     cgroups-add-lock-for-child-cgroups-in-cgroup_post_fork.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: add lock for child->cgroups in cgroup_post_fork()
From: Lai Jiangshan <laijs@cn.fujitsu.com>

When cgroup_post_fork() is called, child is seen by find_task_by_vpid(),
so child->cgroups maybe be changed, It'll incorrect.

child->cgroups<old>'s refcnt is decreased
child->cgroups<new>'s refcnt is increased
but child->cg_list is added to child->cgroups<old>'s list.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Reviewed-by: Paul Menage <menage@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/cgroup.c~cgroups-add-lock-for-child-cgroups-in-cgroup_post_fork kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-add-lock-for-child-cgroups-in-cgroup_post_fork
+++ a/kernel/cgroup.c
@@ -2792,8 +2792,10 @@ void cgroup_post_fork(struct task_struct
 {
 	if (use_task_css_set_links) {
 		write_lock(&css_set_lock);
+		task_lock(child);
 		if (list_empty(&child->cg_list))
 			list_add(&child->cg_list, &child->cgroups->tasks);
+		task_unlock(child);
 		write_unlock(&css_set_lock);
 	}
 }
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
linux-next.patch


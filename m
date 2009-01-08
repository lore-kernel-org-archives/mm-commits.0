From: akpm@linux-foundation.org
Subject: - cgroups-use-task_lock-for-access-tsk-cgroups-safe-in-cgroup_clone.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:47:35 -0800
Message-ID: <200901082247.n08MlZ78027026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763540AbZAHWvU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:51:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     cgroups: use task_lock() for access tsk->cgroups safe in cgroup_clone()
has been removed from the -mm tree.  Its filename was
     cgroups-use-task_lock-for-access-tsk-cgroups-safe-in-cgroup_clone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: use task_lock() for access tsk->cgroups safe in cgroup_clone()
From: Lai Jiangshan <laijs@cn.fujitsu.com>

Use task_lock() protect tsk->cgroups and get_css_set(tsk->cgroups).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/cgroup.c~cgroups-use-task_lock-for-access-tsk-cgroups-safe-in-cgroup_clone kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-use-task_lock-for-access-tsk-cgroups-safe-in-cgroup_clone
+++ a/kernel/cgroup.c
@@ -2903,6 +2903,7 @@ int cgroup_clone(struct task_struct *tsk
 		mutex_unlock(&cgroup_mutex);
 		return 0;
 	}
+	task_lock(tsk);
 	cg = tsk->cgroups;
 	parent = task_cgroup(tsk, subsys->subsys_id);
 
@@ -2915,6 +2916,7 @@ int cgroup_clone(struct task_struct *tsk
 
 	/* Keep the cgroup alive */
 	get_css_set(cg);
+	task_unlock(tsk);
 	mutex_unlock(&cgroup_mutex);
 
 	/* Now do the VFS work to create a cgroup */
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
linux-next.patch


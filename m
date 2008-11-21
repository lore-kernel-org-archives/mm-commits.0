From: akpm@linux-foundation.org
Subject: + cgroups-use-task_lock-for-access-tsk-cgroups-safe-in-cgroup_clone.patch added to -mm tree
Date: Fri, 21 Nov 2008 15:37:26 -0800
Message-ID: <200811212337.mALNbQ6u029314@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752881AbYKUXhm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 18:37:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, xemul@openvz.org


The patch titled
     cgroups: use task_lock() for access tsk->cgroups safe in cgroup_clone()
has been added to the -mm tree.  Its filename is
     cgroups-use-task_lock-for-access-tsk-cgroups-safe-in-cgroup_clone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -2906,6 +2906,7 @@ int cgroup_clone(struct task_struct *tsk
 		mutex_unlock(&cgroup_mutex);
 		return 0;
 	}
+	task_lock(tsk);
 	cg = tsk->cgroups;
 	parent = task_cgroup(tsk, subsys->subsys_id);
 
@@ -2914,6 +2915,7 @@ int cgroup_clone(struct task_struct *tsk
 
 	/* Keep the cgroup alive */
 	get_css_set(cg);
+	task_unlock(tsk);
 	mutex_unlock(&cgroup_mutex);
 
 	/* Now do the VFS work to create a cgroup */
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
linux-next.patch
kprobes-bugfix-try_module_get-even-if-calling_mod-is-null.patch
cgroups-add-lock-for-child-cgroups-in-cgroup_post_fork.patch
cgroups-fix-cgroup_iter_next-bug.patch
cgroups-dont-put-struct-cgroupfs_root-protected-by-rcu.patch
cgroups-use-task_lock-for-access-tsk-cgroups-safe-in-cgroup_clone.patch
cgroups-call-find_css_set-safely-in-cgroup_attach_task.patch
devcgroup-use-list_for_each_entry_rcu.patch
memcontrol-rcu_read_lock-to-protect-mm_match_cgroup.patch
cpuset-rcu_read_lock-to-protect-task_cs.patch
cpuset-rcu_read_lock-to-protect-task_cs-even-we-dont-dereference-to-task_css-return-value.patch


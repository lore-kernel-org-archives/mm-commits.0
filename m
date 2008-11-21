From: akpm@linux-foundation.org
Subject: + cgroups-add-lock-for-child-cgroups-in-cgroup_post_fork.patch added to -mm tree
Date: Fri, 21 Nov 2008 15:37:18 -0800
Message-ID: <200811212337.mALNbIJo029287@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35847 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753568AbYKUXhn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 18:37:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, xemul@openvz.org


The patch titled
     cgroups: add lock for child->cgroups in cgroup_post_fork()
has been added to the -mm tree.  Its filename is
     cgroups-add-lock-for-child-cgroups-in-cgroup_post_fork.patch

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


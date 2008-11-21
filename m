From: akpm@linux-foundation.org
Subject: + cgroups-fix-cgroup_iter_next-bug.patch added to -mm tree
Date: Fri, 21 Nov 2008 15:37:21 -0800
Message-ID: <200811212337.mALNbLds029304@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49282 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753034AbYKUXhs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 18:37:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, xemul@openvz.org


The patch titled
     cgroups: fix cgroup_iter_next() bug
has been added to the -mm tree.  Its filename is
     cgroups-fix-cgroup_iter_next-bug.patch

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


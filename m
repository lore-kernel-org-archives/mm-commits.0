From: akpm@linux-foundation.org
Subject: + cgroups-call-find_css_set-safely-in-cgroup_attach_task.patch added to -mm tree
Date: Fri, 21 Nov 2008 15:41:28 -0800
Message-ID: <200811212341.mALNfS1b031498@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752266AbYKUXlo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 18:41:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, xemul@openvz.org


The patch titled
     cgroups: call find_css_set() safely in cgroup_attach_task()
has been added to the -mm tree.  Its filename is
     cgroups-call-find_css_set-safely-in-cgroup_attach_task.patch

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
Subject: cgroups: call find_css_set() safely in cgroup_attach_task()
From: Lai Jiangshan <laijs@cn.fujitsu.com>

In cgroup_attach_task(), tsk maybe exit when we call find_css_set().  and
find_css_set() will access to invalid css_set.

This patch increases the count before get_css_set(), and decreases it
after find_css_set().

NOTE:

css_set's refcount is also taskcount, after this patch applied, taskcount
may be off-by-one WHEN cgroup_lock() is not held.  but I reviewed other
code which use taskcount, they are still correct.  No regression found by
reviewing and simply testing.

So I do not use two counters in css_set.  (one counter for taskcount, the
other for refcount.  like struct mm_struct) If this fix cause regression,
we will use two counters in css_set.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN kernel/cgroup.c~cgroups-call-find_css_set-safely-in-cgroup_attach_task kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-call-find_css_set-safely-in-cgroup_attach_task
+++ a/kernel/cgroup.c
@@ -1214,7 +1214,7 @@ int cgroup_attach_task(struct cgroup *cg
 	int retval = 0;
 	struct cgroup_subsys *ss;
 	struct cgroup *oldcgrp;
-	struct css_set *cg = tsk->cgroups;
+	struct css_set *cg;
 	struct css_set *newcg;
 	struct cgroupfs_root *root = cgrp->root;
 	int subsys_id;
@@ -1234,11 +1234,16 @@ int cgroup_attach_task(struct cgroup *cg
 		}
 	}
 
+	task_lock(tsk);
+	cg = tsk->cgroups;
+	get_css_set(cg);
+	task_unlock(tsk);
 	/*
 	 * Locate or allocate a new css_set for this task,
 	 * based on its final set of cgroups
 	 */
 	newcg = find_css_set(cg, cgrp);
+	put_css_set(cg);
 	if (!newcg)
 		return -ENOMEM;
 
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


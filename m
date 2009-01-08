From: akpm@linux-foundation.org
Subject: - cgroups-call-find_css_set-safely-in-cgroup_attach_task.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:47:37 -0800
Message-ID: <200901082247.n08Mlb0D027043@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763552AbZAHWsV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:48:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     cgroups: call find_css_set() safely in cgroup_attach_task()
has been removed from the -mm tree.  Its filename was
     cgroups-call-find_css_set-safely-in-cgroup_attach_task.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


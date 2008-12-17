From: akpm@linux-foundation.org
Subject: + cgroups-add-a-per-subsystem-hierarchy_mutex.patch added to -mm tree
Date: Wed, 17 Dec 2008 14:03:30 -0800
Message-ID: <200812172203.mBHM3Unw025345@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751833AbYLQWET (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Dec 2008 17:04:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com


The patch titled
     cgroups: add a per-subsystem hierarchy_mutex
has been added to the -mm tree.  Its filename is
     cgroups-add-a-per-subsystem-hierarchy_mutex.patch

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
Subject: cgroups: add a per-subsystem hierarchy_mutex
From: Paul Menage <menage@google.com>

These patches introduce new locking/refcount support for cgroups to
reduce the need for subsystems to call cgroup_lock(). This will
ultimately allow the atomicity of cgroup_rmdir() (which was removed
recently) to be restored.

These three patches give:

1/3 - introduce a per-subsystem hierarchy_mutex which a subsystem can
     use to prevent changes to its own cgroup tree

2/3 - use hierarchy_mutex in place of calling cgroup_lock() in the
     memory controller

3/3 - introduce a css_tryget() function similar to the one recently
      proposed by Kamezawa, but avoiding spurious refcount failures in
      the event of a race between a css_tryget() and an unsuccessful
      cgroup_rmdir()

Future patches will likely involve:

- using hierarchy mutex in place of cgroup_lock() in more subsystems
 where appropriate

- restoring the atomicity of cgroup_rmdir() with respect to cgroup_create()


This patch:

Add a hierarchy_mutex to the cgroup_subsys object that protects changes to
the hierarchy observed by that subsystem.  It is taken by the cgroup
subsystem (in addition to cgroup_mutex) for the following operations:

- linking a cgroup into that subsystem's cgroup tree
- unlinking a cgroup from that subsystem's cgroup tree
- moving the subsystem to/from a hierarchy (including across the
  bind() callback)

Thus if the subsystem holds its own hierarchy_mutex, it can safely
traverse its own hierarchy.

Signed-off-by: Paul Menage <menage@google.com>
Tested-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/cgroups.txt |    2 -
 include/linux/cgroup.h            |   17 ++++++++++++
 kernel/cgroup.c                   |   37 ++++++++++++++++++++++++++--
 3 files changed, 52 insertions(+), 4 deletions(-)

diff -puN Documentation/cgroups/cgroups.txt~cgroups-add-a-per-subsystem-hierarchy_mutex Documentation/cgroups/cgroups.txt
--- a/Documentation/cgroups/cgroups.txt~cgroups-add-a-per-subsystem-hierarchy_mutex
+++ a/Documentation/cgroups/cgroups.txt
@@ -528,7 +528,7 @@ example in cpusets, no task may attach b
 up.
 
 void bind(struct cgroup_subsys *ss, struct cgroup *root)
-(cgroup_mutex held by caller)
+(cgroup_mutex and ss->hierarchy_mutex held by caller)
 
 Called when a cgroup subsystem is rebound to a different hierarchy
 and root cgroup. Currently this will only involve movement between
diff -puN include/linux/cgroup.h~cgroups-add-a-per-subsystem-hierarchy_mutex include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-add-a-per-subsystem-hierarchy_mutex
+++ a/include/linux/cgroup.h
@@ -337,8 +337,23 @@ struct cgroup_subsys {
 #define MAX_CGROUP_TYPE_NAMELEN 32
 	const char *name;
 
+	/*
+	 * Protects sibling/children links of cgroups in this
+	 * hierarchy, plus protects which hierarchy (or none) the
+	 * subsystem is a part of (i.e. root/sibling).  To avoid
+	 * potential deadlocks, the following operations should not be
+	 * undertaken while holding any hierarchy_mutex:
+	 *
+	 * - allocating memory
+	 * - initiating hotplug events
+	 */
+	struct mutex hierarchy_mutex;
+
+	/*
+	 * Link to parent, and list entry in parent's children.
+	 * Protected by this->hierarchy_mutex and cgroup_lock()
+	 */
 	struct cgroupfs_root *root;
-
 	struct list_head sibling;
 };
 
diff -puN kernel/cgroup.c~cgroups-add-a-per-subsystem-hierarchy_mutex kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-add-a-per-subsystem-hierarchy_mutex
+++ a/kernel/cgroup.c
@@ -714,23 +714,26 @@ static int rebind_subsystems(struct cgro
 			BUG_ON(cgrp->subsys[i]);
 			BUG_ON(!dummytop->subsys[i]);
 			BUG_ON(dummytop->subsys[i]->cgroup != dummytop);
+			mutex_lock(&ss->hierarchy_mutex);
 			cgrp->subsys[i] = dummytop->subsys[i];
 			cgrp->subsys[i]->cgroup = cgrp;
 			list_move(&ss->sibling, &root->subsys_list);
 			ss->root = root;
 			if (ss->bind)
 				ss->bind(ss, cgrp);
-
+			mutex_unlock(&ss->hierarchy_mutex);
 		} else if (bit & removed_bits) {
 			/* We're removing this subsystem */
 			BUG_ON(cgrp->subsys[i] != dummytop->subsys[i]);
 			BUG_ON(cgrp->subsys[i]->cgroup != cgrp);
+			mutex_lock(&ss->hierarchy_mutex);
 			if (ss->bind)
 				ss->bind(ss, dummytop);
 			dummytop->subsys[i]->cgroup = dummytop;
 			cgrp->subsys[i] = NULL;
 			subsys[i]->root = &rootnode;
 			list_move(&ss->sibling, &rootnode.subsys_list);
+			mutex_unlock(&ss->hierarchy_mutex);
 		} else if (bit & final_bits) {
 			/* Subsystem state should already exist */
 			BUG_ON(!cgrp->subsys[i]);
@@ -2326,6 +2329,29 @@ static void init_cgroup_css(struct cgrou
 	cgrp->subsys[ss->subsys_id] = css;
 }
 
+static void cgroup_lock_hierarchy(struct cgroupfs_root *root)
+{
+	/* We need to take each hierarchy_mutex in a consistent order */
+	int i;
+
+	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
+		struct cgroup_subsys *ss = subsys[i];
+		if (ss->root == root)
+			mutex_lock_nested(&ss->hierarchy_mutex, i);
+	}
+}
+
+static void cgroup_unlock_hierarchy(struct cgroupfs_root *root)
+{
+	int i;
+
+	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
+		struct cgroup_subsys *ss = subsys[i];
+		if (ss->root == root)
+			mutex_unlock(&ss->hierarchy_mutex);
+	}
+}
+
 /*
  * cgroup_create - create a cgroup
  * @parent: cgroup that will be parent of the new cgroup
@@ -2374,7 +2400,9 @@ static long cgroup_create(struct cgroup 
 		init_cgroup_css(css, ss, cgrp);
 	}
 
+	cgroup_lock_hierarchy(root);
 	list_add(&cgrp->sibling, &cgrp->parent->children);
+	cgroup_unlock_hierarchy(root);
 	root->number_of_cgroups++;
 
 	err = cgroup_create_dir(cgrp, dentry, mode);
@@ -2492,8 +2520,12 @@ static int cgroup_rmdir(struct inode *un
 	if (!list_empty(&cgrp->release_list))
 		list_del(&cgrp->release_list);
 	spin_unlock(&release_list_lock);
-	/* delete my sibling from parent->children */
+
+	cgroup_lock_hierarchy(cgrp->root);
+	/* delete this cgroup from parent->children */
 	list_del(&cgrp->sibling);
+	cgroup_unlock_hierarchy(cgrp->root);
+
 	spin_lock(&cgrp->dentry->d_lock);
 	d = dget(cgrp->dentry);
 	spin_unlock(&d->d_lock);
@@ -2535,6 +2567,7 @@ static void __init cgroup_init_subsys(st
 	 * need to invoke fork callbacks here. */
 	BUG_ON(!list_empty(&init_task.tasks));
 
+	mutex_init(&ss->hierarchy_mutex);
 	ss->active = 1;
 }
 
_

Patches currently in -mm which might be from menage@google.com are

origin.patch
linux-next.patch
cpuacct-refactoring-cpuusage_read-cpuusage_write.patch
cpuacct-export-percpu-cpuacct-cgroup-stats.patch
oom-print-triggering-tasks-cpuset-and-mems-allowed.patch
oom-print-triggering-tasks-cpuset-and-mems-allowed-fix.patch
mm-remove-cgroup_mm_owner_callbacks.patch
mm-make-get_user_pages-interruptible.patch
mm-make-get_user_pages-interruptible-mmotm-ignore-sigkill-in-get_user_pages-during-munlock.patch
cgroups-make-cgroup-config-a-submenu.patch
cgroups-documentation-updates.patch
cgroups-remove-some-redundant-null-checks.patch
ns_cgroup-remove-unused-spinlock.patch
memcg-fix-a-typo-in-kconfig.patch
cgroups-add-lock-for-child-cgroups-in-cgroup_post_fork.patch
cgroups-fix-cgroup_iter_next-bug.patch
cgroups-dont-put-struct-cgroupfs_root-protected-by-rcu.patch
cgroups-use-task_lock-for-access-tsk-cgroups-safe-in-cgroup_clone.patch
cgroups-call-find_css_set-safely-in-cgroup_attach_task.patch
cgroups-remove-rcu_read_lock-in-cgroupstats_build.patch
cgroups-make-root_list-contains-active-hierarchies-only.patch
cgroups-add-inactive-subsystems-to-rootnodesubsys_list.patch
cgroups-add-inactive-subsystems-to-rootnodesubsys_list-fix.patch
cgroups-introduce-link_css_set-to-remove-duplicate-code.patch
cgroups-introduce-link_css_set-to-remove-duplicate-code-fix.patch
cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup.patch
cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup-checkpatch-fixes.patch
devcgroup-use-list_for_each_entry_rcu.patch
devices-cgroup-allow-mkfifo.patch
memcg-move-all-acccounts-to-parent-at-rmdir.patch
memory-cgroup-hierarchy-documentation-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-fix-for-hierarchical-reclaim.patch
memory-cgroup-hierarchy-feature-selector-v4.patch
memory-cgroup-hierarchy-feature-selector-v4-fix.patch
memcontrol-rcu_read_lock-to-protect-mm_match_cgroup.patch
cgroups-add-a-per-subsystem-hierarchy_mutex.patch
cgroups-use-hierarchy_mutex-in-memory-controller.patch
cgroups-add-css_tryget.patch
cpuset-rcu_read_lock-to-protect-task_cs.patch
add-a-refcount-check-in-dput.patch


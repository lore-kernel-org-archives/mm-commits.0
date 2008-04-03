From: akpm@linux-foundation.org
Subject: + cgroups-simplify-init_subsys.patch added to -mm tree
Date: Thu, 03 Apr 2008 15:59:35 -0700
Message-ID: <200804032259.m33MxZ2Q026912@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753129AbYDCXAA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2008 19:00:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, xemul@openvz.org


The patch titled
     cgroups: simplify init_subsys()
has been added to the -mm tree.  Its filename is
     cgroups-simplify-init_subsys.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: simplify init_subsys()
From: Li Zefan <lizf@cn.fujitsu.com>

We are at system boot and there is only 1 cgroup group (i,e, init_css_set), so
we don't need to run through the css_set linked list.  Neither do we need to
run through the task list, since no processes have been created yet.

Also referring to a comment in cgroup.h:

struct css_set
{
	...
	/*
	 * Set of subsystem states, one for each subsystem. This array
	 * is immutable after creation apart from the init_css_set
	 * during subsystem registration (at boot time).
	 */
	struct cgroup_subsys_state *subsys[CGROUP_SUBSYS_COUNT];
}

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Reviewed-by: Paul Menage <menage@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups.txt |    3 +--
 kernel/cgroup.c           |   35 +++++++++--------------------------
 2 files changed, 10 insertions(+), 28 deletions(-)

diff -puN Documentation/cgroups.txt~cgroups-simplify-init_subsys Documentation/cgroups.txt
--- a/Documentation/cgroups.txt~cgroups-simplify-init_subsys
+++ a/Documentation/cgroups.txt
@@ -500,8 +500,7 @@ post-attachment activity that requires m
 
 void fork(struct cgroup_subsy *ss, struct task_struct *task)
 
-Called when a task is forked into a cgroup. Also called during
-registration for all existing tasks.
+Called when a task is forked into a cgroup.
 
 void exit(struct cgroup_subsys *ss, struct task_struct *task)
 
diff -puN kernel/cgroup.c~cgroups-simplify-init_subsys kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-simplify-init_subsys
+++ a/kernel/cgroup.c
@@ -2472,7 +2472,6 @@ static int cgroup_rmdir(struct inode *un
 static void __init cgroup_init_subsys(struct cgroup_subsys *ss)
 {
 	struct cgroup_subsys_state *css;
-	struct list_head *l;
 
 	printk(KERN_INFO "Initializing cgroup subsys %s\n", ss->name);
 
@@ -2483,35 +2482,19 @@ static void __init cgroup_init_subsys(st
 	BUG_ON(IS_ERR(css));
 	init_cgroup_css(css, ss, dummytop);
 
-	/* Update all cgroup groups to contain a subsys
+	/* Update the init_css_set to contain a subsys
 	 * pointer to this state - since the subsystem is
-	 * newly registered, all tasks and hence all cgroup
-	 * groups are in the subsystem's top cgroup. */
-	write_lock(&css_set_lock);
-	l = &init_css_set.list;
-	do {
-		struct css_set *cg =
-			list_entry(l, struct css_set, list);
-		cg->subsys[ss->subsys_id] = dummytop->subsys[ss->subsys_id];
-		l = l->next;
-	} while (l != &init_css_set.list);
-	write_unlock(&css_set_lock);
-
- 	/* If this subsystem requested that it be notified with fork
- 	 * events, we should send it one now for every process in the
- 	 * system */
-	if (ss->fork) {
-		struct task_struct *g, *p;
-
-		read_lock(&tasklist_lock);
-		do_each_thread(g, p) {
-			ss->fork(ss, p);
-		} while_each_thread(g, p);
-		read_unlock(&tasklist_lock);
-	}
+	 * newly registered, all tasks and hence the
+	 * init_css_set is in the subsystem's top cgroup. */
+	init_css_set.subsys[ss->subsys_id] = dummytop->subsys[ss->subsys_id];
 
 	need_forkexit_callback |= ss->fork || ss->exit;
 
+	/* At system boot, before all subsystems have been
+	 * registered, no tasks have been forked, so we don't
+	 * need to invoke fork callbacks here. */
+	BUG_ON(!list_empty(&init_task.tasks));
+
 	ss->active = 1;
 }
 
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time.patch
ia64-use-goto-to-jump-out-do-while_each_thread.patch
sctp-fix-wrong-debug-counting-of-datamsg.patch
sctp-fix-wrong-debug-counting-of-bind_bucket.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
cgroup-api-files-add-res_counter_read_u64.patch
cgroup-api-files-use-read_u64-in-memory-controller.patch
cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroup-api-files-add-cgroup-map-data-type.patch
cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
cgroup-api-files-drop-mem_cgroup_force_empty.patch
cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
cgroup-api-files-make-cgroup_debug-default-to-off.patch
cgroup-annotate-cgroup_init_subsys-with-__init.patch
cgroup-switch-to-proc_create.patch
cgroups-implement-device-whitelist-v6.patch
cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch
cgroups-implement-device-whitelist-v6-cleanups.patch
cgroups-implement-device-whitelist-doc.patch
cgroups-implement-device-whitelist-v6-fix.patch
cgroups-use-a-hash-table-for-css_set-finding.patch
cgroups-simplify-init_subsys.patch
cgroups-remove-the-css_set-linked-list.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
cpuset-hardwall-flag-switch-cpusets-to-use-the-bulk-cgroup_add_files-api.patch


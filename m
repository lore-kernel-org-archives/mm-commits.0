From: akpm@linux-foundation.org
Subject: + memory-cgroup-enhancements-add-pre_destroy-handler.patch added to -mm tree
Date: Mon, 12 Nov 2007 17:58:06 -0800
Message-ID: <200711130158.lAD1w6Yg020928@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48874 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754672AbXKMB7f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 20:59:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, a.p.zijlstra@chello.nl, balbir@linux.vnet.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, menage@google.com, nickpiggin@yahoo.com.au, rientjes@google.com, svaidy@linux.vnet.ibm.com, xemul@openvz.org


The patch titled
     memory cgroup enhancements: add- pre_destroy() handler
has been added to the -mm tree.  Its filename is
     memory-cgroup-enhancements-add-pre_destroy-handler.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: memory cgroup enhancements: add- pre_destroy() handler
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Add a handler "pre_destroy" to cgroup_subsys.  It is called before
cgroup_rmdir() checks all subsys's refcnt.

I think this is useful for subsys which have some extra refs even if there
are no tasks in cgroup.  By adding pre_destroy(), the kernel keeps the rule
"destroy() against subsystem is called only when refcnt=0." and allows css
ref to be used by other objects than tasks.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Paul Menage <menage@google.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    1 +
 kernel/cgroup.c        |   22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff -puN include/linux/cgroup.h~memory-cgroup-enhancements-add-pre_destroy-handler include/linux/cgroup.h
--- a/include/linux/cgroup.h~memory-cgroup-enhancements-add-pre_destroy-handler
+++ a/include/linux/cgroup.h
@@ -233,6 +233,7 @@ int cgroup_is_descendant(const struct cg
 struct cgroup_subsys {
 	struct cgroup_subsys_state *(*create)(struct cgroup_subsys *ss,
 						  struct cgroup *cont);
+	void (*pre_destroy)(struct cgroup_subsys *ss, struct cgroup *cont);
 	void (*destroy)(struct cgroup_subsys *ss, struct cgroup *cont);
 	int (*can_attach)(struct cgroup_subsys *ss,
 			  struct cgroup *cont, struct task_struct *tsk);
diff -puN kernel/cgroup.c~memory-cgroup-enhancements-add-pre_destroy-handler kernel/cgroup.c
--- a/kernel/cgroup.c~memory-cgroup-enhancements-add-pre_destroy-handler
+++ a/kernel/cgroup.c
@@ -586,6 +586,21 @@ static struct inode *cgroup_new_inode(mo
 	return inode;
 }
 
+/*
+ * Call subsys's pre_destroy handler.
+ * This is called before css refcnt check.
+ */
+
+static void cgroup_call_pre_destroy(struct cgroup *cgrp)
+{
+	struct cgroup_subsys *ss;
+	for_each_subsys(cgrp->root, ss)
+		if (ss->pre_destroy && cgrp->subsys[ss->subsys_id])
+			ss->pre_destroy(ss, cgrp);
+	return;
+}
+
+
 static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 {
 	/* is dentry a directory ? if so, kfree() associated cgroup */
@@ -2160,6 +2175,13 @@ static int cgroup_rmdir(struct inode *un
 	parent = cgrp->parent;
 	root = cgrp->root;
 	sb = root->sb;
+	/*
+	 * Call pre_destroy handlers of subsys
+	 */
+	cgroup_call_pre_destroy(cgrp);
+	/*
+	 * Notify subsyses that rmdir() request comes.
+	 */
 
 	if (cgroup_has_css_refs(cgrp)) {
 		mutex_unlock(&cgroup_mutex);
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

memory-hotremove-unset-migrate-type-isolate-after-removal.patch
swapoff-scan-ptes-preemptibly.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
add-remove_memory-for-ppc64-2.patch
enable-hotplug-memory-remove-for-ppc64.patch
add-arch-specific-walk_memory_remove-for-ppc64.patch
pie-executable-randomization.patch
pie-executable-randomization-uninlining.patch
pie-executable-randomization-checkpatch-fixes.patch
memcgroup-temporarily-revert-swapoff-mod.patch
memory-controller-make-charging-gfp-mask-aware-fix.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
memory-cgroup-enhancements-add-pre_destroy-handler.patch

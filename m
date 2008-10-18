From: akpm@linux-foundation.org
Subject: - cgroups-fix-probable-race-with-put_css_set-and-find_css_set-cgroups-eliminate-race-in-css_set-refcounting.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:51:50 -0700
Message-ID: <200810182351.m9INpose001821@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57271 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751787AbYJRXwg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:52:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, laijs@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: eliminate race in css_set refcounting
has been removed from the -mm tree.  Its filename was
     cgroups-fix-probable-race-with-put_css_set-and-find_css_set-cgroups-eliminate-race-in-css_set-refcounting.patch

This patch was dropped because it was folded into cgroups-fix-probable-race-with-put_css_set-and-find_css_set.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: eliminate race in css_set refcounting
From: Paul Menage <menage@google.com>

Eliminate race in css_set refcounting

This patch replaces the use of krefs in struct css_set with a plain
atomic_t, and ensures that the reference count of a css_set never hits
zero outside of a write_lock(&css_set_lock) critical section

This prevents a race between find_css_set() and put_css_set*() where
the reference count can hit zero when the css_set object is still
accessible to readers of the hash table.

Signed-off-by: Paul Menage <menage@google.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    3 --
 kernel/cgroup.c        |   51 +++++++++++----------------------------
 kernel/cgroup_debug.c  |    4 +--
 3 files changed, 18 insertions(+), 40 deletions(-)

diff -puN include/linux/cgroup.h~cgroups-fix-probable-race-with-put_css_set-and-find_css_set-cgroups-eliminate-race-in-css_set-refcounting include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-fix-probable-race-with-put_css_set-and-find_css_set-cgroups-eliminate-race-in-css_set-refcounting
+++ a/include/linux/cgroup.h
@@ -9,7 +9,6 @@
  */
 
 #include <linux/sched.h>
-#include <linux/kref.h>
 #include <linux/cpumask.h>
 #include <linux/nodemask.h>
 #include <linux/rcupdate.h>
@@ -149,7 +148,7 @@ struct cgroup {
 struct css_set {
 
 	/* Reference count */
-	struct kref ref;
+	atomic_t refcount;
 
 	/*
 	 * List running through all cgroup groups in the same hash
diff -puN kernel/cgroup.c~cgroups-fix-probable-race-with-put_css_set-and-find_css_set-cgroups-eliminate-race-in-css_set-refcounting kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-fix-probable-race-with-put_css_set-and-find_css_set-cgroups-eliminate-race-in-css_set-refcounting
+++ a/kernel/cgroup.c
@@ -252,14 +252,18 @@ static void unlink_css_set(struct css_se
 	}
 }
 
-static void __release_css_set(struct kref *k, int taskexit)
+static void __put_css_set(struct css_set *cg, int taskexit)
 {
 	int i;
-	struct css_set *cg = container_of(k, struct css_set, ref);
-
+	/*
+	 * Ensure that the refcount doesn't hit zero while any readers
+	 * can see it. Similar to atomic_dec_and_lock(), but for an
+	 * rwlock
+	 */
+	if (atomic_add_unless(&cg->refcount, -1, 1))
+		return;
 	write_lock(&css_set_lock);
-	if (atomic_read(&k->refcount) > 0) {
-		/* See find_css_set()'s read_lock()ed section */
+	if (!atomic_dec_and_test(&cg->refcount)) {
 		write_unlock(&css_set_lock);
 		return;
 	}
@@ -280,32 +284,22 @@ static void __release_css_set(struct kre
 	kfree(cg);
 }
 
-static void release_css_set(struct kref *k)
-{
-	__release_css_set(k, 0);
-}
-
-static void release_css_set_taskexit(struct kref *k)
-{
-	__release_css_set(k, 1);
-}
-
 /*
  * refcounted get/put for css_set objects
  */
 static inline void get_css_set(struct css_set *cg)
 {
-	kref_get(&cg->ref);
+	atomic_inc(&cg->refcount);
 }
 
 static inline void put_css_set(struct css_set *cg)
 {
-	kref_put(&cg->ref, release_css_set);
+	__put_css_set(cg, 0);
 }
 
 static inline void put_css_set_taskexit(struct css_set *cg)
 {
-	kref_put(&cg->ref, release_css_set_taskexit);
+	__put_css_set(cg, 1);
 }
 
 /*
@@ -414,20 +408,6 @@ static struct css_set *find_css_set(
 	 * the desired set */
 	read_lock(&css_set_lock);
 	res = find_existing_css_set(oldcg, cgrp, template);
-	/*
-	 * put_css_set[_taskexit]() may race with find_css_set(), in that
-	 * find_css_set() got the css_set after put_css_set() had released it.
-	 *
-	 * We should put the whole put_css_set[_taskexit]() into css_set_lock's
-	 * write_lock critical setion to avoid this race. But it will increase
-	 * overhead for do_exit().
-	 *
-	 * So we do not avoid this race but put it under control:
-	 * __release_css_set() will re-check the refcount
-	 * with css_set_lock held.
-	 *
-	 * This race may trigger the warning in kref_get().
-	 */
 	if (res)
 		get_css_set(res);
 	read_unlock(&css_set_lock);
@@ -445,7 +425,7 @@ static struct css_set *find_css_set(
 		return NULL;
 	}
 
-	kref_init(&res->ref);
+	atomic_set(&res->refcount, 1);
 	INIT_LIST_HEAD(&res->cg_links);
 	INIT_LIST_HEAD(&res->tasks);
 	INIT_HLIST_NODE(&res->hlist);
@@ -1749,7 +1729,7 @@ int cgroup_task_count(const struct cgrou
 
 	read_lock(&css_set_lock);
 	list_for_each_entry(link, &cgrp->css_sets, cgrp_link_list) {
-		count += atomic_read(&link->cg->ref.refcount);
+		count += atomic_read(&link->cg->refcount);
 	}
 	read_unlock(&css_set_lock);
 	return count;
@@ -2516,8 +2496,7 @@ static void __init cgroup_init_subsys(st
 int __init cgroup_init_early(void)
 {
 	int i;
-	kref_init(&init_css_set.ref);
-	kref_get(&init_css_set.ref);
+	atomic_set(&init_css_set.refcount, 1);
 	INIT_LIST_HEAD(&init_css_set.cg_links);
 	INIT_LIST_HEAD(&init_css_set.tasks);
 	INIT_HLIST_NODE(&init_css_set.hlist);
diff -puN kernel/cgroup_debug.c~cgroups-fix-probable-race-with-put_css_set-and-find_css_set-cgroups-eliminate-race-in-css_set-refcounting kernel/cgroup_debug.c
--- a/kernel/cgroup_debug.c~cgroups-fix-probable-race-with-put_css_set-and-find_css_set-cgroups-eliminate-race-in-css_set-refcounting
+++ a/kernel/cgroup_debug.c
@@ -57,7 +57,7 @@ static u64 current_css_set_refcount_read
 	u64 count;
 
 	rcu_read_lock();
-	count = atomic_read(&current->cgroups->ref.refcount);
+	count = atomic_read(&current->cgroups->refcount);
 	rcu_read_unlock();
 	return count;
 }
@@ -90,7 +90,7 @@ static struct cftype files[] =  {
 	{
 		.name = "releasable",
 		.read_u64 = releasable_read,
-	}
+	},
 };
 
 static int debug_populate(struct cgroup_subsys *ss, struct cgroup *cont)
_

Patches currently in -mm which might be from menage@google.com are

origin.patch
container-freezer-document-the-cgroup-freezer-subsystem.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-cgroups-eliminate-race-in-css_set-refcounting.patch
cgroups-convert-tasks-file-to-use-a-seq_file-with-shared-pid-array.patch
cgroups-fix-declaration-of-cgroup_mm_owner_callbacks.patch
devcgroup-use-kmemdup.patch
devcgroup-remove-unused-variable.patch
devcgroup-remove-spin_lock.patch
seq_file-dont-call-bitmap_scnprintf_len.patch
seq_file-add-seq_cpumask_list-seq_nodemask_list.patch
cpuset-use-seq_mask_-to-print-masks.patch
bitmask-remove-bitmap_scnprintf_len.patch


From: akpm@linux-foundation.org
Subject: - cgroups-fix-probable-race-with-put_css_set-and-find_css_set.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:36:13 -0700
Message-ID: <200810202036.m9KKaDDA011325@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753795AbYJTUhA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:37:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: fix probable race with put_css_set[_taskexit] and find_css_set
has been removed from the -mm tree.  Its filename was
     cgroups-fix-probable-race-with-put_css_set-and-find_css_set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: fix probable race with put_css_set[_taskexit] and find_css_set
From: Lai Jiangshan <laijs@cn.fujitsu.com>

put_css_set_taskexit may be called when find_css_set is called on other
cpu.  And the race will occur:

put_css_set_taskexit side                    find_css_set side

                                        |
atomic_dec_and_test(&kref->refcount)    |
    /* kref->refcount = 0 */            |
....................................................................
                                        |  read_lock(&css_set_lock)
                                        |  find_existing_css_set
                                        |  get_css_set
                                        |  read_unlock(&css_set_lock);
....................................................................
__release_css_set                       |
....................................................................
                                        | /* use a released css_set */
                                        |

[put_css_set is the same. But in the current code, all put_css_set are
put into cgroup mutex critical region as the same as find_css_set.]

[akpm@linux-foundation.org: repair comments]
[menage@google.com: eliminate race in css_set refcounting]
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    3 --
 kernel/cgroup.c        |   43 ++++++++++++++++++---------------------
 kernel/cgroup_debug.c  |    4 +--
 3 files changed, 23 insertions(+), 27 deletions(-)

diff -puN include/linux/cgroup.h~cgroups-fix-probable-race-with-put_css_set-and-find_css_set include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-fix-probable-race-with-put_css_set-and-find_css_set
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
diff -puN kernel/cgroup.c~cgroups-fix-probable-race-with-put_css_set-and-find_css_set kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-fix-probable-race-with-put_css_set-and-find_css_set
+++ a/kernel/cgroup.c
@@ -241,7 +241,6 @@ static void unlink_css_set(struct css_se
 	struct cg_cgroup_link *link;
 	struct cg_cgroup_link *saved_link;
 
-	write_lock(&css_set_lock);
 	hlist_del(&cg->hlist);
 	css_set_count--;
 
@@ -251,16 +250,25 @@ static void unlink_css_set(struct css_se
 		list_del(&link->cgrp_link_list);
 		kfree(link);
 	}
-
-	write_unlock(&css_set_lock);
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
+	write_lock(&css_set_lock);
+	if (!atomic_dec_and_test(&cg->refcount)) {
+		write_unlock(&css_set_lock);
+		return;
+	}
 	unlink_css_set(cg);
+	write_unlock(&css_set_lock);
 
 	rcu_read_lock();
 	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
@@ -276,32 +284,22 @@ static void __release_css_set(struct kre
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
@@ -427,7 +425,7 @@ static struct css_set *find_css_set(
 		return NULL;
 	}
 
-	kref_init(&res->ref);
+	atomic_set(&res->refcount, 1);
 	INIT_LIST_HEAD(&res->cg_links);
 	INIT_LIST_HEAD(&res->tasks);
 	INIT_HLIST_NODE(&res->hlist);
@@ -1728,7 +1726,7 @@ int cgroup_task_count(const struct cgrou
 
 	read_lock(&css_set_lock);
 	list_for_each_entry(link, &cgrp->css_sets, cgrp_link_list) {
-		count += atomic_read(&link->cg->ref.refcount);
+		count += atomic_read(&link->cg->refcount);
 	}
 	read_unlock(&css_set_lock);
 	return count;
@@ -2495,8 +2493,7 @@ static void __init cgroup_init_subsys(st
 int __init cgroup_init_early(void)
 {
 	int i;
-	kref_init(&init_css_set.ref);
-	kref_get(&init_css_set.ref);
+	atomic_set(&init_css_set.refcount, 1);
 	INIT_LIST_HEAD(&init_css_set.cg_links);
 	INIT_LIST_HEAD(&init_css_set.tasks);
 	INIT_HLIST_NODE(&init_css_set.hlist);
diff -puN kernel/cgroup_debug.c~cgroups-fix-probable-race-with-put_css_set-and-find_css_set kernel/cgroup_debug.c
--- a/kernel/cgroup_debug.c~cgroups-fix-probable-race-with-put_css_set-and-find_css_set
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

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
linux-next.patch


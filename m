From: akpm@linux-foundation.org
Subject: - devcgroup-remove-spin_lock.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:36:26 -0700
Message-ID: <200810202036.m9KKaQet011376@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754631AbYJTUq6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:46:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, jmorris@namei.org, menage@google.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     devcgroup: remove spin_lock()
has been removed from the -mm tree.  Its filename was
     devcgroup-remove-spin_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devcgroup: remove spin_lock()
From: Lai Jiangshan <laijs@cn.fujitsu.com>

Since we introduced rcu for read side, spin_lock is used only for update. 
But we always hold cgroup_lock() when update, so spin_lock() is not need.

Additional cleanup:
1) include linux/rcupdate.h explicitly
2) remove unused variable cur_devcgroup in devcgroup_update_access()

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/device_cgroup.c |   34 +++++-----------------------------
 1 file changed, 5 insertions(+), 29 deletions(-)

diff -puN security/device_cgroup.c~devcgroup-remove-spin_lock security/device_cgroup.c
--- a/security/device_cgroup.c~devcgroup-remove-spin_lock
+++ a/security/device_cgroup.c
@@ -1,5 +1,5 @@
 /*
- * dev_cgroup.c - device cgroup subsystem
+ * device_cgroup.c - device cgroup subsystem
  *
  * Copyright 2007 IBM Corp
  */
@@ -10,6 +10,7 @@
 #include <linux/list.h>
 #include <linux/uaccess.h>
 #include <linux/seq_file.h>
+#include <linux/rcupdate.h>
 
 #define ACC_MKNOD 1
 #define ACC_READ  2
@@ -22,18 +23,8 @@
 
 /*
  * whitelist locking rules:
- * cgroup_lock() cannot be taken under dev_cgroup->lock.
- * dev_cgroup->lock can be taken with or without cgroup_lock().
- *
- * modifications always require cgroup_lock
- * modifications to a list which is visible require the
- *   dev_cgroup->lock *and* cgroup_lock()
- * walking the list requires dev_cgroup->lock or cgroup_lock().
- *
- * reasoning: dev_whitelist_copy() needs to kmalloc, so needs
- *   a mutex, which the cgroup_lock() is.  Since modifying
- *   a visible list requires both locks, either lock can be
- *   taken for walking the list.
+ * hold cgroup_lock() for update/read.
+ * hold rcu_read_lock() for read.
  */
 
 struct dev_whitelist_item {
@@ -47,7 +38,6 @@ struct dev_whitelist_item {
 struct dev_cgroup {
 	struct cgroup_subsys_state css;
 	struct list_head whitelist;
-	spinlock_t lock;
 };
 
 static inline struct dev_cgroup *css_to_devcgroup(struct cgroup_subsys_state *s)
@@ -103,7 +93,6 @@ free_and_exit:
 /* Stupid prototype - don't bother combining existing entries */
 /*
  * called under cgroup_lock()
- * since the list is visible to other tasks, we need the spinlock also
  */
 static int dev_whitelist_add(struct dev_cgroup *dev_cgroup,
 			struct dev_whitelist_item *wh)
@@ -114,7 +103,6 @@ static int dev_whitelist_add(struct dev_
 	if (!whcopy)
 		return -ENOMEM;
 
-	spin_lock(&dev_cgroup->lock);
 	list_for_each_entry(walk, &dev_cgroup->whitelist, list) {
 		if (walk->type != wh->type)
 			continue;
@@ -130,7 +118,6 @@ static int dev_whitelist_add(struct dev_
 
 	if (whcopy != NULL)
 		list_add_tail_rcu(&whcopy->list, &dev_cgroup->whitelist);
-	spin_unlock(&dev_cgroup->lock);
 	return 0;
 }
 
@@ -144,14 +131,12 @@ static void whitelist_item_free(struct r
 
 /*
  * called under cgroup_lock()
- * since the list is visible to other tasks, we need the spinlock also
  */
 static void dev_whitelist_rm(struct dev_cgroup *dev_cgroup,
 			struct dev_whitelist_item *wh)
 {
 	struct dev_whitelist_item *walk, *tmp;
 
-	spin_lock(&dev_cgroup->lock);
 	list_for_each_entry_safe(walk, tmp, &dev_cgroup->whitelist, list) {
 		if (walk->type == DEV_ALL)
 			goto remove;
@@ -169,7 +154,6 @@ remove:
 			call_rcu(&walk->rcu, whitelist_item_free);
 		}
 	}
-	spin_unlock(&dev_cgroup->lock);
 }
 
 /*
@@ -209,7 +193,6 @@ static struct cgroup_subsys_state *devcg
 		}
 	}
 
-	spin_lock_init(&dev_cgroup->lock);
 	return &dev_cgroup->css;
 }
 
@@ -325,15 +308,11 @@ static int parent_has_perm(struct dev_cg
 {
 	struct cgroup *pcg = childcg->css.cgroup->parent;
 	struct dev_cgroup *parent;
-	int ret;
 
 	if (!pcg)
 		return 1;
 	parent = cgroup_to_devcgroup(pcg);
-	spin_lock(&parent->lock);
-	ret = may_access_whitelist(parent, wh);
-	spin_unlock(&parent->lock);
-	return ret;
+	return may_access_whitelist(parent, wh);
 }
 
 /*
@@ -352,7 +331,6 @@ static int parent_has_perm(struct dev_cg
 static int devcgroup_update_access(struct dev_cgroup *devcgroup,
 				   int filetype, const char *buffer)
 {
-	struct dev_cgroup *cur_devcgroup;
 	const char *b;
 	char *endp;
 	int count;
@@ -361,8 +339,6 @@ static int devcgroup_update_access(struc
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	cur_devcgroup = task_devcgroup(current);

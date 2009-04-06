From: akpm@linux-foundation.org
Subject: [merged] cgroups-fix-cgrouph-comments.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:34:02 -0700
Message-ID: <200904061934.n36JY2kP011357@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754755AbZDFTfZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:35:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: fix cgroup.h comments
has been removed from the -mm tree.  Its filename was
     cgroups-fix-cgrouph-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: fix cgroup.h comments
From: Paul Menage <menage@google.com>

Fix the style of some multi-line comments in cgroup.h to match
Documentation/CodingStyle

Signed-off-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |   71 ++++++++++++++++++++++-----------------
 1 file changed, 41 insertions(+), 30 deletions(-)

diff -puN include/linux/cgroup.h~cgroups-fix-cgrouph-comments include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-fix-cgrouph-comments
+++ a/include/linux/cgroup.h
@@ -47,14 +47,18 @@ enum cgroup_subsys_id {
 
 /* Per-subsystem/per-cgroup state maintained by the system. */
 struct cgroup_subsys_state {
-	/* The cgroup that this subsystem is attached to. Useful
+	/*
+	 * The cgroup that this subsystem is attached to. Useful
 	 * for subsystems that want to know about the cgroup
-	 * hierarchy structure */
+	 * hierarchy structure
+	 */
 	struct cgroup *cgroup;
 
-	/* State maintained by the cgroup system to allow subsystems
+	/*
+	 * State maintained by the cgroup system to allow subsystems
 	 * to be "busy". Should be accessed via css_get(),
-	 * css_tryget() and and css_put(). */
+	 * css_tryget() and and css_put().
+	 */
 
 	atomic_t refcnt;
 
@@ -120,8 +124,10 @@ static inline void css_put(struct cgroup
 enum {
 	/* Control Group is dead */
 	CGRP_REMOVED,
-	/* Control Group has previously had a child cgroup or a task,
-	 * but no longer (only if CGRP_NOTIFY_ON_RELEASE is set) */
+	/*
+	 * Control Group has previously had a child cgroup or a task,
+	 * but no longer (only if CGRP_NOTIFY_ON_RELEASE is set)
+	 */
 	CGRP_RELEASABLE,
 	/* Control Group requires release notifications to userspace */
 	CGRP_NOTIFY_ON_RELEASE,
@@ -130,9 +136,10 @@ enum {
 struct cgroup {
 	unsigned long flags;		/* "unsigned long" so bitops work */
 
-	/* count users of this cgroup. >0 means busy, but doesn't
-	 * necessarily indicate the number of tasks in the
-	 * cgroup */
+	/*
+	 * count users of this cgroup. >0 means busy, but doesn't
+	 * necessarily indicate the number of tasks in the cgroup
+	 */
 	atomic_t count;
 
 	/*
@@ -142,7 +149,7 @@ struct cgroup {
 	struct list_head sibling;	/* my parent's children */
 	struct list_head children;	/* my children */
 
-	struct cgroup *parent;	/* my parent */
+	struct cgroup *parent;		/* my parent */
 	struct dentry *dentry;	  	/* cgroup fs entry, RCU protected */
 
 	/* Private pointers for each registered subsystem */
@@ -177,11 +184,12 @@ struct cgroup {
 	struct rcu_head rcu_head;
 };
 
-/* A css_set is a structure holding pointers to a set of
+/*
+ * A css_set is a structure holding pointers to a set of
  * cgroup_subsys_state objects. This saves space in the task struct
  * object and speeds up fork()/exit(), since a single inc/dec and a
- * list_add()/del() can bump the reference count on the entire
- * cgroup set for a task.
+ * list_add()/del() can bump the reference count on the entire cgroup
+ * set for a task.
  */
 
 struct css_set {
@@ -226,13 +234,8 @@ struct cgroup_map_cb {
 	void *state;
 };
 
-/* struct cftype:
- *
- * The files in the cgroup filesystem mostly have a very simple read/write
- * handling, some common function will take care of it. Nevertheless some cases
- * (read tasks) are special and therefore I define this structure for every
- * kind of file.
- *
+/*
+ * struct cftype: handler definitions for cgroup control files
  *
  * When reading/writing to a file:
  *	- the cgroup to use is file->f_dentry->d_parent->d_fsdata
@@ -241,8 +244,10 @@ struct cgroup_map_cb {
 
 #define MAX_CFTYPE_NAME 64
 struct cftype {
-	/* By convention, the name should begin with the name of the
-	 * subsystem, followed by a period */
+	/*
+	 * By convention, the name should begin with the name of the
+	 * subsystem, followed by a period
+	 */
 	char name[MAX_CFTYPE_NAME];
 	int private;
 
@@ -321,13 +326,17 @@ struct cgroup_scanner {
 	struct ptr_heap *heap;
 };
 
-/* Add a new file to the given cgroup directory. Should only be
- * called by subsystems from within a populate() method */
+/*
+ * Add a new file to the given cgroup directory. Should only be
+ * called by subsystems from within a populate() method
+ */
 int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
 		       const struct cftype *cft);
 
-/* Add a set of new files to the given cgroup directory. Should
- * only be called by subsystems from within a populate() method */
+/*
+ * Add a set of new files to the given cgroup directory. Should
+ * only be called by subsystems from within a populate() method
+ */
 int cgroup_add_files(struct cgroup *cgrp,
 			struct cgroup_subsys *subsys,
 			const struct cftype cft[],
@@ -419,7 +428,8 @@ struct cgroup_iter {
 	struct list_head *task;
 };
 
-/* To iterate across the tasks in a cgroup:
+/*
+ * To iterate across the tasks in a cgroup:
  *
  * 1) call cgroup_iter_start to intialize an iterator
  *
@@ -428,9 +438,10 @@ struct cgroup_iter {
  *
  * 3) call cgroup_iter_end() to destroy the iterator.
  *
- * Or, call cgroup_scan_tasks() to iterate through every task in a cpuset.
- *    - cgroup_scan_tasks() holds the css_set_lock when calling the test_task()
- *      callback, but not while calling the process_task() callback.
+ * Or, call cgroup_scan_tasks() to iterate through every task in a
+ * cgroup - cgroup_scan_tasks() holds the css_set_lock when calling
+ * the test_task() callback, but not while calling the process_task()
+ * callback.
  */
 void cgroup_iter_start(struct cgroup *cgrp, struct cgroup_iter *it);
 struct task_struct *cgroup_iter_next(struct cgroup *cgrp,
_

Patches currently in -mm which might be from menage@google.com are

origin.patch
cls_cgroup-remove-unneeded-cgroup_lock.patch
add-a-refcount-check-in-dput.patch


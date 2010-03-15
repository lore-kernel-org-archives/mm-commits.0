From: akpm@linux-foundation.org
Subject: [merged] cgroups-revamp-subsys-array.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:58:15 -0400
Message-ID: <201003150658.o2F6wmmq016480@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41429 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759694Ab0COG7L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:59:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bblum@andrew.cmu.edu, davem@davemloft.net, kamezawa.hiroyu@jp.fujitsu.com, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: revamp subsys array
has been removed from the -mm tree.  Its filename was
     cgroups-revamp-subsys-array.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: revamp subsys array
From: Ben Blum <bblum@andrew.cmu.edu>

This patch series provides the ability for cgroup subsystems to be
compiled as modules both within and outside the kernel tree.  This is
mainly useful for classifiers and subsystems that hook into components
that are already modules.  cls_cgroup and blkio-cgroup serve as the
example use cases for this feature.

It provides an interface cgroup_load_subsys() and cgroup_unload_subsys()
which modular subsystems can use to register and depart during runtime. 
The net_cls classifier subsystem serves as the example for a subsystem
which can be converted into a module using these changes.

Patch #1 sets up the subsys[] array so its contents can be dynamic as
modules appear and (eventually) disappear.  Iterations over the array are
modified to handle when subsystems are absent, and the dynamic section of
the array is protected by cgroup_mutex.

Patch #2 implements an interface for modules to load subsystems, called
cgroup_load_subsys, similar to cgroup_init_subsys, and adds a module
pointer in struct cgroup_subsys.

Patch #3 adds a mechanism for unloading modular subsystems, which includes
a more advanced rework of the rudimentary reference counting introduced in
patch 2.

Patch #4 modifies the net_cls subsystem, which already had some module
declarations, to be configurable as a module, which also serves as a
simple proof-of-concept.

Part of implementing patches 2 and 4 involved updating css pointers in
each css_set when the module appears or leaves.  In doing this, it was
discovered that css_sets always remain linked to the dummy cgroup,
regardless of whether or not any subsystems are actually bound to it
(i.e., not mounted on an actual hierarchy).  The subsystem loading and
unloading code therefore should keep in mind the special cases where the
added subsystem is the only one in the dummy cgroup (and therefore all
css_sets need to be linked back into it) and where the removed subsys was
the only one in the dummy cgroup (and therefore all css_sets should be
unlinked from it) - however, as all css_sets always stay attached to the
dummy cgroup anyway, these cases are ignored.  Any fix that addresses this
issue should also make sure these cases are addressed in the subsystem
loading and unloading code.



This patch:

Make subsys[] able to be dynamically populated to support modular
subsystems

This patch reworks the way the subsys[] array is used so that subsystems
can register themselves after boot time, and enables the internals of
cgroups to be able to handle when subsystems are not present or may
appear/disappear.

Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>
Acked-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |   10 +++-
 kernel/cgroup.c        |   96 ++++++++++++++++++++++++++++++++-------
 2 files changed, 88 insertions(+), 18 deletions(-)

diff -puN include/linux/cgroup.h~cgroups-revamp-subsys-array include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-revamp-subsys-array
+++ a/include/linux/cgroup.h
@@ -40,13 +40,19 @@ extern int cgroupstats_build(struct cgro
 
 extern const struct file_operations proc_cgroup_operations;
 
-/* Define the enumeration of all cgroup subsystems */
+/* Define the enumeration of all builtin cgroup subsystems */
 #define SUBSYS(_x) _x ## _subsys_id,
 enum cgroup_subsys_id {
 #include <linux/cgroup_subsys.h>
-	CGROUP_SUBSYS_COUNT
+	CGROUP_BUILTIN_SUBSYS_COUNT
 };
 #undef SUBSYS
+/*
+ * This define indicates the maximum number of subsystems that can be loaded
+ * at once. We limit to this many since cgroupfs_root has subsys_bits to keep
+ * track of all of them.
+ */
+#define CGROUP_SUBSYS_COUNT (BITS_PER_BYTE*sizeof(unsigned long))
 
 /* Per-subsystem/per-cgroup state maintained by the system. */
 struct cgroup_subsys_state {
diff -puN kernel/cgroup.c~cgroups-revamp-subsys-array kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-revamp-subsys-array
+++ a/kernel/cgroup.c
@@ -57,10 +57,14 @@
 
 static DEFINE_MUTEX(cgroup_mutex);
 
-/* Generate an array of cgroup subsystem pointers */
+/*
+ * Generate an array of cgroup subsystem pointers. At boot time, this is
+ * populated up to CGROUP_BUILTIN_SUBSYS_COUNT, and modular subsystems are
+ * registered after that. The mutable section of this array is protected by
+ * cgroup_mutex.
+ */
 #define SUBSYS(_x) &_x ## _subsys,
-
-static struct cgroup_subsys *subsys[] = {
+static struct cgroup_subsys *subsys[CGROUP_SUBSYS_COUNT] = {
 #include <linux/cgroup_subsys.h>
 };
 
@@ -448,8 +452,11 @@ static struct css_set *find_existing_css
 	struct hlist_node *node;
 	struct css_set *cg;
 
-	/* Built the set of subsystem state objects that we want to
-	 * see in the new css_set */
+	/*
+	 * Build the set of subsystem state objects that we want to see in the
+	 * new css_set. while subsystems can change globally, the entries here
+	 * won't change, so no need for locking.
+	 */
 	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
 		if (root->subsys_bits & (1UL << i)) {
 			/* Subsystem is in this hierarchy. So we want
@@ -884,7 +891,9 @@ void cgroup_release_and_wakeup_rmdir(str
 	css_put(css);
 }
 
-
+/*
+ * Call with cgroup_mutex held.
+ */
 static int rebind_subsystems(struct cgroupfs_root *root,
 			      unsigned long final_bits)
 {
@@ -892,6 +901,8 @@ static int rebind_subsystems(struct cgro
 	struct cgroup *cgrp = &root->top_cgroup;
 	int i;
 
+	BUG_ON(!mutex_is_locked(&cgroup_mutex));
+
 	removed_bits = root->actual_subsys_bits & ~final_bits;
 	added_bits = final_bits & ~root->actual_subsys_bits;
 	/* Check that any added subsystems are currently free */
@@ -900,6 +911,12 @@ static int rebind_subsystems(struct cgro
 		struct cgroup_subsys *ss = subsys[i];
 		if (!(bit & added_bits))
 			continue;
+		/*
+		 * Nobody should tell us to do a subsys that doesn't exist:
+		 * parse_cgroupfs_options should catch that case and refcounts
+		 * ensure that subsystems won't disappear once selected.
+		 */
+		BUG_ON(ss == NULL);
 		if (ss->root != &rootnode) {
 			/* Subsystem isn't free */
 			return -EBUSY;
@@ -919,6 +936,7 @@ static int rebind_subsystems(struct cgro
 		unsigned long bit = 1UL << i;
 		if (bit & added_bits) {
 			/* We're binding this subsystem to this hierarchy */
+			BUG_ON(ss == NULL);
 			BUG_ON(cgrp->subsys[i]);
 			BUG_ON(!dummytop->subsys[i]);
 			BUG_ON(dummytop->subsys[i]->cgroup != dummytop);
@@ -932,6 +950,7 @@ static int rebind_subsystems(struct cgro
 			mutex_unlock(&ss->hierarchy_mutex);
 		} else if (bit & removed_bits) {
 			/* We're removing this subsystem */
+			BUG_ON(ss == NULL);
 			BUG_ON(cgrp->subsys[i] != dummytop->subsys[i]);
 			BUG_ON(cgrp->subsys[i]->cgroup != cgrp);
 			mutex_lock(&ss->hierarchy_mutex);
@@ -944,6 +963,7 @@ static int rebind_subsystems(struct cgro
 			mutex_unlock(&ss->hierarchy_mutex);
 		} else if (bit & final_bits) {
 			/* Subsystem state should already exist */
+			BUG_ON(ss == NULL);
 			BUG_ON(!cgrp->subsys[i]);
 		} else {
 			/* Subsystem state shouldn't exist */
@@ -986,14 +1006,18 @@ struct cgroup_sb_opts {
 
 };
 
-/* Convert a hierarchy specifier into a bitmask of subsystems and
- * flags. */
+/*
+ * Convert a hierarchy specifier into a bitmask of subsystems and flags. Call
+ * with cgroup_mutex held to protect the subsys[] array.
+ */
 static int parse_cgroupfs_options(char *data,
 				     struct cgroup_sb_opts *opts)
 {
 	char *token, *o = data ?: "all";
 	unsigned long mask = (unsigned long)-1;
 
+	BUG_ON(!mutex_is_locked(&cgroup_mutex));
+
 #ifdef CONFIG_CPUSETS
 	mask = ~(1UL << cpuset_subsys_id);
 #endif
@@ -1009,6 +1033,8 @@ static int parse_cgroupfs_options(char *
 			opts->subsys_bits = 0;
 			for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
 				struct cgroup_subsys *ss = subsys[i];
+				if (ss == NULL)
+					continue;
 				if (!ss->disabled)
 					opts->subsys_bits |= 1ul << i;
 			}
@@ -1053,6 +1079,8 @@ static int parse_cgroupfs_options(char *
 			int i;
 			for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
 				ss = subsys[i];
+				if (ss == NULL)
+					continue;
 				if (!strcmp(token, ss->name)) {
 					if (!ss->disabled)
 						set_bit(i, &opts->subsys_bits);
@@ -1306,7 +1334,9 @@ static int cgroup_get_sb(struct file_sys
 	struct cgroupfs_root *new_root;
 
 	/* First find the desired set of subsystems */
+	mutex_lock(&cgroup_mutex);
 	ret = parse_cgroupfs_options(data, &opts);
+	mutex_unlock(&cgroup_mutex);
 	if (ret)
 		goto out_err;
 
@@ -2918,8 +2948,14 @@ static void cgroup_lock_hierarchy(struct
 	/* We need to take each hierarchy_mutex in a consistent order */
 	int i;
 
+	/*
+	 * No worry about a race with rebind_subsystems that might mess up the
+	 * locking order, since both parties are under cgroup_mutex.
+	 */
 	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
 		struct cgroup_subsys *ss = subsys[i];
+		if (ss == NULL)
+			continue;
 		if (ss->root == root)
 			mutex_lock(&ss->hierarchy_mutex);
 	}
@@ -2931,6 +2967,8 @@ static void cgroup_unlock_hierarchy(stru
 
 	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
 		struct cgroup_subsys *ss = subsys[i];
+		if (ss == NULL)
+			continue;
 		if (ss->root == root)
 			mutex_unlock(&ss->hierarchy_mutex);
 	}
@@ -3054,11 +3092,16 @@ static int cgroup_has_css_refs(struct cg
 	 * synchronization other than RCU, and the subsystem linked
 	 * list isn't RCU-safe */
 	int i;
+	/*
+	 * We won't need to lock the subsys array, because the subsystems
+	 * we're concerned about aren't going anywhere since our cgroup root
+	 * has a reference on them.
+	 */
 	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
 		struct cgroup_subsys *ss = subsys[i];
 		struct cgroup_subsys_state *css;
-		/* Skip subsystems not in this hierarchy */
-		if (ss->root != cgrp->root)
+		/* Skip subsystems not present or not in this hierarchy */
+		if (ss == NULL || ss->root != cgrp->root)
 			continue;
 		css = cgrp->subsys[ss->subsys_id];
 		/* When called from check_for_release() it's possible
@@ -3279,7 +3322,8 @@ int __init cgroup_init_early(void)
 	for (i = 0; i < CSS_SET_TABLE_SIZE; i++)
 		INIT_HLIST_HEAD(&css_set_table[i]);
 
-	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
+	/* at bootup time, we don't worry about modular subsystems */
+	for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
 		struct cgroup_subsys *ss = subsys[i];
 
 		BUG_ON(!ss->name);
@@ -3314,7 +3358,8 @@ int __init cgroup_init(void)
 	if (err)
 		return err;
 
-	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
+	/* at bootup time, we don't worry about modular subsystems */
+	for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
 		struct cgroup_subsys *ss = subsys[i];
 		if (!ss->early_init)
 			cgroup_init_subsys(ss);
@@ -3423,9 +3468,16 @@ static int proc_cgroupstats_show(struct 
 	int i;
 
 	seq_puts(m, "#subsys_name\thierarchy\tnum_cgroups\tenabled\n");
+	/*
+	 * ideally we don't want subsystems moving around while we do this.
+	 * cgroup_mutex is also necessary to guarantee an atomic snapshot of
+	 * subsys/hierarchy state.
+	 */
 	mutex_lock(&cgroup_mutex);
 	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
 		struct cgroup_subsys *ss = subsys[i];
+		if (ss == NULL)
+			continue;
 		seq_printf(m, "%s\t%d\t%d\t%d\n",
 			   ss->name, ss->root->hierarchy_id,
 			   ss->root->number_of_cgroups, !ss->disabled);
@@ -3483,7 +3535,12 @@ void cgroup_fork_callbacks(struct task_s
 {
 	if (need_forkexit_callback) {
 		int i;
-		for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
+		/*
+		 * forkexit callbacks are only supported for builtin
+		 * subsystems, and the builtin section of the subsys array is
+		 * immutable, so we don't need to lock the subsys array here.
+		 */
+		for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
 			struct cgroup_subsys *ss = subsys[i];
 			if (ss->fork)
 				ss->fork(ss, child);
@@ -3552,7 +3609,11 @@ void cgroup_exit(struct task_struct *tsk
 	struct css_set *cg;
 
 	if (run_callbacks && need_forkexit_callback) {
-		for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
+		/*
+		 * modular subsystems can't use callbacks, so no need to lock
+		 * the subsys array
+		 */
+		for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
 			struct cgroup_subsys *ss = subsys[i];
 			if (ss->exit)
 				ss->exit(ss, tsk);
@@ -3844,8 +3905,11 @@ static int __init cgroup_disable(char *s
 	while ((token = strsep(&str, ",")) != NULL) {
 		if (!*token)
 			continue;

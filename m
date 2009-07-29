From: akpm@linux-foundation.org
Subject: + cgroups-allow-cgroup-hierarchies-to-be-created-with-no-bound-subsystems.patch added to -mm tree
Date: Wed, 29 Jul 2009 15:42:52 -0700
Message-ID: <200907292242.n6TMgrCf017121@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48045 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754157AbZG2Wnh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 18:43:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, balbir@in.ibm.com, dhaval@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com


The patch titled
     cgroups: allow cgroup hierarchies to be created with no bound subsystems
has been added to the -mm tree.  Its filename is
     cgroups-allow-cgroup-hierarchies-to-be-created-with-no-bound-subsystems.patch

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
Subject: cgroups: allow cgroup hierarchies to be created with no bound subsystems
From: Paul Menage <menage@google.com>

This patch removes the restriction that a cgroup hierarchy must have at
least one bound subsystem.  The mount option "none" is treated as an
explicit request for no bound subsystems.

A hierarchy with no subsystems can be useful for plain task tracking, and
is also a step towards the support for multiply-bindable subsystems.

As part of this change, the hierarchy id is no longer calculated from the
bitmask of subsystems in the hierarchy (since this is not guaranteed to be
unique) but is allocated via an ida.  Reference counts on cgroups from
css_set objects are now taken explicitly one per hierarchy, rather than
one per subsystem.

Example usage:

mount -t cgroup -o none,name=foo cgroup /mnt/cgroup

Based on the "no-op"/"none" subsystem concept proposed by
kamezawa.hiroyu@jp.fujitsu.com

Signed-off-by: Paul Menage <menage@google.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |  158 ++++++++++++++++++++++++++++------------------
 1 file changed, 99 insertions(+), 59 deletions(-)

diff -puN kernel/cgroup.c~cgroups-allow-cgroup-hierarchies-to-be-created-with-no-bound-subsystems kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-allow-cgroup-hierarchies-to-be-created-with-no-bound-subsystems
+++ a/kernel/cgroup.c
@@ -49,6 +49,7 @@
 #include <linux/namei.h>
 #include <linux/smp_lock.h>
 #include <linux/pid_namespace.h>
+#include <linux/idr.h>
 
 #include <asm/atomic.h>
 
@@ -77,6 +78,9 @@ struct cgroupfs_root {
 	 */
 	unsigned long subsys_bits;
 
+	/* Unique id for this hierarchy. */
+	int hierarchy_id;
+
 	/* The bitmask of subsystems currently attached to this hierarchy */
 	unsigned long actual_subsys_bits;
 
@@ -147,6 +151,10 @@ struct css_id {
 static LIST_HEAD(roots);
 static int root_count;
 
+static DEFINE_IDA(hierarchy_ida);
+static int next_hierarchy_id;
+static DEFINE_SPINLOCK(hierarchy_id_lock);
+
 /* dummytop is a shorthand for the dummy hierarchy's top cgroup */
 #define dummytop (&rootnode.top_cgroup)
 
@@ -264,42 +272,10 @@ static struct hlist_head *css_set_hash(s
  * compiled into their kernel but not actually in use */
 static int use_task_css_set_links __read_mostly;
 
-/* When we create or destroy a css_set, the operation simply
- * takes/releases a reference count on all the cgroups referenced
- * by subsystems in this css_set. This can end up multiple-counting
- * some cgroups, but that's OK - the ref-count is just a
- * busy/not-busy indicator; ensuring that we only count each cgroup
- * once would require taking a global lock to ensure that no
- * subsystems moved between hierarchies while we were doing so.
- *
- * Possible TODO: decide at boot time based on the number of
- * registered subsystems and the number of CPUs or NUMA nodes whether
- * it's better for performance to ref-count every subsystem, or to
- * take a global lock and only add one ref count to each hierarchy.
- */
-
-/*
- * unlink a css_set from the list and free it
- */
-static void unlink_css_set(struct css_set *cg)
+static void __put_css_set(struct css_set *cg, int taskexit)
 {
 	struct cg_cgroup_link *link;
 	struct cg_cgroup_link *saved_link;
-
-	hlist_del(&cg->hlist);
-	css_set_count--;
-
-	list_for_each_entry_safe(link, saved_link, &cg->cg_links,
-				 cg_link_list) {
-		list_del(&link->cg_link_list);
-		list_del(&link->cgrp_link_list);
-		kfree(link);
-	}
-}
-
-static void __put_css_set(struct css_set *cg, int taskexit)
-{
-	int i;
 	/*
 	 * Ensure that the refcount doesn't hit zero while any readers
 	 * can see it. Similar to atomic_dec_and_lock(), but for an
@@ -312,20 +288,27 @@ static void __put_css_set(struct css_set
 		write_unlock(&css_set_lock);
 		return;
 	}
-	unlink_css_set(cg);
-	write_unlock(&css_set_lock);
 
-	rcu_read_lock();
-	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
-		struct cgroup *cgrp = rcu_dereference(cg->subsys[i]->cgroup);
+	/* This css_set is dead. unlink it and release cgroup refcounts */
+	hlist_del(&cg->hlist);
+	css_set_count--;
+
+	list_for_each_entry_safe(link, saved_link, &cg->cg_links,
+				 cg_link_list) {
+		struct cgroup *cgrp = link->cgrp;
+		list_del(&link->cg_link_list);
+		list_del(&link->cgrp_link_list);
 		if (atomic_dec_and_test(&cgrp->count) &&
 		    notify_on_release(cgrp)) {
 			if (taskexit)
 				set_bit(CGRP_RELEASABLE, &cgrp->flags);
 			check_for_release(cgrp);
 		}
+
+		kfree(link);
 	}
-	rcu_read_unlock();
+
+	write_unlock(&css_set_lock);
 	kfree(cg);
 }
 
@@ -519,6 +502,7 @@ static void link_css_set(struct list_hea
 				cgrp_link_list);
 	link->cg = cg;
 	link->cgrp = cgrp;
+	atomic_inc(&cgrp->count);
 	list_move(&link->cgrp_link_list, &cgrp->css_sets);
 	/*
 	 * Always add links to the tail of the list so that the list
@@ -539,7 +523,6 @@ static struct css_set *find_css_set(
 {
 	struct css_set *res;
 	struct cgroup_subsys_state *template[CGROUP_SUBSYS_COUNT];
-	int i;
 
 	struct list_head tmp_cg_links;
 
@@ -578,10 +561,6 @@ static struct css_set *find_css_set(
 
 	write_lock(&css_set_lock);
 	/* Add reference counts and links from the new css_set. */
-	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
-		struct cgroup *cgrp = res->subsys[i]->cgroup;
-		atomic_inc(&cgrp->count);
-	}
 	list_for_each_entry(link, &oldcg->cg_links, cg_link_list) {
 		struct cgroup *c = link->cgrp;
 		if (c->root == cgrp->root)
@@ -972,8 +951,11 @@ struct cgroup_sb_opts {
 	unsigned long flags;
 	char *release_agent;
 	char *name;
+	/* User explicitly requested empty subsystem */
+	bool none;
 
 	struct cgroupfs_root *new_root;
+
 };
 
 /* Convert a hierarchy specifier into a bitmask of subsystems and
@@ -1002,6 +984,9 @@ static int parse_cgroupfs_options(char *
 				if (!ss->disabled)
 					opts->subsys_bits |= 1ul << i;
 			}
+		} else if (!strcmp(token, "none")) {
+			/* Explicitly have no subsystems */
+			opts->none = true;
 		} else if (!strcmp(token, "noprefix")) {
 			set_bit(ROOT_NOPREFIX, &opts->flags);
 		} else if (!strncmp(token, "release_agent=", 14)) {
@@ -1051,6 +1036,8 @@ static int parse_cgroupfs_options(char *
 		}
 	}
 
+	/* Consistency checks */
+
 	/*
 	 * Option noprefix was introduced just for backward compatibility
 	 * with the old cpuset, so we allow noprefix only if mounting just
@@ -1060,7 +1047,15 @@ static int parse_cgroupfs_options(char *
 	    (opts->subsys_bits & mask))
 		return -EINVAL;
 
-	/* We can't have an empty hierarchy */
+
+	/* Can't specify "none" and some subsystems */
+	if (opts->subsys_bits && opts->none)
+		return -EINVAL;
+
+	/*
+	 * We either have to specify by name or by subsystems. (So all
+	 * empty hierarchies must have a name).
+	 */
 	if (!opts->subsys_bits && !opts->name)
 		return -EINVAL;
 
@@ -1141,6 +1136,31 @@ static void init_cgroup_root(struct cgro
 	init_cgroup_housekeeping(cgrp);
 }
 
+static bool init_root_id(struct cgroupfs_root *root)
+{
+	int ret = 0;
+
+	do {
+		if (!ida_pre_get(&hierarchy_ida, GFP_KERNEL))
+			return false;
+		spin_lock(&hierarchy_id_lock);
+		/* Try to allocate the next unused ID */
+		ret = ida_get_new_above(&hierarchy_ida, next_hierarchy_id,
+					&root->hierarchy_id);
+		if (ret == -ENOSPC)
+			/* Try again starting from 0 */
+			ret = ida_get_new(&hierarchy_ida, &root->hierarchy_id);
+		if (!ret) {
+			next_hierarchy_id = root->hierarchy_id + 1;
+		} else if (ret != -EAGAIN) {
+			/* Can only get here if the 31-bit IDR is full ... */
+			BUG_ON(ret);
+		}
+		spin_unlock(&hierarchy_id_lock);
+	} while (ret);
+	return true;
+}
+
 static int cgroup_test_super(struct super_block *sb, void *data)
 {
 	struct cgroup_sb_opts *opts = data;
@@ -1150,8 +1170,12 @@ static int cgroup_test_super(struct supe
 	if (opts->name && strcmp(opts->name, root->name))
 		return 0;
 
-	/* If we asked for subsystems then they must match */
-	if (opts->subsys_bits && (opts->subsys_bits != root->subsys_bits))
+	/*
+	 * If we asked for subsystems (or explicitly for no
+	 * subsystems) then they must match
+	 */
+	if ((opts->subsys_bits || opts->none)
+	    && (opts->subsys_bits != root->subsys_bits))
 		return 0;
 
 	return 1;
@@ -1161,15 +1185,19 @@ static struct cgroupfs_root *cgroup_root
 {
 	struct cgroupfs_root *root;
 
-	/* Empty hierarchies aren't supported */
-	if (!opts->subsys_bits)
+	if (!opts->subsys_bits && !opts->none)
 		return NULL;
 
 	root = kzalloc(sizeof(*root), GFP_KERNEL);
 	if (!root)
 		return ERR_PTR(-ENOMEM);
 
+	if (!init_root_id(root)) {
+		kfree(root);
+		return ERR_PTR(-ENOMEM);
+	}
 	init_cgroup_root(root);
+
 	root->subsys_bits = opts->subsys_bits;
 	root->flags = opts->flags;
 	if (opts->release_agent)
@@ -1179,6 +1207,18 @@ static struct cgroupfs_root *cgroup_root
 	return root;
 }
 
+static void cgroup_drop_root(struct cgroupfs_root *root)
+{
+	if (!root)
+		return;
+
+	BUG_ON(!root->hierarchy_id);
+	spin_lock(&hierarchy_id_lock);
+	ida_remove(&hierarchy_ida, root->hierarchy_id);
+	spin_unlock(&hierarchy_id_lock);
+	kfree(root);
+}
+
 static int cgroup_set_super(struct super_block *sb, void *data)
 {
 	int ret;
@@ -1188,7 +1228,7 @@ static int cgroup_set_super(struct super
 	if (!opts->new_root)
 		return -EINVAL;
 
-	BUG_ON(!opts->subsys_bits);
+	BUG_ON(!opts->subsys_bits && !opts->none);
 
 	ret = set_anon_super(sb, NULL);
 	if (ret)
@@ -1257,7 +1297,7 @@ static int cgroup_get_sb(struct file_sys
 	sb = sget(fs_type, cgroup_test_super, cgroup_set_super, &opts);
 	if (IS_ERR(sb)) {
 		ret = PTR_ERR(sb);
-		kfree(opts.new_root);
+		cgroup_drop_root(opts.new_root);
 		goto out_err;
 	}
 
@@ -1351,7 +1391,7 @@ static int cgroup_get_sb(struct file_sys
 		 * We re-used an existing hierarchy - the new root (if
 		 * any) is not needed
 		 */
-		kfree(opts.new_root);
+		cgroup_drop_root(opts.new_root);
 	}
 
 	simple_set_mnt(mnt, sb);
@@ -1410,7 +1450,7 @@ static void cgroup_kill_sb(struct super_
 	mutex_unlock(&cgroup_mutex);
 
 	kill_litter_super(sb);
-	kfree(root);
+	cgroup_drop_root(root);
 }
 
 static struct file_system_type cgroup_fs_type = {
@@ -3109,7 +3149,7 @@ int __init cgroup_init(void)
 	/* Add init_css_set to the hash table */
 	hhead = css_set_hash(init_css_set.subsys);
 	hlist_add_head(&init_css_set.hlist, hhead);
-
+	BUG_ON(!init_root_id(&rootnode));
 	err = register_filesystem(&cgroup_fs_type);
 	if (err < 0)
 		goto out;
@@ -3164,7 +3204,7 @@ static int proc_cgroup_show(struct seq_f
 		struct cgroup *cgrp;
 		int count = 0;
 
-		seq_printf(m, "%lu:", root->subsys_bits);
+		seq_printf(m, "%d:", root->hierarchy_id);
 		for_each_subsys(root, ss)
 			seq_printf(m, "%s%s", count++ ? "," : "", ss->name);
 		if (strlen(root->name))
@@ -3210,8 +3250,8 @@ static int proc_cgroupstats_show(struct 
 	mutex_lock(&cgroup_mutex);
 	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
 		struct cgroup_subsys *ss = subsys[i];
-		seq_printf(m, "%s\t%lu\t%d\t%d\n",
-			   ss->name, ss->root->subsys_bits,
+		seq_printf(m, "%s\t%d\t%d\t%d\n",
+			   ss->name, ss->root->hierarchy_id,
 			   ss->root->number_of_cgroups, !ss->disabled);
 	}
 	mutex_unlock(&cgroup_mutex);
@@ -3929,8 +3969,8 @@ static int current_css_set_cg_links_read
 			name = c->dentry->d_name.name;
 		else
 			name = "?";
-		seq_printf(seq, "Root %lu group %s\n",
-			   c->root->subsys_bits, name);
+		seq_printf(seq, "Root %d group %s\n",
+			   c->root->hierarchy_id, name);
 	}
 	rcu_read_unlock();
 	read_unlock(&css_set_lock);
_

Patches currently in -mm which might be from menage@google.com are

cgroups-fix-pid-namespace-bug.patch
cgroup-avoid-permanent-sleep-at-rmdir-v7.patch
mm-remove-obsoleted-alloc_pages-cpuset-comment.patch
mm-make-set_mempolicympol_interleav-n_high_memory-aware.patch
mm-make-set_mempolicympol_interleav-n_high_memory-aware-fix.patch
include-linux-credh-work-around-gcc-424-warning-in-get_cred.patch
cgroups-make-unlock-sequence-in-cgroup_get_sb-consistent.patch
cgroups-support-named-cgroups-hierarchies.patch
cgroups-move-the-cgroup-debug-subsys-into-cgroupc-to-access-internal-state.patch
cgroups-add-a-back-pointer-from-struct-cg_cgroup_link-to-struct-cgroup.patch
cgroups-allow-cgroup-hierarchies-to-be-created-with-no-bound-subsystems.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
add-a-refcount-check-in-dput.patch


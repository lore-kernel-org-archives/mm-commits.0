From: akpm@linux-foundation.org
Subject: + cgroups-support-named-cgroups-hierarchies.patch added to -mm tree
Date: Wed, 29 Jul 2009 15:42:43 -0700
Message-ID: <200907292242.n6TMgiLd016912@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51444 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754157AbZG2Wna (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 18:43:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, balbir@in.ibm.com, dhaval@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com


The patch titled
     cgroups: support named cgroups hierarchies
has been added to the -mm tree.  Its filename is
     cgroups-support-named-cgroups-hierarchies.patch

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
Subject: cgroups: support named cgroups hierarchies
From: Paul Menage <menage@google.com>

To simplify referring to cgroup hierarchies in mount statements, and to
allow disambiguation in the presence of empty hierarchies and
multiply-bindable subsystems this patch adds support for naming a new
cgroup hierarchy via the "name=" mount option

A pre-existing hierarchy may be specified by either name or by subsystems;
a hierarchy's name cannot be changed by a remount operation.

Example usage:

# To create a hierarchy called "foo" containing the "cpu" subsystem
mount -t cgroup -oname=foo,cpu cgroup /mnt/cgroup1

# To mount the "foo" hierarchy on a second location
mount -t cgroup -oname=foo cgroup /mnt/cgroup2

Signed-off-by: Paul Menage <menage@google.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/cgroups.txt |   20 +++
 kernel/cgroup.c                   |  184 ++++++++++++++++++++--------
 2 files changed, 156 insertions(+), 48 deletions(-)

diff -puN Documentation/cgroups/cgroups.txt~cgroups-support-named-cgroups-hierarchies Documentation/cgroups/cgroups.txt
--- a/Documentation/cgroups/cgroups.txt~cgroups-support-named-cgroups-hierarchies
+++ a/Documentation/cgroups/cgroups.txt
@@ -408,6 +408,26 @@ You can attach the current shell task by
 
 # echo 0 > tasks
 
+2.3 Mounting hierarchies by name
+--------------------------------
+
+Passing the name=<x> option when mounting a cgroups hierarchy
+associates the given name with the hierarchy.  This can be used when
+mounting a pre-existing hierarchy, in order to refer to it by name
+rather than by its set of active subsystems.  Each hierarchy is either
+nameless, or has a unique name.
+
+The name should match [\w.-]+
+
+When passing a name=<x> option for a new hierarchy, you need to
+specify subsystems manually; the legacy behaviour of mounting all
+subsystems when none are explicitly specified is not supported when
+you give a subsystem a name.
+
+The name of the subsystem appears as part of the hierarchy description
+in /proc/mounts and /proc/<pid>/cgroups.
+
+
 3. Kernel API
 =============
 
diff -puN kernel/cgroup.c~cgroups-support-named-cgroups-hierarchies kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-support-named-cgroups-hierarchies
+++ a/kernel/cgroup.c
@@ -23,6 +23,7 @@
  */
 
 #include <linux/cgroup.h>
+#include <linux/ctype.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/kernel.h>
@@ -60,6 +61,8 @@ static struct cgroup_subsys *subsys[] = 
 #include <linux/cgroup_subsys.h>
 };
 
+#define MAX_CGROUP_ROOT_NAMELEN 64
+
 /*
  * A cgroupfs_root represents the root of a cgroup hierarchy,
  * and may be associated with a superblock to form an active
@@ -94,6 +97,9 @@ struct cgroupfs_root {
 
 	/* The path to use for release notifications. */
 	char release_agent_path[PATH_MAX];
+
+	/* The name for this hierarchy - may be empty */
+	char name[MAX_CGROUP_ROOT_NAMELEN];
 };
 
 /*
@@ -841,6 +847,8 @@ static int cgroup_show_options(struct se
 		seq_puts(seq, ",noprefix");
 	if (strlen(root->release_agent_path))
 		seq_printf(seq, ",release_agent=%s", root->release_agent_path);
+	if (strlen(root->name))
+		seq_printf(seq, ",name=%s", root->name);
 	mutex_unlock(&cgroup_mutex);
 	return 0;
 }
@@ -849,6 +857,9 @@ struct cgroup_sb_opts {
 	unsigned long subsys_bits;
 	unsigned long flags;
 	char *release_agent;
+	char *name;
+
+	struct cgroupfs_root *new_root;
 };
 
 /* Convert a hierarchy specifier into a bitmask of subsystems and
@@ -863,9 +874,7 @@ static int parse_cgroupfs_options(char *
 	mask = ~(1UL << cpuset_subsys_id);
 #endif
 
-	opts->subsys_bits = 0;
-	opts->flags = 0;
-	opts->release_agent = NULL;
+	memset(opts, 0, sizeof(*opts));
 
 	while ((token = strsep(&o, ",")) != NULL) {
 		if (!*token)
@@ -885,11 +894,33 @@ static int parse_cgroupfs_options(char *
 			/* Specifying two release agents is forbidden */
 			if (opts->release_agent)
 				return -EINVAL;
-			opts->release_agent = kzalloc(PATH_MAX, GFP_KERNEL);
+			opts->release_agent =
+				kstrndup(token + 14, PATH_MAX, GFP_KERNEL);
 			if (!opts->release_agent)
 				return -ENOMEM;
-			strncpy(opts->release_agent, token + 14, PATH_MAX - 1);
-			opts->release_agent[PATH_MAX - 1] = 0;
+		} else if (!strncmp(token, "name=", 5)) {
+			int i;
+			const char *name = token + 5;
+			/* Can't specify an empty name */
+			if (!strlen(name))
+				return -EINVAL;
+			/* Must match [\w.-]+ */
+			for (i = 0; i < strlen(name); i++) {
+				char c = name[i];
+				if (isalnum(c))
+					continue;
+				if ((c == '.') || (c == '-') || (c == '_'))
+					continue;
+				return -EINVAL;
+			}
+			/* Specifying two names is forbidden */
+			if (opts->name)
+				return -EINVAL;
+			opts->name = kstrndup(name,
+					      MAX_CGROUP_ROOT_NAMELEN,
+					      GFP_KERNEL);
+			if (!opts->name)
+				return -ENOMEM;
 		} else {
 			struct cgroup_subsys *ss;
 			int i;
@@ -916,7 +947,7 @@ static int parse_cgroupfs_options(char *
 		return -EINVAL;
 
 	/* We can't have an empty hierarchy */
-	if (!opts->subsys_bits)
+	if (!opts->subsys_bits && !opts->name)
 		return -EINVAL;
 
 	return 0;
@@ -944,6 +975,12 @@ static int cgroup_remount(struct super_b
 		goto out_unlock;
 	}
 
+	/* Don't allow name to change at remount */
+	if (opts.name && strcmp(opts.name, root->name)) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
 	ret = rebind_subsystems(root, opts.subsys_bits);
 	if (ret)
 		goto out_unlock;
@@ -955,6 +992,7 @@ static int cgroup_remount(struct super_b
 		strcpy(root->release_agent_path, opts.release_agent);
  out_unlock:
 	kfree(opts.release_agent);
+	kfree(opts.name);
 	mutex_unlock(&cgroup_mutex);
 	mutex_unlock(&cgrp->dentry->d_inode->i_mutex);
 	unlock_kernel();
@@ -977,6 +1015,7 @@ static void init_cgroup_housekeeping(str
 	INIT_LIST_HEAD(&cgrp->pids_list);
 	init_rwsem(&cgrp->pids_mutex);
 }
+
 static void init_cgroup_root(struct cgroupfs_root *root)
 {
 	struct cgroup *cgrp = &root->top_cgroup;
@@ -990,31 +1029,59 @@ static void init_cgroup_root(struct cgro
 
 static int cgroup_test_super(struct super_block *sb, void *data)
 {
-	struct cgroupfs_root *new = data;
+	struct cgroup_sb_opts *opts = data;
 	struct cgroupfs_root *root = sb->s_fs_info;
 
-	/* First check subsystems */
-	if (new->subsys_bits != root->subsys_bits)
-	    return 0;
+	/* If we asked for a name then it must match */
+	if (opts->name && strcmp(opts->name, root->name))
+		return 0;
 
-	/* Next check flags */
-	if (new->flags != root->flags)
+	/* If we asked for subsystems then they must match */
+	if (opts->subsys_bits && (opts->subsys_bits != root->subsys_bits))
 		return 0;
 
 	return 1;
 }
 
+static struct cgroupfs_root *cgroup_root_from_opts(struct cgroup_sb_opts *opts)
+{
+	struct cgroupfs_root *root;
+
+	/* Empty hierarchies aren't supported */
+	if (!opts->subsys_bits)
+		return NULL;
+
+	root = kzalloc(sizeof(*root), GFP_KERNEL);
+	if (!root)
+		return ERR_PTR(-ENOMEM);
+
+	init_cgroup_root(root);
+	root->subsys_bits = opts->subsys_bits;
+	root->flags = opts->flags;
+	if (opts->release_agent)
+		strcpy(root->release_agent_path, opts->release_agent);
+	if (opts->name)
+		strcpy(root->name, opts->name);
+	return root;
+}
+
 static int cgroup_set_super(struct super_block *sb, void *data)
 {
 	int ret;
-	struct cgroupfs_root *root = data;
+	struct cgroup_sb_opts *opts = data;
+
+	/* If we don't have a new root, we can't set up a new sb */
+	if (!opts->new_root)
+		return -EINVAL;
+
+	BUG_ON(!opts->subsys_bits);
 
 	ret = set_anon_super(sb, NULL);
 	if (ret)
 		return ret;
 
-	sb->s_fs_info = root;
-	root->sb = sb;
+	sb->s_fs_info = opts->new_root;
+	opts->new_root->sb = sb;
 
 	sb->s_blocksize = PAGE_CACHE_SIZE;
 	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
@@ -1051,48 +1118,43 @@ static int cgroup_get_sb(struct file_sys
 			 void *data, struct vfsmount *mnt)
 {
 	struct cgroup_sb_opts opts;
+	struct cgroupfs_root *root;
 	int ret = 0;
 	struct super_block *sb;
-	struct cgroupfs_root *root;
-	struct list_head tmp_cg_links;
+	struct cgroupfs_root *new_root;
 
 	/* First find the desired set of subsystems */
 	ret = parse_cgroupfs_options(data, &opts);
-	if (ret) {
-		kfree(opts.release_agent);
-		return ret;
-	}
-
-	root = kzalloc(sizeof(*root), GFP_KERNEL);
-	if (!root) {
-		kfree(opts.release_agent);
-		return -ENOMEM;
-	}
+	if (ret)
+		goto out_err;
 
-	init_cgroup_root(root);
-	root->subsys_bits = opts.subsys_bits;
-	root->flags = opts.flags;
-	if (opts.release_agent) {
-		strcpy(root->release_agent_path, opts.release_agent);
-		kfree(opts.release_agent);
+	/*
+	 * Allocate a new cgroup root. We may not need it if we're
+	 * reusing an existing hierarchy.
+	 */
+	new_root = cgroup_root_from_opts(&opts);
+	if (IS_ERR(new_root)) {
+		ret = PTR_ERR(new_root);
+		goto out_err;
 	}
+	opts.new_root = new_root;
 
-	sb = sget(fs_type, cgroup_test_super, cgroup_set_super, root);
-
+	/* Locate an existing or new sb for this hierarchy */
+	sb = sget(fs_type, cgroup_test_super, cgroup_set_super, &opts);
 	if (IS_ERR(sb)) {
-		kfree(root);
-		return PTR_ERR(sb);
+		ret = PTR_ERR(sb);
+		kfree(opts.new_root);
+		goto out_err;
 	}
 
-	if (sb->s_fs_info != root) {
-		/* Reusing an existing superblock */
-		BUG_ON(sb->s_root == NULL);
-		kfree(root);
-		root = NULL;
-	} else {
-		/* New superblock */
+	root = sb->s_fs_info;
+	BUG_ON(!root);
+	if (root == opts.new_root) {
+		/* We used the new root structure, so this is a new hierarchy */
+		struct list_head tmp_cg_links;
 		struct cgroup *root_cgrp = &root->top_cgroup;
 		struct inode *inode;
+		struct cgroupfs_root *existing_root;
 		int i;
 
 		BUG_ON(sb->s_root != NULL);
@@ -1105,6 +1167,18 @@ static int cgroup_get_sb(struct file_sys
 		mutex_lock(&inode->i_mutex);
 		mutex_lock(&cgroup_mutex);
 
+		if (strlen(root->name)) {
+			/* Check for name clashes with existing mounts */
+			for_each_active_root(existing_root) {
+				if (!strcmp(existing_root->name, root->name)) {
+					ret = -EBUSY;
+					mutex_unlock(&cgroup_mutex);
+					mutex_unlock(&inode->i_mutex);
+					goto drop_new_super;
+				}
+			}
+		}
+
 		/*
 		 * We're accessing css_set_count without locking
 		 * css_set_lock here, but that's OK - it can only be
@@ -1123,7 +1197,8 @@ static int cgroup_get_sb(struct file_sys
 		if (ret == -EBUSY) {
 			mutex_unlock(&cgroup_mutex);
 			mutex_unlock(&inode->i_mutex);
-			goto free_cg_links;
+			free_cg_links(&tmp_cg_links);
+			goto drop_new_super;
 		}
 
 		/* EBUSY should be the only error here */
@@ -1157,15 +1232,25 @@ static int cgroup_get_sb(struct file_sys
 		cgroup_populate_dir(root_cgrp);
 		mutex_unlock(&cgroup_mutex);
 		mutex_unlock(&inode->i_mutex);
+	} else {
+		/*
+		 * We re-used an existing hierarchy - the new root (if
+		 * any) is not needed
+		 */
+		kfree(opts.new_root);
 	}
 
 	simple_set_mnt(mnt, sb);
+	kfree(opts.release_agent);
+	kfree(opts.name);
 	return 0;
 
- free_cg_links:
-	free_cg_links(&tmp_cg_links);
  drop_new_super:
 	deactivate_locked_super(sb);
+ out_err:
+	kfree(opts.release_agent);
+	kfree(opts.name);
+
 	return ret;
 }
 
@@ -2992,6 +3077,9 @@ static int proc_cgroup_show(struct seq_f
 		seq_printf(m, "%lu:", root->subsys_bits);
 		for_each_subsys(root, ss)
 			seq_printf(m, "%s%s", count++ ? "," : "", ss->name);
+		if (strlen(root->name))
+			seq_printf(m, "%sname=%s", count ? "," : "",
+				   root->name);
 		seq_putc(m, ':');
 		get_first_subsys(&root->top_cgroup, NULL, &subsys_id);
 		cgrp = task_cgroup(tsk, subsys_id);
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


From: akpm@linux-foundation.org
Subject: [merged] cgroups-show-correct-file-mode.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:34:17 -0700
Message-ID: <200904061934.n36JYHCg011560@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34775 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757573AbZDFThE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:37:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: show correct file mode
has been removed from the -mm tree.  Its filename was
     cgroups-show-correct-file-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: show correct file mode
From: Li Zefan <lizf@cn.fujitsu.com>

We have some read-only files and write-only files, but currently they are
all set to 0644, which is counter-intuitive and cause trouble for some
cgroup tools like libcgroup.

This patch adds 'mode' to struct cftype to allow cgroup subsys to set it's
own files' file mode, and for the most cases cft->mode can be default to 0
and cgroup will figure out proper mode.

Acked-by: Paul Menage <menage@google.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    5 +++++
 kernel/cgroup.c        |   38 ++++++++++++++++++++++++++++++++++----
 kernel/cpuset.c        |    1 +
 3 files changed, 40 insertions(+), 4 deletions(-)

diff -puN include/linux/cgroup.h~cgroups-show-correct-file-mode include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-show-correct-file-mode
+++ a/include/linux/cgroup.h
@@ -258,6 +258,11 @@ struct cftype {
 	 */
 	char name[MAX_CFTYPE_NAME];
 	int private;
+	/*
+	 * If not 0, file mode is set to this value, otherwise it will
+	 * be figured out automatically
+	 */
+	mode_t mode;
 
 	/*
 	 * If non-zero, defines the maximum length of string that can
diff -puN kernel/cgroup.c~cgroups-show-correct-file-mode kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-show-correct-file-mode
+++ a/kernel/cgroup.c
@@ -1686,7 +1686,7 @@ static struct inode_operations cgroup_di
 	.rename = cgroup_rename,
 };
 
-static int cgroup_create_file(struct dentry *dentry, int mode,
+static int cgroup_create_file(struct dentry *dentry, mode_t mode,
 				struct super_block *sb)
 {
 	static const struct dentry_operations cgroup_dops = {
@@ -1732,7 +1732,7 @@ static int cgroup_create_file(struct den
  * @mode: mode to set on new directory.
  */
 static int cgroup_create_dir(struct cgroup *cgrp, struct dentry *dentry,
-				int mode)
+				mode_t mode)
 {
 	struct dentry *parent;
 	int error = 0;
@@ -1750,6 +1750,33 @@ static int cgroup_create_dir(struct cgro
 	return error;
 }
 
+/**
+ * cgroup_file_mode - deduce file mode of a control file
+ * @cft: the control file in question
+ *
+ * returns cft->mode if ->mode is not 0
+ * returns S_IRUGO|S_IWUSR if it has both a read and a write handler
+ * returns S_IRUGO if it has only a read handler
+ * returns S_IWUSR if it has only a write hander
+ */
+static mode_t cgroup_file_mode(const struct cftype *cft)
+{
+	mode_t mode = 0;
+
+	if (cft->mode)
+		return cft->mode;
+
+	if (cft->read || cft->read_u64 || cft->read_s64 ||
+	    cft->read_map || cft->read_seq_string)
+		mode |= S_IRUGO;
+
+	if (cft->write || cft->write_u64 || cft->write_s64 ||
+	    cft->write_string || cft->trigger)
+		mode |= S_IWUSR;
+
+	return mode;
+}
+
 int cgroup_add_file(struct cgroup *cgrp,
 		       struct cgroup_subsys *subsys,
 		       const struct cftype *cft)
@@ -1757,6 +1784,7 @@ int cgroup_add_file(struct cgroup *cgrp,
 	struct dentry *dir = cgrp->dentry;
 	struct dentry *dentry;
 	int error;
+	mode_t mode;
 
 	char name[MAX_CGROUP_TYPE_NAMELEN + MAX_CFTYPE_NAME + 2] = { 0 };
 	if (subsys && !test_bit(ROOT_NOPREFIX, &cgrp->root->flags)) {
@@ -1767,7 +1795,8 @@ int cgroup_add_file(struct cgroup *cgrp,
 	BUG_ON(!mutex_is_locked(&dir->d_inode->i_mutex));
 	dentry = lookup_one_len(name, dir, strlen(name));
 	if (!IS_ERR(dentry)) {
-		error = cgroup_create_file(dentry, 0644 | S_IFREG,
+		mode = cgroup_file_mode(cft);
+		error = cgroup_create_file(dentry, mode | S_IFREG,
 						cgrp->root->sb);
 		if (!error)
 			dentry->d_fsdata = (void *)cft;
@@ -2349,6 +2378,7 @@ static struct cftype files[] = {
 		.write_u64 = cgroup_tasks_write,
 		.release = cgroup_tasks_release,
 		.private = FILE_TASKLIST,
+		.mode = S_IRUGO | S_IWUSR,
 	},
 
 	{
@@ -2449,7 +2479,7 @@ static void cgroup_unlock_hierarchy(stru
  * Must be called with the mutex on the parent inode held
  */
 static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
-			     int mode)
+			     mode_t mode)
 {
 	struct cgroup *cgrp;
 	struct cgroupfs_root *root = parent->root;
diff -puN kernel/cpuset.c~cgroups-show-correct-file-mode kernel/cpuset.c
--- a/kernel/cpuset.c~cgroups-show-correct-file-mode
+++ a/kernel/cpuset.c
@@ -1706,6 +1706,7 @@ static struct cftype files[] = {
 		.read_u64 = cpuset_read_u64,
 		.write_u64 = cpuset_write_u64,
 		.private = FILE_MEMORY_PRESSURE,
+		.mode = S_IRUGO,
 	},
 
 	{
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch
cls_cgroup-remove-unneeded-cgroup_lock.patch


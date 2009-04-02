From: akpm@linux-foundation.org
Subject: [folded] cgroups-show-correct-file-mode-fix.patch removed from -mm tree
Date: Thu, 02 Apr 2009 16:17:14 -0700
Message-ID: <200904022317.n32NHF7Z010040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50861 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758126AbZDBXUS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Apr 2009 19:20:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: show correct file mode, fix
has been removed from the -mm tree.  Its filename was
     cgroups-show-correct-file-mode-fix.patch

This patch was dropped because it was folded into cgroups-show-correct-file-mode.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: show correct file mode, fix
From: Li Zefan <lizf@cn.fujitsu.com>

- 'mode' should have type mode_t
- use S_IRUGO/S_IWUSR instead of 0444/0200

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    2 +-
 kernel/cgroup.c        |   24 ++++++++++++------------
 kernel/cpuset.c        |    2 +-
 3 files changed, 14 insertions(+), 14 deletions(-)

diff -puN include/linux/cgroup.h~cgroups-show-correct-file-mode-fix include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-show-correct-file-mode-fix
+++ a/include/linux/cgroup.h
@@ -262,7 +262,7 @@ struct cftype {
 	 * If not 0, file mode is set to this value, otherwise it will
 	 * be figured out automatically
 	 */
-	int mode;
+	mode_t mode;
 
 	/*
 	 * If non-zero, defines the maximum length of string that can
diff -puN kernel/cgroup.c~cgroups-show-correct-file-mode-fix kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-show-correct-file-mode-fix
+++ a/kernel/cgroup.c
@@ -1686,7 +1686,7 @@ static struct inode_operations cgroup_di
 	.rename = cgroup_rename,
 };
 
-static int cgroup_create_file(struct dentry *dentry, int mode,
+static int cgroup_create_file(struct dentry *dentry, mode_t mode,
 				struct super_block *sb)
 {
 	static struct dentry_operations cgroup_dops = {
@@ -1732,7 +1732,7 @@ static int cgroup_create_file(struct den
  * @mode: mode to set on new directory.
  */
 static int cgroup_create_dir(struct cgroup *cgrp, struct dentry *dentry,
-				int mode)
+				mode_t mode)
 {
 	struct dentry *parent;
 	int error = 0;
@@ -1755,24 +1755,24 @@ static int cgroup_create_dir(struct cgro
  * @cft: the control file in question
  *
  * returns cft->mode if ->mode is not 0
- * returns 0644 if it has both a read and a write handler
- * returns 0444 if it has only a read handler
- * returns 0200 if it has only a write hander
+ * returns S_IRUGO|S_IWUSR if it has both a read and a write handler
+ * returns S_IRUGO if it has only a read handler
+ * returns S_IWUSR if it has only a write hander
  */
-static int cgroup_file_mode(const struct cftype *cft)
+static mode_t cgroup_file_mode(const struct cftype *cft)
 {
-	int mode = 0;
+	mode_t mode = 0;
 
 	if (cft->mode)
 		return cft->mode;
 
 	if (cft->read || cft->read_u64 || cft->read_s64 ||
 	    cft->read_map || cft->read_seq_string)
-		mode |= 0444;
+		mode |= S_IRUGO;
 
 	if (cft->write || cft->write_u64 || cft->write_s64 ||
 	    cft->write_string || cft->trigger)
-		mode |= 0200;
+		mode |= S_IWUSR;
 
 	return mode;
 }
@@ -1784,7 +1784,7 @@ int cgroup_add_file(struct cgroup *cgrp,
 	struct dentry *dir = cgrp->dentry;
 	struct dentry *dentry;
 	int error;
-	int mode;
+	mode_t mode;
 
 	char name[MAX_CGROUP_TYPE_NAMELEN + MAX_CFTYPE_NAME + 2] = { 0 };
 	if (subsys && !test_bit(ROOT_NOPREFIX, &cgrp->root->flags)) {
@@ -2378,7 +2378,7 @@ static struct cftype files[] = {
 		.write_u64 = cgroup_tasks_write,
 		.release = cgroup_tasks_release,
 		.private = FILE_TASKLIST,
-		.mode = 0644,
+		.mode = S_IRUGO | S_IWUSR,
 	},
 
 	{
@@ -2479,7 +2479,7 @@ static void cgroup_unlock_hierarchy(stru
  * Must be called with the mutex on the parent inode held
  */
 static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
-			     int mode)
+			     mode_t mode)
 {
 	struct cgroup *cgrp;
 	struct cgroupfs_root *root = parent->root;
diff -puN kernel/cpuset.c~cgroups-show-correct-file-mode-fix kernel/cpuset.c
--- a/kernel/cpuset.c~cgroups-show-correct-file-mode-fix
+++ a/kernel/cpuset.c
@@ -1706,7 +1706,7 @@ static struct cftype files[] = {
 		.read_u64 = cpuset_read_u64,
 		.write_u64 = cpuset_write_u64,
 		.private = FILE_MEMORY_PRESSURE,
-		.mode = 0444,
+		.mode = S_IRUGO,
 	},
 
 	{
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups.patch
cgroup-css-id-support.patch
cgroup-fix-frequent-ebusy-at-rmdir.patch
cgroups-more-documentation-for-remount-and-release_agent.patch
cgroups-show-correct-file-mode.patch
cgroups-show-correct-file-mode-fix.patch
cgroups-dont-change-release_agent-when-remount-failed.patch
debug-cgroup-remove-unneeded-cgroup_lock.patch
devcgroup-avoid-using-cgroup_lock.patch
memcg-use-css-id.patch
memcg-hierarchical-stat.patch
memcg-fix-shrinking-memory-to-return-ebusy-by-fixing-retry-algorithm.patch
memcg-fix-oom-killer-under-memcg.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
memcg-charge-swapcache-to-proper-memcg.patch
cgroups-use-css-id-in-swap-cgroup-for-saving-memory-v5.patch
cgroups-use-css-id-in-swap-cgroup-for-saving-memory-v5-fix.patch
cpuset-fix-possible-races-in-cpu-memory-hotplug.patch
cgroups-add-data-field-to-struct-cgroup_scanner.patch
cpuset-rewrite-update_tasks_nodemask.patch
cpuset-avoid-changing-cpusets-mems-when-errno-returned.patch
cpuset-remove-struct-cpuset_hotplug_scanner.patch
cpusets-allow-cpusets-to-be-configured-built-on-non-smp-systems.patch
linux-next.patch
cls_cgroup-remove-unneeded-cgroup_lock.patch


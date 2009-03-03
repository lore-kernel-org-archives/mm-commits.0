From: akpm@linux-foundation.org
Subject: + cgroups-show-correct-file-mode.patch added to -mm tree
Date: Tue, 03 Mar 2009 12:27:42 -0800
Message-ID: <200903032027.n23KRgKv000544@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45638 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754510AbZCCU2P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Mar 2009 15:28:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com


The patch titled
     cgroups: show correct file mode
has been added to the -mm tree.  Its filename is
     cgroups-show-correct-file-mode.patch

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
 kernel/cgroup.c        |   32 +++++++++++++++++++++++++++++++-
 kernel/cpuset.c        |    1 +
 3 files changed, 37 insertions(+), 1 deletion(-)

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
+	int mode;
 
 	/*
 	 * If non-zero, defines the maximum length of string that can
diff -puN kernel/cgroup.c~cgroups-show-correct-file-mode kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-show-correct-file-mode
+++ a/kernel/cgroup.c
@@ -1750,6 +1750,33 @@ static int cgroup_create_dir(struct cgro
 	return error;
 }
 
+/**
+ * cgroup_file_mode - deduce file mode of a control file
+ * @cft: the control file in question
+ *
+ * returns cft->mode if ->mode is not 0
+ * returns 0644 if it has both a read and a write handler
+ * returns 0444 if it has only a read handler
+ * returns 0200 if it has only a write hander
+ */
+static int cgroup_file_mode(const struct cftype *cft)
+{
+	int mode = 0;
+
+	if (cft->mode)
+		return cft->mode;
+
+	if (cft->read || cft->read_u64 || cft->read_s64 ||
+	    cft->read_map || cft->read_seq_string)
+		mode |= 0444;
+
+	if (cft->write || cft->write_u64 || cft->write_s64 ||
+	    cft->write_string || cft->trigger)
+		mode |= 0200;
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
+	int mode;
 
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
+		.mode = 0644,
 	},
 
 	{
diff -puN kernel/cpuset.c~cgroups-show-correct-file-mode kernel/cpuset.c
--- a/kernel/cpuset.c~cgroups-show-correct-file-mode
+++ a/kernel/cpuset.c
@@ -1706,6 +1706,7 @@ static struct cftype files[] = {
 		.read_u64 = cpuset_read_u64,
 		.write_u64 = cpuset_write_u64,
 		.private = FILE_MEMORY_PRESSURE,
+		.mode = 0444,
 	},
 
 	{
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

linux-next.patch
vfs-add-missing-unlock-in-sget.patch
relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups.patch
cgroup-css-id-support.patch
cgroup-fix-frequent-ebusy-at-rmdir.patch
cgroups-more-documentation-for-remount-and-release_agent.patch
cgroups-show-correct-file-mode.patch
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
use-css-id-in-swap_cgroup-for-saving-memory-v4.patch
cpuset-fix-possible-races-in-cpu-memory-hotplug.patch
cgroups-add-data-field-to-struct-cgroup_scanner.patch
cpuset-rewrite-update_tasks_nodemask.patch
cpuset-avoid-changing-cpusets-mems-when-errno-returned.patch
cpuset-remove-struct-cpuset_hotplug_scanner.patch


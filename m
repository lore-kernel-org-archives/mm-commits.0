From: akpm@linux-foundation.org
Subject: - cgroup-files-move-the-release_agent-file-to-use-typed-handlers.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:58:14 -0700
Message-ID: <200807252258.m6PMwECK003269@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752799AbYGYW7R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:59:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, pj@sgi.com, serue@us.ibm.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     cgroup files: move the release_agent file to use typed handlers
has been removed from the -mm tree.  Its filename was
     cgroup-files-move-the-release_agent-file-to-use-typed-handlers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup files: move the release_agent file to use typed handlers
From: Paul Menage <menage@google.com>

Adds cgroup_release_agent_write() and cgroup_release_agent_show()
methods to handle writing/reading the path to a cgroup hierarchy's
release agent. As a result, cgroup_common_file_read() is now unnecessary.

As part of the change, a previously-tolerated race in
cgroup_release_agent() is avoided by copying the current
release_agent_path prior to calling call_usermode_helper().

Signed-off-by: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@in.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    2 
 kernel/cgroup.c        |  125 +++++++++++++++++----------------------
 2 files changed, 59 insertions(+), 68 deletions(-)

diff -puN include/linux/cgroup.h~cgroup-files-move-the-release_agent-file-to-use-typed-handlers include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroup-files-move-the-release_agent-file-to-use-typed-handlers
+++ a/include/linux/cgroup.h
@@ -295,6 +295,8 @@ int cgroup_add_files(struct cgroup *cgrp
 
 int cgroup_is_removed(const struct cgroup *cgrp);
 
+int cgroup_lock_live_group(struct cgroup *cgrp);
+
 int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen);
 
 int cgroup_task_count(const struct cgroup *cgrp);
diff -puN kernel/cgroup.c~cgroup-files-move-the-release_agent-file-to-use-typed-handlers kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-files-move-the-release_agent-file-to-use-typed-handlers
+++ a/kernel/cgroup.c
@@ -89,11 +89,7 @@ struct cgroupfs_root {
 	/* Hierarchy-specific flags */
 	unsigned long flags;
 
-	/* The path to use for release notifications. No locking
-	 * between setting and use - so if userspace updates this
-	 * while child cgroups exist, you could miss a
-	 * notification. We ensure that it's always a valid
-	 * NUL-terminated string */
+	/* The path to use for release notifications. */
 	char release_agent_path[PATH_MAX];
 };
 
@@ -1329,6 +1325,45 @@ enum cgroup_filetype {
 	FILE_RELEASE_AGENT,
 };
 
+/**
+ * cgroup_lock_live_group - take cgroup_mutex and check that cgrp is alive.
+ * @cgrp: the cgroup to be checked for liveness
+ *
+ * Returns true (with lock held) on success, or false (with no lock
+ * held) on failure.
+ */
+int cgroup_lock_live_group(struct cgroup *cgrp)
+{
+	mutex_lock(&cgroup_mutex);
+	if (cgroup_is_removed(cgrp)) {
+		mutex_unlock(&cgroup_mutex);
+		return false;
+	}
+	return true;
+}
+
+static int cgroup_release_agent_write(struct cgroup *cgrp, struct cftype *cft,
+				      const char *buffer)
+{
+	BUILD_BUG_ON(sizeof(cgrp->root->release_agent_path) < PATH_MAX);
+	if (!cgroup_lock_live_group(cgrp))
+		return -ENODEV;
+	strcpy(cgrp->root->release_agent_path, buffer);
+	mutex_unlock(&cgroup_mutex);
+	return 0;
+}
+
+static int cgroup_release_agent_show(struct cgroup *cgrp, struct cftype *cft,
+				     struct seq_file *seq)
+{
+	if (!cgroup_lock_live_group(cgrp))
+		return -ENODEV;
+	seq_puts(seq, cgrp->root->release_agent_path);
+	seq_putc(seq, '\n');
+	mutex_unlock(&cgroup_mutex);
+	return 0;
+}
+
 static ssize_t cgroup_write_X64(struct cgroup *cgrp, struct cftype *cft,
 				struct file *file,
 				const char __user *userbuf,
@@ -1443,10 +1478,6 @@ static ssize_t cgroup_common_file_write(
 		else
 			clear_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
 		break;
-	case FILE_RELEASE_AGENT:
-		BUILD_BUG_ON(sizeof(cgrp->root->release_agent_path) < PATH_MAX);
-		strcpy(cgrp->root->release_agent_path, buffer);
-		break;
 	default:
 		retval = -EINVAL;
 		goto out2;
@@ -1506,49 +1537,6 @@ static ssize_t cgroup_read_s64(struct cg
 	return simple_read_from_buffer(buf, nbytes, ppos, tmp, len);
 }
 
-static ssize_t cgroup_common_file_read(struct cgroup *cgrp,
-					  struct cftype *cft,
-					  struct file *file,
-					  char __user *buf,
-					  size_t nbytes, loff_t *ppos)
-{
-	enum cgroup_filetype type = cft->private;
-	char *page;
-	ssize_t retval = 0;
-	char *s;
-
-	if (!(page = (char *)__get_free_page(GFP_KERNEL)))
-		return -ENOMEM;
-
-	s = page;
-
-	switch (type) {
-	case FILE_RELEASE_AGENT:
-	{
-		struct cgroupfs_root *root;
-		size_t n;
-		mutex_lock(&cgroup_mutex);
-		root = cgrp->root;
-		n = strnlen(root->release_agent_path,
-			    sizeof(root->release_agent_path));
-		n = min(n, (size_t) PAGE_SIZE);
-		strncpy(s, root->release_agent_path, n);
-		mutex_unlock(&cgroup_mutex);
-		s += n;
-		break;
-	}
-	default:
-		retval = -EINVAL;
-		goto out;
-	}
-	*s++ = '\n';
-
-	retval = simple_read_from_buffer(buf, nbytes, ppos, page, s - page);
-out:
-	free_page((unsigned long)page);
-	return retval;
-}
-
 static ssize_t cgroup_file_read(struct file *file, char __user *buf,
 				   size_t nbytes, loff_t *ppos)
 {
@@ -1606,6 +1594,7 @@ int cgroup_seqfile_release(struct inode 
 
 static struct file_operations cgroup_seqfile_operations = {
 	.read = seq_read,
+	.write = cgroup_file_write,
 	.llseek = seq_lseek,
 	.release = cgroup_seqfile_release,
 };
@@ -2283,8 +2272,9 @@ static struct cftype files[] = {
 
 static struct cftype cft_release_agent = {
 	.name = "release_agent",
-	.read = cgroup_common_file_read,
-	.write = cgroup_common_file_write,
+	.read_seq_string = cgroup_release_agent_show,
+	.write_string = cgroup_release_agent_write,
+	.max_write_len = PATH_MAX,
 	.private = FILE_RELEASE_AGENT,
 };
 
@@ -3111,27 +3101,24 @@ static void cgroup_release_agent(struct 
 	while (!list_empty(&release_list)) {
 		char *argv[3], *envp[3];
 		int i;
-		char *pathbuf;
+		char *pathbuf = NULL, *agentbuf = NULL;
 		struct cgroup *cgrp = list_entry(release_list.next,
 						    struct cgroup,
 						    release_list);
 		list_del_init(&cgrp->release_list);
 		spin_unlock(&release_list_lock);
 		pathbuf = kmalloc(PAGE_SIZE, GFP_KERNEL);
-		if (!pathbuf) {
-			spin_lock(&release_list_lock);
-			continue;
-		}
-
-		if (cgroup_path(cgrp, pathbuf, PAGE_SIZE) < 0) {
-			kfree(pathbuf);
-			spin_lock(&release_list_lock);
-			continue;
-		}
+		if (!pathbuf)
+			goto continue_free;
+		if (cgroup_path(cgrp, pathbuf, PAGE_SIZE) < 0)
+			goto continue_free;
+		agentbuf = kstrdup(cgrp->root->release_agent_path, GFP_KERNEL);
+		if (!agentbuf)
+			goto continue_free;
 
 		i = 0;
-		argv[i++] = cgrp->root->release_agent_path;
-		argv[i++] = (char *)pathbuf;
+		argv[i++] = agentbuf;
+		argv[i++] = pathbuf;
 		argv[i] = NULL;
 
 		i = 0;
@@ -3145,8 +3132,10 @@ static void cgroup_release_agent(struct 
 		 * be a slow process */
 		mutex_unlock(&cgroup_mutex);
 		call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
-		kfree(pathbuf);
 		mutex_lock(&cgroup_mutex);
+ continue_free:
+		kfree(pathbuf);
+		kfree(agentbuf);
 		spin_lock(&release_list_lock);
 	}
 	spin_unlock(&release_list_lock);
_

Patches currently in -mm which might be from menage@google.com are

origin.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
make-cgroup_seqfile_release-static.patch
add-a-refcount-check-in-dput.patch


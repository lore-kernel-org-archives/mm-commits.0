From: akpm@linux-foundation.org
Subject: - cgroups-misc-cleanups-to-write_string-patchset.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:58:15 -0700
Message-ID: <200807252258.m6PMwF4M003272@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755426AbYGYXHQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:07:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, pj@sgi.com, serue@us.ibm.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     cgroups: misc cleanups to write_string patchset
has been removed from the -mm tree.  Its filename was
     cgroups-misc-cleanups-to-write_string-patchset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: misc cleanups to write_string patchset
From: Paul Menage <menage@google.com>

This patch contains cleanups suggested by reviewers for the recent
write_string() patchset:

- pair cgroup_lock_live_group() with cgroup_unlock() in cgroup.c for
  clarity, rather than directly unlocking cgroup_mutex.

- make the return type of cgroup_lock_live_group() a bool

- use a #define'd constant for the local buffer size in read/write functions

Signed-off-by: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@in.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    4 ++--
 kernel/cgroup.c        |   21 ++++++++++++---------
 2 files changed, 14 insertions(+), 11 deletions(-)

diff -puN include/linux/cgroup.h~cgroups-misc-cleanups-to-write_string-patchset include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-misc-cleanups-to-write_string-patchset
+++ a/include/linux/cgroup.h
@@ -21,11 +21,13 @@
 struct cgroupfs_root;
 struct cgroup_subsys;
 struct inode;
+struct cgroup;
 
 extern int cgroup_init_early(void);
 extern int cgroup_init(void);
 extern void cgroup_init_smp(void);
 extern void cgroup_lock(void);
+extern bool cgroup_lock_live_group(struct cgroup *cgrp);
 extern void cgroup_unlock(void);
 extern void cgroup_fork(struct task_struct *p);
 extern void cgroup_fork_callbacks(struct task_struct *p);
@@ -295,8 +297,6 @@ int cgroup_add_files(struct cgroup *cgrp
 
 int cgroup_is_removed(const struct cgroup *cgrp);
 
-int cgroup_lock_live_group(struct cgroup *cgrp);
-
 int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen);
 
 int cgroup_task_count(const struct cgroup *cgrp);
diff -puN kernel/cgroup.c~cgroups-misc-cleanups-to-write_string-patchset kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-misc-cleanups-to-write_string-patchset
+++ a/kernel/cgroup.c
@@ -1329,10 +1329,10 @@ enum cgroup_filetype {
  * cgroup_lock_live_group - take cgroup_mutex and check that cgrp is alive.
  * @cgrp: the cgroup to be checked for liveness
  *
- * Returns true (with lock held) on success, or false (with no lock
- * held) on failure.
+ * On success, returns true; the lock should be later released with
+ * cgroup_unlock(). On failure returns false with no lock held.
  */
-int cgroup_lock_live_group(struct cgroup *cgrp)
+bool cgroup_lock_live_group(struct cgroup *cgrp)
 {
 	mutex_lock(&cgroup_mutex);
 	if (cgroup_is_removed(cgrp)) {
@@ -1349,7 +1349,7 @@ static int cgroup_release_agent_write(st
 	if (!cgroup_lock_live_group(cgrp))
 		return -ENODEV;
 	strcpy(cgrp->root->release_agent_path, buffer);
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 	return 0;
 }
 
@@ -1360,16 +1360,19 @@ static int cgroup_release_agent_show(str
 		return -ENODEV;
 	seq_puts(seq, cgrp->root->release_agent_path);
 	seq_putc(seq, '\n');
-	mutex_unlock(&cgroup_mutex);
+	cgroup_unlock();
 	return 0;
 }
 
+/* A buffer size big enough for numbers or short strings */
+#define CGROUP_LOCAL_BUFFER_SIZE 64
+
 static ssize_t cgroup_write_X64(struct cgroup *cgrp, struct cftype *cft,
 				struct file *file,
 				const char __user *userbuf,
 				size_t nbytes, loff_t *unused_ppos)
 {
-	char buffer[64];
+	char buffer[CGROUP_LOCAL_BUFFER_SIZE];
 	int retval = 0;
 	char *end;
 
@@ -1403,7 +1406,7 @@ static ssize_t cgroup_write_string(struc
 				   const char __user *userbuf,
 				   size_t nbytes, loff_t *unused_ppos)
 {
-	char local_buffer[64];
+	char local_buffer[CGROUP_LOCAL_BUFFER_SIZE];
 	int retval = 0;
 	size_t max_bytes = cft->max_write_len;
 	char *buffer = local_buffer;
@@ -1518,7 +1521,7 @@ static ssize_t cgroup_read_u64(struct cg
 			       char __user *buf, size_t nbytes,
 			       loff_t *ppos)
 {
-	char tmp[64];
+	char tmp[CGROUP_LOCAL_BUFFER_SIZE];
 	u64 val = cft->read_u64(cgrp, cft);
 	int len = sprintf(tmp, "%llu\n", (unsigned long long) val);
 
@@ -1530,7 +1533,7 @@ static ssize_t cgroup_read_s64(struct cg
 			       char __user *buf, size_t nbytes,
 			       loff_t *ppos)
 {
-	char tmp[64];
+	char tmp[CGROUP_LOCAL_BUFFER_SIZE];
 	s64 val = cft->read_s64(cgrp, cft);
 	int len = sprintf(tmp, "%lld\n", (long long) val);
 
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


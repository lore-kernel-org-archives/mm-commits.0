From: akpm@linux-foundation.org
Subject: + cgroups-misc-cleanups-to-write_string-patchset.patch added to -mm tree
Date: Tue, 01 Jul 2008 16:21:27 -0700
Message-ID: <200807012321.m61NLR5v020219@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35578 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751537AbYGAXWC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 19:22:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, pj@sgi.com, serue@us.ibm.com, xemul@openvz.org


The patch titled
     cgroups: misc cleanups to write_string patchset
has been added to the -mm tree.  Its filename is
     cgroups-misc-cleanups-to-write_string-patchset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

cgroups-document-the-effect-of-attaching-pid-0-to-a-cgroup.patch
cgroups-document-the-effect-of-attaching-pid-0-to-a-cgroup-fix.patch
call_usermodehelper-increase-reliability.patch
cgroup-use-read-lock-to-guard-find_existing_css_set.patch
mark-res_counter_charge_locked-with-__must_check.patch
cgroup-list_for_each-cleanup-v2.patch
cgroup-anotate-two-variables-with-__read_mostly.patch
cgroup-files-clean-up-whitespace-in-struct-cftype.patch
cgroup-files-add-write_string-cgroup-control-file-method.patch
cgroup-files-move-the-release_agent-file-to-use-typed-handlers.patch
cgroups-misc-cleanups-to-write_string-patchset.patch
cgroup-files-move-notify_on_release-file-to-separate-write-handler.patch
cgroup-files-turn-attach_task_by_pid-directly-into-a-cgroup-write-handler.patch
cgroup-files-remove-cpuset_common_file_write.patch
cgroup-files-convert-devcgroup_access_write-into-a-cgroup-write_string-handler.patch
cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-checkpatch-fixes.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race.patch
memcg-handle-swap-cache.patch
memcg-handle-swap-cache-fix.patch
memcg-handle-swap-cache-fix-shmem-page-migration-incorrectness-on-memcgroup.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-setup-the-memrlimit-controller-cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler-memrlimitcgroup.patch
memrlimit-setup-the-memrlimit-controller-memrlimit-correct-mremap-and-move_vma-accounting.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-sleep-inside-sleeplock-in-mm_update_next_owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memrlimit-improve-fork-and-error-handling.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback-update.patch
cpusets-update-tasks-cpus_allowed-and-mems_allowed-after-cpu-node-offline-online.patch
workqueues-make-get_online_cpus-useable-for-work-func.patch
s390-topology-dont-use-kthread-for-arch_reinit_sched_domains.patch
make-cgroup_seqfile_release-static.patch
add-a-refcount-check-in-dput.patch


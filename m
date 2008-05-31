From: akpm@linux-foundation.org
Subject: - cgroup-files-remove-cpuset_common_file_write.patch removed from -mm tree
Date: Fri, 30 May 2008 17:14:02 -0700
Message-ID: <200805310014.m4V0E2Wk018703@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754344AbYEaARg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 20:17:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, balbir@in.ibm.com, lizf@cn.fujitsu.com, pj@sgi.com, rientjes@google.com, serue@us.ibm.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     cgroup files: remove cpuset_common_file_write()
has been removed from the -mm tree.  Its filename was
     cgroup-files-remove-cpuset_common_file_write.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup files: remove cpuset_common_file_write()
From: Paul Menage <menage@google.com>

This patch tweaks the signatures of the update_cpumask() and
update_nodemask() functions so that they can be called directly as
handlers for the new cgroups write_string() method.

This allows cpuset_common_file_write() to be removed.

Signed-off-by: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   74 ++++++----------------------------------------
 1 file changed, 10 insertions(+), 64 deletions(-)

diff -puN kernel/cpuset.c~cgroup-files-remove-cpuset_common_file_write kernel/cpuset.c
--- a/kernel/cpuset.c~cgroup-files-remove-cpuset_common_file_write
+++ a/kernel/cpuset.c
@@ -227,10 +227,6 @@ static struct cpuset top_cpuset = {
  * The task_struct fields mems_allowed and mems_generation may only
  * be accessed in the context of that task, so require no locks.
  *
- * The cpuset_common_file_write handler for operations that modify
- * the cpuset hierarchy holds cgroup_mutex across the entire operation,
- * single threading all such cpuset modifications across the system.
- *
  * The cpuset_common_file_read() handlers only hold callback_mutex across
  * small pieces of code, such as when reading out possibly multi-word
  * cpumasks and nodemasks.
@@ -770,8 +766,9 @@ static void cpuset_change_cpumask(struct
  * @cs: the cpuset to consider
  * @buf: buffer of cpu numbers written to this cpuset
  */
-static int update_cpumask(struct cpuset *cs, char *buf)
+static int update_cpumask(struct cgroup *cgrp, struct cftype *cft, char *buf)
 {
+	struct cpuset *cs = cgroup_cs(cgrp);
 	struct cpuset trialcs;
 	struct cgroup_scanner scan;
 	struct ptr_heap heap;
@@ -790,7 +787,6 @@ static int update_cpumask(struct cpuset 
 	 * that parsing.  The validate_change() call ensures that cpusets
 	 * with tasks have cpus.
 	 */
-	buf = strstrip(buf);
 	if (!*buf) {
 		cpus_clear(trialcs.cpus_allowed);
 	} else {
@@ -898,8 +894,9 @@ static void cpuset_migrate_mm(struct mm_
 
 static void *cpuset_being_rebound;
 
-static int update_nodemask(struct cpuset *cs, char *buf)
+static int update_nodemask(struct cgroup *cgrp, struct cftype *cft, char *buf)
 {
+	struct cpuset *cs = cgroup_cs(cgrp);
 	struct cpuset trialcs;
 	nodemask_t oldmem;
 	struct task_struct *p;
@@ -925,7 +922,6 @@ static int update_nodemask(struct cpuset
 	 * that parsing.  The validate_change() call ensures that cpusets
 	 * with tasks have memory.
 	 */
-	buf = strstrip(buf);
 	if (!*buf) {
 		nodes_clear(trialcs.mems_allowed);
 	} else {
@@ -1238,60 +1234,6 @@ typedef enum {
 	FILE_SPREAD_SLAB,
 } cpuset_filetype_t;
 
-static ssize_t cpuset_common_file_write(struct cgroup *cont,
-					struct cftype *cft,
-					struct file *file,
-					const char __user *userbuf,
-					size_t nbytes, loff_t *unused_ppos)
-{
-	struct cpuset *cs = cgroup_cs(cont);
-	cpuset_filetype_t type = cft->private;
-	char *buffer;
-	int retval = 0;
-
-	/* Crude upper limit on largest legitimate cpulist user might write. */
-	if (nbytes > 100U + 6 * max(NR_CPUS, MAX_NUMNODES))
-		return -E2BIG;
-
-	/* +1 for nul-terminator */
-	buffer = kmalloc(nbytes + 1, GFP_KERNEL);
-	if (!buffer)
-		return -ENOMEM;
-
-	if (copy_from_user(buffer, userbuf, nbytes)) {
-		retval = -EFAULT;
-		goto out1;
-	}
-	buffer[nbytes] = 0;	/* nul-terminate */
-
-	cgroup_lock();
-
-	if (cgroup_is_removed(cont)) {
-		retval = -ENODEV;
-		goto out2;
-	}
-
-	switch (type) {
-	case FILE_CPULIST:
-		retval = update_cpumask(cs, buffer);
-		break;
-	case FILE_MEMLIST:
-		retval = update_nodemask(cs, buffer);
-		break;
-	default:
-		retval = -EINVAL;
-		goto out2;
-	}
-
-	if (retval == 0)
-		retval = nbytes;
-out2:
-	cgroup_unlock();
-out1:
-	kfree(buffer);
-	return retval;
-}
-
 static int cpuset_write_u64(struct cgroup *cgrp, struct cftype *cft, u64 val)
 {
 	int retval = 0;
@@ -1486,14 +1428,18 @@ static struct cftype files[] = {
 	{
 		.name = "cpus",
 		.read = cpuset_common_file_read,
-		.write = cpuset_common_file_write,
+		.write_string = update_cpumask,
+		.max_write_len = (100U + 6 * NR_CPUS),
+		.lockmode = CFT_LOCK_CGL_WRITE,
 		.private = FILE_CPULIST,
 	},
 
 	{
 		.name = "mems",
 		.read = cpuset_common_file_read,
-		.write = cpuset_common_file_write,
+		.write_string = update_nodemask,
+		.max_write_len = (100U + 6 * MAX_NUMNODES),
+		.lockmode = CFT_LOCK_CGL_WRITE,
 		.private = FILE_MEMLIST,
 	},
 
_

Patches currently in -mm which might be from menage@google.com are

call_usermodehelper-increase-reliability.patch
cgroup-use-read-lock-to-guard-find_existing_css_set.patch
mark-res_counter_charge_locked-with-__must_check.patch
cgroup-dont-call-vfs_mkdir.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-handle-swap-cache.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
make-cgroup_seqfile_release-static.patch
add-a-refcount-check-in-dput.patch


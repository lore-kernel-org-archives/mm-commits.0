From: akpm@linux-foundation.org
Subject: + cgroup-files-remove-cpuset_common_file_write.patch added to -mm tree
Date: Tue, 24 Jun 2008 16:24:55 -0700
Message-ID: <200806242324.m5ONOtZA011655@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53691 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752726AbYFXXZn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jun 2008 19:25:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, pj@sgi.com, serue@us.ibm.com, xemul@openvz.org


The patch titled
     cgroup files: remove cpuset_common_file_write()
has been added to the -mm tree.  Its filename is
     cgroup-files-remove-cpuset_common_file_write.patch

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
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |  109 ++++++++++++++--------------------------------
 1 file changed, 35 insertions(+), 74 deletions(-)

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
@@ -770,7 +766,7 @@ static void cpuset_change_cpumask(struct
  * @cs: the cpuset to consider
  * @buf: buffer of cpu numbers written to this cpuset
  */
-static int update_cpumask(struct cpuset *cs, char *buf)
+static int update_cpumask(struct cpuset *cs, const char *buf)
 {
 	struct cpuset trialcs;
 	struct cgroup_scanner scan;
@@ -790,7 +786,6 @@ static int update_cpumask(struct cpuset 
 	 * that parsing.  The validate_change() call ensures that cpusets
 	 * with tasks have cpus.
 	 */
-	buf = strstrip(buf);
 	if (!*buf) {
 		cpus_clear(trialcs.cpus_allowed);
 	} else {
@@ -900,7 +895,7 @@ static void cpuset_migrate_mm(struct mm_
 
 static void *cpuset_being_rebound;
 
-static int update_nodemask(struct cpuset *cs, char *buf)
+static int update_nodemask(struct cpuset *cs, const char *buf)
 {
 	struct cpuset trialcs;
 	nodemask_t oldmem;
@@ -927,7 +922,6 @@ static int update_nodemask(struct cpuset
 	 * that parsing.  The validate_change() call ensures that cpusets
 	 * with tasks have memory.
 	 */
-	buf = strstrip(buf);
 	if (!*buf) {
 		nodes_clear(trialcs.mems_allowed);
 	} else {
@@ -1254,72 +1248,14 @@ typedef enum {
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
 	struct cpuset *cs = cgroup_cs(cgrp);
 	cpuset_filetype_t type = cft->private;
 
-	cgroup_lock();
-
-	if (cgroup_is_removed(cgrp)) {
-		cgroup_unlock();
+	if (!cgroup_lock_live_group(cgrp))
 		return -ENODEV;
-	}
 
 	switch (type) {
 	case FILE_CPU_EXCLUSIVE:
@@ -1365,12 +1301,9 @@ static int cpuset_write_s64(struct cgrou
 	struct cpuset *cs = cgroup_cs(cgrp);
 	cpuset_filetype_t type = cft->private;
 
-	cgroup_lock();
-
-	if (cgroup_is_removed(cgrp)) {
-		cgroup_unlock();
+	if (!cgroup_lock_live_group(cgrp))
 		return -ENODEV;
-	}
+
 	switch (type) {
 	case FILE_SCHED_RELAX_DOMAIN_LEVEL:
 		retval = update_relax_domain_level(cs, val);
@@ -1384,6 +1317,32 @@ static int cpuset_write_s64(struct cgrou
 }
 
 /*
+ * Common handling for a write to a "cpus" or "mems" file.
+ */
+static int cpuset_write_resmask(struct cgroup *cgrp, struct cftype *cft,
+				const char *buf)
+{
+	int retval = 0;
+
+	if (!cgroup_lock_live_group(cgrp))
+		return -ENODEV;
+
+	switch (cft->private) {
+	case FILE_CPULIST:
+		retval = update_cpumask(cgroup_cs(cgrp), buf);
+		break;
+	case FILE_MEMLIST:
+		retval = update_nodemask(cgroup_cs(cgrp), buf);
+		break;
+	default:
+		retval = -EINVAL;
+		break;
+	}
+	cgroup_unlock();
+	return retval;
+}
+
+/*
  * These ascii lists should be read in a single call, by using a user
  * buffer large enough to hold the entire map.  If read in smaller
  * chunks, there is no guarantee of atomicity.  Since the display format
@@ -1502,14 +1461,16 @@ static struct cftype files[] = {
 	{
 		.name = "cpus",
 		.read = cpuset_common_file_read,
-		.write = cpuset_common_file_write,
+		.write_string = cpuset_write_resmask,
+		.max_write_len = (100U + 6 * NR_CPUS),
 		.private = FILE_CPULIST,
 	},
 
 	{
 		.name = "mems",
 		.read = cpuset_common_file_read,
-		.write = cpuset_common_file_write,
+		.write_string = cpuset_write_resmask,
+		.max_write_len = (100U + 6 * MAX_NUMNODES),
 		.private = FILE_MEMLIST,
 	},
 
_

Patches currently in -mm which might be from menage@google.com are

call_usermodehelper-increase-reliability.patch
cgroup-use-read-lock-to-guard-find_existing_css_set.patch
mark-res_counter_charge_locked-with-__must_check.patch
cgroup-list_for_each-cleanup-v2.patch
cgroup-anotate-two-variables-with-__read_mostly.patch
cgroup-files-clean-up-whitespace-in-struct-cftype.patch
cgroup-files-add-write_string-cgroup-control-file-method.patch
cgroup-files-move-the-release_agent-file-to-use-typed-handlers.patch
cgroup-files-move-notify_on_release-file-to-separate-write-handler.patch
cgroup-files-turn-attach_task_by_pid-directly-into-a-cgroup-write-handler.patch
cgroup-files-remove-cpuset_common_file_write.patch
cgroup-files-convert-devcgroup_access_write-into-a-cgroup-write_string-handler.patch
cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
memcg-handle-swap-cache.patch
memcg-handle-swap-cache-fix.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-setup-the-memrlimit-controller-cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler-memrlimitcgroup.patch
cpusets-update-tasks-cpus_allowed-and-mems_allowed-after-cpu-node-offline-online.patch
make-cgroup_seqfile_release-static.patch
add-a-refcount-check-in-dput.patch


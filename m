From: akpm@linux-foundation.org
Subject: + cgroups-_s64-files-use-read_s64-write_s64-in-cfs-cgroup-for-rt_runtime-file.patch added to -mm tree
Date: Wed, 05 Mar 2008 16:24:26 -0800
Message-ID: <200803060024.m260OQYu031042@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754097AbYCFAYs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 19:24:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, a.p.zijlstra@chello.nl, mingo@elte.hu


The patch titled
     CGroups _s64 files: use read_s64/write_s64 in CFS cgroup for rt_runtime file
has been added to the -mm tree.  Its filename is
     cgroups-_s64-files-use-read_s64-write_s64-in-cfs-cgroup-for-rt_runtime-file.patch

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
Subject: CGroups _s64 files: use read_s64/write_s64 in CFS cgroup for rt_runtime file
From: Paul Menage <menage@google.com>

This removes some filesystem boilerplate from the CFS cgroup subsystem.

Signed-off-by: Paul Menage <menage@google.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   54 ++++++++---------------------------------------
 1 file changed, 10 insertions(+), 44 deletions(-)

diff -puN kernel/sched.c~cgroups-_s64-files-use-read_s64-write_s64-in-cfs-cgroup-for-rt_runtime-file kernel/sched.c
--- a/kernel/sched.c~cgroups-_s64-files-use-read_s64-write_s64-in-cfs-cgroup-for-rt_runtime-file
+++ a/kernel/sched.c
@@ -8116,49 +8116,15 @@ static u64 cpu_shares_read_u64(struct cg
 #endif
 
 #ifdef CONFIG_RT_GROUP_SCHED
-static ssize_t cpu_rt_runtime_write(struct cgroup *cgrp, struct cftype *cft,
-				struct file *file,
-				const char __user *userbuf,
-				size_t nbytes, loff_t *unused_ppos)
-{
-	char buffer[64];
-	int retval = 0;
-	s64 val;
-	char *end;
-
-	if (!nbytes)
-		return -EINVAL;
-	if (nbytes >= sizeof(buffer))
-		return -E2BIG;
-	if (copy_from_user(buffer, userbuf, nbytes))
-		return -EFAULT;
-
-	buffer[nbytes] = 0;     /* nul-terminate */
-
-	/* strip newline if necessary */
-	if (nbytes && (buffer[nbytes-1] == '\n'))
-		buffer[nbytes-1] = 0;
-	val = simple_strtoll(buffer, &end, 0);
-	if (*end)
-		return -EINVAL;
-
-	/* Pass to subsystem */
-	retval = sched_group_set_rt_runtime(cgroup_tg(cgrp), val);
-	if (!retval)
-		retval = nbytes;
-	return retval;
-}
-
-static ssize_t cpu_rt_runtime_read(struct cgroup *cgrp, struct cftype *cft,
-				   struct file *file,
-				   char __user *buf, size_t nbytes,
-				   loff_t *ppos)
-{
-	char tmp[64];
-	long val = sched_group_rt_runtime(cgroup_tg(cgrp));
-	int len = sprintf(tmp, "%ld\n", val);
+static int cpu_rt_runtime_write(struct cgroup *cgrp, struct cftype *cft,
+				s64 val)
+{
+	return sched_group_set_rt_runtime(cgroup_tg(cgrp), val);
+}
 
-	return simple_read_from_buffer(buf, nbytes, ppos, tmp, len);
+static s64 cpu_rt_runtime_read(struct cgroup *cgrp, struct cftype *cft)
+{
+	return sched_group_rt_runtime(cgroup_tg(cgrp));
 }
 
 static int cpu_rt_period_write_uint(struct cgroup *cgrp, struct cftype *cftype,
@@ -8184,8 +8150,8 @@ static struct cftype cpu_files[] = {
 #ifdef CONFIG_RT_GROUP_SCHED
 	{
 		.name = "rt_runtime_us",
-		.read = cpu_rt_runtime_read,
-		.write = cpu_rt_runtime_write,
+		.read_s64 = cpu_rt_runtime_read,
+		.write_s64 = cpu_rt_runtime_write,
 	},
 	{
 		.name = "rt_period_us",
_

Patches currently in -mm which might be from menage@google.com are

make-cgroup_enable_task_cg_lists-static.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
cgroup-api-files-add-res_counter_read_u64.patch
cgroup-api-files-use-read_u64-in-memory-controller.patch
cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroup-api-files-add-cgroup-map-data-type.patch
cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
cgroup-api-files-drop-mem_cgroup_force_empty.patch
cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
cgroup-api-files-make-cgroup_debug-default-to-off.patch
cgroups-_s64-files-add-cgroups-read_s64-write_s64-file-methods.patch
cgroups-_s64-files-use-read_s64-write_s64-in-cfs-cgroup-for-rt_runtime-file.patch
cpuset-hardwall-flag-switch-cpusets-to-use-the-bulk-cgroup_add_files-api.patch
cpuset-hardwall-flag-add-a-mem_hardwall-flag-to-cpusets.patch
add-a-refcount-check-in-dput.patch


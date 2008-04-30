From: akpm@linux-foundation.org
Subject: - cgroups-_s64-files-use-read_s64-write_s64-in-cfs-cgroup-for-rt_runtime-file.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:42:33 -0700
Message-ID: <200804300542.m3U5gXmi029156@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42728 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760649AbYD3GM0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, a.p.zijlstra@chello.nl, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     CGroups _s64 files: use read_s64/write_s64 in CFS cgroup for rt_runtime file
has been removed from the -mm tree.  Its filename was
     cgroups-_s64-files-use-read_s64-write_s64-in-cfs-cgroup-for-rt_runtime-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 kernel/sched.c |   52 ++++++++---------------------------------------
 1 file changed, 9 insertions(+), 43 deletions(-)

diff -puN kernel/sched.c~cgroups-_s64-files-use-read_s64-write_s64-in-cfs-cgroup-for-rt_runtime-file kernel/sched.c
--- a/kernel/sched.c~cgroups-_s64-files-use-read_s64-write_s64-in-cfs-cgroup-for-rt_runtime-file
+++ a/kernel/sched.c
@@ -9073,48 +9073,14 @@ static u64 cpu_shares_read_u64(struct cg
 
 #ifdef CONFIG_RT_GROUP_SCHED
 static ssize_t cpu_rt_runtime_write(struct cgroup *cgrp, struct cftype *cft,
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
@@ -9140,8 +9106,8 @@ static struct cftype cpu_files[] = {
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

origin.patch
disable-the-memory-controller-by-default-v3.patch
add-a-refcount-check-in-dput.patch


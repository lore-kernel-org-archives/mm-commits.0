From: akpm@linux-foundation.org
Subject: - cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:42:10 -0700
Message-ID: <200804300542.m3U5gABs029123@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52308 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757064AbYD3Fnb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:43:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, a.p.zijlstra@chello.nl, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, pj@sgi.com, xemul@openvz.org, yamamoto@valinux.co.jp, mm-commits@vge


The patch titled
     CGroup API files: rename read/write_uint methods to read_write_u64
has been removed from the -mm tree.  Its filename was
     cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: CGroup API files: rename read/write_uint methods to read_write_u64
From: Paul Menage <menage@google.com>

Several people have justifiably complained that the "_uint" suffix is
inappropriate for functions that handle u64 values, so this patch just renames
all these functions and their users to have the suffic _u64.

[peterz@infradead.org: build fix]
Signed-off-by: Paul Menage <menage@google.com>
Cc: "Li Zefan" <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    8 ++++----
 kernel/cgroup.c        |   32 ++++++++++++++++----------------
 kernel/cgroup_debug.c  |    8 ++++----
 kernel/sched.c         |   16 ++++++++--------
 4 files changed, 32 insertions(+), 32 deletions(-)

diff -puN include/linux/cgroup.h~cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64 include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64
+++ a/include/linux/cgroup.h
@@ -190,20 +190,20 @@ struct cftype {
 			 struct file *file,
 			 char __user *buf, size_t nbytes, loff_t *ppos);
 	/*
-	 * read_uint() is a shortcut for the common case of returning a
+	 * read_u64() is a shortcut for the common case of returning a
 	 * single integer. Use it in place of read()
 	 */
-	u64 (*read_uint) (struct cgroup *cgrp, struct cftype *cft);
+	u64 (*read_u64) (struct cgroup *cgrp, struct cftype *cft);
 	ssize_t (*write) (struct cgroup *cgrp, struct cftype *cft,
 			  struct file *file,
 			  const char __user *buf, size_t nbytes, loff_t *ppos);
 
 	/*
-	 * write_uint() is a shortcut for the common case of accepting
+	 * write_u64() is a shortcut for the common case of accepting
 	 * a single integer (as parsed by simple_strtoull) from
 	 * userspace. Use in place of write(); return 0 or error.
 	 */
-	int (*write_uint) (struct cgroup *cgrp, struct cftype *cft, u64 val);
+	int (*write_u64) (struct cgroup *cgrp, struct cftype *cft, u64 val);
 
 	int (*release) (struct inode *inode, struct file *file);
 };
diff -puN kernel/cgroup.c~cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64 kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64
+++ a/kernel/cgroup.c
@@ -1311,10 +1311,10 @@ enum cgroup_filetype {
 	FILE_RELEASE_AGENT,
 };
 
-static ssize_t cgroup_write_uint(struct cgroup *cgrp, struct cftype *cft,
-				 struct file *file,
-				 const char __user *userbuf,
-				 size_t nbytes, loff_t *unused_ppos)
+static ssize_t cgroup_write_u64(struct cgroup *cgrp, struct cftype *cft,
+				struct file *file,
+				const char __user *userbuf,
+				size_t nbytes, loff_t *unused_ppos)
 {
 	char buffer[64];
 	int retval = 0;
@@ -1338,7 +1338,7 @@ static ssize_t cgroup_write_uint(struct 
 		return -EINVAL;
 
 	/* Pass to subsystem */
-	retval = cft->write_uint(cgrp, cft, val);
+	retval = cft->write_u64(cgrp, cft, val);
 	if (!retval)
 		retval = nbytes;
 	return retval;
@@ -1419,18 +1419,18 @@ static ssize_t cgroup_file_write(struct 
 		return -ENODEV;
 	if (cft->write)
 		return cft->write(cgrp, cft, file, buf, nbytes, ppos);
-	if (cft->write_uint)
-		return cgroup_write_uint(cgrp, cft, file, buf, nbytes, ppos);
+	if (cft->write_u64)
+		return cgroup_write_u64(cgrp, cft, file, buf, nbytes, ppos);
 	return -EINVAL;
 }
 
-static ssize_t cgroup_read_uint(struct cgroup *cgrp, struct cftype *cft,
-				   struct file *file,
-				   char __user *buf, size_t nbytes,
-				   loff_t *ppos)
+static ssize_t cgroup_read_u64(struct cgroup *cgrp, struct cftype *cft,
+			       struct file *file,
+			       char __user *buf, size_t nbytes,
+			       loff_t *ppos)
 {
 	char tmp[64];
-	u64 val = cft->read_uint(cgrp, cft);
+	u64 val = cft->read_u64(cgrp, cft);
 	int len = sprintf(tmp, "%llu\n", (unsigned long long) val);
 
 	return simple_read_from_buffer(buf, nbytes, ppos, tmp, len);
@@ -1490,8 +1490,8 @@ static ssize_t cgroup_file_read(struct f
 
 	if (cft->read)
 		return cft->read(cgrp, cft, file, buf, nbytes, ppos);
-	if (cft->read_uint)
-		return cgroup_read_uint(cgrp, cft, file, buf, nbytes, ppos);
+	if (cft->read_u64)
+		return cgroup_read_u64(cgrp, cft, file, buf, nbytes, ppos);
 	return -EINVAL;
 }
 
@@ -2158,14 +2158,14 @@ static struct cftype files[] = {
 
 	{
 		.name = "notify_on_release",
-		.read_uint = cgroup_read_notify_on_release,
+		.read_u64 = cgroup_read_notify_on_release,
 		.write = cgroup_common_file_write,
 		.private = FILE_NOTIFY_ON_RELEASE,
 	},
 
 	{
 		.name = "releasable",
-		.read_uint = cgroup_read_releasable,
+		.read_u64 = cgroup_read_releasable,
 		.private = FILE_RELEASABLE,
 	}
 };
diff -puN kernel/cgroup_debug.c~cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64 kernel/cgroup_debug.c
--- a/kernel/cgroup_debug.c~cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64
+++ a/kernel/cgroup_debug.c
@@ -65,21 +65,21 @@ static u64 current_css_set_refcount_read
 static struct cftype files[] =  {
 	{
 		.name = "cgroup_refcount",
-		.read_uint = cgroup_refcount_read,
+		.read_u64 = cgroup_refcount_read,
 	},
 	{
 		.name = "taskcount",
-		.read_uint = taskcount_read,
+		.read_u64 = taskcount_read,
 	},
 
 	{
 		.name = "current_css_set",
-		.read_uint = current_css_set_read,
+		.read_u64 = current_css_set_read,
 	},
 
 	{
 		.name = "current_css_set_refcount",
-		.read_uint = current_css_set_refcount_read,
+		.read_u64 = current_css_set_refcount_read,
 	},
 };
 
diff -puN kernel/sched.c~cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64 kernel/sched.c
--- a/kernel/sched.c~cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64
+++ a/kernel/sched.c
@@ -9057,13 +9057,13 @@ cpu_cgroup_attach(struct cgroup_subsys *
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-static int cpu_shares_write_uint(struct cgroup *cgrp, struct cftype *cftype,
+static int cpu_shares_write_u64(struct cgroup *cgrp, struct cftype *cftype,
 				u64 shareval)
 {
 	return sched_group_set_shares(cgroup_tg(cgrp), shareval);
 }
 
-static u64 cpu_shares_read_uint(struct cgroup *cgrp, struct cftype *cft)
+static u64 cpu_shares_read_u64(struct cgroup *cgrp, struct cftype *cft)
 {
 	struct task_group *tg = cgroup_tg(cgrp);
 
@@ -9133,8 +9133,8 @@ static struct cftype cpu_files[] = {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	{
 		.name = "shares",
-		.read_uint = cpu_shares_read_uint,
-		.write_uint = cpu_shares_write_uint,
+		.read_u64 = cpu_shares_read_u64,
+		.write_u64 = cpu_shares_write_u64,
 	},
 #endif
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -9145,8 +9145,8 @@ static struct cftype cpu_files[] = {
 	},
 	{
 		.name = "rt_period_us",
-		.read_uint = cpu_rt_period_read_uint,
-		.write_uint = cpu_rt_period_write_uint,
+		.read_u64 = cpu_rt_period_read_uint,
+		.write_u64 = cpu_rt_period_write_uint,
 	},
 #endif
 };
@@ -9277,8 +9277,8 @@ out:
 static struct cftype files[] = {
 	{
 		.name = "usage",
-		.read_uint = cpuusage_read,
-		.write_uint = cpuusage_write,
+		.read_u64 = cpuusage_read,
+		.write_u64 = cpuusage_write,
 	},
 };
 
_

Patches currently in -mm which might be from menage@google.com are

origin.patch
disable-the-memory-controller-by-default-v3.patch
add-a-refcount-check-in-dput.patch


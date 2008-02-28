From: akpm@linux-foundation.org
Subject: + cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch added to -mm tree
Date: Wed, 27 Feb 2008 17:02:25 -0800
Message-ID: <200802280102.m1S12PoQ008133@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54278 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755812AbYB1BD3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 20:03:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, pj@sgi.com, xemul@openvz.org, yamamoto@valinux.co.jp


The patch titled
     CGroup API files: rename read/write_uint methods to read_write_u64
has been added to the -mm tree.  Its filename is
     cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch

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
Subject: CGroup API files: rename read/write_uint methods to read_write_u64
From: Paul Menage <menage@google.com>

Several people have justifiably complained that the "_uint" suffix is
inappropriate for functions that handle u64 values, so this patch just renames
all these functions and their users to have the suffic _u64.

Signed-off-by: Paul Menage <menage@google.com>
Cc: "Li Zefan" <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    8 ++++----
 kernel/cgroup.c        |   32 ++++++++++++++++----------------
 kernel/cgroup_debug.c  |    8 ++++----
 kernel/sched.c         |   18 +++++++++---------
 4 files changed, 33 insertions(+), 33 deletions(-)

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
@@ -1303,10 +1303,10 @@ enum cgroup_filetype {
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
@@ -1330,7 +1330,7 @@ static ssize_t cgroup_write_uint(struct 
 		return -EINVAL;
 
 	/* Pass to subsystem */
-	retval = cft->write_uint(cgrp, cft, val);
+	retval = cft->write_u64(cgrp, cft, val);
 	if (!retval)
 		retval = nbytes;
 	return retval;
@@ -1411,18 +1411,18 @@ static ssize_t cgroup_file_write(struct 
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
@@ -1482,8 +1482,8 @@ static ssize_t cgroup_file_read(struct f
 
 	if (cft->read)
 		return cft->read(cgrp, cft, file, buf, nbytes, ppos);
-	if (cft->read_uint)
-		return cgroup_read_uint(cgrp, cft, file, buf, nbytes, ppos);
+	if (cft->read_u64)
+		return cgroup_read_u64(cgrp, cft, file, buf, nbytes, ppos);
 	return -EINVAL;
 }
 
@@ -2145,14 +2145,14 @@ static struct cftype files[] = {
 
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
@@ -8290,13 +8290,13 @@ cpu_cgroup_attach(struct cgroup_subsys *
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
 
@@ -8350,13 +8350,13 @@ static ssize_t cpu_rt_runtime_read(struc
 	return simple_read_from_buffer(buf, nbytes, ppos, tmp, len);
 }
 
-static int cpu_rt_period_write_uint(struct cgroup *cgrp, struct cftype *cftype,
+static int cpu_rt_period_write_u64(struct cgroup *cgrp, struct cftype *cftype,
 		u64 rt_period_us)
 {
 	return sched_group_set_rt_period(cgroup_tg(cgrp), rt_period_us);
 }
 
-static u64 cpu_rt_period_read_uint(struct cgroup *cgrp, struct cftype *cft)
+static u64 cpu_rt_period_read_u64(struct cgroup *cgrp, struct cftype *cft)
 {
 	return sched_group_rt_period(cgroup_tg(cgrp));
 }
@@ -8366,8 +8366,8 @@ static struct cftype cpu_files[] = {
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
@@ -8378,8 +8378,8 @@ static struct cftype cpu_files[] = {
 	},
 	{
 		.name = "rt_period_us",
-		.read_uint = cpu_rt_period_read_uint,
-		.write_uint = cpu_rt_period_write_uint,
+		.read_u64 = cpu_rt_period_read_u64,
+		.write_u64 = cpu_rt_period_write_u64,
 	},
 #endif
 };
@@ -8487,7 +8487,7 @@ static u64 cpuusage_read(struct cgroup *
 static struct cftype files[] = {
 	{
 		.name = "usage",
-		.read_uint = cpuusage_read,
+		.read_u64 = cpuusage_read,
 	},
 };
 
_

Patches currently in -mm which might be from menage@google.com are

cgroup-fix-default-notify_on_release-setting.patch
memory-resource-controller-use-strstrip-while-parsing-arguments.patch
memory-controller-rename-to-memory-resource-controller.patch
make-cgroup_enable_task_cg_lists-static.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
cgroup-api-files-add-res_counter_read_u64.patch
cgroup-api-files-use-read_u64-in-memory-controller.patch
cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
cgroup-api-files-add-cgroup-map-data-type.patch
cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
cgroup-api-files-drop-mem_cgroup_force_empty.patch
cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
cgroup-api-files-make-cgroup_debug-default-to-off.patch
add-a-refcount-check-in-dput.patch

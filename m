From: akpm@linux-foundation.org
Subject: - cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:58:25 -0700
Message-ID: <200807252258.m6PMwP7a003290@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59678 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754116AbYGYW7R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:59:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, pj@sgi.com, serue@us.ibm.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     cgroup files: convert res_counter_write() to be a cgroups write_string() handler
has been removed from the -mm tree.  Its filename was
     cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup files: convert res_counter_write() to be a cgroups write_string() handler
From: Paul Menage <menage@google.com>

Currently res_counter_write() is a raw file handler even though it's
ultimately taking a number, since in some cases it wants to
pre-process the string when converting it to a number.

This patch converts res_counter_write() from a raw file handler to a
write_string() handler; this allows some of the boilerplate
copying/locking/checking to be removed, and simplies the cleanup path,
since these functions are now performed by the cgroups framework.

[lizf@cn.fujitsu.com: build fix]
Signed-off-by: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/res_counter.h |   11 +++++--
 kernel/res_counter.c        |   48 ++++++++++++++--------------------
 mm/memcontrol.c             |   24 +++--------------
 3 files changed, 34 insertions(+), 49 deletions(-)

diff -puN include/linux/res_counter.h~cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler include/linux/res_counter.h
--- a/include/linux/res_counter.h~cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler
+++ a/include/linux/res_counter.h
@@ -63,9 +63,14 @@ u64 res_counter_read_u64(struct res_coun
 ssize_t res_counter_read(struct res_counter *counter, int member,
 		const char __user *buf, size_t nbytes, loff_t *pos,
 		int (*read_strategy)(unsigned long long val, char *s));
-ssize_t res_counter_write(struct res_counter *counter, int member,
-		const char __user *buf, size_t nbytes, loff_t *pos,
-		int (*write_strategy)(char *buf, unsigned long long *val));
+
+typedef int (*write_strategy_fn)(const char *buf, unsigned long long *val);
+
+int res_counter_memparse_write_strategy(const char *buf,
+					unsigned long long *res);
+
+int res_counter_write(struct res_counter *counter, int member,
+		      const char *buffer, write_strategy_fn write_strategy);
 
 /*
  * the field descriptors. one for each member of res_counter
diff -puN kernel/res_counter.c~cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler kernel/res_counter.c
--- a/kernel/res_counter.c~cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler
+++ a/kernel/res_counter.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/res_counter.h>
 #include <linux/uaccess.h>
+#include <linux/mm.h>
 
 void res_counter_init(struct res_counter *counter)
 {
@@ -102,44 +103,37 @@ u64 res_counter_read_u64(struct res_coun
 	return *res_counter_member(counter, member);
 }
 
-ssize_t res_counter_write(struct res_counter *counter, int member,
-		const char __user *userbuf, size_t nbytes, loff_t *pos,
-		int (*write_strategy)(char *st_buf, unsigned long long *val))
+int res_counter_memparse_write_strategy(const char *buf,
+					unsigned long long *res)
 {
-	int ret;
-	char *buf, *end;
-	unsigned long flags;
-	unsigned long long tmp, *val;
+	char *end;
+	/* FIXME - make memparse() take const char* args */
+	*res = memparse((char *)buf, &end);
+	if (*end != '\0')
+		return -EINVAL;
 
-	buf = kmalloc(nbytes + 1, GFP_KERNEL);
-	ret = -ENOMEM;
-	if (buf == NULL)
-		goto out;
-
-	buf[nbytes] = '\0';
-	ret = -EFAULT;
-	if (copy_from_user(buf, userbuf, nbytes))
-		goto out_free;
+	*res = PAGE_ALIGN(*res);
+	return 0;
+}
 
-	ret = -EINVAL;
+int res_counter_write(struct res_counter *counter, int member,
+		      const char *buf, write_strategy_fn write_strategy)
+{
+	char *end;
+	unsigned long flags;
+	unsigned long long tmp, *val;
 
-	strstrip(buf);
 	if (write_strategy) {
-		if (write_strategy(buf, &tmp)) {
-			goto out_free;
-		}
+		if (write_strategy(buf, &tmp))
+			return -EINVAL;
 	} else {
 		tmp = simple_strtoull(buf, &end, 10);
 		if (*end != '\0')
-			goto out_free;
+			return -EINVAL;
 	}
 	spin_lock_irqsave(&counter->lock, flags);
 	val = res_counter_member(counter, member);
 	*val = tmp;
 	spin_unlock_irqrestore(&counter->lock, flags);
-	ret = nbytes;
-out_free:
-	kfree(buf);
-out:
-	return ret;
+	return 0;
 }
diff -puN mm/memcontrol.c~cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler mm/memcontrol.c
--- a/mm/memcontrol.c~cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler
+++ a/mm/memcontrol.c
@@ -838,32 +838,18 @@ out:
 	return ret;
 }
 
-static int mem_cgroup_write_strategy(char *buf, unsigned long long *tmp)
-{
-	*tmp = memparse(buf, &buf);
-	if (*buf != '\0')
-		return -EINVAL;
-
-	/*
-	 * Round up the value to the closest page size
-	 */
-	*tmp = ((*tmp + PAGE_SIZE - 1) >> PAGE_SHIFT) << PAGE_SHIFT;
-	return 0;
-}
-
 static u64 mem_cgroup_read(struct cgroup *cont, struct cftype *cft)
 {
 	return res_counter_read_u64(&mem_cgroup_from_cont(cont)->res,
 				    cft->private);
 }
 
-static ssize_t mem_cgroup_write(struct cgroup *cont, struct cftype *cft,
-				struct file *file, const char __user *userbuf,
-				size_t nbytes, loff_t *ppos)
+static int mem_cgroup_write(struct cgroup *cont, struct cftype *cft,
+			    const char *buffer)
 {
 	return res_counter_write(&mem_cgroup_from_cont(cont)->res,
-				cft->private, userbuf, nbytes, ppos,
-				mem_cgroup_write_strategy);
+				 cft->private, buffer,
+				 res_counter_memparse_write_strategy);
 }
 
 static int mem_cgroup_reset(struct cgroup *cont, unsigned int event)
@@ -940,7 +926,7 @@ static struct cftype mem_cgroup_files[] 
 	{
 		.name = "limit_in_bytes",
 		.private = RES_LIMIT,
-		.write = mem_cgroup_write,
+		.write_string = mem_cgroup_write,
 		.read_u64 = mem_cgroup_read,
 	},
 	{
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


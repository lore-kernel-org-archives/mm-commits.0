From: akpm@linux-foundation.org
Subject: + cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler.patch added to -mm tree
Date: Tue, 24 Jun 2008 16:24:59 -0700
Message-ID: <200806242325.m5ONP0Mn011663@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751097AbYFXXcT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jun 2008 19:32:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, pj@sgi.com, serue@us.ibm.com, xemul@openvz.org


The patch titled
     cgroup files: convert res_counter_write() to be a cgroups write_string() handler
has been added to the -mm tree.  Its filename is
     cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler.patch

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
Subject: cgroup files: convert res_counter_write() to be a cgroups write_string() handler
From: Paul Menage <menage@google.com>

Currently read_counter_write() is a raw file handler even though it's
ultimately taking a number, since in some cases it wants to
pre-process the string when converting it to a number.

This patch converts res_counter_write() from a raw file handler to a
write_string() handler; this allows some of the boilerplate
copying/locking/checking to be removed, and simplies the cleanup path,
since these functions are now performed by the cgroups framework.

Signed-off-by: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/res_counter.h |   11 +++++--
 kernel/res_counter.c        |   47 ++++++++++++++--------------------
 mm/memcontrol.c             |   24 +++--------------
 3 files changed, 33 insertions(+), 49 deletions(-)

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
@@ -102,44 +102,37 @@ u64 res_counter_read_u64(struct res_coun
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


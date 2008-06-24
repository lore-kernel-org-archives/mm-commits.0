From: akpm@linux-foundation.org
Subject: + cgroup-files-convert-devcgroup_access_write-into-a-cgroup-write_string-handler.patch added to -mm tree
Date: Tue, 24 Jun 2008 16:24:57 -0700
Message-ID: <200806242324.m5ONOvqo011660@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56767 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753233AbYFXXZt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jun 2008 19:25:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, pj@sgi.com, serue@us.ibm.com, xemul@openvz.org


The patch titled
     cgroup files: convert devcgroup_access_write() into a cgroup write_string() handler
has been added to the -mm tree.  Its filename is
     cgroup-files-convert-devcgroup_access_write-into-a-cgroup-write_string-handler.patch

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
Subject: cgroup files: convert devcgroup_access_write() into a cgroup write_string() handler
From: Paul Menage <menage@google.com>

This patch converts devcgroup_access_write() from a raw file handler
into a handler for the cgroup write_string() method. This allows some
boilerplate copying/locking/checking to be removed and simplifies the
cleanup path, since these functions are performed by the cgroups
framework before calling the handler.

Signed-off-by: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@in.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/device_cgroup.c |  103 ++++++++++++++-----------------------
 1 file changed, 39 insertions(+), 64 deletions(-)

diff -puN security/device_cgroup.c~cgroup-files-convert-devcgroup_access_write-into-a-cgroup-write_string-handler security/device_cgroup.c
--- a/security/device_cgroup.c~cgroup-files-convert-devcgroup_access_write-into-a-cgroup-write_string-handler
+++ a/security/device_cgroup.c
@@ -59,6 +59,11 @@ static inline struct dev_cgroup *cgroup_
 	return css_to_devcgroup(cgroup_subsys_state(cgroup, devices_subsys_id));
 }
 
+static inline struct dev_cgroup *task_devcgroup(struct task_struct *task)
+{
+	return css_to_devcgroup(task_subsys_state(task, devices_subsys_id));
+}
+
 struct cgroup_subsys devices_subsys;
 
 static int devcgroup_can_attach(struct cgroup_subsys *ss,
@@ -312,10 +317,10 @@ static int may_access_whitelist(struct d
  * when adding a new allow rule to a device whitelist, the rule
  * must be allowed in the parent device
  */
-static int parent_has_perm(struct cgroup *childcg,
+static int parent_has_perm(struct dev_cgroup *childcg,
 				  struct dev_whitelist_item *wh)
 {
-	struct cgroup *pcg = childcg->parent;
+	struct cgroup *pcg = childcg->css.cgroup->parent;
 	struct dev_cgroup *parent;
 	int ret;
 
@@ -341,39 +346,18 @@ static int parent_has_perm(struct cgroup
  * new access is only allowed if you're in the top-level cgroup, or your
  * parent cgroup has the access you're asking for.
  */
-static ssize_t devcgroup_access_write(struct cgroup *cgroup, struct cftype *cft,
-				struct file *file, const char __user *userbuf,
-				size_t nbytes, loff_t *ppos)
-{
-	struct cgroup *cur_cgroup;
-	struct dev_cgroup *devcgroup, *cur_devcgroup;
-	int filetype = cft->private;
-	char *buffer, *b;
+static int devcgroup_update_access(struct dev_cgroup *devcgroup,
+				   int filetype, const char *buffer)
+{
+	struct dev_cgroup *cur_devcgroup;
+	const char *b;
 	int retval = 0, count;
 	struct dev_whitelist_item wh;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	devcgroup = cgroup_to_devcgroup(cgroup);
-	cur_cgroup = task_cgroup(current, devices_subsys.subsys_id);
-	cur_devcgroup = cgroup_to_devcgroup(cur_cgroup);
-
-	buffer = kmalloc(nbytes+1, GFP_KERNEL);
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
-	if (cgroup_is_removed(cgroup)) {
-		retval = -ENODEV;
-		goto out2;
-	}
+	cur_devcgroup = task_devcgroup(current);
 
 	memset(&wh, 0, sizeof(wh));
 	b = buffer;
@@ -390,14 +374,11 @@ static ssize_t devcgroup_access_write(st
 		wh.type = DEV_CHAR;
 		break;
 	default:
-		retval = -EINVAL;
-		goto out2;
+		return -EINVAL;
 	}
 	b++;
-	if (!isspace(*b)) {
-		retval = -EINVAL;
-		goto out2;
-	}
+	if (!isspace(*b))
+		return -EINVAL;
 	b++;
 	if (*b == '*') {
 		wh.major = ~0;
@@ -409,13 +390,10 @@ static ssize_t devcgroup_access_write(st
 			b++;
 		}
 	} else {
-		retval = -EINVAL;
-		goto out2;
-	}
-	if (*b != ':') {
-		retval = -EINVAL;
-		goto out2;
+		return -EINVAL;
 	}
+	if (*b != ':')
+		return -EINVAL;
 	b++;
 
 	/* read minor */
@@ -429,13 +407,10 @@ static ssize_t devcgroup_access_write(st
 			b++;
 		}
 	} else {
-		retval = -EINVAL;
-		goto out2;
-	}
-	if (!isspace(*b)) {
-		retval = -EINVAL;
-		goto out2;
+		return -EINVAL;
 	}
+	if (!isspace(*b))
+		return -EINVAL;
 	for (b++, count = 0; count < 3; count++, b++) {
 		switch (*b) {
 		case 'r':
@@ -452,8 +427,7 @@ static ssize_t devcgroup_access_write(st
 			count = 3;
 			break;
 		default:
-			retval = -EINVAL;
-			goto out2;
+			return -EINVAL;
 		}
 	}
 
@@ -461,38 +435,39 @@ handle:
 	retval = 0;
 	switch (filetype) {
 	case DEVCG_ALLOW:
-		if (!parent_has_perm(cgroup, &wh))
-			retval = -EPERM;
-		else
-			retval = dev_whitelist_add(devcgroup, &wh);
-		break;
+		if (!parent_has_perm(devcgroup, &wh))
+			return -EPERM;
+		return dev_whitelist_add(devcgroup, &wh);
 	case DEVCG_DENY:
 		dev_whitelist_rm(devcgroup, &wh);
 		break;
 	default:
-		retval = -EINVAL;
-		goto out2;
+		return -EINVAL;
 	}
+	return 0;
+}
 
-	if (retval == 0)
-		retval = nbytes;
-
-out2:
+static int devcgroup_access_write(struct cgroup *cgrp, struct cftype *cft,
+				  const char *buffer)
+{
+	int retval;
+	if (!cgroup_lock_live_group(cgrp))
+		return -ENODEV;
+	retval = devcgroup_update_access(cgroup_to_devcgroup(cgrp),
+					 cft->private, buffer);
 	cgroup_unlock();
-out1:
-	kfree(buffer);
 	return retval;
 }
 
 static struct cftype dev_cgroup_files[] = {
 	{
 		.name = "allow",
-		.write  = devcgroup_access_write,
+		.write_string  = devcgroup_access_write,
 		.private = DEVCG_ALLOW,
 	},
 	{
 		.name = "deny",
-		.write = devcgroup_access_write,
+		.write_string = devcgroup_access_write,
 		.private = DEVCG_DENY,
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


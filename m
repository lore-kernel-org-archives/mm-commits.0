From: akpm@linux-foundation.org
Subject: - cgroup-files-convert-devcgroup_access_write-into-a-cgroup-write_string-handler.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:58:23 -0700
Message-ID: <200807252258.m6PMwNwd003285@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41903 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754703AbYGYW7U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:59:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, pj@sgi.com, serue@us.ibm.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     cgroup files: convert devcgroup_access_write() into a cgroup write_string() handler
has been removed from the -mm tree.  Its filename was
     cgroup-files-convert-devcgroup_access_write-into-a-cgroup-write_string-handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -392,14 +376,11 @@ static ssize_t devcgroup_access_write(st
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
@@ -411,13 +392,10 @@ static ssize_t devcgroup_access_write(st
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
@@ -431,13 +409,10 @@ static ssize_t devcgroup_access_write(st
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
@@ -454,8 +429,7 @@ static ssize_t devcgroup_access_write(st
 			count = 3;
 			break;
 		default:
-			retval = -EINVAL;
-			goto out2;
+			return -EINVAL;
 		}
 	}
 
@@ -463,38 +437,39 @@ handle:
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


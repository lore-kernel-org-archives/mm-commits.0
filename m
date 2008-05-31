From: akpm@linux-foundation.org
Subject: - cgroup-files-convert-devcgroup_access_write-into-a-cgroup-write_string-handler.patch removed from -mm tree
Date: Fri, 30 May 2008 17:14:05 -0700
Message-ID: <200805310014.m4V0E5bX018706@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753796AbYEaAQP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 20:16:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, balbir@in.ibm.com, lizf@cn.fujitsu.com, pj@sgi.com, rientjes@google.com, serue@us.ibm.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     cgroup files: convert devcgroup_access_write() into a cgroup write_string() handler
has been removed from the -mm tree.  Its filename was
     cgroup-files-convert-devcgroup_access_write-into-a-cgroup-write_string-handler.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup files: convert devcgroup_access_write() into a cgroup write_string() handler
From: Paul Menage <menage@google.com>

This patch converts devcgroup_access_write() from a raw file handler into
a handler for the cgroup write_string() method.  This allows some
boilerplate copying/locking/checking to be removed and simplifies the
cleanup path, since these functions are performed by the cgroups framework
before calling the handler.

Signed-off-by: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/device_cgroup.c |   79 ++++++++++---------------------------
 1 file changed, 22 insertions(+), 57 deletions(-)

diff -puN security/device_cgroup.c~cgroup-files-convert-devcgroup_access_write-into-a-cgroup-write_string-handler security/device_cgroup.c
--- a/security/device_cgroup.c~cgroup-files-convert-devcgroup_access_write-into-a-cgroup-write_string-handler
+++ a/security/device_cgroup.c
@@ -323,14 +323,14 @@ static int parent_has_perm(struct cgroup
  * new access is only allowed if you're in the top-level cgroup, or your
  * parent cgroup has the access you're asking for.
  */
-static ssize_t devcgroup_access_write(struct cgroup *cgroup, struct cftype *cft,
-				struct file *file, const char __user *userbuf,
-				size_t nbytes, loff_t *ppos)
+static int devcgroup_access_write(struct cgroup *cgroup,
+				  struct cftype *cft,
+				  char *buffer)
 {
 	struct cgroup *cur_cgroup;
 	struct dev_cgroup *devcgroup, *cur_devcgroup;
 	int filetype = cft->private;
-	char *buffer, *b;
+	char *b;
 	int retval = 0, count;
 	struct dev_whitelist_item wh;
 
@@ -341,22 +341,6 @@ static ssize_t devcgroup_access_write(st
 	cur_cgroup = task_cgroup(current, devices_subsys.subsys_id);
 	cur_devcgroup = cgroup_to_devcgroup(cur_cgroup);
 
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
-
 	memset(&wh, 0, sizeof(wh));
 	b = buffer;
 
@@ -372,14 +356,11 @@ static ssize_t devcgroup_access_write(st
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
@@ -391,13 +372,10 @@ static ssize_t devcgroup_access_write(st
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
@@ -411,13 +389,10 @@ static ssize_t devcgroup_access_write(st
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
@@ -434,8 +409,7 @@ static ssize_t devcgroup_access_write(st
 			count = 3;
 			break;
 		default:
-			retval = -EINVAL;
-			goto out2;
+			return -EINVAL;
 		}
 	}
 
@@ -444,38 +418,29 @@ handle:
 	switch (filetype) {
 	case DEVCG_ALLOW:
 		if (!parent_has_perm(cgroup, &wh))
-			retval = -EPERM;
-		else
-			retval = dev_whitelist_add(devcgroup, &wh);
-		break;
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
-
-	if (retval == 0)
-		retval = nbytes;
-
-out2:
-	cgroup_unlock();
-out1:
-	kfree(buffer);
-	return retval;
+	return 0;
 }
 
 static struct cftype dev_cgroup_files[] = {
 	{
 		.name = "allow",
-		.write  = devcgroup_access_write,
+		.write_string  = devcgroup_access_write,
 		.private = DEVCG_ALLOW,
+		.lockmode = CFT_LOCK_CGL_WRITE,
 	},
 	{
 		.name = "deny",
-		.write = devcgroup_access_write,
+		.write_string = devcgroup_access_write,
 		.private = DEVCG_DENY,
+		.lockmode = CFT_LOCK_CGL_WRITE,
 	},
 	{
 		.name = "list",
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


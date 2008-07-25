From: akpm@linux-foundation.org
Subject: - cgroup-files-add-write_string-cgroup-control-file-method.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:58:11 -0700
Message-ID: <200807252258.m6PMwBxZ003266@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754881AbYGYXHL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:07:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, pj@sgi.com, serue@us.ibm.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     cgroup files: add write_string cgroup control file method
has been removed from the -mm tree.  Its filename was
     cgroup-files-add-write_string-cgroup-control-file-method.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup files: add write_string cgroup control file method
From: Paul Menage <menage@google.com>

This patch adds a write_string() method for cgroups control files. The
semantics are that a buffer is copied from userspace to kernelspace
and the handler function invoked on that buffer.  The buffer is
guaranteed to be nul-terminated, and no longer than max_write_len
(defaulting to 64 bytes if unspecified). Later patches will convert
existing raw file write handlers in control group subsystems to use
this method.

Signed-off-by: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Balbir Singh <balbir@in.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |   14 ++++++++++++++
 kernel/cgroup.c        |   35 +++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff -puN include/linux/cgroup.h~cgroup-files-add-write_string-cgroup-control-file-method include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroup-files-add-write_string-cgroup-control-file-method
+++ a/include/linux/cgroup.h
@@ -205,6 +205,13 @@ struct cftype {
 	 * subsystem, followed by a period */
 	char name[MAX_CFTYPE_NAME];
 	int private;
+
+	/*
+	 * If non-zero, defines the maximum length of string that can
+	 * be passed to write_string; defaults to 64
+	 */
+	size_t max_write_len;
+
 	int (*open)(struct inode *inode, struct file *file);
 	ssize_t (*read)(struct cgroup *cgrp, struct cftype *cft,
 			struct file *file,
@@ -249,6 +256,13 @@ struct cftype {
 	int (*write_s64)(struct cgroup *cgrp, struct cftype *cft, s64 val);
 
 	/*
+	 * write_string() is passed a nul-terminated kernelspace
+	 * buffer of maximum length determined by max_write_len.
+	 * Returns 0 or -ve error code.
+	 */
+	int (*write_string)(struct cgroup *cgrp, struct cftype *cft,
+			    const char *buffer);
+	/*
 	 * trigger() callback can be used to get some kick from the
 	 * userspace, when the actual string written is not important
 	 * at all. The private field can be used to determine the
diff -puN kernel/cgroup.c~cgroup-files-add-write_string-cgroup-control-file-method kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-files-add-write_string-cgroup-control-file-method
+++ a/kernel/cgroup.c
@@ -1363,6 +1363,39 @@ static ssize_t cgroup_write_X64(struct c
 	return retval;
 }
 
+static ssize_t cgroup_write_string(struct cgroup *cgrp, struct cftype *cft,
+				   struct file *file,
+				   const char __user *userbuf,
+				   size_t nbytes, loff_t *unused_ppos)
+{
+	char local_buffer[64];
+	int retval = 0;
+	size_t max_bytes = cft->max_write_len;
+	char *buffer = local_buffer;
+
+	if (!max_bytes)
+		max_bytes = sizeof(local_buffer) - 1;
+	if (nbytes >= max_bytes)
+		return -E2BIG;
+	/* Allocate a dynamic buffer if we need one */
+	if (nbytes >= sizeof(local_buffer)) {
+		buffer = kmalloc(nbytes + 1, GFP_KERNEL);
+		if (buffer == NULL)
+			return -ENOMEM;
+	}
+	if (nbytes && copy_from_user(buffer, userbuf, nbytes))
+		return -EFAULT;
+
+	buffer[nbytes] = 0;     /* nul-terminate */
+	strstrip(buffer);
+	retval = cft->write_string(cgrp, cft, buffer);
+	if (!retval)
+		retval = nbytes;
+	if (buffer != local_buffer)
+		kfree(buffer);
+	return retval;
+}
+
 static ssize_t cgroup_common_file_write(struct cgroup *cgrp,
 					   struct cftype *cft,
 					   struct file *file,
@@ -1440,6 +1473,8 @@ static ssize_t cgroup_file_write(struct 
 		return cft->write(cgrp, cft, file, buf, nbytes, ppos);
 	if (cft->write_u64 || cft->write_s64)
 		return cgroup_write_X64(cgrp, cft, file, buf, nbytes, ppos);
+	if (cft->write_string)
+		return cgroup_write_string(cgrp, cft, file, buf, nbytes, ppos);
 	if (cft->trigger) {
 		int ret = cft->trigger(cgrp, (unsigned int)cft->private);
 		return ret ? ret : nbytes;
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


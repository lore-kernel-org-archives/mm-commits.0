From: akpm@linux-foundation.org
Subject: + cgroup-files-add-write_string-cgroup-control-file-method.patch added to -mm tree
Date: Tue, 24 Jun 2008 16:24:46 -0700
Message-ID: <200806242324.m5ONOl3o011638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753227AbYFXX0A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jun 2008 19:26:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, pj@sgi.com, serue@us.ibm.com, xemul@openvz.org


The patch titled
     cgroup files: add write_string cgroup control file method
has been added to the -mm tree.  Its filename is
     cgroup-files-add-write_string-cgroup-control-file-method.patch

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


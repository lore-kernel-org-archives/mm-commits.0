From: akpm@linux-foundation.org
Subject: - cgroup-files-add-a-cgroup-write_string-control-file-method.patch removed from -mm tree
Date: Fri, 30 May 2008 17:13:50 -0700
Message-ID: <200805310013.m4V0Do4u018685@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35530 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754593AbYEaAZQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 20:25:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, balbir@in.ibm.com, lizf@cn.fujitsu.com, pj@sgi.com, rientjes@google.com, serue@us.ibm.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     cgroup files: add a cgroup write_string control file method
has been removed from the -mm tree.  Its filename was
     cgroup-files-add-a-cgroup-write_string-control-file-method.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup files: add a cgroup write_string control file method
From: Paul Menage <menage@google.com>

This patch adds a write_string() method for cgroups control files.  The
semantics are that a buffer is copied from userspace to kernelspace and
the handler function invoked on that buffer.  Any control group locking is
done after the copy from userspace has occurred.  The buffer is guaranteed
to be nul-terminated, and no longer than max_write_len (defaulting to 64
bytes if unspecified).  Later patches will convert existing raw file write
handlers in control group subsystems to use this method.

Signed-off-by: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |   10 ++++++++++
 kernel/cgroup.c        |    5 ++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff -puN include/linux/cgroup.h~cgroup-files-add-a-cgroup-write_string-control-file-method include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroup-files-add-a-cgroup-write_string-control-file-method
+++ a/include/linux/cgroup.h
@@ -281,6 +281,10 @@ struct cftype {
 	 */
 	int lockmode;
 
+	/* If non-zero, defines the maximum length of string that can
+	 * be passed to write_string; defaults to 64 */
+	int max_write_len;
+
 	int (*open) (struct inode *inode, struct file *file);
 	ssize_t (*read) (struct cgroup *cgrp, struct cftype *cft,
 			 struct file *file,
@@ -323,6 +327,12 @@ struct cftype {
 	 * write_s64() is a signed version of write_u64()
 	 */
 	int (*write_s64) (struct cgroup *cgrp, struct cftype *cft, s64 val);
+	/*
+	 * write_string() is passed a nul-terminated kernelspace
+	 * buffer of maximum length determined by max_write_len
+	 */
+	int (*write_string) (struct cgroup *cgrp, struct cftype *cft,
+			     char *buffer);
 
 	/*
 	 * trigger() callback can be used to get some kick from the
diff -puN kernel/cgroup.c~cgroup-files-add-a-cgroup-write_string-control-file-method kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-files-add-a-cgroup-write_string-control-file-method
+++ a/kernel/cgroup.c
@@ -1461,7 +1461,7 @@ static ssize_t cgroup_file_write(struct 
 	ssize_t retval;
 	char static_buffer[64];
 	char *buffer = static_buffer;
-	ssize_t max_bytes = sizeof(static_buffer) - 1;
+	ssize_t max_bytes =  cft->max_write_len ?: sizeof(static_buffer) - 1;
 	if (!cft->write && !cft->trigger) {
 		if (!nbytes)
 			return -EINVAL;
@@ -1489,6 +1489,8 @@ static ssize_t cgroup_file_write(struct 
 		retval = cft->write(cgrp, cft, file, userbuf, nbytes, ppos);
 	else if (cft->write_u64 || cft->write_s64)
 		retval = cgroup_write_X64(cgrp, cft, buffer);
+	else if (cft->write_string)
+		retval = cft->write_string(cgrp, cft, buffer);
 	else if (cft->trigger)
 		retval = cft->trigger(cgrp, (unsigned int)cft->private);
 	else
@@ -1651,6 +1653,7 @@ static struct file_operations cgroup_seq
 	.read = seq_read,
 	.llseek = seq_lseek,
 	.release = cgroup_seqfile_release,
+	.write = cgroup_file_write,
 };
 
 static int cgroup_file_open(struct inode *inode, struct file *file)
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


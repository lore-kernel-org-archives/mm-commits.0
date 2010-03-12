From: akpm@linux-foundation.org
Subject: + proc-cleanup-remove-unused-assignments.patch added to -mm tree
Date: Fri, 12 Mar 2010 14:14:24 -0800
Message-ID: <201003122214.o2CMEOIM011050@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45485 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758703Ab0CLWOn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Mar 2010 17:14:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, serue@us.ibm.com


The patch titled
     proc: cleanup: remove unused assignments
has been added to the -mm tree.  Its filename is
     proc-cleanup-remove-unused-assignments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: cleanup: remove unused assignments
From: Dan Carpenter <error27@gmail.com>

I removed 3 unused assignments.  The first two get reset on the first
statement of their functions.  For "err" in root.c we don't return an
error and we don't use the variable again.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    4 ++--
 fs/proc/root.c |    1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/proc/base.c~proc-cleanup-remove-unused-assignments fs/proc/base.c
--- a/fs/proc/base.c~proc-cleanup-remove-unused-assignments
+++ a/fs/proc/base.c
@@ -2519,7 +2519,7 @@ static struct dentry *proc_base_instanti
 	const struct pid_entry *p = ptr;
 	struct inode *inode;
 	struct proc_inode *ei;
-	struct dentry *error = ERR_PTR(-EINVAL);
+	struct dentry *error;
 
 	/* Allocate the inode */
 	error = ERR_PTR(-ENOMEM);
@@ -2869,7 +2869,7 @@ out:
 
 struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, struct nameidata *nd)
 {
-	struct dentry *result = ERR_PTR(-ENOENT);
+	struct dentry *result;
 	struct task_struct *task;
 	unsigned tgid;
 	struct pid_namespace *ns;
diff -puN fs/proc/root.c~proc-cleanup-remove-unused-assignments fs/proc/root.c
--- a/fs/proc/root.c~proc-cleanup-remove-unused-assignments
+++ a/fs/proc/root.c
@@ -110,7 +110,6 @@ void __init proc_root_init(void)
 	if (err)
 		return;
 	proc_mnt = kern_mount_data(&proc_fs_type, &init_pid_ns);
-	err = PTR_ERR(proc_mnt);
 	if (IS_ERR(proc_mnt)) {
 		unregister_filesystem(&proc_fs_type);
 		return;
_

Patches currently in -mm which might be from error27@gmail.com are

linux-next.patch
i915-fix-small-leak-on-error-path.patch
sched-cleanup-remove-unused-variable-in-try_to_wake_up.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
goku_udc-potential-null-dereference.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
proc-cleanup-remove-unused-assignments.patch


From: akpm@linux-foundation.org
Subject: - proc-proper-pidns-handling-for-proc-self.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:12:07 -0800
Message-ID: <200802082011.m18KBms1010146@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57981 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755006AbYBHVCo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:02:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, adobriyan@gmail.com, oleg@tv-sign.ru, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     proc: proper pidns handling for /proc/self
has been removed from the -mm tree.  Its filename was
     proc-proper-pidns-handling-for-proc-self.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: proper pidns handling for /proc/self
From: Eric W. Biederman <ebiederm@xmission.com>

Currently if you access a /proc that is not mounted with your processes
current pid namespace /proc/self will point at a completely

This patch fixes /proc/self to point to the current process if it is
available in the particular mount of /proc or to return -ENOENT if the
current process is not visible.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN fs/proc/base.c~proc-proper-pidns-handling-for-proc-self fs/proc/base.c
--- a/fs/proc/base.c~proc-proper-pidns-handling-for-proc-self
+++ a/fs/proc/base.c
@@ -2101,15 +2101,23 @@ static const struct file_operations proc
 static int proc_self_readlink(struct dentry *dentry, char __user *buffer,
 			      int buflen)
 {
+	struct pid_namespace *ns = dentry->d_sb->s_fs_info;
+	pid_t tgid = task_tgid_nr_ns(current, ns);
 	char tmp[PROC_NUMBUF];
-	sprintf(tmp, "%d", task_tgid_vnr(current));
+	if (!tgid)
+		return -ENOENT;
+	sprintf(tmp, "%d", tgid);
 	return vfs_readlink(dentry,buffer,buflen,tmp);
 }
 
 static void *proc_self_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
+	struct pid_namespace *ns = dentry->d_sb->s_fs_info;
+	pid_t tgid = task_tgid_nr_ns(current, ns);
 	char tmp[PROC_NUMBUF];
-	sprintf(tmp, "%d", task_tgid_vnr(current));
+	if (!tgid)
+		return ERR_PTR(-ENOENT);
+	sprintf(tmp, "%d", task_tgid_nr_ns(current, ns));
 	return ERR_PTR(vfs_follow_link(nd,tmp));
 }
 
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
use-find_task_by_vpid-in-audit-code.patch
ia64-fix-ptrace-inside-a-namespace.patch
mips-use-find_task_by_vpid-in-system-calls.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
git-x86.patch
deprecate-find_task_by_pid-kgdb.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch

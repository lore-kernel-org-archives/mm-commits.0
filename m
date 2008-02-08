From: akpm@linux-foundation.org
Subject: - proc-fix-the-threaded-proc-self.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:12:09 -0800
Message-ID: <200802082011.m18KBom4010149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46745 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756725AbYBHVEt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:04:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, guichaz@yahoo.fr, mingo@elte.hu, oleg@tv-sign.ru, rjw@sisk.pl, roland@redhat.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     proc: fix the threaded /proc/self
has been removed from the -mm tree.  Its filename was
     proc-fix-the-threaded-proc-self.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: fix the threaded /proc/self
From: ebiederm@xmission.com (Eric W. Biederman)

Long ago when the CLONE_THREAD support first went it someone thought it
would be wise to point /proc/self at /proc/<tgid> instead of /proc/<pid>.

Given that /proc/<tgid> can return information about a very different task
(if enough things have been unshared) then our current process /proc/<tgid>
seems blatantly wrong.  So far I have yet to think up an example where the
current behavior would be advantageous, and I can see several places where
it is seriously non-intuitive.

We may be stuck with the current broken behavior for backwards
compatibility reasons but lets try fixing our ancient bug for the 2.6.25
time frame and see if anyone screams.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: "Guillaume Chazarain" <guichaz@yahoo.fr>
Cc: "Pavel Emelyanov" <xemul@openvz.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/proc/base.c~proc-fix-the-threaded-proc-self fs/proc/base.c
--- a/fs/proc/base.c~proc-fix-the-threaded-proc-self
+++ a/fs/proc/base.c
@@ -2102,22 +2102,22 @@ static int proc_self_readlink(struct den
 			      int buflen)
 {
 	struct pid_namespace *ns = dentry->d_sb->s_fs_info;
-	pid_t tgid = task_tgid_nr_ns(current, ns);
+	pid_t pid = task_pid_nr_ns(current, ns);
 	char tmp[PROC_NUMBUF];
-	if (!tgid)
+	if (!pid)
 		return -ENOENT;
-	sprintf(tmp, "%d", tgid);
+	sprintf(tmp, "%d", pid);
 	return vfs_readlink(dentry,buffer,buflen,tmp);
 }
 
 static void *proc_self_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
 	struct pid_namespace *ns = dentry->d_sb->s_fs_info;
-	pid_t tgid = task_tgid_nr_ns(current, ns);
+	pid_t pid = task_pid_nr_ns(current, ns);
 	char tmp[PROC_NUMBUF];
-	if (!tgid)
+	if (!pid)
 		return ERR_PTR(-ENOENT);
-	sprintf(tmp, "%d", task_tgid_nr_ns(current, ns));
+	sprintf(tmp, "%d", pid);
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

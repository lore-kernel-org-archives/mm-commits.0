From: akpm@linux-foundation.org
Subject: +
 procfs-change-the-owner-of-non-dumpable-and-writeable-files.patch added to
 -mm tree
Date: Wed, 18 Jan 2017 15:09:59 -0800
Message-ID: <587ff5c7.0Rhn3dl8nBOfbfKB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53802 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750992AbdARXLa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2017 18:11:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: asarai@suse.de, jdanis@google.com, john.stultz@linaro.org, keescook@chromium.org, mguzik@redhat.com, mhocko@suse.com, oleg@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: change the owner of non-dumpable and writeable files
has been added to the -mm tree.  Its filename is
     procfs-change-the-owner-of-non-dumpable-and-writeable-files.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/procfs-change-the-owner-of-non-dumpable-and-writeable-files.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/procfs-change-the-owner-of-non-dumpable-and-writeable-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Aleksa Sarai <asarai@suse.de>
Subject: procfs: change the owner of non-dumpable and writeable files

In order to protect against ptrace(2) and similar attacks on container
runtimes when they join namespaces, many runtimes set mm->dumpable to
SUID_DUMP_DISABLE.  However, doing this means that attempting to set up an
unprivileged user namespace will fail because an unprivileged process can
no longer access /proc/self/{setgroups,{uid,gid}_map} for the container
process (which is the same uid as the runtime process).

Fix this by changing pid_getattr to *also* change the owner of regular
files that have a mode of 0644 (when the process is not dumpable).  This
ensures that the important /proc/[pid]/...  files mentioned above are
properly accessible by a container runtime in a rootless container
context.

The most blantant issue is that a non-dumpable process in a rootless
container context is unable to open /proc/self/setgroups, because it
doesn't own the file.

int main(void)
{
	prctl(PR_SET_DUMPABLE, 0, 0, 0, 0);
	unshare(CLONE_NEWUSER);

	/* This will fail. */
	int fd = open("/proc/self/setgroups", O_WRONLY);
	if (fd < 0)
		abort();

	return 0;
}

Link: http://lkml.kernel.org/r/20170118040159.4751-1-asarai@suse.de
Signed-off-by: Aleksa Sarai <asarai@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Mateusz Guzik <mguzik@redhat.com>
Cc: Janis Danisevskis <jdanis@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/proc/base.c~procfs-change-the-owner-of-non-dumpable-and-writeable-files fs/proc/base.c
--- a/fs/proc/base.c~procfs-change-the-owner-of-non-dumpable-and-writeable-files
+++ a/fs/proc/base.c
@@ -1702,6 +1702,7 @@ int pid_getattr(struct vfsmount *mnt, st
 			return -ENOENT;
 		}
 		if ((inode->i_mode == (S_IFDIR|S_IRUGO|S_IXUGO)) ||
+		    (inode->i_mode == (S_IFREG|S_IRUGO|S_IWUSR)) ||
 		    task_dumpable(task)) {
 			cred = __task_cred(task);
 			stat->uid = cred->euid;
@@ -1743,6 +1744,7 @@ int pid_revalidate(struct dentry *dentry
 
 	if (task) {
 		if ((inode->i_mode == (S_IFDIR|S_IRUGO|S_IXUGO)) ||
+		    (inode->i_mode == (S_IFREG|S_IRUGO|S_IWUSR)) ||
 		    task_dumpable(task)) {
 			rcu_read_lock();
 			cred = __task_cred(task);
@@ -2362,7 +2364,7 @@ out:
 	return -ENOENT;
 }
 
-static struct dentry *proc_pident_lookup(struct inode *dir, 
+static struct dentry *proc_pident_lookup(struct inode *dir,
 					 struct dentry *dentry,
 					 const struct pid_entry *ents,
 					 unsigned int nents)
@@ -2504,7 +2506,7 @@ static const struct pid_entry attr_dir_s
 
 static int proc_attr_dir_readdir(struct file *file, struct dir_context *ctx)
 {
-	return proc_pident_readdir(file, ctx, 
+	return proc_pident_readdir(file, ctx,
 				   attr_dir_stuff, ARRAY_SIZE(attr_dir_stuff));
 }
 
_

Patches currently in -mm which might be from asarai@suse.de are

procfs-change-the-owner-of-non-dumpable-and-writeable-files.patch


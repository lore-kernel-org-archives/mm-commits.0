From: akpm@linux-foundation.org
Subject: [folded] procfs-introduce-the-proc-pid-map_files-directory-make-proc-pid-map_files-being-checkpoint_restore-dependent.patch removed from -mm tree
Date: Tue, 10 Jan 2012 14:54:59 -0800
Message-ID: <20120110225500.0AB831E007A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:61955 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab2AJWzA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 17:55:00 -0500
Received: by mail-gy0-f202.google.com with SMTP id r15so14315ghr.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2012 14:55:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, adobriyan@gmail.com, kirill@shutemov.name, segoon@openwall.com, tj@kernel.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: proc -- Make /proc/<pid>/map_files being CHECKPOINT_RESTORE dependent
has been removed from the -mm tree.  Its filename was
     procfs-introduce-the-proc-pid-map_files-directory-make-proc-pid-map_files-being-checkpoint_restore-dependent.patch

This patch was dropped because it was folded into procfs-introduce-the-proc-pid-map_files-directory.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: fs: proc -- Make /proc/<pid>/map_files being CHECKPOINT_RESTORE dependent

This entry was introduced in a sake of C/R, so no need to built it in by
default.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Tejun Heo <tj@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN fs/proc/base.c~procfs-introduce-the-proc-pid-map_files-directory-make-proc-pid-map_files-being-checkpoint_restore-dependent fs/proc/base.c
--- a/fs/proc/base.c~procfs-introduce-the-proc-pid-map_files-directory-make-proc-pid-map_files-being-checkpoint_restore-dependent
+++ a/fs/proc/base.c
@@ -2049,6 +2049,8 @@ static const struct file_operations proc
 	.llseek		= default_llseek,
 };
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
+
 /*
  * dname_to_vma_addr - maps a dentry name into two unsigned longs
  * which represent vma start and end addresses.
@@ -2394,6 +2396,8 @@ static const struct file_operations proc
 	.llseek		= default_llseek,
 };
 
+#endif /* CONFIG_CHECKPOINT_RESTORE */
+
 /*
  * /proc/pid/fd needs a special permission handler so that a process can still
  * access /proc/self/fd after it has executed a setuid().
@@ -3009,7 +3013,9 @@ static const struct inode_operations pro
 static const struct pid_entry tgid_base_stuff[] = {
 	DIR("task",       S_IRUGO|S_IXUGO, proc_task_inode_operations, proc_task_operations),
 	DIR("fd",         S_IRUSR|S_IXUSR, proc_fd_inode_operations, proc_fd_operations),
+#ifdef CONFIG_CHECKPOINT_RESTORE
 	DIR("map_files",  S_IRUSR|S_IXUSR, proc_map_files_inode_operations, proc_map_files_operations),
+#endif
 	DIR("fdinfo",     S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
 	DIR("ns",	  S_IRUSR|S_IXUGO, proc_ns_dir_inode_operations, proc_ns_dir_operations),
 #ifdef CONFIG_NET
_

Patches currently in -mm which might be from gorcunov@openvz.org are

origin.patch
procfs-make-proc_get_link-to-use-dentry-instead-of-inode.patch
procfs-introduce-the-proc-pid-map_files-directory.patch


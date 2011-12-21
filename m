From: akpm@linux-foundation.org
Subject: + procfs-introduce-the-proc-pid-map_files-directory-make-proc-pid-map_files-being-checkpoint_restore-dependent.patch added to -mm tree
Date: Wed, 21 Dec 2011 12:16:36 -0800
Message-ID: <20111221201637.331B420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:32937 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab1LUUQk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Dec 2011 15:16:40 -0500
Received: by eaak10 with SMTP id k10so16547eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2011 12:16:38 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, adobriyan@gmail.com, kirill@shutemov.name, segoon@openwall.com, tj@kernel.org, xemul@parallels.com


The patch titled
     Subject: fs: proc -- Make /proc/<pid>/map_files being CHECKPOINT_RESTORE dependent
has been added to the -mm tree.  Its filename is
     procfs-introduce-the-proc-pid-map_files-directory-make-proc-pid-map_files-being-checkpoint_restore-dependent.patch

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
@@ -2163,6 +2163,8 @@ static const struct file_operations proc
 	.llseek		= default_llseek,
 };
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
+
 /*
  * dname_to_vma_addr - maps a dentry name into two unsigned longs
  * which represent vma start and end addresses.
@@ -2508,6 +2510,8 @@ static const struct file_operations proc
 	.llseek		= default_llseek,
 };
 
+#endif /* CONFIG_CHECKPOINT_RESTORE */
+
 /*
  * /proc/pid/fd needs a special permission handler so that a process can still
  * access /proc/self/fd after it has executed a setuid().
@@ -3123,7 +3127,9 @@ static const struct inode_operations pro
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
Subject: Subject: fs: proc -- Make /proc/<pid>/map_files being CHECKPOINT_RESTORE dependent

Patches currently in -mm which might be from gorcunov@openvz.org are

linux-next.patch
procfs-make-proc_get_link-to-use-dentry-instead-of-inode.patch
procfs-introduce-the-proc-pid-map_files-directory.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
procfs-introduce-the-proc-pid-map_files-directory-make-proc-pid-map_files-being-checkpoint_restore-dependent.patch
sysctl-add-the-kernelns_last_pid-control.patch
c-r-introduce-checkpoint_restore-symbol.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch


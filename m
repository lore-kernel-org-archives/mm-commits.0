From: akpm@linux-foundation.org
Subject: [folded] fs-proc-introduce-proc-pid-task-tid-children-entry-v9-fix.patch removed from -mm tree
Date: Thu, 31 May 2012 16:20:04 -0700
Message-ID: <20120531232004.9DB04A009B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:61622 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758620Ab2EaXUF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 19:20:05 -0400
Received: by qabg24 with SMTP id g24so10259qab.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 16:20:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, keescook@chromium.org, oleg@redhat.com, serge.hallyn@canonical.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: c/r: fs, proc: Move children entry back to tid_base_stuff
has been removed from the -mm tree.  Its filename was
     fs-proc-introduce-proc-pid-task-tid-children-entry-v9-fix.patch

This patch was dropped because it was folded into fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: c/r: fs, proc: Move children entry back to tid_base_stuff

While merging to linux-next the "children" entry jumped from
tid_base_stuff to tgid_base_stuff by mistake.  Fix it, by moving it back.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/proc/base.c~fs-proc-introduce-proc-pid-task-tid-children-entry-v9-fix fs/proc/base.c
--- a/fs/proc/base.c~fs-proc-introduce-proc-pid-task-tid-children-entry-v9-fix
+++ a/fs/proc/base.c
@@ -2980,9 +2980,6 @@ static const struct pid_entry tgid_base_
 	ONE("stat",       S_IRUGO, proc_tgid_stat),
 	ONE("statm",      S_IRUGO, proc_pid_statm),
 	REG("maps",       S_IRUGO, proc_pid_maps_operations),
-#ifdef CONFIG_CHECKPOINT_RESTORE
-	REG("children",  S_IRUGO, proc_tid_children_operations),
-#endif
 #ifdef CONFIG_NUMA
 	REG("numa_maps",  S_IRUGO, proc_pid_numa_maps_operations),
 #endif
@@ -3342,6 +3339,9 @@ static const struct pid_entry tid_base_s
 	ONE("stat",      S_IRUGO, proc_tid_stat),
 	ONE("statm",     S_IRUGO, proc_pid_statm),
 	REG("maps",      S_IRUGO, proc_tid_maps_operations),
+#ifdef CONFIG_CHECKPOINT_RESTORE
+	REG("children",  S_IRUGO, proc_tid_children_operations),
+#endif
 #ifdef CONFIG_NUMA
 	REG("numa_maps", S_IRUGO, proc_tid_numa_maps_operations),
 #endif
_

Patches currently in -mm which might be from gorcunov@openvz.org are

origin.patch
sethostname-setdomainname-notify-userspace-when-there-is-a-change-in-uts_kern_table.patch
pidns-use-task_active_pid_ns-in-do_notify_parent.patch
pidns-make-killed-children-autoreap.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch


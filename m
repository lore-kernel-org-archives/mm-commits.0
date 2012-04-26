From: akpm@linux-foundation.org
Subject: + fs-proc-introduce-proc-pid-task-tid-children-entry-v9-fix.patch added to -mm tree
Date: Thu, 26 Apr 2012 15:08:53 -0700
Message-ID: <20120426220853.B2800A07B1@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:36750 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316Ab2DZWI4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Apr 2012 18:08:56 -0400
Received: by lbbge1 with SMTP id ge1so3253lbb.1
        for <mm-commits@vger.kernel.org>; Thu, 26 Apr 2012 15:08:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, keescook@chromium.org, oleg@redhat.com, serge.hallyn@canonical.com, xemul@parallels.com


The patch titled
     Subject: c/r: fs, proc: Move children entry back to tid_base_stuff
has been added to the -mm tree.  Its filename is
     fs-proc-introduce-proc-pid-task-tid-children-entry-v9-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: c/r: fs, proc: Move children entry back to tid_base_stuff

Patches currently in -mm which might be from gorcunov@openvz.org are

linux-next.patch
sethostname-setdomainname-notify-userspace-when-there-is-a-change-in-uts_kern_table.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch
c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment.patch
c-r-prctl-return-efault-instead-of-einval-in-case-if-underlied-vma-is-not-found.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
c-r-prctl-drop-vma-flags-test-on-pr_set_mm_-stack-data-assignment.patch


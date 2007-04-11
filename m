From: akpm@linux-foundation.org
Subject: + change-reparent_to_init-to-reparent_to_kthreadd.patch added to -mm tree
Date: Wed, 11 Apr 2007 13:41:21 -0700
Message-ID: <200704112041.l3BKfL82013879@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59857 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030751AbXDKUl2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 16:41:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, oleg@tv-sign.ru


The patch titled
     Change reparent_to_init to reparent_to_kthreadd
has been added to the -mm tree.  Its filename is
     change-reparent_to_init-to-reparent_to_kthreadd.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Change reparent_to_init to reparent_to_kthreadd
From: Eric W. Biederman <ebiederm@xmission.com>

When a kernel thread calls daemonize, instead of reparenting the thread to
init reparent the thread to kthreadd next to the threads created by
kthread_create.

This is really just a stop gap until daemonize goes away, but it does
ensure no kernel threads are under init and they are all in one place that
is easy to find.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff -puN kernel/exit.c~change-reparent_to_init-to-reparent_to_kthreadd kernel/exit.c
--- a/kernel/exit.c~change-reparent_to_init-to-reparent_to_kthreadd
+++ a/kernel/exit.c
@@ -26,6 +26,7 @@
 #include <linux/profile.h>
 #include <linux/mount.h>
 #include <linux/proc_fs.h>
+#include <linux/kthread.h>
 #include <linux/mempolicy.h>
 #include <linux/taskstats_kern.h>
 #include <linux/delayacct.h>
@@ -257,26 +258,25 @@ static int has_stopped_jobs(struct pid *
 }
 
 /**
- * reparent_to_init - Reparent the calling kernel thread to the init task of the pid space that the thread belongs to.
+ * reparent_to_kthreadd - Reparent the calling kernel thread to kthreadd
  *
  * If a kernel thread is launched as a result of a system call, or if
- * it ever exits, it should generally reparent itself to init so that
- * it is correctly cleaned up on exit.
+ * it ever exits, it should generally reparent itself to kthreadd so it
+ * isn't in the way of other processes and is correctly cleaned up on exit.
  *
  * The various task state such as scheduling policy and priority may have
  * been inherited from a user process, so we reset them to sane values here.
  *
- * NOTE that reparent_to_init() gives the caller full capabilities.
+ * NOTE that reparent_to_kthreadd() gives the caller full capabilities.
  */
-static void reparent_to_init(void)
+static void reparent_to_kthreadd(void)
 {
 	write_lock_irq(&tasklist_lock);
 
 	ptrace_unlink(current);
 	/* Reparent to init */
 	remove_parent(current);
-	current->parent = child_reaper(current);
-	current->real_parent = child_reaper(current);
+	current->real_parent = current->parent = kthreadd_task;
 	add_parent(current);
 
 	/* Set the exit signal to SIGCHLD so we signal init on exit */
@@ -403,7 +403,7 @@ void daemonize(const char *name, ...)
 	current->files = init_task.files;
 	atomic_inc(&current->files->count);
 
-	reparent_to_init();
+	reparent_to_kthreadd();
 }
 
 EXPORT_SYMBOL(daemonize);
_

Patches currently in -mm which might be from ebiederm@xmission.com are

powerpc-rtas-msi-support.patch
fix-i-oat-for-kexec.patch
fix-x86_64-mm-relocatable-kernel-support.patch
account-for-module-percpu-space-separately-from-kernel.patch
i386-irq-kill-irq-compression.patch
i386-relocate-vdso-elf-headers-to-match-mapped-location-with-compat_vdso.patch
i386-make-compat_vdso-runtime-selectable.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
allow-access-to-proc-pid-fd-after-setuid.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
fix-race-between-proc_get_inode-and-remove_proc_entry.patch
fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-reorder-struct-pid_dentry-to-save-space-on-64bit-archs-and-constify-them.patch
tty-remove-unnecessary-export-of-proc_clear_tty.patch
tty-simplify-calling-of-put_pid.patch
tty-introduce-no_tty-and-use-it-in-selinux.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up-fix.patch
clean-up-elf-note-generation.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
use-the-apic-to-determine-the-hardware-processor-id-i386.patch
use-the-apic-to-determine-the-hardware-processor-id-x86_64.patch
always-ask-the-hardware-to-obtain-hardware-processor-id-ia64.patch
proc-cleanup-use-seq_release_private-where-appropriate.patch
kthread-dont-depend-on-work-queues-take-2.patch
kthread-dont-depend-on-work-queues-take-2-fix.patch
change-reparent_to_init-to-reparent_to_kthreadd.patch
edac-k8-driver-coding-tidy.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-and-sid-of-init-process.patch
use-struct-pid-parameter-in-copy_process.patch
use-task_pgrp-task_session-in-copy_process.patch
kill-unused-sesssion-and-group-values-in-rocket-driver.patch
fix-some-coding-style-errors-in-autofs.patch
replace-pid_t-in-autofs-with-struct-pid-reference.patch
dont-init-pgrp-and-__session-in-init_signals.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch

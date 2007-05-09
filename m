From: akpm@linux-foundation.org
Subject: - change-reparent_to_init-to-reparent_to_kthreadd.patch removed from -mm tree
Date: Wed, 09 May 2007 14:52:29 -0700
Message-ID: <200705092152.l49LqT88003000@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58698 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758689AbXEIVxD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:53:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     Change reparent_to_init to reparent_to_kthreadd
has been removed from the -mm tree.  Its filename was
     change-reparent_to_init-to-reparent_to_kthreadd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 8 insertions(+), 8 deletions(-)

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
@@ -254,26 +255,25 @@ static int has_stopped_jobs(struct pid *
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
@@ -400,7 +400,7 @@ void daemonize(const char *name, ...)
 	current->files = init_task.files;
 	atomic_inc(&current->files->count);
 
-	reparent_to_init();
+	reparent_to_kthreadd();
 }
 
 EXPORT_SYMBOL(daemonize);
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
iop13xx-msi-support-rev6.patch
dvb_en_50221-convert-to-kthread-api.patch
fix-i-oat-for-kexec.patch
pci-disable-msi-by-default-on-systems-with-serverworks-ht1000-chips.patch
i386-irq-kill-irq-compression.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-efi-fix-proc-iomem-type-for-kexec-tools.patch
x86_64-display-more-intutive-error-message-if-kernel-is-not-2mb-aligned.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-and-sid-of-init-process.patch
use-struct-pid-parameter-in-copy_process.patch
use-task_pgrp-task_session-in-copy_process.patch
kill-unused-sesssion-and-group-values-in-rocket-driver.patch
fix-some-coding-style-errors-in-autofs.patch
replace-pid_t-in-autofs-with-struct-pid-reference.patch
dont-init-pgrp-and-__session-in-init_signals.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch

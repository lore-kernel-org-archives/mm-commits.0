From: akpm@linux-foundation.org
Subject: - workqueues-make-get_online_cpus-useable-for-work-func-fix.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:31:44 -0700
Message-ID: <200807250031.m6P0Viqh014323@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752632AbYGYAch (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 20:32:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ego@in.ibm.com, heiko.carstens@de.ibm.com, maxk@qualcomm.com, menage@google.com, mingo@elte.hu, oleg@tv-sign.ru, peterz@infradead.org, pj@sgi.com, schwidefs


The patch titled
     workqueues-make-get_online_cpus-useable-for-work-func-fix
has been removed from the -mm tree.  Its filename was
     workqueues-make-get_online_cpus-useable-for-work-func-fix.patch

This patch was dropped because it was folded into workqueues-make-get_online_cpus-useable-for-work-func.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: workqueues-make-get_online_cpus-useable-for-work-func-fix
From: Andrew Morton <akpm@linux-foundation.org>

Fix CONFIG_SMP=n.

Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Paul Jackson <pj@sgi.com>
Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpu.h |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN include/linux/cpu.h~workqueues-make-get_online_cpus-useable-for-work-func-fix include/linux/cpu.h
--- a/include/linux/cpu.h~workqueues-make-get_online_cpus-useable-for-work-func-fix
+++ a/include/linux/cpu.h
@@ -69,10 +69,11 @@ static inline void unregister_cpu_notifi
 #endif
 
 int cpu_up(unsigned int cpu);
-
 extern void cpu_hotplug_init(void);
+extern void cpu_maps_update_begin(void);
+extern void cpu_maps_update_done(void);
 
-#else
+#else	/* CONFIG_SMP */
 
 static inline int register_cpu_notifier(struct notifier_block *nb)
 {
@@ -87,10 +88,16 @@ static inline void cpu_hotplug_init(void
 {
 }
 
+static inline void cpu_maps_update_begin(void)
+{
+}
+
+static inline void cpu_maps_update_done(void)
+{
+}
+
 #endif /* CONFIG_SMP */
 extern struct sysdev_class cpu_sysdev_class;
-extern void cpu_maps_update_begin(void);
-extern void cpu_maps_update_done(void);
 
 #ifdef CONFIG_HOTPLUG_CPU
 /* Stop CPUs going up and down. */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm.patch
build-kernel-profileo-only-when-requested-cleanups.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
exec-remove-some-includes.patch
inflate-refactor-inflate-malloc-code.patch
drivers-misc-hpiloc-needs-config_pci.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
gpio-sysfs-interface-updated.patch
gpio-add-bt8xxgpio-driver.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction.patch
ext3-handle-corrupted-orphan-list-at-mount.patch
ext3-handle-deleting-corrupted-indirect-blocks.patch
jbd-dont-abort-if-flushing-file-data-failed.patch
reiserfs-convert-j_flush_sem-to-mutex.patch
reiserfs-convert-j_commit_lock-to-mutex.patch
quota-move-function-macros-from-quotah-to-quotaopsh.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup.patch
devcgroup-code-cleanup.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-limit-change-shrink-usage.patch
coredump-format_corename-fix-the-core_uses_pid-logic.patch
workqueues-make-get_online_cpus-useable-for-work-func.patch
workqueues-make-get_online_cpus-useable-for-work-func-fix.patch
ipc-semc-convert-undo-structures-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-rewrite-undo-list-locking-checkpatch-fixes.patch
fs-partition-checkc-fix-return-value-warning-v2-cleanup.patch
block-ioctlc-and-fs-partition-checkc-checkpatch-fixes.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
edac-mpc85xx-fix-pci-ofdev-2nd-pass-checkpatch-fixes.patch


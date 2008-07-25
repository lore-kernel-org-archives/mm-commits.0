From: akpm@linux-foundation.org
Subject: - locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:09:40 -0700
Message-ID: <200807250009.m6P09eUc013332@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752146AbYGYAKl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 20:10:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mingo@elte.hu, rostedt@goodmis.org, srostedt@redhat.com, mm-commits@vger.kernel.org


The patch titled
     locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix
has been removed from the -mm tree.  Its filename was
     locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch

This patch was dropped because it was folded into locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/irqflags.h |    2 ++
 include/linux/spinlock.h |    1 +
 2 files changed, 3 insertions(+)

diff -puN include/linux/irqflags.h~locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix include/linux/irqflags.h
--- a/include/linux/irqflags.h~locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix
+++ a/include/linux/irqflags.h
@@ -11,6 +11,8 @@
 #ifndef _LINUX_TRACE_IRQFLAGS_H
 #define _LINUX_TRACE_IRQFLAGS_H
 
+#include <linux/typecheck.h>
+
 #ifdef CONFIG_TRACE_IRQFLAGS
   extern void trace_softirqs_on(unsigned long ip);
   extern void trace_softirqs_off(unsigned long ip);
diff -puN include/linux/spinlock.h~locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix include/linux/spinlock.h
--- a/include/linux/spinlock.h~locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix
+++ a/include/linux/spinlock.h
@@ -46,6 +46,7 @@
  *  linux/spinlock.h:     builds the final spin_*() APIs.
  */
 
+#include <linux/typecheck.h>
 #include <linux/preempt.h>
 #include <linux/linkage.h>
 #include <linux/compiler.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
build-kernel-profileo-only-when-requested-cleanups.patch
seq_file-fix-bug-when-seq_read-reads-nothing-fix.patch
exec-remove-some-includes-fix.patch
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch
drivers-misc-hpiloc-needs-config_pci.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support-fix.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support-fix-fix.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support-fix-fix-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes-fix.patch
ext3-handle-corrupted-orphan-list-at-mount-cleanup.patch
ext3-handle-corrupted-orphan-list-at-mount-fix.patch
ext3-handle-corrupted-orphan-list-at-mount-cleanup-fix.patch
ext3-handle-deleting-corrupted-indirect-blocks-fix.patch
jbd-dont-abort-if-flushing-file-data-failed-fix.patch
reiserfs-convert-j_flush_sem-to-mutex.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix-fix.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-fix.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-checkpatch-fixes.patch
devcgroup-code-cleanup-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
memcg-limit-change-shrink-usage-checkpatch-fixes.patch
coredump-format_corename-fix-the-core_uses_pid-logic-checkpatch-fixes.patch
workqueues-make-get_online_cpus-useable-for-work-func-fix.patch
ipc-semc-convert-undo-structures-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-rewrite-undo-list-locking-checkpatch-fixes.patch
fs-partition-checkc-fix-return-value-warning-v2-cleanup.patch
block-ioctlc-and-fs-partition-checkc-checkpatch-fixes.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
edac-mpc85xx-fix-pci-ofdev-2nd-pass-checkpatch-fixes.patch


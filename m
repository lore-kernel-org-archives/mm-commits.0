From: akpm@linux-foundation.org
Subject: - proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-2.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:32:59 -0800
Message-ID: <200802080832.m188Wekv015724@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32782 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758680AbYBHIh6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:37:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ebiederm@xmission.com, heiko.carstens@de.ibm.com, kamalesh@linux.vnet.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-2
has been removed from the -mm tree.  Its filename was
     proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-2.patch

This patch was dropped because it was folded into proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-2
From: Andrew Morton <akpm@linux-foundation.org>

In file included from include/asm/thread_info.h:39,
                 from include/linux/thread_info.h:21,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:49,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/timex.h:57,
                 from include/linux/sched.h:53,
                 from arch/s390/kernel/asm-offsets.c:7:
include/asm/processor.h:184: warning: 'struct seq_file' declared inside parameter list
include/asm/processor.h:184: warning: its scope is only this definition or declaration, which is probably not what you want

arch/s390/kernel/traps.c: In function 'task_show_regs':
arch/s390/kernel/traps.c:226: error: implicit declaration of function 'seq_printf'

Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/traps.c     |    1 +
 include/asm-s390/processor.h |    1 +
 2 files changed, 2 insertions(+)

diff -puN arch/s390/kernel/traps.c~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-2 arch/s390/kernel/traps.c
--- a/arch/s390/kernel/traps.c~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-2
+++ a/arch/s390/kernel/traps.c
@@ -24,6 +24,7 @@
 #include <linux/smp.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/seq_file.h>
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/kdebug.h>
diff -puN include/asm-s390/processor.h~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-2 include/asm-s390/processor.h
--- a/include/asm-s390/processor.h~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-2
+++ a/include/asm-s390/processor.h
@@ -161,6 +161,7 @@ struct stack_frame {
 /* Forward declaration, a strange C thing */
 struct task_struct;
 struct mm_struct;
+struct seq_file;
 
 /* Free all resources held by a thread. */
 extern void release_thread(struct task_struct *);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cleanup-the-code-managed-with-the-user_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option.patch
proc-detect-duplicate-names-on-registration.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-2.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-3.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-nommu-fix.patch
proc-fix-openless-usage-due-to-proc_fops-flip-checkpatch-fixes.patch
intel-iommu-fault_reason_index_cleanuppatch-fix.patch
modules-make-module_address_lookup-safe-fix.patch
wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace-fix.patch
pid-sys_wait-fixes-v2-checkpatch-fixes.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
rewrite-rd-fixes.patch
fs-remove-fastcall-it-is-always-empty-checkpatch-fixes.patch
kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch
lib-remove-fastcall-from-lib-checkpatch-fixes.patch
remove-fastcall-from-linux-include-checkpatch-fixes.patch
constify-tables-in-kernel-sysctl_checkc-fix.patch
aoe-statically-initialise-devlist_lock.patch
ufs-fix-symlink-creation-on-ufs2-fix.patch
libfs-allow-error-return-from-simple-attributes-fix.patch
fs-hfsplus-unicodec-fix-uninitialized-var-warning.patch
fs-afs-securityc-fix-uninitialized-var-warning.patch
mount-options-fix-tmpfs-fix.patch
char-applicom-use-pci_match_id-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2.patch

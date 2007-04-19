From: akpm@linux-foundation.org
Subject: + mutex-subsystem-synchro-test-module-convert-to-the-kthread-api.patch added to -mm tree
Date: Thu, 19 Apr 2007 15:29:37 -0700
Message-ID: <200704192229.l3JMTb96032619@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42223 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753896AbXDSWaY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 18:30:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, dhowells@redhat.com, mingo@elte.hu


The patch titled
     synchro_test: convert to the kthread API
has been added to the -mm tree.  Its filename is
     mutex-subsystem-synchro-test-module-convert-to-the-kthread-api.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: synchro_test: convert to the kthread API
From: Eric W. Biederman <ebiederm@xmission.com>

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/synchro-test.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff -puN kernel/synchro-test.c~mutex-subsystem-synchro-test-module-convert-to-the-kthread-api kernel/synchro-test.c
--- a/kernel/synchro-test.c~mutex-subsystem-synchro-test-module-convert-to-the-kthread-api
+++ a/kernel/synchro-test.c
@@ -30,6 +30,7 @@
 #include <linux/timer.h>
 #include <linux/completion.h>
 #include <linux/mutex.h>
+#include <linux/kthread.h>
 
 #define MAX_THREADS 64
 
@@ -224,7 +225,6 @@ static int mutexer(void *arg)
 {
 	unsigned int N = (unsigned long) arg;
 
-	daemonize("Mutex%u", N);
 	set_user_nice(current, 19);
 
 	while (atomic_read(&do_stuff)) {
@@ -246,7 +246,6 @@ static int semaphorer(void *arg)
 {
 	unsigned int N = (unsigned long) arg;
 
-	daemonize("Sem%u", N);
 	set_user_nice(current, 19);
 
 	while (atomic_read(&do_stuff)) {
@@ -268,7 +267,6 @@ static int reader(void *arg)
 {
 	unsigned int N = (unsigned long) arg;
 
-	daemonize("Read%u", N);
 	set_user_nice(current, 19);
 
 	while (atomic_read(&do_stuff)) {
@@ -292,7 +290,6 @@ static int writer(void *arg)
 {
 	unsigned int N = (unsigned long) arg;
 
-	daemonize("Write%u", N);
 	set_user_nice(current, 19);
 
 	while (atomic_read(&do_stuff)) {
@@ -316,7 +313,6 @@ static int downgrader(void *arg)
 {
 	unsigned int N = (unsigned long) arg;
 
-	daemonize("Down%u", N);
 	set_user_nice(current, 19);
 
 	while (atomic_read(&do_stuff)) {
@@ -433,27 +429,27 @@ static int __init do_tests(void)
 	for (loop = 0; loop < MAX_THREADS; loop++) {
 		if (loop < nummx) {
 			init_completion(&mx_comp[loop]);
-			kernel_thread(mutexer, (void *) loop, 0);
+			kthread_run(mutexer, (void *) loop, "Mutex%u", loop);
 		}
 
 		if (loop < numsm) {
 			init_completion(&sm_comp[loop]);
-			kernel_thread(semaphorer, (void *) loop, 0);
+			kthread_run(semaphorer, (void *) loop, "Sem%u", loop);
 		}
 
 		if (loop < numrd) {
 			init_completion(&rd_comp[loop]);
-			kernel_thread(reader, (void *) loop, 0);
+			kthread_run(reader, (void *) loop, "Read%u", loop);
 		}
 
 		if (loop < numwr) {
 			init_completion(&wr_comp[loop]);
-			kernel_thread(writer, (void *) loop, 0);
+			kthread_run(writer, (void *) loop, "Write%u", loop);
 		}
 
 		if (loop < numdg) {
 			init_completion(&dg_comp[loop]);
-			kernel_thread(downgrader, (void *) loop, 0);
+			kthread_run(downgrader, (void *) loop, "Down%u", loop);
 		}
 	}
 
_

Patches currently in -mm which might be from ebiederm@xmission.com are

powerpc-rtas-msi-support.patch
fix-i-oat-for-kexec.patch
i386-irq-kill-irq-compression.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
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
wait_for_helper-remove-unneeded-do_sigaction.patch
worker_thread-dont-play-with-sigchld-and-numa-policy.patch
change-kernel-threads-to-ignore-signals-instead-of-blocking-them.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
edac-k8-driver-coding-tidy.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-and-sid-of-init-process.patch
use-struct-pid-parameter-in-copy_process.patch
use-task_pgrp-task_session-in-copy_process.patch
kill-unused-sesssion-and-group-values-in-rocket-driver.patch
fix-some-coding-style-errors-in-autofs.patch
replace-pid_t-in-autofs-with-struct-pid-reference.patch
dont-init-pgrp-and-__session-in-init_signals.patch
mutex-subsystem-synchro-test-module-convert-to-the-kthread-api.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch

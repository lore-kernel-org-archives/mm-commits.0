From: akpm@linux-foundation.org
Subject: + md-remove-broken-sigkill-support.patch added to -mm tree
Date: Thu, 19 Apr 2007 15:30:19 -0700
Message-ID: <200704192230.l3JMUJVw032666@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43421 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754172AbXDSWa4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 18:30:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, neilb@suse.de


The patch titled
     md: remove broken SIGKILL support
has been added to the -mm tree.  Its filename is
     md-remove-broken-sigkill-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: remove broken SIGKILL support
From: Eric W. Biederman <ebiederm@xmission.com>

Currently md_thread calls allow_signal so it can receive a SIGKILL but then
does nothing with it except flush the sigkill so that it not can use an
interruptible sleep.

This whole dance is silly so remove the unnecessary and broken signal
handling logic.

Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |    6 ------
 1 files changed, 6 deletions(-)

diff -puN drivers/md/md.c~md-remove-broken-sigkill-support drivers/md/md.c
--- a/drivers/md/md.c~md-remove-broken-sigkill-support
+++ a/drivers/md/md.c
@@ -4542,17 +4542,11 @@ static int md_thread(void * arg)
 	 */
 
 	current->flags |= PF_NOFREEZE;
-	allow_signal(SIGKILL);
 	while (!kthread_should_stop()) {
 
 		/* We need to wait INTERRUPTIBLE so that
 		 * we don't add to the load-average.
-		 * That means we need to be sure no signals are
-		 * pending
 		 */
-		if (signal_pending(current))
-			flush_signals(current);
-
 		wait_event_interruptible_timeout
 			(thread->wqueue,
 			 test_bit(THREAD_WAKEUP, &thread->flags)
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
md-remove-broken-sigkill-support.patch
mutex-subsystem-synchro-test-module-convert-to-the-kthread-api.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch

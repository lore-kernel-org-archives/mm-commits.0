From: akpm@linux-foundation.org
Subject: + drivers-staging-epl-do-not-use-clone_sighand-with-allow_signal.patch added to -mm tree
Date: Mon, 04 May 2009 16:36:15 -0700
Message-ID: <200905042336.n44NaFuL018857@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56781 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751830AbZEDXjw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 19:39:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, Ronald.Sieber@systec-electronic.com, daniel.krueger@systec-electronic.com, gregkh@suse.de


The patch titled
     drivers/staging/epl: do not use CLONE_SIGHAND with allow_signal()
has been added to the -mm tree.  Its filename is
     drivers-staging-epl-do-not-use-clone_sighand-with-allow_signal.patch

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
Subject: drivers/staging/epl: do not use CLONE_SIGHAND with allow_signal()
From: Oleg Nesterov <oleg@redhat.com>

Not sure this patch is really needed since kernel_thread() is deprecated
(and checkpatch.pl complains).

But we should not use kernel_thread(CLONE_SIGHAND) if we are going to play
with signals.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Daniel Krueger <daniel.krueger@systec-electronic.com>
Cc: Ronald Sieber <Ronald.Sieber@systec-electronic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/epl/EplSdoUdpu.c         |    3 ++-
 drivers/staging/epl/ShbIpc-LinuxKernel.c |    8 ++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/staging/epl/EplSdoUdpu.c~drivers-staging-epl-do-not-use-clone_sighand-with-allow_signal drivers/staging/epl/EplSdoUdpu.c
--- a/drivers/staging/epl/EplSdoUdpu.c~drivers-staging-epl-do-not-use-clone_sighand-with-allow_signal
+++ a/drivers/staging/epl/EplSdoUdpu.c
@@ -334,7 +334,8 @@ tEplKernel EplSdoUdpuConfig(unsigned lon
 	}
 	// create Listen-Thread
 	SdoUdpInstance_g.m_ThreadHandle =
-	    kernel_thread(EplSdoUdpThread, &SdoUdpInstance_g, CLONE_KERNEL);
+		kernel_thread(EplSdoUdpThread, &SdoUdpInstance_g,
+				CLONE_FS | CLONE_FILES);
 	if (SdoUdpInstance_g.m_ThreadHandle == 0) {
 		Ret = kEplSdoUdpThreadError;
 		goto Exit;
diff -puN drivers/staging/epl/ShbIpc-LinuxKernel.c~drivers-staging-epl-do-not-use-clone_sighand-with-allow_signal drivers/staging/epl/ShbIpc-LinuxKernel.c
--- a/drivers/staging/epl/ShbIpc-LinuxKernel.c~drivers-staging-epl-do-not-use-clone_sighand-with-allow_signal
+++ a/drivers/staging/epl/ShbIpc-LinuxKernel.c
@@ -532,8 +532,8 @@ tShbError ShbIpcStartSignalingNewData(tS
 
 	//create thread for signalling new data
 	pShbMemInst->m_tThreadNewDataId =
-	    kernel_thread(ShbIpcThreadSignalNewData, pShbInstance_p,
-			  CLONE_KERNEL);
+		kernel_thread(ShbIpcThreadSignalNewData, pShbInstance_p,
+				CLONE_FS | CLONE_FILES);
 
       Exit:
 	return ShbError;
@@ -636,8 +636,8 @@ tShbError ShbIpcStartSignalingJobReady(t
 	pShbMemHeader->m_fJobReady = FALSE;
 	//create thread for signalling new data
 	pShbMemInst->m_tThreadJobReadyId =
-	    kernel_thread(ShbIpcThreadSignalJobReady, pShbInstance_p,
-			  CLONE_KERNEL);
+		kernel_thread(ShbIpcThreadSignalJobReady, pShbInstance_p,
+				CLONE_FS | CLONE_FILES);
       Exit:
 	return ShbError;
 }
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
rcu_sched_grace_period-kill-the-bogus-flush_signals.patch
drivers-staging-epl-do-not-use-clone_sighand-with-allow_signal.patch
slow_work_thread-should-do-the-exclusive-wait.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
ptrace-remove-pt_dtrace-from-arch-h8300.patch
ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch
ptrace-remove-pt_dtrace-from-m68k-m68knommu.patch
ptrace-remove-pt_dtrace-from-arch-m32r.patch
ptrace-mm_need_new_owner-use-real_parent-to-search-in-the-siblings.patch
ptrace-tracehook_unsafe_exec-remove-the-stale-comment.patch
ptrace-tracehook_unsafe_exec-remove-the-stale-comment-fix.patch
ptrace-do-not-use-task-ptrace-directly-in-core-kernel.patch
copy_process-remove-the-unneeded-clear_tsk_thread_flagtif_sigpending.patch
elf_core_dump-use-rcu_read_lock-to-access-real_parent.patch
kthreads-simplify-the-startup-synchronization.patch
kthreads-rework-kthread_stop.patch
kthreads-simplify-migration_thread-exit-path.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch
signals-tracehook_notify_jctl-change.patch
utrace-core-kill-exclude_xtrace-logic.patch


From: akpm@linux-foundation.org
Subject: [merged] powerpc-eeh-remove-eeh_event_handler-daemonize.patch removed from -mm tree
Date: Tue, 03 Apr 2012 13:10:55 -0700
Message-ID: <20120403201055.7219AA0341@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:61093 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab2DCUK5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Apr 2012 16:10:57 -0400
Received: by wibhj13 with SMTP id hj13so4139wib.1
        for <mm-commits@vger.kernel.org>; Tue, 03 Apr 2012 13:10:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, benh@kernel.crashing.org, linasvepstas@gmail.com, matt.fleming@intel.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/eeh: remove eeh_event_handler()->daemonize()
has been removed from the -mm tree.  Its filename was
     powerpc-eeh-remove-eeh_event_handler-daemonize.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: powerpc/eeh: remove eeh_event_handler()->daemonize()

daemonize() is only needed when a user-space task does kernel_thread().

eeh_event_handler() thread is created by the worker kthread, and thus it
doesn't need the soon-to-be-deprecated daemonize().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Linas Vepstas <linasvepstas@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Matt Fleming <matt.fleming@intel.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/pseries/eeh_event.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/platforms/pseries/eeh_event.c~powerpc-eeh-remove-eeh_event_handler-daemonize arch/powerpc/platforms/pseries/eeh_event.c
--- a/arch/powerpc/platforms/pseries/eeh_event.c~powerpc-eeh-remove-eeh_event_handler-daemonize
+++ a/arch/powerpc/platforms/pseries/eeh_event.c
@@ -59,7 +59,7 @@ static int eeh_event_handler(void * dumm
 	struct eeh_event *event;
 	struct eeh_dev *edev;
 
-	daemonize("eehd");
+	set_task_comm(current, "eehd");
 	set_current_state(TASK_INTERRUPTIBLE);
 
 	spin_lock_irqsave(&eeh_eventlist_lock, flags);
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
sysrq-use-send_sig_forced-instead-of-force_sig.patch
alpha-use-set_current_blocked-and-block_sigmask.patch
c6x-use-set_current_blocked-and-block_sigmask.patch
avr32-dont-mask-signals-in-the-error-path.patch
avr32-use-set_current_blocked-in-handle_signal-sys_rt_sigreturn.patch
avr32-use-block_sigmask.patch
m32r-use-set_current_blocked-and-block_sigmask.patch
m68k-use-set_current_blocked-and-block_sigmask.patch
mn10300-use-set_current_blocked-and-block_sigmask.patch
cris-use-set_current_blocked-and-block_sigmask.patch
ia64-use-set_current_blocked-and-block_sigmask.patch
microblaze-dont-reimplement-force_sigsegv.patch
microblaze-no-need-to-reset-handler-if-sa_oneshot.patch
microblaze-fix-signal-masking.patch
microblaze-use-set_current_blocked-and-block_sigmask.patch
mips-use-set_current_blocked-and-block_sigmask.patch
score-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch
score-use-set_current_blocked-and-block_sigmask.patch
h8300-use-set_current_blocked-and-block_sigmask.patch
unicore32-use-block_sigmask.patch
blackfin-use-set_current_blocked-and-block_sigmask.patch
parisc-use-set_current_blocked-and-block_sigmask.patch
frv-use-set_current_blocked-and-block_sigmask.patch
kmod-unexport-call_usermodehelper_freeinfo.patch
kmod-convert-two-call-sites-to-call_usermodehelper_fns.patch
kmod-move-call_usermodehelper_fns-to-c-file-and-unexport-all-its-helpers.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch


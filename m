From: akpm@linux-foundation.org
Subject: + drivers-char-espc-fix-bootup-lockup.patch added to -mm tree
Date: Fri, 07 Mar 2008 02:36:28 -0800
Message-ID: <200803071036.m27AaS6V017808@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42720 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752591AbYCGKgq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2008 05:36:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, jirislaby@gmail.com


The patch titled
     drivers/char/esp.c: fix bootup lockup
has been added to the -mm tree.  Its filename is
     drivers-char-espc-fix-bootup-lockup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/esp.c: fix bootup lockup
From: Ingo Molnar <mingo@elte.hu>

randconfig testing found a bootup lockup in drivers/char/esp.c - find
the fix below. Not sure why it became more prominent in 2.6.25-rc4, the
bug seems rather old and i've been doing allyesconfig bootups for ages
with CONFIG_ESP enabled.

------------->
Subject: drivers/char/esp.c: fix bootup lockup
Date: Fri Mar 07 10:47:43 CET 2008

fix this bootup lockup:

 PM: Adding info for No Bus:ttyP63
 ttyP32 at 0x0240 (irq = 0) is an ESP primary port
 BUG: spinlock lockup on CPU#0, swapper/1, f56dd004
 Pid: 1, comm: swapper Not tainted 2.6.25-rc4-sched-devel.git-x86-latest.git #402 [<c03ac6f4>] _raw_spin_lock+0x134/0x140
  [<c08649be>] _spin_lock_irqsave+0x5e/0x80
  [<c0b9fbfe>] ? espserial_init+0x2be/0x6e0
  [<c0b9fbfe>] espserial_init+0x2be/0x6e0
  [<c0b877a3>] kernel_init+0x83/0x260
  [<c0b9f940>] ? espserial_init+0x0/0x6e0
  [<c010416a>] ? restore_nocheck_notrace+0x0/0xe
  [<c0b87720>] ? kernel_init+0x0/0x260
  [<c0b87720>] ? kernel_init+0x0/0x260
  [<c0104507>] kernel_thread_helper+0x7/0x10
  =======================

kzalloc() is not the way to initialize spinlocks anymore.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/esp.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/char/esp.c~drivers-char-espc-fix-bootup-lockup drivers/char/esp.c
--- a/drivers/char/esp.c~drivers-char-espc-fix-bootup-lockup
+++ a/drivers/char/esp.c
@@ -2484,6 +2484,7 @@ static int __init espserial_init(void)
 			return 0;
 		}
 
+		spin_lock_init(&info->lock);
 		/* rx_trigger, tx_trigger are needed by autoconfig */
 		info->config.rx_trigger = rx_trigger;
 		info->config.tx_trigger = tx_trigger;
_

Patches currently in -mm which might be from mingo@elte.hu are

typo-in-documentation-scheduler-sched-statstxt.patch
drivers-char-espc-fix-bootup-lockup.patch
git-x86.patch
arch-x86-kernel-ptracec-fix-defined-but-unused-warnings.patch
documentation-i386-io-apictxt-fix-description.patch
add-the-dff-desktop-form-factor-dell-optiplex-745-to-the-reboot-errata-list.patch
git-kgdb-light.patch
git-acpi-fixup.patch
git-hrt.patch
git-kvm.patch
git-sched.patch
execute-tasklets-in-the-same-order-they-were-queued.patch
git-semaphore.patch
git-semaphore-git-rejects.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
rcu-move-preempt_rcu-config-option-back-under-preempt.patch
x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
x86-fix-clearcopy_user_page-declarations-in-pageh.patch
x86-visws-fix-printk-format-warnings.patch
time-prevent-the-loop-in-timespec_add_ns-from-being-optimised-away.patch
time-dont-touch-an-offlined-cpus-ts-tick_stopped-in-tick_cancel_sched_timer.patch
taint-kernel-after-warn_oncondition.patch
add-rusage_thread.patch
proper-__do_softirq-prototype.patch
proper-extern-for-late_time_init.patch
x86-configurable-dmi-scanning-code.patch
cgroups-_s64-files-add-cgroups-read_s64-write_s64-file-methods.patch
cgroups-_s64-files-use-read_s64-write_s64-in-cfs-cgroup-for-rt_runtime-file.patch
simplify-cpu_hotplug_begin-put_online_cpus.patch
asm-futexh-should-include-linux-uaccessh.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch


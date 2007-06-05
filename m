From: akpm@linux-foundation.org
Subject: + lguest-the-guest-code-tsc-fix.patch added to -mm tree
Date: Tue, 05 Jun 2007 14:14:30 -0700
Message-ID: <200706052114.l55LEUOF003115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47195 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765846AbXFEVOj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2007 17:14:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au


The patch titled
     lguest: tsc fix
has been added to the -mm tree.  Its filename is
     lguest-the-guest-code-tsc-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest: tsc fix
From: Rusty Russell <rusty@rustcorp.com.au>

In recent -mm kernels, the TSC capability cannot be disabled, resulting in a
divide by zero error in the normal sched_clock.

The correct fix is to have a special lguest sched_clock implementation: this
is as simple as it gets.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/lguest.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff -puN drivers/lguest/lguest.c~lguest-the-guest-code-tsc-fix drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c~lguest-the-guest-code-tsc-fix
+++ a/drivers/lguest/lguest.c
@@ -352,13 +352,20 @@ static void lguest_time_irq(unsigned int
 	update_process_times(user_mode_vm(get_irq_regs()));
 }
 
+static u64 sched_clock_base;
 static void lguest_time_init(void)
 {
 	set_irq_handler(0, lguest_time_irq);
 	hcall(LHCALL_TIMER_READ, 0, 0, 0);
+	sched_clock_base = jiffies_64;
 	enable_lguest_irq(0);
 }
 
+static unsigned long long lguest_sched_clock(void)
+{
+	return (jiffies_64 - sched_clock_base) * (1000000000 / HZ);
+}
+
 static void lguest_load_esp0(struct tss_struct *tss,
 				     struct thread_struct *thread)
 {
@@ -491,6 +498,7 @@ __init void lguest_init(void)
 	paravirt_ops.time_init = lguest_time_init;
 	paravirt_ops.set_lazy_mode = lguest_lazy_mode;
 	paravirt_ops.wbinvd = lguest_wbinvd;
+	paravirt_ops.sched_clock = lguest_sched_clock;
 
 	hcall(LHCALL_LGUEST_INIT, __pa(&lguest_data), 0, 0);
 	strncpy(boot_command_line, boot->cmdline, COMMAND_LINE_SIZE);
@@ -506,8 +514,6 @@ __init void lguest_init(void)
 	/* Math is always hard! */
 	new_cpu_data.hard_math = 1;
 
-	tsc_disable = 1;
-
 #ifdef CONFIG_X86_MCE
 	mce_disabled = 1;
 #endif
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

git-kbuild.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
use-menuconfig-objects-ii-module-menu.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
define-new-percpu-interface-for-shared-data.patch
use-the-new-percpu-interface-for-shared-data.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-the-guest-code-tidyups.patch
lguest-the-guest-code-tidyups-update.patch
lguest-the-guest-code-update-for-mm-disable-tsc-dont-set-pge-bit.patch
lguest-speed-up-paravirt_lazy_flush-handling.patch
lguest-more-lazy_hcalls.patch
lguest-the-guest-code-tsc-fix.patch
lguest-the-host-code.patch
lguest-the-host-code-tidyups.patch
lguest-the-host-code-tidyups-update.patch
lguest-the-host-code-borkages.patch
lguest-faster-tls-switching.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-makefile-and-kconfig-tidyups.patch
lguest-the-console-driver.patch
lguest-the-console-driver-tidyups.patch
lguest-the-net-driver.patch
lguest-the-net-driver-tidyups.patch
lguest-the-net-driver-tidyups-update.patch
lguest-the-net-driver-include-fix.patch
lguest-the-block-driver.patch
lguest-the-block-driver-tidyups.patch
lguest-the-block-driver-tidyups-update.patch
lguest-the-documentation-example-launcher.patch
lguest-the-documentation-example-launcher-example-launcher-fix.patch
lguest-dont-signal-like-crazy-use-lhreq_break-command.patch
lguest-use-tsc.patch
lguest-use-hrtimers.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch

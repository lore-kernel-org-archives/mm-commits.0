From: akpm@linux-foundation.org
Subject: + softlockup-make-asm-irq_regsh-available-on-every-platform.patch added to -mm tree
Date: Tue, 17 Jul 2007 17:58:45 -0700
Message-ID: <200707180058.l6I0wjdM016595@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58837 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756334AbXGRA7G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 20:59:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, benh@kernel.crashing.org, galak@gate.crashing.org, paulus@samba.org, spyro@f2s.com, starvik@axis.com, uclinux-v850@lsi.nec.co.jp


The patch titled
     softlockup: make asm/irq_regs.h available on every platform
has been added to the -mm tree.  Its filename is
     softlockup-make-asm-irq_regsh-available-on-every-platform.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: softlockup: make asm/irq_regs.h available on every platform
From: Ingo Molnar <mingo@elte.hu>

The softlockup detector would like to use get_irq_regs(), so generalize the
availability on every Linux architecture.

(It is fine for an architecture to always return NULL to get_irq_regs(),
which it does by default.)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Ian Molton <spyro@f2s.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Miles Bader <uclinux-v850@lsi.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-arm26/irq_regs.h |    1 +
 include/asm-cris/irq_regs.h  |    1 +
 include/asm-ppc/irq_regs.h   |    1 +
 include/asm-v850/irq_regs.h  |    1 +
 4 files changed, 4 insertions(+)

diff -puN /dev/null include/asm-arm26/irq_regs.h
--- /dev/null
+++ a/include/asm-arm26/irq_regs.h
@@ -0,0 +1 @@
+#include <asm-generic/irq_regs.h>
diff -puN /dev/null include/asm-cris/irq_regs.h
--- /dev/null
+++ a/include/asm-cris/irq_regs.h
@@ -0,0 +1 @@
+#include <asm-generic/irq_regs.h>
diff -puN /dev/null include/asm-ppc/irq_regs.h
--- /dev/null
+++ a/include/asm-ppc/irq_regs.h
@@ -0,0 +1 @@
+#include <asm-generic/irq_regs.h>
diff -puN /dev/null include/asm-v850/irq_regs.h
--- /dev/null
+++ a/include/asm-v850/irq_regs.h
@@ -0,0 +1 @@
+#include <asm-generic/irq_regs.h>
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
git-acpi.patch
git-kvm.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
tick-management-spread-timer-interrupt.patch
highres-improve-debug-output.patch
hrtimer-speedup-hrtimer_enqueue.patch
pcspkr-use-the-global-pit-lock.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
i386-pit-stop-only-when-in-periodic-or-oneshot-mode.patch
i386-remove-volatile-in-apicc.patch
i386-hpet-assumes-boot-cpu-is-0.patch
i386-move-pit-function-declarations-and-constants-to-correct-header-file.patch
x86_64-untangle-asm-hpeth-from-asm-timexh.patch
x86_64-use-generic-cmos-update.patch
x86_64-remove-dead-code-and-other-janitor-work-in-tscc.patch
x86_64-fix-apic-typo.patch
x86_64-convert-to-cleckevents.patch
acpi-remove-the-useless-ifdef-code.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
ich-force-hpet-restructure-hpet-generic-clock-code.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
geode-mfgpt-clock-event-device-support.patch
i386-ioapic-remove-old-irq-balancing-debug-cruft.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
time-make-sure-sys_gettimeofday-and-sys_time-are-in.patch
fix-the-softlockup-watchdog-to-actually-work.patch
sys_time-use-barrier-instead-of-smp_rmb.patch
immunize-rcu_dereference-against-crazy-compiler-writers.patch
remove-workaround-for-unimmunized-rcu_dereference-from-mce_log.patch
fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats.patch
softlockup-make-asm-irq_regsh-available-on-every-platform.patch
softlockup-improve-debug-output.patch
softlockup-watchdog-style-cleanups.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
fix-raw_spinlock_t-vs-lockdep.patch
lockdep-sanitise-config_prove_locking.patch
lockdep-reduce-the-ifdeffery.patch
lockstat-core-infrastructure.patch
lockstat-human-readability-tweaks.patch
lockstat-hook-into-spinlock_t-rwlock_t-rwsem-and-mutex.patch
lockdep-various-fixes.patch
lockdep-fixup-sk_callback_lock-annotation.patch
lockstat-measure-lock-bouncing.patch
lockstat-better-class-name-representation.patch
lockdep-debugging-give-stacktrace-for-init_error.patch
stacktrace-fix-header-file-for-config_stacktrace.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
random-warning-squishes.patch

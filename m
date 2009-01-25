From: akpm@linux-foundation.org
Subject: + hrtimers-retrigger_next_event-needs-local-irqs-disabled.patch added to -mm tree
Date: Sat, 24 Jan 2009 18:42:31 -0800
Message-ID: <200901250242.n0P2gVAr024877@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753971AbZAYCnb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 24 Jan 2009 21:43:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, maciej.rutecki@gmail.com, mingo@elte.hu, rjw@sisk.pl, rusty@rustcorp.com.au, tglx@linutronix.de


The patch titled
     hrtimers: retrigger_next_event() needs local irqs disabled
has been added to the -mm tree.  Its filename is
     hrtimers-retrigger_next_event-needs-local-irqs-disabled.patch

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
Subject: hrtimers: retrigger_next_event() needs local irqs disabled
From: Andrew Morton <akpm@linux-foundation.org>

Maciej reports "BUG: using smp_processor_id() in preemptible" warnings.

The call to hrtimer_hres_active() fiddles with per-cpu things and needs to
be called non-preemtibly.  The chosen way for this function appears to be
via local_irq_disable().

Reported-by: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hrtimer.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN kernel/hrtimer.c~hrtimers-retrigger_next_event-needs-local-irqs-disabled kernel/hrtimer.c
--- a/kernel/hrtimer.c~hrtimers-retrigger_next_event-needs-local-irqs-disabled
+++ a/kernel/hrtimer.c
@@ -562,7 +562,7 @@ static int hrtimer_reprogram(struct hrti
 /*
  * Retrigger next event is called after clock was set
  *
- * Called with interrupts disabled via on_each_cpu()
+ * Called with interrupts disabled.
  */
 static void retrigger_next_event(void *arg)
 {
@@ -614,8 +614,12 @@ void clock_was_set(void)
  */
 void hres_timers_resume(void)
 {
+	unsigned long flags;
+
 	/* Retrigger the CPU local events: */
+	local_irq_save(flags);
 	retrigger_next_event(NULL);
+	local_irq_restore(flags);
 }
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kprobes-fix-module-compilation-error-with-config_kprobes=n.patch
i-need-old-gcc.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
x86-define-arch_want_frame_pointers-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
drivers-net-mlx4-profilec-fix-min-warning.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
regulator-minor-cleanup-of-virtual-consumer-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
hrtimers-retrigger_next_event-needs-local-irqs-disabled.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix-3-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch


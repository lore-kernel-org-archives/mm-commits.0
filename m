From: akpm@linux-foundation.org
Subject: + acpi-fix-pmtimer-overflow-which-makes-cx-states-time-incorrect-checkpatch-fixes.patch added to -mm tree
Date: Mon, 26 Jan 2009 22:53:31 -0800
Message-ID: <200901270653.n0R6rVaG016145@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751423AbZA0GyM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 01:54:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, alex.shi@intel.com, lenb@kernel.org, yakui.zhao@intel.com


The patch titled
     acpi-fix-pmtimer-overflow-which-makes-cx-states-time-incorrect-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     acpi-fix-pmtimer-overflow-which-makes-cx-states-time-incorrect-checkpatch-fixes.patch

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
Subject: acpi-fix-pmtimer-overflow-which-makes-cx-states-time-incorrect-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: space prohibited after that open parenthesis '('
#127: FILE: drivers/acpi/processor_idle.c:545:
+		sleep_ticks = US_TO_PM_TIMER_TICKS( idle_time);

ERROR: space prohibited after that open parenthesis '('
#156: FILE: drivers/acpi/processor_idle.c:611:
+		sleep_ticks = US_TO_PM_TIMER_TICKS( idle_time);

ERROR: space prohibited after that open parenthesis '('
#218: FILE: drivers/acpi/processor_idle.c:1535:
+	sleep_ticks = US_TO_PM_TIMER_TICKS( idle_time);

total: 3 errors, 0 warnings, 192 lines checked

./patches/acpi-fix-pmtimer-overflow-which-makes-cx-states-time-incorrect.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alex Shi <alex.shi@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Yakui.zhao <yakui.zhao@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_idle.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/acpi/processor_idle.c~acpi-fix-pmtimer-overflow-which-makes-cx-states-time-incorrect-checkpatch-fixes drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~acpi-fix-pmtimer-overflow-which-makes-cx-states-time-incorrect-checkpatch-fixes
+++ a/drivers/acpi/processor_idle.c
@@ -542,7 +542,7 @@ static void acpi_processor_idle(void)
 			mark_tsc_unstable("possible TSC halt in C2");
 #endif
 		/* Compute time (ticks) that we were actually asleep */
-		sleep_ticks = US_TO_PM_TIMER_TICKS( idle_time);
+		sleep_ticks = US_TO_PM_TIMER_TICKS(idle_time);
 
 		/* Tell the scheduler how much we idled: */
 		sched_clock_idle_wakeup_event(sleep_ticks*PM_TIMER_TICK_NS);
@@ -608,7 +608,7 @@ static void acpi_processor_idle(void)
 			mark_tsc_unstable("TSC halts in C3");
 #endif
 		/* Compute time (ticks) that we were actually asleep */
-		sleep_ticks = US_TO_PM_TIMER_TICKS( idle_time);
+		sleep_ticks = US_TO_PM_TIMER_TICKS(idle_time);
 		/* Tell the scheduler how much we idled: */
 		sched_clock_idle_wakeup_event(sleep_ticks*PM_TIMER_TICK_NS);
 
@@ -1532,7 +1532,7 @@ static int acpi_idle_enter_simple(struct
 	if (tsc_halts_in_c(cx->type))
 		mark_tsc_unstable("TSC halts in idle");;
 #endif
-	sleep_ticks = US_TO_PM_TIMER_TICKS( idle_time);
+	sleep_ticks = US_TO_PM_TIMER_TICKS(idle_time);
 
 	/* Tell the scheduler how much we idled: */
 	sched_clock_idle_wakeup_event(sleep_ticks*PM_TIMER_TICK_NS);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kprobes-fix-module-compilation-error-with-config_kprobes=n.patch
i-need-old-gcc.patch
linux-next.patch
next-remove-localversion.patch
acpi-fix-pmtimer-overflow-which-makes-cx-states-time-incorrect-checkpatch-fixes.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
x86-define-arch_want_frame_pointers-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
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


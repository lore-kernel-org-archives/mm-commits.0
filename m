From: akpm@linux-foundation.org
Subject: + lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic.patch added to -mm tree
Date: Wed, 27 Jun 2007 14:21:38 -0700
Message-ID: <200706272121.l5RLLchA007379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47830 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753281AbXF0VW0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jun 2007 17:22:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, rusty@rustcorp.com.au


The patch titled
     lguest vs clockevents-fix-resume-logic
has been added to the -mm tree.  Its filename is
     lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest vs clockevents-fix-resume-logic
From: Thomas Gleixner <tglx@linutronix.de>

On Wed, 2007-06-27 at 00:01 -0700, Andrew Morton wrote:
> arch/i386/xen/time.c: In function 'xen_vcpuop_set_mode':
> arch/i386/xen/time.c:457: warning: enumeration value 'CLOCK_EVT_MODE_RESUME' not handled in switch

Fixup lguest clock event device.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/lguest.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN drivers/lguest/lguest.c~lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c~lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic
+++ a/drivers/lguest/lguest.c
@@ -390,6 +390,8 @@ static void lguest_clockevent_set_mode(e
 		break;
 	case CLOCK_EVT_MODE_PERIODIC:
 		BUG();
+	case CLOCK_EVT_MODE_RESUME:
+		break;
 	}
 }
 
_

Patches currently in -mm which might be from tglx@linutronix.de are

git-acpi-add-exports.patch
git-arm.patch
i386-hpet-check-if-the-counter-works.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown.patch
timekeeping-fixup-shadow-variable-argument.patch
timerc-cleanup-recently-introduced-whitespace-damage.patch
clockevents-remove-prototypes-of-removed-functions.patch
clockevents-fix-resume-logic.patch
clockevents-fix-device-replacement.patch
tick-management-spread-timer-interrupt.patch
highres-improve-debug-output.patch
highres-improve-debug-output-fix.patch
hrtimer-speedup-hrtimer_enqueue.patch
pcspkr-use-the-global-pit-lock.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
ntp-move-the-cmos-update-code-into-ntpc-fix.patch
ntp-move-the-cmos-update-code-into-ntpc-fix-fix.patch
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
ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
ich-force-hpet-restructure-hpet-generic-clock-code.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
remove-clockevents_releaserequest_device.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
improve-behaviour-of-spurious-irq-detect.patch
improve-behaviour-of-spurious-irq-detect-fix.patch
sys_time-speedup.patch
futex-tidy-up-the-code-v2.patch
lguest-the-host-code.patch
lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic.patch

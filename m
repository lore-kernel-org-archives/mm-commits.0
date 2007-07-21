From: akpm@linux-foundation.org
Subject: - lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic.patch removed from -mm tree
Date: Sat, 21 Jul 2007 04:34:01 -0700
Message-ID: <200707211134.l6LBY15B014235@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33505 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932859AbXGULen (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 21 Jul 2007 07:34:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest vs clockevents-fix-resume-logic
has been removed from the -mm tree.  Its filename was
     lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic.patch

This patch was dropped because it was folded into clockevents-fix-resume-logic.patch

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
 1 file changed, 2 insertions(+)

diff -puN drivers/lguest/lguest.c~lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c~lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic
+++ a/drivers/lguest/lguest.c
@@ -398,6 +398,8 @@ static void lguest_clockevent_set_mode(e
 		break;
 	case CLOCK_EVT_MODE_PERIODIC:
 		BUG();
+	case CLOCK_EVT_MODE_RESUME:
+		break;
 	}
 }
 
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
clockevents-remove-prototypes-of-removed-functions.patch
clockevents-fix-resume-logic.patch
lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic.patch
clockevents-fix-device-replacement.patch
tick-management-spread-timer-interrupt.patch
highres-improve-debug-output.patch
hrtimer-speedup-hrtimer_enqueue.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
i386-pit-stop-only-when-in-periodic-or-oneshot-mode.patch

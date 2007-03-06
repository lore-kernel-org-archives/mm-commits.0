From: akpm@linux-foundation.org
Subject: - tick-management-dyntick--highres-functionality-fix.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:01:21 -0800
Message-ID: <200703060101.l2611L8u007057@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43878 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932836AbXCFBBh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:01:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     tick-management touch softlockup watchdog on resume
has been removed from the -mm tree.  Its filename was
     tick-management-dyntick--highres-functionality-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: tick-management touch softlockup watchdog on resume
From: Thomas Gleixner <tglx@linutronix.de>

The softlockup watchdog needs to be touched after resume to avoid a false
positive.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/time/tick-common.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN kernel/time/tick-common.c~tick-management-dyntick--highres-functionality-fix kernel/time/tick-common.c
--- a/kernel/time/tick-common.c~tick-management-dyntick--highres-functionality-fix
+++ a/kernel/time/tick-common.c
@@ -312,6 +312,7 @@ static int tick_notify(struct notifier_b
 
 	case CLOCK_EVT_NOTIFY_RESUME:
 		tick_resume_jiffy_update();
+		touch_softlockup_watchdog();
 		break;
 
 	case CLOCK_EVT_NOTIFY_CPU_DEAD:
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
bugfix-dont-use-the-tsc-in-sched_clock-if-unstable.patch
cleanup-unify-tsc_unstable-and-tsc_disable.patch
possible-bugfix-make-dmi_mark_tsc_unstable-call-mark_tsc_unstable.patch
log-reason-why-tsc-was-marked-unstable.patch
optimize-timespec_trunc.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch

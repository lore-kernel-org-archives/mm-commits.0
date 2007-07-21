From: akpm@linux-foundation.org
Subject: - clockevents-fix-resume-logic-xen-fix.patch removed from -mm tree
Date: Sat, 21 Jul 2007 04:33:25 -0700
Message-ID: <200707211133.l6LBXPva014206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52529 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937564AbXGULeI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 21 Jul 2007 07:34:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jeremy@goop.org, johnstul@us.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     clockevents-fix-resume-logic-xen-fix
has been removed from the -mm tree.  Its filename was
     clockevents-fix-resume-logic-xen-fix.patch

This patch was dropped because it was folded into clockevents-fix-resume-logic.patch

------------------------------------------------------
Subject: clockevents-fix-resume-logic-xen-fix
From: Andrew Morton <akpm@linux-foundation.org>

arch/i386/xen/time.c: In function 'xen_vcpuop_set_mode':
arch/i386/xen/time.c:462: warning: enumeration value 'CLOCK_EVT_MODE_RESUME' not handled in switch

Is this right?

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/xen/time.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/i386/xen/time.c~clockevents-fix-resume-logic-xen-fix arch/i386/xen/time.c
--- a/arch/i386/xen/time.c~clockevents-fix-resume-logic-xen-fix
+++ a/arch/i386/xen/time.c
@@ -475,6 +475,8 @@ static void xen_vcpuop_set_mode(enum clo
 		    HYPERVISOR_vcpu_op(VCPUOP_stop_periodic_timer, cpu, NULL))
 			BUG();
 		break;
+	case CLOCK_EVT_MODE_RESUME:
+		break;
 	}
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-pie-randomization.patch
clockevents-fix-resume-logic.patch
clockevents-fix-resume-logic-xen-fix.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
rtc-add-support-for-stk17ta8-chip-fix.patch

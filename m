From: akpm@linux-foundation.org
Subject: - hrtimers-fix-hrtimer_cb_irqsafe_no_softirq-description.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:21:12 -0800
Message-ID: <200703070421.l274LCKV018878@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47024 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161305AbXCGEV3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:21:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@debian.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     hrtimers: fix HRTIMER_CB_IRQSAFE_NO_SOFTIRQ description
has been removed from the -mm tree.  Its filename was
     hrtimers-fix-hrtimer_cb_irqsafe_no_softirq-description.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hrtimers: fix HRTIMER_CB_IRQSAFE_NO_SOFTIRQ description
From: Andres Salomon <dilinger@debian.org>

The description for HRTIMER_CB_IRQSAFE_NO_SOFTIRQ is backwards; "NO
SOFTIRQ" sounds a whole lot like it means it must not be run in a softirq.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hrtimer.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/hrtimer.h~hrtimers-fix-hrtimer_cb_irqsafe_no_softirq-description include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~hrtimers-fix-hrtimer_cb_irqsafe_no_softirq-description
+++ a/include/linux/hrtimer.h
@@ -47,7 +47,7 @@ enum hrtimer_restart {
  *	HRTIMER_CB_IRQSAFE:		Callback may run in hardirq context
  *	HRTIMER_CB_IRQSAFE_NO_RESTART:	Callback may run in hardirq context and
  *					does not restart the timer
- *	HRTIMER_CB_IRQSAFE_NO_SOFTIRQ:	Callback must run in softirq context
+ *	HRTIMER_CB_IRQSAFE_NO_SOFTIRQ:	Callback must run in hardirq context
  *					Special mode for tick emultation
  */
 enum hrtimer_cb_mode {
_

Patches currently in -mm which might be from dilinger@debian.org are

origin.patch

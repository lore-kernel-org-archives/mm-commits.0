From: akpm@linux-foundation.org
Subject: + hrtimers-fix-hrtimer_cb_irqsafe_no_softirq-description.patch added to -mm tree
Date: Mon, 05 Mar 2007 19:19:48 -0800
Message-ID: <200703060319.l263JmcB010487@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48695 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933901AbXCFDT5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 22:19:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@debian.org, mingo@elte.hu, tglx@linutronix.de


The patch titled
     hrtimers: fix HRTIMER_CB_IRQSAFE_NO_SOFTIRQ description
has been added to the -mm tree.  Its filename is
     hrtimers-fix-hrtimer_cb_irqsafe_no_softirq-description.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

i386-make-x86_64-tsc-header-require-i386-rather-than-vice-versa.patch
hrtimers-fix-hrtimer_cb_irqsafe_no_softirq-description.patch
hrtimers-hrtimer_clock_base-description-typo.patch

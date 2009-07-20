From: akpm@linux-foundation.org
Subject: + pm-irq-fix-comment-describing-suspend_device_irqs.patch added to -mm tree
Date: Mon, 20 Jul 2009 12:58:55 -0700
Message-ID: <200907201958.n6KJwt6u006976@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751020AbZGTT67 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jul 2009 15:58:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl


The patch titled
     PM/irq: fix comment describing suspend_device_irqs()
has been added to the -mm tree.  Its filename is
     pm-irq-fix-comment-describing-suspend_device_irqs.patch

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
Subject: PM/irq: fix comment describing suspend_device_irqs()
From: Rafael J. Wysocki <rjw@sisk.pl>

The kerneldoc comment describing suspend_device_irqs() is currently
misleading, because generally the function doesn't really disable
interrupt lines at the chip level.  Replace it with a more accurate one.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/pm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/irq/pm.c~pm-irq-fix-comment-describing-suspend_device_irqs kernel/irq/pm.c
--- a/kernel/irq/pm.c~pm-irq-fix-comment-describing-suspend_device_irqs
+++ a/kernel/irq/pm.c
@@ -15,10 +15,10 @@
 /**
  * suspend_device_irqs - disable all currently enabled interrupt lines
  *
- * During system-wide suspend or hibernation device interrupts need to be
- * disabled at the chip level and this function is provided for this purpose.
- * It disables all interrupt lines that are enabled at the moment and sets the
- * IRQ_SUSPENDED flag for them.
+ * During system-wide suspend or hibernation device drivers need to be prevented
+ * from receiving interrupts and this function is provided for this purpose.
+ * It marks all interrupt lines in use, except for the timer ones, as disabled
+ * and sets the IRQ_SUSPENDED flag for each of them.
  */
 void suspend_device_irqs(void)
 {
_

Patches currently in -mm which might be from rjw@sisk.pl are

linux-next.patch
pm-irq-fix-comment-describing-suspend_device_irqs.patch
genirq-do-not-disable-irq_wakeup-marked-irqs-on-suspend.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch


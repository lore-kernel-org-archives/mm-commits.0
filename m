From: akpm@linux-foundation.org
Subject: [merged] pm-irq-fix-comment-describing-suspend_device_irqs.patch removed from -mm tree
Date: Fri, 24 Jul 2009 13:39:40 -0700
Message-ID: <200907242039.n6OKdeUi009401@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753868AbZGXUkS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Jul 2009 16:40:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     PM/irq: fix comment describing suspend_device_irqs()
has been removed from the -mm tree.  Its filename was
     pm-irq-fix-comment-describing-suspend_device_irqs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
genirq-do-not-disable-irq_wakeup-marked-irqs-on-suspend.patch


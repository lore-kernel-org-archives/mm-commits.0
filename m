From: akpm@linux-foundation.org
Subject: [merged]
 drivers-rtc-interfacec-return-ebusy-not-eacces-when-device-is-busy.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:35:12 -0700
Message-ID: <51db1470.U30xSjmk8fKk9c+X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51419 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab3GHTfN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:35:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, a.zummo@towertech.it, chris.brand@broadcom.com

Subject: [merged] drivers-rtc-interfacec-return-ebusy-not-eacces-when-device-is-busy.patch removed from -mm tree
To: chris.brand@broadcom.com,a.zummo@towertech.it,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:35:12 -0700


The patch titled
     Subject: drivers/rtc/interface.c: return -EBUSY, not -EACCES when device is busy
has been removed from the -mm tree.  Its filename was
     drivers-rtc-interfacec-return-ebusy-not-eacces-when-device-is-busy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chris Brand <chris.brand@broadcom.com>
Subject: drivers/rtc/interface.c: return -EBUSY, not -EACCES when device is busy

If rtc->irq_task is non-NULL and task is NULL, they always
rtc_irq_set_freq(), whenever err is set to -EBUSY it will then immediately
be set to -EACCES, misleading the caller as to the underlying problem.

Signed-off-by: Chris Brand <chris.brand@broadcom.com>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/interface.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/interface.c~drivers-rtc-interfacec-return-ebusy-not-eacces-when-device-is-busy drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~drivers-rtc-interfacec-return-ebusy-not-eacces-when-device-is-busy
+++ a/drivers/rtc/interface.c
@@ -698,9 +698,9 @@ retry:
 	spin_lock_irqsave(&rtc->irq_task_lock, flags);
 	if (rtc->irq_task != NULL && task == NULL)
 		err = -EBUSY;
-	if (rtc->irq_task != task)
+	else if (rtc->irq_task != task)
 		err = -EACCES;
-	if (!err) {
+	else {
 		if (rtc_update_hrtimer(rtc, enabled) < 0) {
 			spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
 			cpu_relax();
@@ -734,9 +734,9 @@ retry:
 	spin_lock_irqsave(&rtc->irq_task_lock, flags);
 	if (rtc->irq_task != NULL && task == NULL)
 		err = -EBUSY;
-	if (rtc->irq_task != task)
+	else if (rtc->irq_task != task)
 		err = -EACCES;
-	if (!err) {
+	else {
 		rtc->irq_freq = freq;
 		if (rtc->pie_enabled && rtc_update_hrtimer(rtc, 1) < 0) {
 			spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
_

Patches currently in -mm which might be from chris.brand@broadcom.com are

origin.patch


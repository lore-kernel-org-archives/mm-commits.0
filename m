From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-interfacec-return-ebusy-not-eacces-when-device-is-busy.patch
 added to -mm tree
Date: Mon, 10 Jun 2013 16:09:59 -0700
Message-ID: <51b65cc7.Q7MNarmNOf9u25Ud%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60552 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab3FJXKA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jun 2013 19:10:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, a.zummo@towertech.it, chris.brand@broadcom.com

Subject: + drivers-rtc-interfacec-return-ebusy-not-eacces-when-device-is-busy.patch added to -mm tree
To: chris.brand@broadcom.com,a.zummo@towertech.it
From: akpm@linux-foundation.org
Date: Mon, 10 Jun 2013 16:09:59 -0700


The patch titled
     Subject: drivers/rtc/interface.c: return -EBUSY, not -EACCES when device is busy
has been added to the -mm tree.  Its filename is
     drivers-rtc-interfacec-return-ebusy-not-eacces-when-device-is-busy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

drivers-rtc-interfacec-return-ebusy-not-eacces-when-device-is-busy.patch


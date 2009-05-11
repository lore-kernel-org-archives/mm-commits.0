From: akpm@linux-foundation.org
Subject: + mfd-pcf50633-fix-unsafe-disable_irq.patch added to -mm tree
Date: Mon, 11 May 2009 13:25:24 -0700
Message-ID: <200905112025.n4BKPO3O026754@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753439AbZEKUaN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 May 2009 16:30:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arhuaco@freaks-unidos.net, balajirrao@openmoko.org, mingo@elte.hu, sameo@openedhand.com, tglx@linutronix.de


The patch titled
     mfd: pcf50633: fix unsafe disable_irq()
has been added to the -mm tree.  Its filename is
     mfd-pcf50633-fix-unsafe-disable_irq.patch

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
Subject: mfd: pcf50633: fix unsafe disable_irq()
From: Nelson Castillo <arhuaco@freaks-unidos.net>

Without this change Openmoko Freerunner (GTA02) bootstrap will deadlock. 
As pointed out in other patches this issue is in the wild since the merge
of:

: commit 3aa551c9b4c40018f0e261a178e3d25478dc04a9
: Author: Thomas Gleixner <tglx@linutronix.de>
: Date:   Mon Mar 23 18:28:15 2009 +0100
: 
:    genirq: add threaded interrupt handler support
: 
:    Add support for threaded interrupt handlers

Signed-off-by: Nelson Castillo <arhuaco@freaks-unidos.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: <balajirrao@openmoko.org>
Cc: Samuel Ortiz <sameo@openedhand.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/pcf50633-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mfd/pcf50633-core.c~mfd-pcf50633-fix-unsafe-disable_irq drivers/mfd/pcf50633-core.c
--- a/drivers/mfd/pcf50633-core.c~mfd-pcf50633-fix-unsafe-disable_irq
+++ a/drivers/mfd/pcf50633-core.c
@@ -443,7 +443,7 @@ static irqreturn_t pcf50633_irq(int irq,
 	dev_dbg(pcf->dev, "pcf50633_irq\n");
 
 	get_device(pcf->dev);
-	disable_irq(pcf->irq);
+	disable_irq_nosync(pcf->irq);
 	schedule_work(&pcf->irq_work);
 
 	return IRQ_HANDLED;
_

Patches currently in -mm which might be from arhuaco@freaks-unidos.net are

mfd-pcf50633-fix-unsafe-disable_irq.patch


From: akpm@linux-foundation.org
Subject: [merged] mfd-pcf50633-fix-unsafe-disable_irq.patch removed from -mm tree
Date: Sun, 17 May 2009 09:54:40 -0700
Message-ID: <200905171654.n4HGseP7017290@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752461AbZEQQ5q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 17 May 2009 12:57:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arhuaco@freaks-unidos.net, balajirrao@openmoko.org, mingo@elte.hu, sameo@openedhand.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     mfd: pcf50633: fix unsafe disable_irq()
has been removed from the -mm tree.  Its filename was
     mfd-pcf50633-fix-unsafe-disable_irq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch


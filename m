From: akpm@linux-foundation.org
Subject: [merged]
 drivers-input-misc-da9055_onkeyc-remove-use-of-regmap_irq_get_virq.patch
 removed from -mm tree
Date: Tue, 22 Apr 2014 11:00:47 -0700
Message-ID: <5356ae4f.6OIW/Ph4PmoGoCEE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47387 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933011AbaDVSAt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Apr 2014 14:00:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dmitry.torokhov@gmail.com, a.zummo@towertech.it, Adam.Thomson.Opensource@diasemi.com

Subject: [merged] drivers-input-misc-da9055_onkeyc-remove-use-of-regmap_irq_get_virq.patch removed from -mm tree
To: Adam.Thomson.Opensource@diasemi.com,a.zummo@towertech.it,dmitry.torokhov@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 22 Apr 2014 11:00:47 -0700


The patch titled
     Subject: drivers/input/misc/da9055_onkey.c: remove use of regmap_irq_get_virq()
has been removed from the -mm tree.  Its filename was
     drivers-input-misc-da9055_onkeyc-remove-use-of-regmap_irq_get_virq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Subject: drivers/input/misc/da9055_onkey.c: remove use of regmap_irq_get_virq()

Using platform_get_irq_byname() to retrieve the IRQ number returns the
VIRQ number rather than the local IRQ number for the device.  Passing that
value then into regmap_irq_get_virq() causes a failure because the
function is expecting the local IRQ number (e.g.  0, 1, 2, 3, etc).

This patch removes use of regmap_irq_get_virq() to prevent this failure
from happening.

Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/misc/da9055_onkey.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/input/misc/da9055_onkey.c~drivers-input-misc-da9055_onkeyc-remove-use-of-regmap_irq_get_virq drivers/input/misc/da9055_onkey.c
--- a/drivers/input/misc/da9055_onkey.c~drivers-input-misc-da9055_onkeyc-remove-use-of-regmap_irq_get_virq
+++ a/drivers/input/misc/da9055_onkey.c
@@ -109,7 +109,6 @@ static int da9055_onkey_probe(struct pla
 
 	INIT_DELAYED_WORK(&onkey->work, da9055_onkey_work);
 
-	irq = regmap_irq_get_virq(da9055->irq_data, irq);
 	err = request_threaded_irq(irq, NULL, da9055_onkey_irq,
 				   IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
 				   "ONKEY", onkey);
_

Patches currently in -mm which might be from Adam.Thomson.Opensource@diasemi.com are

linux-next.patch


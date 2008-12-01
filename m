From: akpm@linux-foundation.org
Subject: - input-touchscreen-driver-add-support-ad7877-touchscreen-driver-fix.patch removed from -mm tree
Date: Mon, 01 Dec 2008 14:18:47 -0800
Message-ID: <200812012218.mB1MIljX011724@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54849 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752845AbYLAWZR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Dec 2008 17:25:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.hennerich@analog.com, cooloney@kernel.org, dmitry.torokhov@gmail.com, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     input: AD7877 driver fixup
has been removed from the -mm tree.  Its filename was
     input-touchscreen-driver-add-support-ad7877-touchscreen-driver-fix.patch

This patch was dropped because it was folded into input-touchscreen-driver-add-support-ad7877-touchscreen-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: AD7877 driver fixup
From: Michael Hennerich <michael.hennerich@analog.com>

 - Test flag with spinlock hold

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/ad7877.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff -puN drivers/input/touchscreen/ad7877.c~input-touchscreen-driver-add-support-ad7877-touchscreen-driver-fix drivers/input/touchscreen/ad7877.c
--- a/drivers/input/touchscreen/ad7877.c~input-touchscreen-driver-add-support-ad7877-touchscreen-driver-fix
+++ a/drivers/input/touchscreen/ad7877.c
@@ -388,10 +388,11 @@ static irqreturn_t ad7877_irq(int irq, v
 	 * doesn't get issued twice while in work.
 	 */
 
-	if (ts->pending)
-		return IRQ_HANDLED;
-
 	spin_lock_irqsave(&ts->lock, flags);
+	if (ts->pending) {
+		spin_unlock_irqrestore(&ts->lock, flags);
+		return IRQ_HANDLED;
+	}
 	ts->pending = 1;
 	spin_unlock_irqrestore(&ts->lock, flags);
 
@@ -420,10 +421,12 @@ static void ad7877_disable(struct ad7877
 {
 	unsigned long flags;
 
-	if (ts->disabled)
+	spin_lock_irqsave(&ts->lock, flags);
+	if (ts->disabled) {
+		spin_unlock_irqrestore(&ts->lock, flags);
 		return;
+	}
 
-	spin_lock_irqsave(&ts->lock, flags);
 	ts->disabled = 1;
 	disable_irq(ts->spi->irq);
 	spin_unlock_irqrestore(&ts->lock, flags);
@@ -443,10 +446,11 @@ static void ad7877_enable(struct ad7877 
 {
 	unsigned long flags;
 
-	if (!ts->disabled)
-		return;

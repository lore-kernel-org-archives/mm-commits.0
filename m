From: akpm@linux-foundation.org
Subject: [merged] spi_mpc83xx-remove-dead-code.patch removed from -mm tree
Date: Mon, 22 Jun 2009 10:00:17 -0700
Message-ID: <200906221700.n5MH0HKX009584@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34451 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754406AbZFVRC0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jun 2009 13:02:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, benh@kernel.crashing.org, david-b@pacbell.net, galak@gate.crashing.org, mm-commits@vger.kernel.org


The patch titled
     spi_mpc83xx: remove dead code
has been removed from the -mm tree.  Its filename was
     spi_mpc83xx-remove-dead-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi_mpc83xx: remove dead code
From: Anton Vorontsov <avorontsov@ru.mvista.com>

This patch removes #if 0'ed code, and spi_mpc83xx->busy variable that is
used by that dead snippet only.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: David Brownell <david-b@pacbell.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_mpc83xx.c |   17 -----------------
 1 file changed, 17 deletions(-)

diff -puN drivers/spi/spi_mpc83xx.c~spi_mpc83xx-remove-dead-code drivers/spi/spi_mpc83xx.c
--- a/drivers/spi/spi_mpc83xx.c~spi_mpc83xx-remove-dead-code
+++ a/drivers/spi/spi_mpc83xx.c
@@ -98,8 +98,6 @@ struct mpc83xx_spi {
 
 	bool qe_mode;
 
-	u8 busy;
-
 	struct workqueue_struct *workqueue;
 	struct work_struct work;
 
@@ -411,7 +409,6 @@ static void mpc83xx_spi_work(struct work
 						       work);
 
 	spin_lock_irq(&mpc83xx_spi->lock);
-	mpc83xx_spi->busy = 1;
 	while (!list_empty(&mpc83xx_spi->queue)) {
 		struct spi_message *m = container_of(mpc83xx_spi->queue.next,
 						   struct spi_message, queue);
@@ -423,7 +420,6 @@ static void mpc83xx_spi_work(struct work
 
 		spin_lock_irq(&mpc83xx_spi->lock);
 	}
-	mpc83xx_spi->busy = 0;
 	spin_unlock_irq(&mpc83xx_spi->lock);
 }
 
@@ -465,19 +461,6 @@ static int mpc83xx_spi_setup(struct spi_
 		cs->hw_mode = hw_mode; /* Restore settings */
 		return retval;
 	}
-
-#if 0 /* Don't think this is needed */
-	/* NOTE we _need_ to call chipselect() early, ideally with adapter
-	 * setup, unless the hardware defaults cooperate to avoid confusion
-	 * between normal (active low) and inverted chipselects.
-	 */

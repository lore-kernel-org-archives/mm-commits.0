From: akpm@linux-foundation.org
Subject: + spi_mpc83xx-remove-dead-code.patch added to -mm tree
Date: Mon, 04 May 2009 13:56:23 -0700
Message-ID: <200905042056.n44KuNbM016882@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755236AbZEDVAI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 17:00:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, benh@kernel.crashing.org, david-b@pacbell.net, galak@gate.crashing.org


The patch titled
     spi_mpc83xx: remove dead code
has been added to the -mm tree.  Its filename is
     spi_mpc83xx-remove-dead-code.patch

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
-
-	/* deselect chip (low or high) */
-	spin_lock(&mpc83xx_spi->lock);
-	if (!mpc83xx_spi->busy)
-		mpc83xx_spi_chipselect(spi, BITBANG_CS_INACTIVE);
-	spin_unlock(&mpc83xx_spi->lock);
-#endif
 	return 0;
 }
 
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

linux-next.patch
mpc52xx_psc_spi-convert-to-cs_control-callback.patch
spi_mpc83xx-handle-other-freescale-processors.patch
spi_mpc83xx-quieten-down-the-requested-speed-is-too-low-message.patch
spi_mpc83xx-add-small-delay-after-asserting-chip-select-line.patch
powerpc-86xx-add-mmc-spi-support-for-mpc8610hpcd-boards.patch
spi_mpc83xx-fix-checkpatch-issues.patch
spi_mpc83xx-split-mpc83xx_spi_work-into-two-routines.patch
spi_mpc83xx-remove-dead-code.patch
spi_mpc83xx-rename-spi_83xxc-to-spi_8xxxc.patch
spi_mpc8xxx-s-83xx-8xxx-g.patch


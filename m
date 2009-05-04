From: akpm@linux-foundation.org
Subject: + spi_mpc83xx-split-mpc83xx_spi_work-into-two-routines.patch added to -mm tree
Date: Mon, 04 May 2009 13:56:21 -0700
Message-ID: <200905042056.n44KuLlc016797@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47702 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754074AbZEDVAJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 17:00:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, benh@kernel.crashing.org, david-b@pacbell.net, galak@gate.crashing.org


The patch titled
     spi_mpc83xx: split mpc83xx_spi_work() into two routines
has been added to the -mm tree.  Its filename is
     spi_mpc83xx-split-mpc83xx_spi_work-into-two-routines.patch

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
Subject: spi_mpc83xx: split mpc83xx_spi_work() into two routines
From: Anton Vorontsov <avorontsov@ru.mvista.com>

mpc83xx_spi_work() is quite large, with up to five indentation levels and
is quite difficult to read.

So, split the function in two parts:
1. mpc83xx_spi_work() now only traverse queued spi messages;
2. mpc83xx_spi_do_one_msg() only manages single messages.

There should be no functional changes.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: David Brownell <david-b@pacbell.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_mpc83xx.c |  115 ++++++++++++++++++------------------
 1 file changed, 60 insertions(+), 55 deletions(-)

diff -puN drivers/spi/spi_mpc83xx.c~spi_mpc83xx-split-mpc83xx_spi_work-into-two-routines drivers/spi/spi_mpc83xx.c
--- a/drivers/spi/spi_mpc83xx.c~spi_mpc83xx-split-mpc83xx_spi_work-into-two-routines
+++ a/drivers/spi/spi_mpc83xx.c
@@ -350,71 +350,76 @@ static int mpc83xx_spi_bufs(struct spi_d
 	return mpc83xx_spi->count;
 }
 
-static void mpc83xx_spi_work(struct work_struct *work)
+static void mpc83xx_spi_do_one_msg(struct spi_message *m)
 {
-	struct mpc83xx_spi *mpc83xx_spi =
-		container_of(work, struct mpc83xx_spi, work);
-
-	spin_lock_irq(&mpc83xx_spi->lock);
-	mpc83xx_spi->busy = 1;
-	while (!list_empty(&mpc83xx_spi->queue)) {
-		struct spi_message *m;
-		struct spi_device *spi;
-		struct spi_transfer *t = NULL;
-		unsigned cs_change;
-		int status, nsecs = 50;
-
-		m = container_of(mpc83xx_spi->queue.next,
-				struct spi_message, queue);
-		list_del_init(&m->queue);
-		spin_unlock_irq(&mpc83xx_spi->lock);
-
-		spi = m->spi;
-		cs_change = 1;
-		status = 0;
-		list_for_each_entry(t, &m->transfers, transfer_list) {
-			if (t->bits_per_word || t->speed_hz) {
-				/* Don't allow changes if CS is active */
-				status = -EINVAL;
-
-				if (cs_change)
-					status = mpc83xx_spi_setup_transfer(spi, t);
-				if (status < 0)
-					break;
-			}
-
-			if (cs_change) {
-				mpc83xx_spi_chipselect(spi, BITBANG_CS_ACTIVE);
-				ndelay(nsecs);
-			}
-			cs_change = t->cs_change;
-			if (t->len)
-				status = mpc83xx_spi_bufs(spi, t);
-			if (status) {
-				status = -EMSGSIZE;
+	struct spi_device *spi = m->spi;
+	struct spi_transfer *t;
+	unsigned int cs_change;
+	const int nsecs = 50;
+	int status;
+
+	cs_change = 1;
+	status = 0;
+	list_for_each_entry(t, &m->transfers, transfer_list) {
+		if (t->bits_per_word || t->speed_hz) {
+			/* Don't allow changes if CS is active */
+			status = -EINVAL;
+
+			if (cs_change)
+				status = mpc83xx_spi_setup_transfer(spi, t);
+			if (status < 0)
 				break;
-			}
-			m->actual_length += t->len;
-
-			if (t->delay_usecs)
-				udelay(t->delay_usecs);
+		}
 
-			if (cs_change) {
-				ndelay(nsecs);
-				mpc83xx_spi_chipselect(spi, BITBANG_CS_INACTIVE);
-				ndelay(nsecs);
-			}
+		if (cs_change) {
+			mpc83xx_spi_chipselect(spi, BITBANG_CS_ACTIVE);
+			ndelay(nsecs);
 		}
+		cs_change = t->cs_change;
+		if (t->len)
+			status = mpc83xx_spi_bufs(spi, t);
+		if (status) {
+			status = -EMSGSIZE;
+			break;
+		}
+		m->actual_length += t->len;
 
-		m->status = status;
-		m->complete(m->context);
+		if (t->delay_usecs)
+			udelay(t->delay_usecs);
 
-		if (status || !cs_change) {
+		if (cs_change) {
 			ndelay(nsecs);
 			mpc83xx_spi_chipselect(spi, BITBANG_CS_INACTIVE);
+			ndelay(nsecs);
 		}
+	}
+
+	m->status = status;
+	m->complete(m->context);
+
+	if (status || !cs_change) {
+		ndelay(nsecs);
+		mpc83xx_spi_chipselect(spi, BITBANG_CS_INACTIVE);
+	}
+
+	mpc83xx_spi_setup_transfer(spi, NULL);
+}
+
+static void mpc83xx_spi_work(struct work_struct *work)
+{
+	struct mpc83xx_spi *mpc83xx_spi = container_of(work, struct mpc83xx_spi,
+						       work);
+
+	spin_lock_irq(&mpc83xx_spi->lock);
+	mpc83xx_spi->busy = 1;
+	while (!list_empty(&mpc83xx_spi->queue)) {
+		struct spi_message *m = container_of(mpc83xx_spi->queue.next,
+						   struct spi_message, queue);
+
+		list_del_init(&m->queue);
+		spin_unlock_irq(&mpc83xx_spi->lock);
 
-		mpc83xx_spi_setup_transfer(spi, NULL);
+		mpc83xx_spi_do_one_msg(m);
 
 		spin_lock_irq(&mpc83xx_spi->lock);
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


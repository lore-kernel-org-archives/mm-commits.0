From: akpm@linux-foundation.org
Subject: - max3100-spi-uart-driver-fix.patch removed from -mm tree
Date: Fri, 09 Jan 2009 14:17:58 -0800
Message-ID: <200901092217.n09MHwAl021416@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35757 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932191AbZAIWTr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2009 17:19:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chripell@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     max3100-spi-uart-driver fix
has been removed from the -mm tree.  Its filename was
     max3100-spi-uart-driver-fix.patch

This patch was dropped because it was folded into max3100-spi-uart-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: max3100-spi-uart-driver fix
From: Christian Pellegrin <chripell@gmail.com>

This patch fixes a problem about PM in my code that I found when testing
patches that went in -mm. The full patch against the Linus tree can be
found at http://www.evolware.org/chri/paciugo/

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/max3100.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/serial/max3100.c~max3100-spi-uart-driver-fix drivers/serial/max3100.c
--- a/drivers/serial/max3100.c~max3100-spi-uart-driver-fix
+++ a/drivers/serial/max3100.c
@@ -566,6 +566,7 @@ static void max3100_shutdown(struct uart
 	if (s->workqueue) {
 		flush_workqueue(s->workqueue);
 		destroy_workqueue(s->workqueue);
+		s->workqueue = NULL;
 	}
 	if (s->irq)
 		free_irq(s->irq, s);
@@ -614,6 +615,7 @@ static int max3100_startup(struct uart_p
 		dev_warn(&s->spi->dev, "cannot allocate irq %d\n", s->irq);
 		s->irq = 0;
 		destroy_workqueue(s->workqueue);
+		s->workqueue = NULL;
 		return -EBUSY;
 	}
 
@@ -884,7 +886,8 @@ static int max3100_resume(struct spi_dev
 	enable_irq(s->irq);
 
 	s->conf_commit = 1;
-	max3100_dowork(s);
+	if (s->workqueue)
+		max3100_dowork(s);
 
 	return 0;
 }
_

Patches currently in -mm which might be from chripell@gmail.com are

origin.patch
max3100-spi-uart-driver.patch
max3100-spi-uart-driver-fix.patch


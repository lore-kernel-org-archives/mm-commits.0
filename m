From: akpm@linux-foundation.org
Subject: + max3100-spi-uart-driver-fix.patch added to -mm tree
Date: Fri, 10 Oct 2008 12:37:36 -0700
Message-ID: <200810101937.m9AJbaN6026829@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759597AbYJJTiM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Oct 2008 15:38:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chripell@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     max3100-spi-uart-driver fix
has been added to the -mm tree.  Its filename is
     max3100-spi-uart-driver-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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

max3100-spi-uart-driver.patch
max3100-spi-uart-driver-fix.patch


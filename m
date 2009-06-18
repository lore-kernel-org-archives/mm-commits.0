From: akpm@linux-foundation.org
Subject: [merged] gpio-max7301-add-missing-__devexit-marking.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:44:35 -0700
Message-ID: <200906182244.n5IMiZAO003613@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33931 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758820AbZFRWow (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:44:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, david-b@pacbell.net, dbaryshkov@gmail.com, j.beisert@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     gpio: max7301: add missing __devexit marking
has been removed from the -mm tree.  Its filename was
     gpio-max7301-add-missing-__devexit-marking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: max7301: add missing __devexit marking
From: Mike Frysinger <vapier@gentoo.org>

The remove member of the spi_driver max7301_driver uses __devexit_p(), so
the remove function itself should be marked with __devexit.  Even more so
considering the probe function is marked with __devinit.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Juergen Beisert <j.beisert@pengutronix.de>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/max7301.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpio/max7301.c~gpio-max7301-add-missing-__devexit-marking drivers/gpio/max7301.c
--- a/drivers/gpio/max7301.c~gpio-max7301-add-missing-__devexit-marking
+++ a/drivers/gpio/max7301.c
@@ -287,7 +287,7 @@ exit_destroy:
 	return ret;
 }
 
-static int max7301_remove(struct spi_device *spi)
+static int __devexit max7301_remove(struct spi_device *spi)
 {
 	struct max7301 *ts;
 	int ret;
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
istallion-add-missing-__devexit-marking.patch
linux-next.patch
pcmcia-yenta-add-missing-__devexit-marking.patch


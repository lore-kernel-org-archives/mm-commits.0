From: akpm@linux-foundation.org
Subject: + pxa2xx_spi-prevent-panic-case-setup-fails.patch added to -mm tree
Date: Fri, 08 May 2009 10:40:42 -0700
Message-ID: <200905081740.n48HegWA026064@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752866AbZEHRnq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 May 2009 13:43:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drwyrm@gmail.com, dbrownell@users.sourceforge.net, eric.y.miao@gmail.com


The patch titled
     pxa2xx_spi: prevent panic case setup() fails
has been added to the -mm tree.  Its filename is
     pxa2xx_spi-prevent-panic-case-setup-fails.patch

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
Subject: pxa2xx_spi: prevent panic case setup() fails
From: Daniel Ribeiro <drwyrm@gmail.com>

setup() may fail before ctldata is set, causing a kernel panic on
cleanup().

Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/pxa2xx_spi.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/spi/pxa2xx_spi.c~pxa2xx_spi-prevent-panic-case-setup-fails drivers/spi/pxa2xx_spi.c
--- a/drivers/spi/pxa2xx_spi.c~pxa2xx_spi-prevent-panic-case-setup-fails
+++ a/drivers/spi/pxa2xx_spi.c
@@ -1373,6 +1373,9 @@ static void cleanup(struct spi_device *s
 {
 	struct chip_data *chip = spi_get_ctldata(spi);
 
+	if (!chip)
+		return;
+
 	if (gpio_is_valid(chip->gpio_cs))
 		gpio_free(chip->gpio_cs);
 
_

Patches currently in -mm which might be from drwyrm@gmail.com are

origin.patch
pxa2xx_spi-prevent-panic-case-setup-fails.patch
linux-next.patch


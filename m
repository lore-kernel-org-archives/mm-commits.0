From: akpm@linux-foundation.org
Subject: + spi-limit-reaches-1-tested-0.patch added to -mm tree
Date: Tue, 10 Feb 2009 11:35:48 -0800
Message-ID: <200902101935.n1AJZmF4018695@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754017AbZBJTgA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Feb 2009 14:36:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, dbrownell@users.sourceforge.net, mceier@gmail.com


The patch titled
     spi: limit reaches -1, tested 0
has been added to the -mm tree.  Its filename is
     spi-limit-reaches-1-tested-0.patch

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
Subject: spi: limit reaches -1, tested 0
From: Roel Kluin <roel.kluin@gmail.com>

With a postfix decrement limit will reach -1 rather than 0, so the warning
will not be issued.

Also, add a cpu_relax() into the busy-wait loop.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Mariusz Ceier <mceier@gmail.com>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_imx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/spi/spi_imx.c~spi-limit-reaches-1-tested-0 drivers/spi/spi_imx.c
--- a/drivers/spi/spi_imx.c~spi-limit-reaches-1-tested-0
+++ a/drivers/spi/spi_imx.c
@@ -779,7 +779,8 @@ static irqreturn_t interrupt_transfer(st
 
 			/* Read trailing bytes */
 			limit = loops_per_jiffy << 1;
-			while ((read(drv_data) == 0) && limit--);
+			while ((read(drv_data) == 0) && --limit)
+				cpu_relax();
 
 			if (limit == 0)
 				dev_err(&drv_data->pdev->dev,
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
leds-fix-confusion.patch
paride-pgc-xs-confusion.patch
mm-get_nid_for_pfn-returns-int.patch
alpha-fix-macros.patch
spi-limit-reaches-1-tested-0.patch
rtc-wm8350-retries-will-reach-1.patch
ufs-sector_t-cannot-be-negative.patch


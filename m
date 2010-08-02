From: akpm@linux-foundation.org
Subject: + gen_nand-fix-support-for-multiple-chips.patch added to -mm tree
Date: Mon, 02 Aug 2010 13:56:16 -0700
Message-ID: <201008022056.o72KuGTG010695@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754975Ab0HBU5E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Aug 2010 16:57:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marek.vasut@gmail.com, Artem.Bityutskiy@nokia.com, dwmw2@infradead.org, stable@kernel.org


The patch titled
     gen_nand: fix support for multiple chips
has been added to the -mm tree.  Its filename is
     gen_nand-fix-support-for-multiple-chips.patch

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
Subject: gen_nand: fix support for multiple chips
From: Marek Vasut <marek.vasut@gmail.com>

Correct a problem where gen_nand driver assumed there can be only one chip
and ignored the pdata->chip.nr_chips value.

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/plat_nand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/nand/plat_nand.c~gen_nand-fix-support-for-multiple-chips drivers/mtd/nand/plat_nand.c
--- a/drivers/mtd/nand/plat_nand.c~gen_nand-fix-support-for-multiple-chips
+++ a/drivers/mtd/nand/plat_nand.c
@@ -91,7 +91,7 @@ static int __devinit plat_nand_probe(str
 	}
 
 	/* Scan to find existance of the device */
-	if (nand_scan(&data->mtd, 1)) {
+	if (nand_scan(&data->mtd, pdata->chip.nr_chips)) {
 		err = -ENXIO;
 		goto out;
 	}
_

Patches currently in -mm which might be from marek.vasut@gmail.com are

linux-next.patch
gen_nand-fix-support-for-multiple-chips.patch
backlight-fix-blanking-for-lms283gf05-lcd.patch
backlight-fix-blanking-for-l4f00242t03-lcd.patch
maintainers-update-arm-voipac-pxa270-file-patterns.patch
maintainers-update-arm-zipit-z2-support-file-patterns.patch


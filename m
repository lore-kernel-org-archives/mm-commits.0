From: akpm@linux-foundation.org
Subject: + nand-fsl_upm-fix-build-problem-with-2628-rc2.patch added to -mm tree
Date: Wed, 26 Nov 2008 16:47:13 -0800
Message-ID: <200811270047.mAR0lEDP009110@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41695 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752234AbYK0Ary (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Nov 2008 19:47:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wg@grandegger.com, avorontsov@ru.mvista.com, dwmw2@infradead.org


The patch titled
     NAND: fsl_upm: fix build problem with 2.6.28-rc2
has been added to the -mm tree.  Its filename is
     nand-fsl_upm-fix-build-problem-with-2628-rc2.patch

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
Subject: NAND: fsl_upm: fix build problem with 2.6.28-rc2
From: Wolfgang Grandegger <wg@grandegger.com>

The patch fixes following build error:

  CC      drivers/mtd/nand/fsl_upm.o
drivers/mtd/nand/fsl_upm.c: In function 'fun_chip_init':
drivers/mtd/nand/fsl_upm.c:168: warning: passing argument 2 of 'of_mtd_parse_partitions' from incompatible pointer type
drivers/mtd/nand/fsl_upm.c:168: warning: passing argument 3 of 'of_mtd_parse_partitions' from incompatible pointer type
drivers/mtd/nand/fsl_upm.c:168: error: too many arguments to function 'of_mtd_parse_partitions'
make[1]: *** [drivers/mtd/nand/fsl_upm.o] Error 1

The breakage was introduced in 69fd3a8d098faf41a04930afa83757c0555ee360
("[MTD] remove unused mtd parameter in of_mtd_parse_partitions()").

While at it, also add a check for the of_mtd_parse_partitions() return
value.

Signed-off-by: Wolfgang Grandegger <wg@grandegger.com>
Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/fsl_upm.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/mtd/nand/fsl_upm.c~nand-fsl_upm-fix-build-problem-with-2628-rc2 drivers/mtd/nand/fsl_upm.c
--- a/drivers/mtd/nand/fsl_upm.c~nand-fsl_upm-fix-build-problem-with-2628-rc2
+++ a/drivers/mtd/nand/fsl_upm.c
@@ -163,9 +163,11 @@ static int __devinit fun_chip_init(struc
 	ret = parse_mtd_partitions(&fun->mtd, part_types, &fun->parts, 0);
 
 #ifdef CONFIG_MTD_OF_PARTS
-	if (ret == 0)
-		ret = of_mtd_parse_partitions(fun->dev, &fun->mtd,
-					      flash_np, &fun->parts);
+	if (ret == 0) {
+		ret = of_mtd_parse_partitions(fun->dev, flash_np, &fun->parts);
+		if (ret < 0)
+			goto err;
+	}
 #endif
 	if (ret > 0)
 		ret = add_mtd_partitions(&fun->mtd, fun->parts, ret);
_

Patches currently in -mm which might be from wg@grandegger.com are

linux-next.patch
nand-fsl_upm-fix-build-problem-with-2628-rc2.patch


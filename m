From: akpm@linux-foundation.org
Subject: + spi_s3c24xxc-fix-build.patch added to -mm tree
Date: Sat, 05 May 2007 11:39:48 -0700
Message-ID: <200705051839.l45IdmdR011072@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754565AbXEESkS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 5 May 2007 14:40:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arnaud.patard@rtp-net.org, dbrownell@users.sourceforge.net


The patch titled
     spi_s3c24xx.c: Fix build
has been added to the -mm tree.  Its filename is
     spi_s3c24xxc-fix-build.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spi_s3c24xx.c: Fix build
From: Arnaud Patard <arnaud.patard@rtp-net.org>

Commit a836f5856ae46ccb2464ea76031ea05ae967b832 removes the shutdown
member of the bitbang structure, breaking the build of spi_s3c24xx.c.

Signed-off-by: Arnaud Patard <arnaud.patard@rtp-net.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_s3c24xx.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/spi/spi_s3c24xx.c~spi_s3c24xxc-fix-build drivers/spi/spi_s3c24xx.c
--- a/drivers/spi/spi_s3c24xx.c~spi_s3c24xxc-fix-build
+++ a/drivers/spi/spi_s3c24xx.c
@@ -342,8 +342,6 @@ static int s3c24xx_spi_probe(struct plat
 		goto err_register;
 	}
 
-	dev_dbg(hw->dev, "shutdown=%d\n", hw->bitbang.shutdown);
-
 	/* register all the devices associated */
 
 	bi = &hw->pdata->board_info[0];
_

Patches currently in -mm which might be from arnaud.patard@rtp-net.org are

spi_s3c24xxc-fix-build.patch
git-mmc.patch

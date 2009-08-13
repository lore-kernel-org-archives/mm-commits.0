From: akpm@linux-foundation.org
Subject: + spi_s3c24xx-fix-header-includes.patch added to -mm tree
Date: Thu, 13 Aug 2009 14:28:08 -0700
Message-ID: <200908132128.n7DLS80a008730@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756366AbZHMV2f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Aug 2009 17:28:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@simtec.co.uk, david-b@pacbell.net


The patch titled
     spi_s3c24xx: fix header includes
has been added to the -mm tree.  Its filename is
     spi_s3c24xx-fix-header-includes.patch

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
Subject: spi_s3c24xx: fix header includes
From: Ben Dooks <ben@simtec.co.uk>

The driver includes <asm/io.h> where it should be including <linux/io.h>
and also includes <mach/hardware.h> and <asm/dma.h> without using anything
from these.

Signed-off-by: Ben Dooks <ben@simtec.co.uk>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_s3c24xx.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/spi/spi_s3c24xx.c~spi_s3c24xx-fix-header-includes drivers/spi/spi_s3c24xx.c
--- a/drivers/spi/spi_s3c24xx.c~spi_s3c24xx-fix-header-includes
+++ a/drivers/spi/spi_s3c24xx.c
@@ -20,14 +20,11 @@
 #include <linux/clk.h>
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
+#include <linux/io.h>
 
 #include <linux/spi/spi.h>
 #include <linux/spi/spi_bitbang.h>
 
-#include <asm/io.h>
-#include <asm/dma.h>
-#include <mach/hardware.h>

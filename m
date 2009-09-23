From: akpm@linux-foundation.org
Subject: [merged] spi_s3c24xx-fix-header-includes.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:58:17 -0700
Message-ID: <200909231958.n8NJwHjR008646@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48294 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753785AbZIWT6r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:58:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben@simtec.co.uk, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     spi_s3c24xx: fix header includes
has been removed from the -mm tree.  Its filename was
     spi_s3c24xx-fix-header-includes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

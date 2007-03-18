From: akpm@linux-foundation.org
Subject: - spi_s3c24xxc-warning-fix.patch removed from -mm tree
Date: Sun, 18 Mar 2007 01:10:19 -0800
Message-ID: <200703180910.l2I9AJ1H020081@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60504 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159AbXCRJK1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 05:10:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnaud.patard@rtp-net.org, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi_s3c24xx.c: warning fix
has been removed from the -mm tree.  Its filename was
     spi_s3c24xxc-warning-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi_s3c24xx.c: warning fix
From: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>

The set_cs field of struct s3c24xx_spi is declared as returning a int but
the value returned but set_cs is never fixed.  Moreover, the default
function for set_cs and the set_cs defintion in the platform data are
returning void.

I'm proposing to change the prototype to void (*set_cs)(...). By doing
this, I'm also fixing 2 build warnings:

drivers/spi/spi_s3c24xx.c: In function 's3c24xx_spi_probe':
drivers/spi/spi_s3c24xx.c:330: warning: assignment from incompatible pointer type
drivers/spi/spi_s3c24xx.c:335: warning: assignment from incompatible pointer type

Signed-off-by: Arnaud Patard <arnaud.patard@rtp-net.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_s3c24xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/spi/spi_s3c24xx.c~spi_s3c24xxc-warning-fix drivers/spi/spi_s3c24xx.c
--- a/drivers/spi/spi_s3c24xx.c~spi_s3c24xxc-warning-fix
+++ a/drivers/spi/spi_s3c24xx.c
@@ -41,7 +41,7 @@ struct s3c24xx_spi {
 	int			 len;
 	int			 count;
 
-	int			(*set_cs)(struct s3c2410_spi_info *spi,
+	void			(*set_cs)(struct s3c2410_spi_info *spi,
 					  int cs, int pol);
 
 	/* data buffers */
_

Patches currently in -mm which might be from arnaud.patard@rtp-net.org are

origin.patch

From: akpm@linux-foundation.org
Subject: + spi_s3c24xxc-warning-fix.patch added to -mm tree
Date: Fri, 16 Mar 2007 11:49:20 -0800
Message-ID: <200703161949.l2GJnKJ3020153@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33308 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627AbXCPTtc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Mar 2007 15:49:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arnaud.patard@rtp-net.org, dbrownell@users.sourceforge.net


The patch titled
     spi_s3c24xx.c: warning fix
has been added to the -mm tree.  Its filename is
     spi_s3c24xxc-warning-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

spi_s3c24xxc-warning-fix.patch

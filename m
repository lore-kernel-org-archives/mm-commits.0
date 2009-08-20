From: akpm@linux-foundation.org
Subject: [merged] spi_s3c24xx-fix-transfer-setup-code.patch removed from -mm tree
Date: Thu, 20 Aug 2009 13:12:58 -0700
Message-ID: <200908202012.n7KKCwtD015852@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49699 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755289AbZHTUNj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Aug 2009 16:13:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben@simtec.co.uk, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     spi_s3c24xx: fix transfer setup code
has been removed from the -mm tree.  Its filename was
     spi_s3c24xx-fix-transfer-setup-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi_s3c24xx: fix transfer setup code
From: Ben Dooks <ben@simtec.co.uk>

Since the changes to the bitbang driver, there is the possibility we will
be called with either the speed_hz or bpw values zero.  We take these to
mean that the default values (8 bits per word, or maximum bus speed).

Signed-off-by: Ben Dooks <ben@simtec.co.uk>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_s3c24xx.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/spi/spi_s3c24xx.c~spi_s3c24xx-fix-transfer-setup-code drivers/spi/spi_s3c24xx.c
--- a/drivers/spi/spi_s3c24xx.c~spi_s3c24xx-fix-transfer-setup-code
+++ a/drivers/spi/spi_s3c24xx.c
@@ -116,6 +116,12 @@ static int s3c24xx_spi_setupxfer(struct 
 	bpw = t ? t->bits_per_word : spi->bits_per_word;
 	hz  = t ? t->speed_hz : spi->max_speed_hz;
 
+	if (!bpw)
+		bpw = 8;
+
+	if (!hz)
+		hz = spi->max_speed_hz;
+
 	if (bpw != 8) {
 		dev_err(&spi->dev, "invalid bits-per-word (%d)\n", bpw);
 		return -EINVAL;
_

Patches currently in -mm which might be from ben@simtec.co.uk are

origin.patch
linux-next.patch
spi-fix-spelling-of-automatically-in-documentation.patch
spi_s3c24xx-fix-header-includes.patch
spi_s3c24xx-use-resource_size-to-get-resource-size.patch
spi_s3c24xx-use-dev_pm_ops.patch
spi_s3c24xx-cache-device-setup-data.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
gpiolib-add-names-file-in-gpio-chip-sysfs-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs-checkpatch-fixes-fix.patch


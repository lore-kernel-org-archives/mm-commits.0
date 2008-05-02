From: akpm@linux-foundation.org
Subject: - gpio-pca953x-add-support-for-pca9555-i2c-i-o-expander.patch removed from -mm tree
Date: Fri, 02 May 2008 12:43:19 -0700
Message-ID: <200805021943.m42JhJ4d011277@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932429AbYEBTn5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:43:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: will.newton@gmail.com, david-b@pacbell.net, eric.miao@marvell.com, will.newton@imgtec.com, mm-commits@vger.kernel.org


The patch titled
     gpio: pca953x: add support for pca9555 I2C I/O expander
has been removed from the -mm tree.  Its filename was
     gpio-pca953x-add-support-for-pca9555-i2c-i-o-expander.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: pca953x: add support for pca9555 I2C I/O expander
From: "Will Newton" <will.newton@gmail.com>

Add support for pca9555 I2C I/O expander.  As the comment suggests this part
is software compatible with the pca9539.

Signed-off-by: Will Newton <will.newton@imgtec.com>
Cc: "eric miao" <eric.miao@marvell.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/pca953x.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/gpio/pca953x.c~gpio-pca953x-add-support-for-pca9555-i2c-i-o-expander drivers/gpio/pca953x.c
--- a/drivers/gpio/pca953x.c~gpio-pca953x-add-support-for-pca9555-i2c-i-o-expander
+++ a/drivers/gpio/pca953x.c
@@ -30,6 +30,8 @@ static const struct i2c_device_id pca953
 	{ "pca9537", 4, },
 	{ "pca9538", 8, },
 	{ "pca9539", 16, },
+	{ "pca9555", 16, },
+	{ "pca9557", 8, },
 	/* REVISIT several pca955x parts should work here too */
 	{ }
 };
@@ -193,7 +195,7 @@ static int __devinit pca953x_probe(struc
 {
 	struct pca953x_platform_data *pdata;
 	struct pca953x_chip *chip;
-	int ret, i;
+	int ret;
 
 	pdata = client->dev.platform_data;
 	if (pdata == NULL)
_

Patches currently in -mm which might be from will.newton@gmail.com are

origin.patch


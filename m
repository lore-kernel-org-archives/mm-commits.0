From: akpm@linux-foundation.org
Subject: - i2c-dont-autograb-i2c-pca-is.patch removed from -mm tree
Date: Tue, 12 Aug 2008 13:32:57 -0700
Message-ID: <200808122032.m7CKWvkj011749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54955 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868AbYHLUns (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 16:43:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rene.herman@keyaccess.nl, rene.herman@gmail.com, mm-commits@vger.kernel.org


The patch titled
     i2c: don't autograb i2c-pca-is
has been removed from the -mm tree.  Its filename was
     i2c-dont-autograb-i2c-pca-is.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: i2c: don't autograb i2c-pca-is
From: Rene Herman <rene.herman@keyaccess.nl>

Grabbing ISA bus resources without anything or anyone telling us we should
can break boot on randconfig/allyesconfig builds by keeping resources that
are in fact owned by different hardware busy and does as reported by Ingo
Molnar.

Generally it's also dangerous to just poke at random I/O ports and
especially those in the range where other old easily confused ISA hardware
might live.

For this specialized I2C bus driver, insist that the user specifies
the resources before grabbing them.

The^WA user of this driver is a one time

echo "options i2c-pca-isa base=0x330 irq=10" >> /etc/modprobe.conf

away from the old behaviour.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-pca-isa.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff -puN drivers/i2c/busses/i2c-pca-isa.c~i2c-dont-autograb-i2c-pca-is drivers/i2c/busses/i2c-pca-isa.c
--- a/drivers/i2c/busses/i2c-pca-isa.c~i2c-dont-autograb-i2c-pca-is
+++ a/drivers/i2c/busses/i2c-pca-isa.c
@@ -36,8 +36,8 @@
 #define DRIVER "i2c-pca-isa"
 #define IO_SIZE 4
 
-static unsigned long base   = 0x330;
-static int irq 	  = 10;
+static unsigned long base;
+static int irq = -1;
 
 /* Data sheet recommends 59kHz for 100kHz operation due to variation
  * in the actual clock rate */
@@ -107,6 +107,19 @@ static struct i2c_adapter pca_isa_ops = 
 	.timeout	= 100,
 };
 
+static int __devinit pca_isa_match(struct device *dev, unsigned int id)
+{
+	int match = base != 0;
+
+	if (match) {
+		if (irq == -1)
+			dev_warn(dev, "using poling mode (specify irq)\n");
+	} else
+		dev_err(dev, "please specify base\n");
+
+	return match;
+}
+
 static int __devinit pca_isa_probe(struct device *dev, unsigned int id)
 {
 	init_waitqueue_head(&pca_wait);
@@ -153,7 +166,7 @@ static int __devexit pca_isa_remove(stru
 {
 	i2c_del_adapter(&pca_isa_ops);
 
-	if (irq > 0) {
+	if (irq > -1) {
 		disable_irq(irq);
 		free_irq(irq, &pca_isa_ops);
 	}
@@ -163,6 +176,7 @@ static int __devexit pca_isa_remove(stru
 }
 
 static struct isa_driver pca_isa_driver = {
+	.match		= pca_isa_match,
 	.probe		= pca_isa_probe,
 	.remove		= __devexit_p(pca_isa_remove),
 	.driver = {
_

Patches currently in -mm which might be from rene.herman@keyaccess.nl are

origin.patch
v4l1-make-pms-not-autoprobe-when-builtin.patch
v4l1-make-pms-not-autoprobe-when-builtin-update.patch
isdn-make-icn-not-autograb-when-builtin.patch
pnp-make-the-resource-type-an-unsigned-long.patch
pnp-make-the-resource-type-an-unsigned-long-fix.patch


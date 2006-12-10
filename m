From: akpm@osdl.org
Subject: + make-lm70_remove-a-__devexit-function.patch added to -mm tree
Date: Sun, 10 Dec 2006 12:15:24 -0800
Message-ID: <200612102015.kBAKFObT002010@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57965 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762486AbWLJUPc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 15:15:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org


The patch titled
     Make lm70_remove a __devexit function
has been added to the -mm tree.  Its filename is
     make-lm70_remove-a-__devexit-function.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Make lm70_remove a __devexit function
From: Ralf Baechle <ralf@linux-mips.org>

Saves a few bytes on the module.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/hwmon/lm70.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/hwmon/lm70.c~make-lm70_remove-a-__devexit-function drivers/hwmon/lm70.c
--- a/drivers/hwmon/lm70.c~make-lm70_remove-a-__devexit-function
+++ a/drivers/hwmon/lm70.c
@@ -126,7 +126,7 @@ out_dev_reg_failed:
 	return status;
 }
 
-static int __exit lm70_remove(struct spi_device *spi)
+static int __devexit lm70_remove(struct spi_device *spi)
 {
 	struct lm70 *p_lm70 = dev_get_drvdata(&spi->dev);
 
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
sysctl-remove-unused-context-param.patch
dont-build-some-broken-isdn-drivers-on-big-endian-mips.patch
make-lm70_remove-a-__devexit-function.patch
mips-dbg_io-stray-brackets-fix.patch
git-mtd.patch
git-net.patch
fix-pnx8550-serial-breakage.patch
pnx8550-uart-driver.patch
pci-legacy-resource-fix.patch
pci-legacy-resource-fix-tidy.patch
xfs-remove-useless-wmb-memory-barrier.patch
tty-remove-useless-memory-barrier.patch
getting-rid-of-all-casts-of-kalloc-calls.patch


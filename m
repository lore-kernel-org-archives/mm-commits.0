From: akpm@linux-foundation.org
Subject: [merged] plat_nand-add-missing-__devexit_p.patch removed from -mm tree
Date: Tue, 09 Jun 2009 11:12:14 -0700
Message-ID: <200906091812.n59ICEto018513@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759098AbZFISM1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2009 14:12:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     plat_nand: add missing __devexit_p()
has been removed from the -mm tree.  Its filename was
     plat_nand-add-missing-__devexit_p.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: plat_nand: add missing __devexit_p()
From: Mike Frysinger <vapier@gentoo.org>

The remove function uses __devexit, so the .remove assignment needs
__devexit_p() to fix a build error with hotplug disabled.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/plat_nand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/nand/plat_nand.c~plat_nand-add-missing-__devexit_p drivers/mtd/nand/plat_nand.c
--- a/drivers/mtd/nand/plat_nand.c~plat_nand-add-missing-__devexit_p
+++ a/drivers/mtd/nand/plat_nand.c
@@ -139,7 +139,7 @@ static int __devexit plat_nand_remove(st
 
 static struct platform_driver plat_nand_driver = {
 	.probe		= plat_nand_probe,
-	.remove		= plat_nand_remove,
+	.remove		= __devexit_p(plat_nand_remove),
 	.driver		= {
 		.name	= "gen_nand",
 		.owner	= THIS_MODULE,
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
shm-fix-unused-warnings-on-nommu.patch
linux-next.patch
pcmcia-yenta-add-missing-__devexit-marking.patch
drivers-hvc-add-missing-__devexit_p.patch
kmap_types-make-most-arches-use-generic-header-file.patch
gitignore-ignore-patch-files.patch
drivers-char-rtc-disable-legacy-rtc-driver-on-blackfin-systems.patch
gpio-max7301-add-missing-__devexit-marking.patch
istallion-add-missing-__devexit-marking.patch
edac-add-missing-__devexit_p.patch


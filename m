From: akpm@linux-foundation.org
Subject: [merged] mtd-nand-gpio-use-ioreadwrite_rep-accessors.patch removed from -mm tree
Date: Mon, 17 Dec 2012 12:26:14 -0800
Message-ID: <20121217202615.B11EA20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:64992 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab2LQU0S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Dec 2012 15:26:18 -0500
Received: by mail-wi0-f202.google.com with SMTP id hn17so210270wib.1
        for <mm-commits@vger.kernel.org>; Mon, 17 Dec 2012 12:26:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew@mattleach.net, arnd@arndb.de, benh@kernel.crashing.org, dwmw2@infradead.org, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mtd: nand/gpio: use io{read,write}*_rep accessors
has been removed from the -mm tree.  Its filename was
     mtd-nand-gpio-use-ioreadwrite_rep-accessors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Leach <matthew@mattleach.net>
Subject: mtd: nand/gpio: use io{read,write}*_rep accessors

The {read,write}s{b,w,l} operations are not defined by all architectures
and are being removed from the asm-generic/io.h interface.

This patch replaces the usage of these string functions in the mtd
gpio accessors with io{read,write}{8,16,32}_rep calls instead.

Signed-off-by: Matthew Leach <matthew@mattleach.net>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ben Herrenschmidt <benh@kernel.crashing.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/gpio.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/mtd/nand/gpio.c~mtd-nand-gpio-use-ioreadwrite_rep-accessors drivers/mtd/nand/gpio.c
--- a/drivers/mtd/nand/gpio.c~mtd-nand-gpio-use-ioreadwrite_rep-accessors
+++ a/drivers/mtd/nand/gpio.c
@@ -90,14 +90,14 @@ static void gpio_nand_writebuf(struct mt
 {
 	struct nand_chip *this = mtd->priv;
 
-	writesb(this->IO_ADDR_W, buf, len);
+	iowrite8_rep(this->IO_ADDR_W, buf, len);
 }
 
 static void gpio_nand_readbuf(struct mtd_info *mtd, u_char *buf, int len)
 {
 	struct nand_chip *this = mtd->priv;
 
-	readsb(this->IO_ADDR_R, buf, len);
+	ioread8_rep(this->IO_ADDR_R, buf, len);
 }
 
 static void gpio_nand_writebuf16(struct mtd_info *mtd, const u_char *buf,
@@ -106,7 +106,7 @@ static void gpio_nand_writebuf16(struct 
 	struct nand_chip *this = mtd->priv;
 
 	if (IS_ALIGNED((unsigned long)buf, 2)) {
-		writesw(this->IO_ADDR_W, buf, len>>1);
+		iowrite16_rep(this->IO_ADDR_W, buf, len>>1);
 	} else {
 		int i;
 		unsigned short *ptr = (unsigned short *)buf;
@@ -121,7 +121,7 @@ static void gpio_nand_readbuf16(struct m
 	struct nand_chip *this = mtd->priv;
 
 	if (IS_ALIGNED((unsigned long)buf, 2)) {
-		readsw(this->IO_ADDR_R, buf, len>>1);
+		ioread16_rep(this->IO_ADDR_R, buf, len>>1);
 	} else {
 		int i;
 		unsigned short *ptr = (unsigned short *)buf;
_

Patches currently in -mm which might be from matthew@mattleach.net are

origin.patch
linux-next.patch
include-linux-inith-use-the-stringify-operator-for-the-__define_initcall-macro.patch
musb-tusb6010-use-ioreadwrite_rep-accessors.patch
usb-musb-use-ioreadwrite_rep-accessors.patch


From: akpm@linux-foundation.org
Subject: + mtd-nand-gpio-use-ioreadwrite_rep-accessors.patch added to -mm tree
Date: Thu, 13 Dec 2012 14:46:39 -0800
Message-ID: <20121213224640.9EC2520005C@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:54382 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520Ab2LMWqn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Dec 2012 17:46:43 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so142330bkc.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Dec 2012 14:46:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthew@mattleach.net, arnd@arndb.de, benh@kernel.crashing.org, dwmw2@infradead.org, will.deacon@arm.com


The patch titled
     Subject: mtd: nand/gpio: use io{read,write}*_rep accessors
has been added to the -mm tree.  Its filename is
     mtd-nand-gpio-use-ioreadwrite_rep-accessors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mtd-nand-gpio-use-ioreadwrite_rep-accessors.patch
musb-tusb6010-use-ioreadwrite_rep-accessors.patch
usb-musb-use-ioreadwrite_rep-accessors.patch


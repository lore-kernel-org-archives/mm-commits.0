From: akpm@linux-foundation.org
Subject: + drivers-gpio-gpio-genericc-fix-build-errors.patch added to -mm tree
Date: Wed, 14 Sep 2011 13:44:02 -0700
Message-ID: <201109142044.p8EKi22K029379@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:15240 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143Ab1INUo1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Sep 2011 16:44:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rmk+kernel@arm.linux.org.uk, grant.likely@secretlab.ca


The patch titled
     drivers/gpio/gpio-generic.c: fix build errors
has been added to the -mm tree.  Its filename is
     drivers-gpio-gpio-genericc-fix-build-errors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/gpio/gpio-generic.c: fix build errors
From: Russell King <rmk+kernel@arm.linux.org.uk>

Building a kernel with hotplug disabled results in a link failure:

`bgpio_remove' referenced in section `___ksymtab_gpl+bgpio_remove' of drivers/built-in.o: defined in discarded section `.devexit.text' of drivers/built-in.o

This is because of bgpio_remove() is exported.  It is illegal to export
symbols which are discarded either at link time or as part of an init/exit
section.

Fix this by dropping the __devexit attributation from bgpio_remove(). 
Also drop the __devinit attributation from bgpio_init().

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
To: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpio-generic.c     |   15 +++++----------
 include/linux/basic_mmio_gpio.h |   15 +++++----------
 2 files changed, 10 insertions(+), 20 deletions(-)

diff -puN drivers/gpio/gpio-generic.c~gpio-fix-build-errors-with-gpio-genericc drivers/gpio/gpio-generic.c
--- a/drivers/gpio/gpio-generic.c~gpio-fix-build-errors-with-gpio-genericc
+++ a/drivers/gpio/gpio-generic.c
@@ -351,7 +351,7 @@ static int bgpio_setup_direction(struct 
 	return 0;
 }
 
-int __devexit bgpio_remove(struct bgpio_chip *bgc)
+int bgpio_remove(struct bgpio_chip *bgc)
 {
 	int err = gpiochip_remove(&bgc->gc);
 
@@ -361,15 +361,10 @@ int __devexit bgpio_remove(struct bgpio_
 }
 EXPORT_SYMBOL_GPL(bgpio_remove);
 
-int __devinit bgpio_init(struct bgpio_chip *bgc,
-			 struct device *dev,
-			 unsigned long sz,
-			 void __iomem *dat,
-			 void __iomem *set,
-			 void __iomem *clr,
-			 void __iomem *dirout,
-			 void __iomem *dirin,
-			 bool big_endian)
+int bgpio_init(struct bgpio_chip *bgc, struct device *dev,
+	       unsigned long sz, void __iomem *dat, void __iomem *set,
+	       void __iomem *clr, void __iomem *dirout, void __iomem *dirin,
+	       bool big_endian)
 {
 	int ret;
 
diff -puN include/linux/basic_mmio_gpio.h~gpio-fix-build-errors-with-gpio-genericc include/linux/basic_mmio_gpio.h
--- a/include/linux/basic_mmio_gpio.h~gpio-fix-build-errors-with-gpio-genericc
+++ a/include/linux/basic_mmio_gpio.h
@@ -63,15 +63,10 @@ static inline struct bgpio_chip *to_bgpi
 	return container_of(gc, struct bgpio_chip, gc);
 }
 
-int __devexit bgpio_remove(struct bgpio_chip *bgc);
-int __devinit bgpio_init(struct bgpio_chip *bgc,
-			 struct device *dev,
-			 unsigned long sz,
-			 void __iomem *dat,
-			 void __iomem *set,
-			 void __iomem *clr,
-			 void __iomem *dirout,
-			 void __iomem *dirin,
-			 bool big_endian);
+int bgpio_remove(struct bgpio_chip *bgc);
+int bgpio_init(struct bgpio_chip *bgc, struct device *dev,
+	       unsigned long sz, void __iomem *dat, void __iomem *set,
+	       void __iomem *clr, void __iomem *dirout, void __iomem *dirin,
+	       bool big_endian);
 
 #endif /* __BASIC_MMIO_GPIO_H */
_

Patches currently in -mm which might be from rmk+kernel@arm.linux.org.uk are

origin.patch
drivers-gpio-gpio-genericc-fix-build-errors.patch
linux-next.patch


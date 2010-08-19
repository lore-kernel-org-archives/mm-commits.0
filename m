From: akpm@linux-foundation.org
Subject: + mmc-make-dev_to_mmc_card-macro-public.patch added to -mm tree
Date: Thu, 19 Aug 2010 14:49:47 -0700
Message-ID: <201008192149.o7JLnl8Y010340@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43393 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751164Ab0HSVtx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Aug 2010 17:49:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andy.shevchenko@gmail.com, adrian.hunter@nokia.com, ext-andriy.shevchenko@nokia.com, linux-mmc@vger.kernel.org


The patch titled
     mmc: make dev_to_mmc_card() macro public
has been added to the -mm tree.  Its filename is
     mmc-make-dev_to_mmc_card-macro-public.patch

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
Subject: mmc: make dev_to_mmc_card() macro public
From: Andy Shevchenko <andy.shevchenko@gmail.com>

Conversion from struct device to struct mmc_card is used more than in one
place.  Due to this it's better to have public macro for such thing.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Adrian Hunter <adrian.hunter@nokia.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/card/mmc_test.c |    4 +---
 drivers/mmc/core/bus.c      |    1 -
 drivers/mmc/core/bus.h      |    2 +-
 include/linux/mmc/card.h    |    2 ++
 4 files changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/mmc/card/mmc_test.c~mmc-make-dev_to_mmc_card-macro-public drivers/mmc/card/mmc_test.c
--- a/drivers/mmc/card/mmc_test.c~mmc-make-dev_to_mmc_card-macro-public
+++ a/drivers/mmc/card/mmc_test.c
@@ -1935,12 +1935,10 @@ static ssize_t mmc_test_show(struct devi
 static ssize_t mmc_test_store(struct device *dev,
 	struct device_attribute *attr, const char *buf, size_t count)
 {
-	struct mmc_card *card;
+	struct mmc_card *card = dev_to_mmc_card(dev);
 	struct mmc_test_card *test;
 	int testcase;
 
-	card = container_of(dev, struct mmc_card, dev);
-
 	testcase = simple_strtol(buf, NULL, 10);
 
 	test = kzalloc(sizeof(struct mmc_test_card), GFP_KERNEL);
diff -puN drivers/mmc/core/bus.c~mmc-make-dev_to_mmc_card-macro-public drivers/mmc/core/bus.c
--- a/drivers/mmc/core/bus.c~mmc-make-dev_to_mmc_card-macro-public
+++ a/drivers/mmc/core/bus.c
@@ -22,7 +22,6 @@
 #include "sdio_cis.h"
 #include "bus.h"
 
-#define dev_to_mmc_card(d)	container_of(d, struct mmc_card, dev)
 #define to_mmc_driver(d)	container_of(d, struct mmc_driver, drv)
 
 static ssize_t mmc_type_show(struct device *dev,
diff -puN drivers/mmc/core/bus.h~mmc-make-dev_to_mmc_card-macro-public drivers/mmc/core/bus.h
--- a/drivers/mmc/core/bus.h~mmc-make-dev_to_mmc_card-macro-public
+++ a/drivers/mmc/core/bus.h
@@ -14,7 +14,7 @@
 #define MMC_DEV_ATTR(name, fmt, args...)					\
 static ssize_t mmc_##name##_show (struct device *dev, struct device_attribute *attr, char *buf)	\
 {										\
-	struct mmc_card *card = container_of(dev, struct mmc_card, dev);	\
+	struct mmc_card *card = dev_to_mmc_card(dev);				\
 	return sprintf(buf, fmt, args);						\
 }										\
 static DEVICE_ATTR(name, S_IRUGO, mmc_##name##_show, NULL)
diff -puN include/linux/mmc/card.h~mmc-make-dev_to_mmc_card-macro-public include/linux/mmc/card.h
--- a/include/linux/mmc/card.h~mmc-make-dev_to_mmc_card-macro-public
+++ a/include/linux/mmc/card.h
@@ -173,6 +173,8 @@ static inline int mmc_blksz_for_byte_mod
 #define mmc_card_name(c)	((c)->cid.prod_name)
 #define mmc_card_id(c)		(dev_name(&(c)->dev))
 
+#define dev_to_mmc_card(d)	container_of(d, struct mmc_card, dev)
+
 #define mmc_list_to_card(l)	container_of(l, struct mmc_card, node)
 #define mmc_get_drvdata(c)	dev_get_drvdata(&(c)->dev)
 #define mmc_set_drvdata(c,d)	dev_set_drvdata(&(c)->dev, d)
_

Patches currently in -mm which might be from andy.shevchenko@gmail.com are

linux-next.patch
mmc-make-dev_to_mmc_card-macro-public.patch


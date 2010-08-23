From: akpm@linux-foundation.org
Subject: + mmc-rename-dev_to_mmc_card-to-mmc_dev_to_card.patch added to -mm tree
Date: Mon, 23 Aug 2010 13:29:34 -0700
Message-ID: <201008232029.o7NKTYLE013143__10338.1232861013$1282595549$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50384 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754566Ab0HWU3l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Aug 2010 16:29:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andy.shevchenko@gmail.com, ext-andriy.shevchenko@nokia.com, linux-mmc@vger.kernel.org


The patch titled
     mmc: rename dev_to_mmc_card() to mmc_dev_to_card()
has been added to the -mm tree.  Its filename is
     mmc-rename-dev_to_mmc_card-to-mmc_dev_to_card.patch

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
Subject: mmc: rename dev_to_mmc_card() to mmc_dev_to_card()
From: Andy Shevchenko <andy.shevchenko@gmail.com>

Global symbols should use their subsystem name in a prefixed fashion.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/card/mmc_test.c |    2 +-
 drivers/mmc/core/bus.c      |   14 +++++++-------
 drivers/mmc/core/bus.h      |    2 +-
 include/linux/mmc/card.h    |    2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/mmc/card/mmc_test.c~mmc-rename-dev_to_mmc_card-to-mmc_dev_to_card drivers/mmc/card/mmc_test.c
--- a/drivers/mmc/card/mmc_test.c~mmc-rename-dev_to_mmc_card-to-mmc_dev_to_card
+++ a/drivers/mmc/card/mmc_test.c
@@ -1935,7 +1935,7 @@ static ssize_t mmc_test_show(struct devi
 static ssize_t mmc_test_store(struct device *dev,
 	struct device_attribute *attr, const char *buf, size_t count)
 {
-	struct mmc_card *card = dev_to_mmc_card(dev);
+	struct mmc_card *card = mmc_dev_to_card(dev);
 	struct mmc_test_card *test;
 	int testcase;
 
diff -puN drivers/mmc/core/bus.c~mmc-rename-dev_to_mmc_card-to-mmc_dev_to_card drivers/mmc/core/bus.c
--- a/drivers/mmc/core/bus.c~mmc-rename-dev_to_mmc_card-to-mmc_dev_to_card
+++ a/drivers/mmc/core/bus.c
@@ -27,7 +27,7 @@
 static ssize_t mmc_type_show(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
-	struct mmc_card *card = dev_to_mmc_card(dev);
+	struct mmc_card *card = mmc_dev_to_card(dev);
 
 	switch (card->type) {
 	case MMC_TYPE_MMC:
@@ -61,7 +61,7 @@ static int mmc_bus_match(struct device *
 static int
 mmc_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
-	struct mmc_card *card = dev_to_mmc_card(dev);
+	struct mmc_card *card = mmc_dev_to_card(dev);
 	const char *type;
 	int retval = 0;
 
@@ -104,7 +104,7 @@ mmc_bus_uevent(struct device *dev, struc
 static int mmc_bus_probe(struct device *dev)
 {
 	struct mmc_driver *drv = to_mmc_driver(dev->driver);
-	struct mmc_card *card = dev_to_mmc_card(dev);
+	struct mmc_card *card = mmc_dev_to_card(dev);
 
 	return drv->probe(card);
 }
@@ -112,7 +112,7 @@ static int mmc_bus_probe(struct device *
 static int mmc_bus_remove(struct device *dev)
 {
 	struct mmc_driver *drv = to_mmc_driver(dev->driver);
-	struct mmc_card *card = dev_to_mmc_card(dev);
+	struct mmc_card *card = mmc_dev_to_card(dev);
 
 	drv->remove(card);
 
@@ -122,7 +122,7 @@ static int mmc_bus_remove(struct device 
 static int mmc_bus_suspend(struct device *dev, pm_message_t state)
 {
 	struct mmc_driver *drv = to_mmc_driver(dev->driver);
-	struct mmc_card *card = dev_to_mmc_card(dev);
+	struct mmc_card *card = mmc_dev_to_card(dev);
 	int ret = 0;
 
 	if (dev->driver && drv->suspend)
@@ -133,7 +133,7 @@ static int mmc_bus_suspend(struct device
 static int mmc_bus_resume(struct device *dev)
 {
 	struct mmc_driver *drv = to_mmc_driver(dev->driver);
-	struct mmc_card *card = dev_to_mmc_card(dev);
+	struct mmc_card *card = mmc_dev_to_card(dev);
 	int ret = 0;
 
 	if (dev->driver && drv->resume)
@@ -188,7 +188,7 @@ EXPORT_SYMBOL(mmc_unregister_driver);
 
 static void mmc_release_card(struct device *dev)
 {
-	struct mmc_card *card = dev_to_mmc_card(dev);
+	struct mmc_card *card = mmc_dev_to_card(dev);
 
 	sdio_free_common_cis(card);
 
diff -puN drivers/mmc/core/bus.h~mmc-rename-dev_to_mmc_card-to-mmc_dev_to_card drivers/mmc/core/bus.h
--- a/drivers/mmc/core/bus.h~mmc-rename-dev_to_mmc_card-to-mmc_dev_to_card
+++ a/drivers/mmc/core/bus.h
@@ -14,7 +14,7 @@
 #define MMC_DEV_ATTR(name, fmt, args...)					\
 static ssize_t mmc_##name##_show (struct device *dev, struct device_attribute *attr, char *buf)	\
 {										\
-	struct mmc_card *card = dev_to_mmc_card(dev);				\
+	struct mmc_card *card = mmc_dev_to_card(dev);				\
 	return sprintf(buf, fmt, args);						\
 }										\
 static DEVICE_ATTR(name, S_IRUGO, mmc_##name##_show, NULL)
diff -puN include/linux/mmc/card.h~mmc-rename-dev_to_mmc_card-to-mmc_dev_to_card include/linux/mmc/card.h
--- a/include/linux/mmc/card.h~mmc-rename-dev_to_mmc_card-to-mmc_dev_to_card
+++ a/include/linux/mmc/card.h
@@ -173,7 +173,7 @@ static inline int mmc_blksz_for_byte_mod
 #define mmc_card_name(c)	((c)->cid.prod_name)
 #define mmc_card_id(c)		(dev_name(&(c)->dev))
 
-#define dev_to_mmc_card(d)	container_of(d, struct mmc_card, dev)
+#define mmc_dev_to_card(d)	container_of(d, struct mmc_card, dev)
 
 #define mmc_list_to_card(l)	container_of(l, struct mmc_card, node)
 #define mmc_get_drvdata(c)	dev_get_drvdata(&(c)->dev)
_

Patches currently in -mm which might be from andy.shevchenko@gmail.com are

linux-next.patch
scripts-mod-modpostc-fix-commentary-accordingly-to-last-changes.patch
mmc-make-dev_to_mmc_card-macro-public.patch
mmc-rename-dev_to_mmc_card-to-mmc_dev_to_card.patch


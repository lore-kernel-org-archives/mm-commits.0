From: akpm@linux-foundation.org
Subject: + drivers-leds-leds-lp5521c-check-if-reset-is-successful.patch added to -mm tree
Date: Tue, 18 Oct 2011 14:11:18 -0700
Message-ID: <201110182111.p9ILBJL6030560@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:46463 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab1JRVL2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2011 17:11:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: srinidhi.kasagar@stericsson.com, linus.walleij@linaro.org, naga.radheshy@stericsson.com, richard.purdie@linuxfoundation.org


The patch titled
     Subject: drivers/leds/leds-lp5521.c: check if reset is successful
has been added to the -mm tree.  Its filename is
     drivers-leds-leds-lp5521c-check-if-reset-is-successful.patch

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
From: Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Subject: drivers/leds/leds-lp5521.c: check if reset is successful

Make sure that the reset is successful by issuing a dummy read to R
channel current register and check its default value.  On some platforms,
without this dummy read, any further access to {R/G/B}_EXEC will not have
any impact.

Signed-off-by: srinidhi kasagar <srinidhi.kasagar@stericsson.com>
Tested-by: Naga Radhesh <naga.radheshy@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Richard Purdie <richard.purdie@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lp5521.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff -puN drivers/leds/leds-lp5521.c~drivers-leds-leds-lp5521c-check-if-reset-is-successful drivers/leds/leds-lp5521.c
--- a/drivers/leds/leds-lp5521.c~drivers-leds-leds-lp5521c-check-if-reset-is-successful
+++ a/drivers/leds/leds-lp5521.c
@@ -97,6 +97,9 @@
 /* Status */
 #define LP5521_EXT_CLK_USED		0x08
 
+/* default R channel current register value */
+#define LP5521_REG_R_CURR_DEFAULT	0xAF
+
 struct lp5521_engine {
 	int		id;
 	u8		mode;
@@ -643,6 +646,7 @@ static int __devinit lp5521_probe(struct
 	struct lp5521_chip		*chip;
 	struct lp5521_platform_data	*pdata;
 	int ret, i, led;
+	u8 buf;
 
 	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
 	if (!chip)
@@ -681,6 +685,21 @@ static int __devinit lp5521_probe(struct
 				     * Exact value is not available. 10 - 20ms
 				     * appears to be enough for reset.
 				     */
+
+	/*
+	 * Make sure that the chip is reset by reading back
+	 * r channel current reg. This is a dummy read, otherwise
+	 * in some platforms, access to R G B channel program
+	 * execution mode to 'Run' in LP5521_REG_ENABLE register
+	 * will not have any affect - strange!
+	 */
+	lp5521_read(client, LP5521_REG_R_CURRENT, &buf);
+	if (buf != LP5521_REG_R_CURR_DEFAULT) {
+		dev_err(&client->dev, "error in reseting chip\n");
+		goto fail2;
+	}
+	usleep_range(10000, 20000);
+
 	ret = lp5521_detect(client);
 
 	if (ret) {
_
Subject: Subject: drivers/leds/leds-lp5521.c: check if reset is successful

Patches currently in -mm which might be from srinidhi.kasagar@stericsson.com are

origin.patch
linux-next.patch
arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file.patch
drivers-leds-leds-lp5521c-check-if-reset-is-successful.patch
drivers-leds-leds-lp5521c-check-if-reset-is-successful-fix.patch


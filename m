From: akpm@linux-foundation.org
Subject: + backlight-lm3630-potential-null-deref-in-probe.patch added to
 -mm tree
Date: Wed, 25 Sep 2013 14:24:19 -0700
Message-ID: <52435483.0PPj41HpHyO3cR7w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49629 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918Ab3IYVYU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Sep 2013 17:24:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, dan.carpenter@oracle.com

Subject: + backlight-lm3630-potential-null-deref-in-probe.patch added to -mm tree
To: dan.carpenter@oracle.com,jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Wed, 25 Sep 2013 14:24:19 -0700


The patch titled
     Subject: drivers/video/backlight/lm3630a_bl.c: potential NULL deref in probe()
has been added to the -mm tree.  Its filename is
     backlight-lm3630-potential-null-deref-in-probe.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/backlight-lm3630-potential-null-deref-in-probe.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/backlight-lm3630-potential-null-deref-in-probe.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: drivers/video/backlight/lm3630a_bl.c: potential NULL deref in probe()

We dereference "pdata" later in the function so we can't leave it as NULL.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lm3630a_bl.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff -puN drivers/video/backlight/lm3630a_bl.c~backlight-lm3630-potential-null-deref-in-probe drivers/video/backlight/lm3630a_bl.c
--- a/drivers/video/backlight/lm3630a_bl.c~backlight-lm3630-potential-null-deref-in-probe
+++ a/drivers/video/backlight/lm3630a_bl.c
@@ -389,22 +389,21 @@ static int lm3630a_probe(struct i2c_clie
 
 	i2c_set_clientdata(client, pchip);
 	if (pdata == NULL) {
-		pchip->pdata = devm_kzalloc(pchip->dev,
-					    sizeof(struct
-						   lm3630a_platform_data),
-					    GFP_KERNEL);
-		if (pchip->pdata == NULL)
+		pdata = devm_kzalloc(pchip->dev,
+				     sizeof(struct lm3630a_platform_data),
+				     GFP_KERNEL);
+		if (pdata == NULL)
 			return -ENOMEM;
 		/* default values */
-		pchip->pdata->leda_ctrl = LM3630A_LEDA_ENABLE;
-		pchip->pdata->ledb_ctrl = LM3630A_LEDB_ENABLE;
-		pchip->pdata->leda_max_brt = LM3630A_MAX_BRIGHTNESS;
-		pchip->pdata->ledb_max_brt = LM3630A_MAX_BRIGHTNESS;
-		pchip->pdata->leda_init_brt = LM3630A_MAX_BRIGHTNESS;
-		pchip->pdata->ledb_init_brt = LM3630A_MAX_BRIGHTNESS;
-	} else {
-		pchip->pdata = pdata;
+		pdata->leda_ctrl = LM3630A_LEDA_ENABLE;
+		pdata->ledb_ctrl = LM3630A_LEDB_ENABLE;
+		pdata->leda_max_brt = LM3630A_MAX_BRIGHTNESS;
+		pdata->ledb_max_brt = LM3630A_MAX_BRIGHTNESS;
+		pdata->leda_init_brt = LM3630A_MAX_BRIGHTNESS;
+		pdata->ledb_init_brt = LM3630A_MAX_BRIGHTNESS;
 	}
+	pchip->pdata = pdata;
+
 	/* chip initialize */
 	rval = lm3630a_chip_init(pchip);
 	if (rval < 0) {
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
backlight-lm3630-signedness-bug-in-lm3630a_chip_init.patch
backlight-lm3630-potential-null-deref-in-probe.patch
linux-next.patch


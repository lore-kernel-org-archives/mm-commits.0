From: akpm@linux-foundation.org
Subject: [merged] backlight-lm3630-potential-null-deref-in-probe.patch
 removed from -mm tree
Date: Wed, 13 Nov 2013 12:40:34 -0800
Message-ID: <5283e3c2.Rlcq5AGbYPSZSCIW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42938 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab3KMUke (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:40:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, dan.carpenter@oracle.com

Subject: [merged] backlight-lm3630-potential-null-deref-in-probe.patch removed from -mm tree
To: dan.carpenter@oracle.com,jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:40:34 -0800


The patch titled
     Subject: drivers/video/backlight/lm3630a_bl.c: potential NULL deref in probe()
has been removed from the -mm tree.  Its filename was
     backlight-lm3630-potential-null-deref-in-probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
framework-for-version-lvb-remove-some-impossible-checks.patch
drivers-block-paride-pgc-underflow-bug-in-pg_write.patch
xfs-underflow-bug-in-xfs_attrlist_by_handle.patch
linux-next.patch


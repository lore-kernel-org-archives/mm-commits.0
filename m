From: akpm@linux-foundation.org
Subject: [merged] fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:43:44 -0700
Message-ID: <200904011843.n31Ihi22010169@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933550AbZDASqC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:46:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kristoffer.ericson@gmail.com, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     fbdev: update s1d13xxxfb to differ between revisions and production ids
has been removed from the -mm tree.  Its filename was
     fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: update s1d13xxxfb to differ between revisions and production ids
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>

The s1d13xxx chip provides two values of identification value: the
Production id (e.g 13506/13505/13806..) and a revision number 0,1,2,3). 
Together these can help us to differentiate between similiar setups.

This patch adds the proper way of grabbing both those values and save them
for future reference (in order to decide what functions a card supports,
e.g acceleration).

We also move away from the concept of all s1d13xxx = s1d13806 when we
really support alot more.

[akpm@linux-foundation.org: coding-style fixes]
[akpm@linux-foundation.org: simplify s1d13xxxfb_probe()]
Signed-off-by: Kristoffer Ericson <kristoffer.ericson@gmail.com
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s1d13xxxfb.c |   48 ++++++++++++++++++++++++++---------
 include/video/s1d13xxxfb.h |   16 +++++++----
 2 files changed, 46 insertions(+), 18 deletions(-)

diff -puN drivers/video/s1d13xxxfb.c~fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids drivers/video/s1d13xxxfb.c
--- a/drivers/video/s1d13xxxfb.c~fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids
+++ a/drivers/video/s1d13xxxfb.c
@@ -50,9 +50,22 @@
 #define dbg(fmt, args...) do { } while (0)
 #endif
 
-static const int __devinitconst s1d13xxxfb_revisions[] = {
-	S1D13506_CHIP_REV,	/* Rev.4 on HP Jornada 7xx S1D13506 */
-	S1D13806_CHIP_REV,	/* Rev.7 on .. */
+/*
+ * List of card production ids
+ */
+static const int s1d13xxxfb_prod_ids[] = {
+	S1D13505_PROD_ID,
+	S1D13506_PROD_ID,
+	S1D13806_PROD_ID,
+};
+
+/*
+ * List of card strings
+ */
+static const char *s1d13xxxfb_prod_names[] = {
+	"S1D13505",
+	"S1D13506",
+	"S1D13806",
 };
 
 /*
@@ -377,7 +390,6 @@ s1d13xxxfb_pan_display(struct fb_var_scr
 	return 0;
 }
 
-
 /* framebuffer information structures */
 
 static struct fb_ops s1d13xxxfb_fbops = {
@@ -544,7 +556,7 @@ s1d13xxxfb_probe(struct platform_device 
 	struct s1d13xxxfb_pdata *pdata = NULL;
 	int ret = 0;
 	int i;
-	u8 revision;
+	u8 revision, prod_id;
 
 	dbg("probe called: device is %p\n", pdev);
 
@@ -613,19 +625,31 @@ s1d13xxxfb_probe(struct platform_device 
 		goto bail;
 	}
 
-	revision = s1d13xxxfb_readreg(default_par, S1DREG_REV_CODE) >> 2;
-
+	/* production id is top 6 bits */
+	prod_id = s1d13xxxfb_readreg(default_par, S1DREG_REV_CODE) >> 2;
+	/* revision id is lower 2 bits */
+	revision = s1d13xxxfb_readreg(default_par, S1DREG_REV_CODE) & 0x3;
 	ret = -ENODEV;
 
-	for (i = 0; i < ARRAY_SIZE(s1d13xxxfb_revisions); i++) {
-		if (revision == s1d13xxxfb_revisions[i])
+	for (i = 0; i < ARRAY_SIZE(s1d13xxxfb_prod_ids); i++) {
+		if (prod_id == s1d13xxxfb_prod_ids[i]) {
+			/* looks like we got it in our list */
+			default_par->prod_id = prod_id;
+			default_par->revision = revision;
 			ret = 0;
+			break;
+		}
 	}
 
-	if (!ret)
+	if (!ret) {
+		printk(KERN_INFO PFX "chip production id %i = %s\n",
+			prod_id, s1d13xxxfb_prod_names[i]);
 		printk(KERN_INFO PFX "chip revision %i\n", revision);
-	else {
-		printk(KERN_INFO PFX "unknown chip revision %i\n", revision);
+	} else {
+		printk(KERN_INFO PFX
+			"unknown chip production id %i, revision %i\n",
+			prod_id, revision);
+		printk(KERN_INFO PFX "please contant maintainer\n");
 		goto bail;
 	}
 
diff -puN include/video/s1d13xxxfb.h~fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids include/video/s1d13xxxfb.h
--- a/include/video/s1d13xxxfb.h~fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids
+++ a/include/video/s1d13xxxfb.h
@@ -14,13 +14,16 @@
 #define	S1D13XXXFB_H
 
 #define S1D_PALETTE_SIZE		256
-#define S1D13506_CHIP_REV		4	/* expected chip revision number for s1d13506 */
-#define S1D13806_CHIP_REV		7	/* expected chip revision number for s1d13806 */
-#define S1D_FBID			"S1D13806"
-#define S1D_DEVICENAME			"s1d13806fb"
+#define S1D_FBID			"S1D13xxx"
+#define S1D_DEVICENAME			"s1d13xxxfb"
+
+/* S1DREG_REV_CODE register = prod_id (6 bits) + revision (2 bits) */
+#define S1D13505_PROD_ID		0x3	/* 000011 */
+#define S1D13506_PROD_ID		0x4	/* 000100 */
+#define S1D13806_PROD_ID		0x7	/* 000111 */
 
 /* register definitions (tested on s1d13896) */
-#define S1DREG_REV_CODE			0x0000	/* Revision Code Register */
+#define S1DREG_REV_CODE			0x0000	/* Prod + Rev Code Register */
 #define S1DREG_MISC			0x0001	/* Miscellaneous Register */
 #define S1DREG_GPIO_CNF0		0x0004	/* General IO Pins Configuration Register 0 */
 #define S1DREG_GPIO_CNF1		0x0005	/* General IO Pins Configuration Register 1 */
@@ -141,10 +144,11 @@ struct s1d13xxxfb_regval {
 	u8	value;
 };
 

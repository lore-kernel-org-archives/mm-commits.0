From: akpm@linux-foundation.org
Subject: + fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids.patch added to -mm tree
Date: Tue, 10 Feb 2009 16:26:33 -0800
Message-ID: <200902110026.n1B0QXjk032684@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59728 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754465AbZBKA0k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Feb 2009 19:26:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kristoffer.ericson@gmail.com, krzysztof.h1@poczta.fm


The patch titled
     fbdev: update s1d13xxxfb to differ between revisions and production ids
has been added to the -mm tree.  Its filename is
     fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids.patch

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
Subject: fbdev: update s1d13xxxfb to differ between revisions and production ids
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>

The s1d13xxx chip provides two values of identification value: the
Production id (e.g 13506/13505/13806..) and a revision number 0,1,2,3). 
Together these can help us to differentiate between similiar setups.

This patch adds the proper way of grabbing both those values and save them
for future reference (=3D in order to decide what functions a card
supports, e.g acceleration).

We also move away from the concept of all s1d13xxx = s1d13806 when we
really support alot more.

Signed-off-by: Kristoffer Ericson <kristoffer.ericson@gmail.com
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s1d13xxxfb.c |   48 ++++++++++++++++++++++++++---------
 1 file changed, 36 insertions(+), 12 deletions(-)

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
+	u8 revision,prod_id;
 
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
+		}
+
+		/* jump ship if we find something */
+		if (!ret)
+			break;
 	}
 
-	if (!ret)
+	if (!ret) {
+		printk(KERN_INFO PFX "chip production id %i = %s\n", prod_id, s1d13xxxfb_prod_names[i]);
 		printk(KERN_INFO PFX "chip revision %i\n", revision);
-	else {
-		printk(KERN_INFO PFX "unknown chip revision %i\n", revision);
+	} else {
+		printk(KERN_INFO PFX "unknown chip production id %i, revision %i\n", prod_id, revision);
+		printk(KERN_INFO PFX "please contant maintainer\n");
 		goto bail;
 	}
 
_

Patches currently in -mm which might be from kristoffer.ericson@gmail.com are

fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-checkpatch-fixes.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-simplification.patch


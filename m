From: akpm@linux-foundation.org
Subject: + matroxfb-use-kzalloc.patch added to -mm tree
Date: Tue, 06 Feb 2007 16:30:46 -0800
Message-ID: <200702070030.l170Ukix001914@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56581 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030447AbXBGAbO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Feb 2007 19:31:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, jsimmons@infradead.org, vandrove@vc.cvut.cz


The patch titled
     matroxfb: Use kzalloc
has been added to the -mm tree.  Its filename is
     matroxfb-use-kzalloc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: matroxfb: Use kzalloc
From: Jean Delvare <khali@linux-fr.org>

Use kzalloc instead of kmalloc+memset, twice.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Petr Vandrovec <vandrove@vc.cvut.cz>
Acked-By: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/matrox/i2c-matroxfb.c   |    4 +---
 drivers/video/matrox/matroxfb_crtc2.c |    3 +--
 2 files changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/video/matrox/i2c-matroxfb.c~matroxfb-use-kzalloc drivers/video/matrox/i2c-matroxfb.c
--- a/drivers/video/matrox/i2c-matroxfb.c~matroxfb-use-kzalloc
+++ a/drivers/video/matrox/i2c-matroxfb.c
@@ -147,7 +147,7 @@ static void* i2c_matroxfb_probe(struct m
 	unsigned long flags;
 	struct matroxfb_dh_maven_info* m2info;
 
-	m2info = kmalloc(sizeof(*m2info), GFP_KERNEL);
+	m2info = kzalloc(sizeof(*m2info), GFP_KERNEL);
 	if (!m2info)
 		return NULL;
 
@@ -156,8 +156,6 @@ static void* i2c_matroxfb_probe(struct m
 	matroxfb_DAC_out(PMINFO DAC_XGENIOCTRL, 0x00);
 	matroxfb_DAC_unlock_irqrestore(flags);
 
-	memset(m2info, 0, sizeof(*m2info));
-
 	switch (ACCESS_FBINFO(chip)) {
 		case MGA_2064:
 		case MGA_2164:
diff -puN drivers/video/matrox/matroxfb_crtc2.c~matroxfb-use-kzalloc drivers/video/matrox/matroxfb_crtc2.c
--- a/drivers/video/matrox/matroxfb_crtc2.c~matroxfb-use-kzalloc
+++ a/drivers/video/matrox/matroxfb_crtc2.c
@@ -694,12 +694,11 @@ static void* matroxfb_crtc2_probe(struct
 	/* hardware is CRTC2 incapable... */
 	if (!ACCESS_FBINFO(devflags.crtc2))
 		return NULL;
-	m2info = kmalloc(sizeof(*m2info), GFP_KERNEL);
+	m2info = kzalloc(sizeof(*m2info), GFP_KERNEL);
 	if (!m2info) {
 		printk(KERN_ERR "matroxfb_crtc2: Not enough memory for CRTC2 control structs\n");
 		return NULL;
 	}
-	memset(m2info, 0, sizeof(*m2info));
 	m2info->primary_dev = MINFO;
 	if (matroxfb_dh_registerfb(m2info)) {
 		kfree(m2info);
_

Patches currently in -mm which might be from khali@linux-fr.org are

git-alsa.patch
matroxfb-use-kzalloc.patch

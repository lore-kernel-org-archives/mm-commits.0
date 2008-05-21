From: akpm@linux-foundation.org
Subject: + s3c2410-add-error-print-if-we-cannot-add-attribute.patch added to -mm tree
Date: Wed, 21 May 2008 15:14:05 -0700
Message-ID: <200805212214.m4LME62g003456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751116AbYEUWOp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 May 2008 18:14:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-fbdev@fluff.org, arnaud.patard@rtp-net.org, ben-linux@fluff.org, krzysztof.h1@wp.pl


The patch titled
     S3C2410: add error print if we cannot add attribute
has been added to the -mm tree.  Its filename is
     s3c2410-add-error-print-if-we-cannot-add-attribute.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: S3C2410: add error print if we cannot add attribute
From: Ben Dooks <ben-fbdev@fluff.org>

Fix the following warning by checking the result of device_create_file and
printing an error but not removing the device (loss of debug registers is
not fatal).

drivers/video/s3c2410fb.c:905: warning: ignoring return value of 'device_create_file', declared with attribute warn_unused_result

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c2410fb.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/video/s3c2410fb.c~s3c2410-add-error-print-if-we-cannot-add-attribute drivers/video/s3c2410fb.c
--- a/drivers/video/s3c2410fb.c~s3c2410-add-error-print-if-we-cannot-add-attribute
+++ a/drivers/video/s3c2410fb.c
@@ -972,7 +972,10 @@ static int __init s3c24xxfb_probe(struct
 	}
 
 	/* create device files */
-	device_create_file(&pdev->dev, &dev_attr_debug);
+	ret = device_create_file(&pdev->dev, &dev_attr_debug);
+	if (ret) {
+		printk(KERN_ERR "failed to add debug attribute\n");
+	}
 
 	printk(KERN_INFO "fb%d: %s frame buffer device\n",
 		fbinfo->node, fbinfo->fix.id);
_

Patches currently in -mm which might be from ben-fbdev@fluff.org are

sm501-reverse-fpen-vbiasen-flags-behaviour.patch
s3c2410-ensure-that-fb_blank_powerdown-shuts-down-the-controller.patch
s3c2410-add-error-print-if-we-cannot-add-attribute.patch
s3c2410-clean-out-changelog-header-and-tidy.patch
s3c2410-fix-driver-module_alias.patch


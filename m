From: akpm@linux-foundation.org
Subject: - s3c2410-add-error-print-if-we-cannot-add-attribute.patch removed from -mm tree
Date: Tue, 27 May 2008 00:28:00 -0700
Message-ID: <200805270728.m4R7S084014808@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756075AbYE0H3I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 03:29:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-fbdev@fluff.org, arnaud.patard@rtp-net.org, ben-linux@fluff.org, krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     S3C2410: add error print if we cannot add attribute
has been removed from the -mm tree.  Its filename was
     s3c2410-add-error-print-if-we-cannot-add-attribute.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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



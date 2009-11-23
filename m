From: akpm@linux-foundation.org
Subject: + sm501-fix-missing-uses-of-resource_size.patch added to -mm tree
Date: Mon, 23 Nov 2009 12:41:08 -0800
Message-ID: <200911232041.nANKf9vg010119@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756923AbZKWUlP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Nov 2009 15:41:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@simtec.co.uk, krzysztof.h1@poczta.fm, linux@simtec.co.uk, vince@simtec.co.uk


The patch titled
     sm501: fix missing uses of resource_size()
has been added to the -mm tree.  Its filename is
     sm501-fix-missing-uses-of-resource_size.patch

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
Subject: sm501: fix missing uses of resource_size()
From: Ben Dooks <ben@simtec.co.uk>

There are several places in the SM501 fb driver that could do with using
resource_size() to calculate the size of a resource.

Also fix a bug where request_mem_region() is being passed one too few
bytes when requesting the register memory region, which was causing the
following in /proc/iomem:

 13e80000-13e8ffff : sm501-fb.0
   13e80000-13e8fffe : sm501-fb

fixed, this reads:

 13e80000-13e8ffff : sm501-fb.0
   13e80000-13e8ffff : sm501-fb

Signed-off-by: Ben Dooks <ben@simtec.co.uk>
Signed-off-by: Simtec Linux Team <linux@simtec.co.uk>
Cc: Vincent Sanders <vince@simtec.co.uk>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sm501fb.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/video/sm501fb.c~sm501-fix-missing-uses-of-resource_size drivers/video/sm501fb.c
--- a/drivers/video/sm501fb.c~sm501-fix-missing-uses-of-resource_size
+++ a/drivers/video/sm501fb.c
@@ -1338,7 +1338,7 @@ static int sm501fb_start(struct sm501fb_
 	}
 
 	info->regs_res = request_mem_region(res->start,
-					    res->end - res->start,
+					    resource_size(res),
 					    pdev->name);
 
 	if (info->regs_res == NULL) {
@@ -1347,7 +1347,7 @@ static int sm501fb_start(struct sm501fb_
 		goto err_release;
 	}
 
-	info->regs = ioremap(res->start, (res->end - res->start)+1);
+	info->regs = ioremap(res->start, resource_size(res));
 	if (info->regs == NULL) {
 		dev_err(dev, "cannot remap registers\n");
 		ret = -ENXIO;
@@ -1363,7 +1363,7 @@ static int sm501fb_start(struct sm501fb_
 	}
 
 	info->fbmem_res = request_mem_region(res->start,
-					     (res->end - res->start)+1,
+					     resource_size(res),
 					     pdev->name);
 	if (info->fbmem_res == NULL) {
 		dev_err(dev, "cannot claim framebuffer\n");
@@ -1371,13 +1371,13 @@ static int sm501fb_start(struct sm501fb_
 		goto err_regs_map;
 	}
 
-	info->fbmem = ioremap(res->start, (res->end - res->start)+1);
+	info->fbmem = ioremap(res->start, resource_size(res));
 	if (info->fbmem == NULL) {
 		dev_err(dev, "cannot remap framebuffer\n");
 		goto err_mem_res;
 	}
 
-	info->fbmem_len = (res->end - res->start)+1;
+	info->fbmem_len = resource_size(res);
 
 	/* clear framebuffer memory - avoids garbage data on unused fb */
 	memset(info->fbmem, 0, info->fbmem_len);
_

Patches currently in -mm which might be from ben@simtec.co.uk are

linux-next.patch
s3cmci-convert-missed-s3c2410_gpio-calls-to-gpiolib-calls.patch
spi_s3c24xx-add-fiq-pseudo-dma-support.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
sm501-fix-missing-uses-of-resource_size.patch
sm501-fix-use-of-old-asm-ioh-instead-of-linux-ioh.patch
sm501-implement-acceleration-features.patch


From: akpm@linux-foundation.org
Subject: + atmel_lcdfb-change-irq_base-definition-to-allow-error-reporting.patch added to -mm tree
Date: Thu, 06 Nov 2008 17:35:07 -0800
Message-ID: <200811070135.mA71Z78G013269@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750698AbYKGBfX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Nov 2008 20:35:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nicolas.ferre@atmel.com, hskinnemoen@atmel.com, linux@maxim.org.za, roel.kluin@gmail.com


The patch titled
     atmel_lcdfb: change irq_base definition to allow error reporting
has been added to the -mm tree.  Its filename is
     atmel_lcdfb-change-irq_base-definition-to-allow-error-reporting.patch

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
Subject: atmel_lcdfb: change irq_base definition to allow error reporting
From: Nicolas Ferre <nicolas.ferre@atmel.com>

Changed because old the definition of unsigned long cannot be negative.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Reported-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Andrew Victor <linux@maxim.org.za>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/video/atmel_lcdc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/video/atmel_lcdc.h~atmel_lcdfb-change-irq_base-definition-to-allow-error-reporting include/video/atmel_lcdc.h
--- a/include/video/atmel_lcdc.h~atmel_lcdfb-change-irq_base-definition-to-allow-error-reporting
+++ a/include/video/atmel_lcdc.h
@@ -38,7 +38,7 @@ struct atmel_lcdfb_info {
 	spinlock_t		lock;
 	struct fb_info		*info;
 	void __iomem		*mmio;
-	unsigned long		irq_base;
+	int			irq_base;
 	struct work_struct	task;
 
 	unsigned int		guard_time;
_

Patches currently in -mm which might be from nicolas.ferre@atmel.com are

atmel_lcdfb-change-irq_base-definition-to-allow-error-reporting.patch


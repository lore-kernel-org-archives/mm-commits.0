From: akpm@linux-foundation.org
Subject: + drivers-misc-atmel-sscc-use-resource_size.patch added to -mm tree
Date: Thu, 09 Jun 2011 16:28:18 -0700
Message-ID: <201106092328.p59NSItF007882@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752715Ab1FIX2T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2011 19:28:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, hsweeten@visionengravers.com


The patch titled
     drivers/misc/atmel-ssc.c: use resource_size()
has been added to the -mm tree.  Its filename is
     drivers-misc-atmel-sscc-use-resource_size.patch

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
Subject: drivers/misc/atmel-ssc.c: use resource_size()
From: H Hartley Sweeten <hartleys@visionengravers.com>

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/atmel-ssc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/atmel-ssc.c~drivers-misc-atmel-sscc-use-resource_size drivers/misc/atmel-ssc.c
--- a/drivers/misc/atmel-ssc.c~drivers-misc-atmel-sscc-use-resource_size
+++ a/drivers/misc/atmel-ssc.c
@@ -95,7 +95,7 @@ static int __init ssc_probe(struct platf
 	}
 
 	ssc->pdev = pdev;
-	ssc->regs = ioremap(regs->start, regs->end - regs->start + 1);
+	ssc->regs = ioremap(regs->start, resource_size(regs));
 	if (!ssc->regs) {
 		dev_dbg(&pdev->dev, "ioremap failed\n");
 		retval = -EINVAL;
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

origin.patch
linux-next.patch
drivers-misc-atmel-sscc-use-resource_size.patch


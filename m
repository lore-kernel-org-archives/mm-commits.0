From: akpm@linux-foundation.org
Subject: + pl061-fix-offset-value-range-checking.patch added to -mm tree
Date: Wed, 21 Apr 2010 12:19:11 -0700
Message-ID: <201004211919.o3LJJBbX004154@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754129Ab0DUTTZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Apr 2010 15:19:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, baruch@tkos.co.il


The patch titled
     pl061: fix offset value range checking
has been added to the -mm tree.  Its filename is
     pl061-fix-offset-value-range-checking.patch

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
Subject: pl061: fix offset value range checking
From: Axel Lin <axel.lin@gmail.com>

The valid offset value is 0..PL061_GPIO_NR-1, this patch corrects the
offset value range checking.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/pl061.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpio/pl061.c~pl061-fix-offset-value-range-checking drivers/gpio/pl061.c
--- a/drivers/gpio/pl061.c~pl061-fix-offset-value-range-checking
+++ a/drivers/gpio/pl061.c
@@ -158,7 +158,7 @@ static int pl061_irq_type(unsigned irq, 
 	unsigned long flags;
 	u8 gpiois, gpioibe, gpioiev;
 
-	if (offset < 0 || offset > PL061_GPIO_NR)
+	if (offset < 0 || offset >= PL061_GPIO_NR)
 		return -EINVAL;
 
 	spin_lock_irqsave(&chip->irq_lock, flags);
_

Patches currently in -mm which might be from axel.lin@gmail.com are

linux-next.patch
pl061-fix-offset-value-range-checking.patch


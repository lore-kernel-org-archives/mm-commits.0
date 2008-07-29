From: akpm@linux-foundation.org
Subject: + rtc-m48t59-reduce-structure-m48t59_private.patch added to -mm tree
Date: Mon, 28 Jul 2008 22:26:31 -0700
Message-ID: <200807290526.m6T5QVLm016182@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752555AbYG2F0q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 01:26:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, a.zummo@towertech.it, david-b@pacbell.net


The patch titled
     rtc-m48t59: reduce structure m48t59_private
has been added to the -mm tree.  Its filename is
     rtc-m48t59-reduce-structure-m48t59_private.patch

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
Subject: rtc-m48t59: reduce structure m48t59_private
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Remove element size from the structure m48t59_private as it is used as
local variable for storing temporary value.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m48t59.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-m48t59.c~rtc-m48t59-reduce-structure-m48t59_private drivers/rtc/rtc-m48t59.c
--- a/drivers/rtc/rtc-m48t59.c~rtc-m48t59-reduce-structure-m48t59_private
+++ a/drivers/rtc/rtc-m48t59.c
@@ -34,7 +34,6 @@
 
 struct m48t59_private {
 	void __iomem *ioaddr;
-	unsigned int size; /* iomem size */
 	int irq;
 	struct rtc_device *rtc;
 	spinlock_t lock; /* serialize the NVRAM and RTC access */
@@ -403,8 +402,7 @@ static int __devinit m48t59_rtc_probe(st
 	if (!m48t59)
 		return -ENOMEM;
 
-	m48t59->size = res->end - res->start + 1;
-	m48t59->ioaddr = ioremap(res->start, m48t59->size);
+	m48t59->ioaddr = ioremap(res->start, res->end - res->start + 1);
 	if (!m48t59->ioaddr)
 		goto out;
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
drivers-video-release-mutex-in-error-handling-code.patch
linux-next.patch
rtc-m48t59-reduce-structure-m48t59_private.patch


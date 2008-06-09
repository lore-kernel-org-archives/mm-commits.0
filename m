From: akpm@linux-foundation.org
Subject: + smc911x-pass-along-private-data-and-use-iomem-fix.patch added to -mm tree
Date: Mon, 09 Jun 2008 15:05:14 -0700
Message-ID: <200806092205.m59M5EeB010571@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60140 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752885AbYFIWFi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2008 18:05:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl, damm@igel.co.jp, jeff@garzik.org, lethal@linux-sh.org


The patch titled
     smc911x-pass-along-private-data-and-use-iomem fix
has been added to the -mm tree.  Its filename is
     smc911x-pass-along-private-data-and-use-iomem-fix.patch

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
Subject: smc911x-pass-along-private-data-and-use-iomem fix
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Parenthesis fix in drivers/net/smc911x.h

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Magnus Damm <damm@igel.co.jp>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/smc911x.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/smc911x.h~smc911x-pass-along-private-data-and-use-iomem-fix drivers/net/smc911x.h
--- a/drivers/net/smc911x.h~smc911x-pass-along-private-data-and-use-iomem-fix
+++ a/drivers/net/smc911x.h
@@ -99,7 +99,7 @@ struct smc911x_local {
  */
 
 #if	SMC_USE_16BIT
-#define SMC_inl(lp, r)		 (readw((lp)->base + (r)) & 0xFFFF) + (readw((lp)->base + (r) + 2) << 16))
+#define SMC_inl(lp, r)		 ((readw((lp)->base + (r)) & 0xFFFF) + (readw((lp)->base + (r) + 2) << 16))
 #define SMC_outl(v, lp, r) 			 \
 	do{					 \
 		 writew(v & 0xFFFF, (lp)->base + (r));	 \
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

linux-next.patch
smc911x-pass-along-private-data-and-use-iomem-fix.patch
reiser4.patch


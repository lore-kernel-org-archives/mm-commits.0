From: akpm@linux-foundation.org
Subject: + smc91x-add-insw-outsw-to-default-config-v2.patch added to -mm tree
Date: Wed, 27 Feb 2008 13:27:23 -0800
Message-ID: <200802272127.m1RLRN0H031149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754700AbYB0V1v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 16:27:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: magnus.damm@gmail.com, damm@igel.co.jp, jeff@garzik.org, lethal@linux-sh.org, nico@cam.org


The patch titled
     smc91x: add insw/outsw to default config
has been added to the -mm tree.  Its filename is
     smc91x-add-insw-outsw-to-default-config-v2.patch

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
Subject: smc91x: add insw/outsw to default config
From: Magnus Damm <magnus.damm@gmail.com>

This patch makes sure SMC_insw()/SMC_outsw() are defined for the default
configuration.  Without this change BUG()s will be triggered when using 16-bit
only platform data and the default configuration.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Acked-by: Nicolas Pitre <nico@cam.org>
Cc: Paul Mundt <lethal@linux-sh.org>,
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/smc91x.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/net/smc91x.h~smc91x-add-insw-outsw-to-default-config-v2 drivers/net/smc91x.h
--- a/drivers/net/smc91x.h~smc91x-add-insw-outsw-to-default-config-v2
+++ a/drivers/net/smc91x.h
@@ -476,6 +476,8 @@ static inline void LPD7_SMC_outsw (unsig
 #define SMC_outb(v, a, r)	writeb(v, (a) + (r))
 #define SMC_outw(v, a, r)	writew(v, (a) + (r))
 #define SMC_outl(v, a, r)	writel(v, (a) + (r))
+#define SMC_insw(a, r, p, l)	readsw((a) + (r), p, l)
+#define SMC_outsw(a, r, p, l)	writesw((a) + (r), p, l)
 #define SMC_insl(a, r, p, l)	readsl((a) + (r), p, l)
 #define SMC_outsl(a, r, p, l)	writesl((a) + (r), p, l)
 
_

Patches currently in -mm which might be from magnus.damm@gmail.com are

smc91x-pass-along-private-data-v2.patch
smc91x-introduce-platform-data-flags-v2.patch
smc91x-add-insw-outsw-to-default-config-v2.patch
smc91x-make-superh-use-default-config-v2.patch
sh-revert-dreamcast-pci-change.patch
sm501-add-uart-support.patch

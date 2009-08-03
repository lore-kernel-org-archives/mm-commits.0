From: akpm@linux-foundation.org
Subject: + drivers-rtc-correct-error-handling-code.patch added to -mm tree
Date: Mon, 03 Aug 2009 13:07:27 -0700
Message-ID: <200908032007.n73K7Ri9015751@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33312 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752408AbZHCUHr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Aug 2009 16:07:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, david-b@pacbell.net, w.sang@pengutronix.de


The patch titled
     drivers/rtc: correct error-handling code
has been added to the -mm tree.  Its filename is
     drivers-rtc-correct-error-handling-code.patch

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
Subject: drivers/rtc: correct error-handling code
From: Julia Lawall <julia@diku.dk>

This code is not executed before ds1307->rtc has been successfully
initialized to the result of calling rtc_device_register.  Thus the test
that ds1307->rtc is not NULL is always true.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@match exists@
expression x, E;
statement S1, S2;
@@

x = rtc_device_register(...)
... when != x = E
(
*  if (x == NULL || ...) S1 else S2
|
*  if (x == NULL && ...) S1 else S2
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-ds1307.c~drivers-rtc-correct-error-handling-code drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~drivers-rtc-correct-error-handling-code
+++ a/drivers/rtc/rtc-ds1307.c
@@ -896,8 +896,7 @@ read_rtc:
 	return 0;
 
 exit_irq:
-	if (ds1307->rtc)
-		rtc_device_unregister(ds1307->rtc);
+	rtc_device_unregister(ds1307->rtc);
 exit_free:
 	kfree(ds1307);
 	return err;
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-media-dvb-use-dst_type-field-instead-of-type_flags.patch
drivers-ata-use-resource_size.patch
drivers-rtc-correct-error-handling-code.patch
drivers-video-imxfbc-fix-resource-size-off-by-1-error.patch
edac-fix-resource-size-calculation.patch
fs-romfs-correct-error-handling-code.patch
drivers-vlynq-vlynqc-fix-resource-size-off-by-1-error.patch


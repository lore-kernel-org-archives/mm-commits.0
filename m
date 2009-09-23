From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-correct-error-handling-code.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:59:12 -0700
Message-ID: <200909231959.n8NJxC2I010458@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56147 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753808AbZIWT71 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:59:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, david-b@pacbell.net, w.sang@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     drivers/rtc: correct error-handling code
has been removed from the -mm tree.  Its filename was
     drivers-rtc-correct-error-handling-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
drivers-md-introduce-missing-kfree.patch
edac-fix-resource-size-calculation.patch
fs-romfs-correct-error-handling-code.patch
drivers-vlynq-vlynqc-fix-resource-size-off-by-1-error.patch


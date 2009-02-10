From: akpm@linux-foundation.org
Subject: + rtc-t-reaches-1-tested-0.patch added to -mm tree
Date: Tue, 10 Feb 2009 11:38:32 -0800
Message-ID: <200902101938.n1AJcWmG022658@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55728 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754219AbZBJTk0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Feb 2009 14:40:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, a.zummo@towertech.it, david-b@pacbell.net, mano@roarinelk.homelinux.net


The patch titled
     rtc: t reaches -1, tested 0
has been added to the -mm tree.  Its filename is
     rtc-t-reaches-1-tested-0.patch

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
Subject: rtc: t reaches -1, tested 0
From: Roel Kluin <roel.kluin@gmail.com>

With a postfix decrement t will reach -1 rather than 0, so neither the
warning nor the `goto error_out' will occur.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Manuel Lauss <mano@roarinelk.homelinux.net>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-au1xxx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-au1xxx.c~rtc-t-reaches-1-tested-0 drivers/rtc/rtc-au1xxx.c
--- a/drivers/rtc/rtc-au1xxx.c~rtc-t-reaches-1-tested-0
+++ a/drivers/rtc/rtc-au1xxx.c
@@ -81,7 +81,7 @@ static int __devinit au1xtoy_rtc_probe(s
 	if (au_readl(SYS_TOYTRIM) != 32767) {
 		/* wait until hardware gives access to TRIM register */
 		t = 0x00100000;
-		while ((au_readl(SYS_COUNTER_CNTRL) & SYS_CNTRL_T0S) && t--)
+		while ((au_readl(SYS_COUNTER_CNTRL) & SYS_CNTRL_T0S) && --t)
 			msleep(1);
 
 		if (!t) {
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
leds-fix-confusion.patch
paride-pgc-xs-confusion.patch
mm-get_nid_for_pfn-returns-int.patch
alpha-fix-macros.patch
spi-limit-reaches-1-tested-0.patch
rtc-wm8350-retries-will-reach-1.patch
rtc-t-reaches-1-tested-0.patch
ufs-sector_t-cannot-be-negative.patch


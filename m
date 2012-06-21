From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-r9701c-avoid-second-call-to-rtc_valid_tm.patch added to -mm tree
Date: Thu, 21 Jun 2012 13:51:45 -0700
Message-ID: <20120621205146.0BBE0A0329@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:39709 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760246Ab2FUUvs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 16:51:48 -0400
Received: by eaao13 with SMTP id o13so65722eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 13:51:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: devendra.aaru@gmail.com, a.zummo@towertech.it, agust@denx.de, andreas.dumberger@tqs.de


The patch titled
     Subject: drivers/rtc/rtc-r9701.c: avoid second call to rtc_valid_tm()
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-r9701c-avoid-second-call-to-rtc_valid_tm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Devendra Naga <devendra.aaru@gmail.com>
Subject: drivers/rtc/rtc-r9701.c: avoid second call to rtc_valid_tm()

r9701_get_datetime() calls rtc_valid_tm() and returns the value returned
by rtc_valid_tm(), which can be used in the `if', so calling
rtc_valid_tm() a second time is not required.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Anatolij Gustschin <agust@denx.de>
Cc: Andreas Dumberger <andreas.dumberger@tqs.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-r9701.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-r9701.c~drivers-rtc-rtc-r9701c-avoid-second-call-to-rtc_valid_tm drivers/rtc/rtc-r9701.c
--- a/drivers/rtc/rtc-r9701.c~drivers-rtc-rtc-r9701c-avoid-second-call-to-rtc_valid_tm
+++ a/drivers/rtc/rtc-r9701.c
@@ -138,8 +138,7 @@ static int __devinit r9701_probe(struct 
 	 * contain invalid values. If so, try to write a default date:
 	 * 2000/1/1 00:00:00
 	 */
-	r9701_get_datetime(&spi->dev, &dt);
-	if (rtc_valid_tm(&dt)) {
+	if (r9701_get_datetime(&spi->dev, &dt)) {
 		dev_info(&spi->dev, "trying to repair invalid date/time\n");
 		dt.tm_sec  = 0;
 		dt.tm_min  = 0;
_
Subject: Subject: drivers/rtc/rtc-r9701.c: avoid second call to rtc_valid_tm()

Patches currently in -mm which might be from devendra.aaru@gmail.com are

origin.patch
linux-next.patch
drivers-rtc-rtc-spearc-fix-use-after-free-in-spear_rtc_remove.patch
drivers-rtc-rtc-r9701c-avoid-second-call-to-rtc_valid_tm.patch
drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch


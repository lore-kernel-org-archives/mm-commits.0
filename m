From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-cmosc-fix-broken-nvram-bank-2-writing.patch added to -mm tree
Date: Tue, 22 Nov 2011 15:16:26 -0800
Message-ID: <201111222316.pAMNGQSw028848@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:62085 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835Ab1KVXQe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2011 18:16:34 -0500
Received: by wwe5 with SMTP id 5so28499wwe.1
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2011 15:16:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@rainbow-software.org, a.zummo@towertech.it


The patch titled
     Subject: drivers/rtc/rtc-cmos.c: fix broken NVRAM bank 2 writing
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-cmosc-fix-broken-nvram-bank-2-writing.patch

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
From: Ondrej Zary <linux@rainbow-software.org>
Subject: drivers/rtc/rtc-cmos.c: fix broken NVRAM bank 2 writing

Fix writing to NVRAM bank 2 in rtc-cmos driver.  It never worked since its
introduction in 2.6.28 because of a typo.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-cmos.c~drivers-rtc-rtc-cmosc-fix-broken-nvram-bank-2-writing drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~drivers-rtc-rtc-cmosc-fix-broken-nvram-bank-2-writing
+++ a/drivers/rtc/rtc-cmos.c
@@ -164,7 +164,7 @@ static inline unsigned char cmos_read_ba
 static inline void cmos_write_bank2(unsigned char val, unsigned char addr)
 {
 	outb(addr, RTC_PORT(2));
-	outb(val, RTC_PORT(2));
+	outb(val, RTC_PORT(3));
 }
 
 #else
_
Subject: Subject: drivers/rtc/rtc-cmos.c: fix broken NVRAM bank 2 writing

Patches currently in -mm which might be from linux@rainbow-software.org are

cyber2000fb-avoid-palette-corruption-at-higher-clocks.patch
drivers-rtc-rtc-cmosc-fix-broken-nvram-bank-2-writing.patch


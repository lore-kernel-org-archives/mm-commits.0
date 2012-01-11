From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-cmosc-fix-broken-nvram-bank-2-writing.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:31:56 -0800
Message-ID: <20120111213156.953091E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:61363 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab2AKVb5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:31:57 -0500
Received: by mail-gx0-f202.google.com with SMTP id k3so134903ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:31:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rainbow-software.org, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-cmos.c: fix broken NVRAM bank 2 writing
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-cmosc-fix-broken-nvram-bank-2-writing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from linux@rainbow-software.org are

origin.patch
linux-next.patch
cyber2000fb-avoid-palette-corruption-at-higher-clocks.patch


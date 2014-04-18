From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-pcf8523c-fix-month-definition.patch added to
 -mm tree
Date: Fri, 18 Apr 2014 12:57:14 -0700
Message-ID: <5351839a.QdHbeN+z/KDe1gBq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42194 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594AbaDRT5P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Apr 2014 15:57:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, a.zummo@towertech.it, chris.wei.cui@gmail.com

Subject: + drivers-rtc-rtc-pcf8523c-fix-month-definition.patch added to -mm tree
To: chris.wei.cui@gmail.com,a.zummo@towertech.it
From: akpm@linux-foundation.org
Date: Fri, 18 Apr 2014 12:57:14 -0700


The patch titled
     Subject: drivers/rtc/rtc-pcf8523.c: fix month definition
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-pcf8523c-fix-month-definition.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-pcf8523c-fix-month-definition.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-pcf8523c-fix-month-definition.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chris Cui <chris.wei.cui@gmail.com>
Subject: drivers/rtc/rtc-pcf8523.c: fix month definition

PCF8523 uses 1-12 to represent month according to datasheet.
link: www.nxp.com/documents/data_sheet/PCF8523.pdf.

Signed-off-by: Chris Cui <chris.wei.cui@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8523.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-pcf8523.c~drivers-rtc-rtc-pcf8523c-fix-month-definition drivers/rtc/rtc-pcf8523.c
--- a/drivers/rtc/rtc-pcf8523.c~drivers-rtc-rtc-pcf8523c-fix-month-definition
+++ a/drivers/rtc/rtc-pcf8523.c
@@ -206,7 +206,7 @@ static int pcf8523_rtc_read_time(struct
 	tm->tm_hour = bcd2bin(regs[2] & 0x3f);
 	tm->tm_mday = bcd2bin(regs[3] & 0x3f);
 	tm->tm_wday = regs[4] & 0x7;
-	tm->tm_mon = bcd2bin(regs[5] & 0x1f);
+	tm->tm_mon = bcd2bin(regs[5] & 0x1f) - 1;
 	tm->tm_year = bcd2bin(regs[6]) + 100;
 
 	return rtc_valid_tm(tm);
@@ -229,7 +229,7 @@ static int pcf8523_rtc_set_time(struct d
 	regs[3] = bin2bcd(tm->tm_hour);
 	regs[4] = bin2bcd(tm->tm_mday);
 	regs[5] = tm->tm_wday;
-	regs[6] = bin2bcd(tm->tm_mon);
+	regs[6] = bin2bcd(tm->tm_mon + 1);
 	regs[7] = bin2bcd(tm->tm_year - 100);
 
 	msg.addr = client->addr;
_

Patches currently in -mm which might be from chris.wei.cui@gmail.com are

drivers-rtc-rtc-pcf8523c-fix-month-definition.patch


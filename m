From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-pcf8523c-fix-month-definition.patch
 removed from -mm tree
Date: Wed, 07 May 2014 12:04:56 -0700
Message-ID: <536a83d8.DN5vjvmSEYaLihiM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56098 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaEGTE5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2014 15:04:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, a.zummo@towertech.it, chris.wei.cui@gmail.com

Subject: [merged] drivers-rtc-rtc-pcf8523c-fix-month-definition.patch removed from -mm tree
To: chris.wei.cui@gmail.com,a.zummo@towertech.it,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 07 May 2014 12:04:56 -0700


The patch titled
     Subject: drivers/rtc/rtc-pcf8523.c: fix month definition
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-pcf8523c-fix-month-definition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch


From: akpm@linux-foundation.org
Subject: [merged] rtc-pcf8563-fix-pcf8563_irq-error-return-value.patch
 removed from -mm tree
Date: Tue, 14 Oct 2014 11:20:52 -0700
Message-ID: <543d6984.U0RgZUgZCTEqEPut%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44352 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbaJNSUv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:20:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, a.zummo@towertech.it, sergei.shtylyov@cogentembedded.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-pcf8563.c: fix pcf8563_irq() error return value
has been removed from the -mm tree.  Its filename was
     rtc-pcf8563-fix-pcf8563_irq-error-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: drivers/rtc/rtc-pcf8563.c: fix pcf8563_irq() error return value

As pointed out by Sergei Shtylyov, the pcf8563_irq function contains a bug
in the error handling: an interrupt handler is not supposed to return an
errno value but an 'enum irqreturn'.

Let's fix this by returning IRQ_NONE in case of a communication error.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8563.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-pcf8563.c~rtc-pcf8563-fix-pcf8563_irq-error-return-value drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c~rtc-pcf8563-fix-pcf8563_irq-error-return-value
+++ a/drivers/rtc/rtc-pcf8563.c
@@ -168,7 +168,7 @@ static irqreturn_t pcf8563_irq(int irq,
 
 	err = pcf8563_get_alarm_mode(pcf8563->client, NULL, &pending);
 	if (err)
-		return err;
+		return IRQ_NONE;
 
 	if (pending) {
 		rtc_update_irq(pcf8563->rtc, 1, RTC_IRQF | RTC_AF);
_

Patches currently in -mm which might be from arnd@arndb.de are

origin.patch
linux-next.patch


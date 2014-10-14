From: akpm@linux-foundation.org
Subject: [merged] rtc-pcf8563-fix-uninitialized-use-warning.patch removed
 from -mm tree
Date: Tue, 14 Oct 2014 11:20:50 -0700
Message-ID: <543d6982.PV5qrDYaxtc8Wl8W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44347 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbaJNSUt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:20:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, a.zummo@towertech.it, sergei.shtylyov@cogentembedded.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-pcf8563.c: fix uninitialized use warning
has been removed from the -mm tree.  Its filename was
     rtc-pcf8563-fix-uninitialized-use-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: drivers/rtc/rtc-pcf8563.c: fix uninitialized use warning

gcc-4.9 found a potential condition under which the 'pending' variable may
be used uninitialized:

drivers/rtc/rtc-pcf8563.c: In function 'pcf8563_irq':
drivers/rtc/rtc-pcf8563.c:173:5: warning: 'pending' may be used uninitialized in this function [-Wmaybe-uninitialized]

This is because in the pcf8563_get_alarm_mode() function, we check any
nonzero return of pcf8563_read_block_data, but in the irq function we only
check for negative values, so a possible positive value does not get
detected if the compiler chooses not to inline the entire call chain.

Checking for any non-zero value in the interrupt handler as well is just
as correct and lets the compiler know what we are doing, without needing a
bogus initialization.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8563.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-pcf8563.c~rtc-pcf8563-fix-uninitialized-use-warning drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c~rtc-pcf8563-fix-uninitialized-use-warning
+++ a/drivers/rtc/rtc-pcf8563.c
@@ -167,7 +167,7 @@ static irqreturn_t pcf8563_irq(int irq,
 	char pending;
 
 	err = pcf8563_get_alarm_mode(pcf8563->client, NULL, &pending);
-	if (err < 0)
+	if (err)
 		return err;
 
 	if (pending) {
_

Patches currently in -mm which might be from arnd@arndb.de are

origin.patch
linux-next.patch


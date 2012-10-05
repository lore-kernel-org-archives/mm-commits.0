From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-jz4740c-fix-irq-error-check.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:17:00 -0700
Message-ID: <20121005201701.3A54C5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:60327 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab2JEURC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:17:02 -0400
Received: by mail-we0-f202.google.com with SMTP id x43so139620wey.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:17:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lars@metafoo.de, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-jz4740.c: fix IRQ error check
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-jz4740c-fix-irq-error-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lars-Peter Clausen <lars@metafoo.de>
Subject: drivers/rtc/rtc-jz4740.c: fix IRQ error check

The irq field of the jz4740_irc struct is unsigned.  Yet we assign the
result of platform_get_irq() to it.  platform_get_irq() may return a
negative error code and the code checks for this condition by checking if
'irq' is less than zero.  But since 'irq' is unsigned this test will
always be false.  Fix it by making 'irq' signed.

The issue was found using the following coccinelle semantic patch:

//<smpl>
@@
type T;
unsigned T i;
@@
(
*i < 0
|
*i >= 0
)
//</smpl>

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-jz4740.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-jz4740.c~drivers-rtc-rtc-jz4740c-fix-irq-error-check drivers/rtc/rtc-jz4740.c
--- a/drivers/rtc/rtc-jz4740.c~drivers-rtc-rtc-jz4740c-fix-irq-error-check
+++ a/drivers/rtc/rtc-jz4740.c
@@ -42,7 +42,7 @@ struct jz4740_rtc {
 
 	struct rtc_device *rtc;
 
-	unsigned int irq;
+	int irq;
 
 	spinlock_t lock;
 };
_

Patches currently in -mm which might be from lars@metafoo.de are

origin.patch
linux-next.patch


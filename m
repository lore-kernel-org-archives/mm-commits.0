From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-jz4740c-fix-irq-error-check.patch added to -mm tree
Date: Wed, 22 Aug 2012 16:49:26 -0700
Message-ID: <20120822234928.00A955C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:44706 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296Ab2HVXta (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Aug 2012 19:49:30 -0400
Received: by faem1 with SMTP id m1so5109fae.1
        for <mm-commits@vger.kernel.org>; Wed, 22 Aug 2012 16:49:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lars@metafoo.de, a.zummo@towertech.it


The patch titled
     Subject: drivers/rtc/rtc-jz4740.c: fix IRQ error check
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-jz4740c-fix-irq-error-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
drivers-rtc-rtc-jz4740c-fix-irq-error-check.patch
drivers-rtc-rtc-spearc-fix-several-error-checks.patch


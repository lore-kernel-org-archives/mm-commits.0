From: akpm@linux-foundation.org
Subject: + arm-at91-fix-rtc-irq-mask-for-sam9x5-socs.patch added to -mm
 tree
Date: Thu, 29 May 2014 16:09:54 -0700
Message-ID: <5387be42.521nuQ79GZ8BxMwA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46213 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbaE2XJz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 May 2014 19:09:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, plagnioj@jcrosoft.com, nicolas.ferre@atmel.com, mark.roszko@gmail.com, linux@maxim.org.za, johan@hovold.com, bevenson@melinkcorp.com, a.zummo@towertech.it, boris.brezillon@free-electrons.com

Subject: + arm-at91-fix-rtc-irq-mask-for-sam9x5-socs.patch added to -mm tree
To: boris.brezillon@free-electrons.com,a.zummo@towertech.it,bevenson@melinkcorp.com,johan@hovold.com,linux@maxim.org.za,mark.roszko@gmail.com,nicolas.ferre@atmel.com,plagnioj@jcrosoft.com
From: akpm@linux-foundation.org
Date: Thu, 29 May 2014 16:09:54 -0700


The patch titled
     Subject: ARM: at91: fix rtc irq mask for sam9x5 SoCs
has been added to the -mm tree.  Its filename is
     arm-at91-fix-rtc-irq-mask-for-sam9x5-socs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-at91-fix-rtc-irq-mask-for-sam9x5-socs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-at91-fix-rtc-irq-mask-for-sam9x5-socs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: ARM: at91: fix rtc irq mask for sam9x5 SoCs

The RTC IMR register is not reliable on sam9x5 SoCs, hence why me have to
mask all interrupts no matter what IMR claims about already masked irqs.

Mark said:

: Atmel actually has this issue in the Errata of the SAM9G25 and SAM9G35
: datasheets which might be worth referencing in the description?

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Reported-by: Bryan Evenson <bevenson@melinkcorp.com>
Tested-by: Bryan Evenson <bevenson@melinkcorp.com>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Mark Roszko <mark.roszko@gmail.com>
Cc: Johan Hovold <johan@hovold.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-at91/sysirq_mask.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN arch/arm/mach-at91/sysirq_mask.c~arm-at91-fix-rtc-irq-mask-for-sam9x5-socs arch/arm/mach-at91/sysirq_mask.c
--- a/arch/arm/mach-at91/sysirq_mask.c~arm-at91-fix-rtc-irq-mask-for-sam9x5-socs
+++ a/arch/arm/mach-at91/sysirq_mask.c
@@ -37,12 +37,7 @@ void __init at91_sysirq_mask_rtc(u32 rtc
 	if (!base)
 		return;
 
-	mask = readl_relaxed(base + AT91_RTC_IMR);
-	if (mask) {
-		pr_info("AT91: Disabling rtc irq\n");
-		writel_relaxed(mask, base + AT91_RTC_IDR);
-		(void)readl_relaxed(base + AT91_RTC_IMR);	/* flush */
-	}
+	writel_relaxed(0x1f, base + AT91_RTC_IDR);
 
 	iounmap(base);
 }
_

Patches currently in -mm which might be from boris.brezillon@free-electrons.com are

rtc-rtc-at91rm9200-fix-infinite-wait-for-ackupd-irq.patch
rtc-rtc-at91rm9200-fix-infinite-wait-for-ackupd-irq-v2.patch
arm-at91-fix-rtc-irq-mask-for-sam9x5-socs.patch
linux-next.patch


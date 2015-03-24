From: akpm@linux-foundation.org
Subject: + rtc-at91rm9200-make-io-endian-agnostic.patch added to -mm tree
Date: Tue, 24 Mar 2015 15:21:52 -0700
Message-ID: <5511e380.RagduGQYn99c/g/S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbbCXWVx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Mar 2015 18:21:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben.dooks@codethink.co.uk, a.zummo@towertech.it, linux@maxim.org.za, nicolas.ferre@atmel.com, plagnioj@jcrosoft.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-at91rm9200.c: make IO endian agnostic
has been added to the -mm tree.  Its filename is
     rtc-at91rm9200-make-io-endian-agnostic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-at91rm9200-make-io-endian-agnostic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-at91rm9200-make-io-endian-agnostic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ben Dooks <ben.dooks@codethink.co.uk>
Subject: drivers/rtc/rtc-at91rm9200.c: make IO endian agnostic

Change the __raw IO calls to readl/write_relaxed which makes the driver
endian agnostic to run properly on big endian systems.

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Andrew Victor <linux@maxim.org.za>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at91rm9200.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-at91rm9200.c~rtc-at91rm9200-make-io-endian-agnostic drivers/rtc/rtc-at91rm9200.c
--- a/drivers/rtc/rtc-at91rm9200.c~rtc-at91rm9200-make-io-endian-agnostic
+++ a/drivers/rtc/rtc-at91rm9200.c
@@ -37,9 +37,9 @@
 #include "rtc-at91rm9200.h"
 
 #define at91_rtc_read(field) \
-	__raw_readl(at91_rtc_regs + field)
+	readl_relaxed(at91_rtc_regs + field)
 #define at91_rtc_write(field, val) \
-	__raw_writel((val), at91_rtc_regs + field)
+	writel_relaxed((val), at91_rtc_regs + field)
 
 #define AT91_RTC_EPOCH		1900UL	/* just like arch/arm/common/rtctime.c */
 
_

Patches currently in -mm which might be from ben.dooks@codethink.co.uk are

linux-next.patch
rtc-at91rm9200-make-io-endian-agnostic.patch


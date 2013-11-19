From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-at91sam9c-include-mach-hardwareh-explicitly.patch added to
 -mm tree
Date: Tue, 19 Nov 2013 15:55:16 -0800
Message-ID: <528bfa64.EWkMPVZ5xt40w+Zm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42733 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab3KSXzR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Nov 2013 18:55:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, plagnioj@jcrosoft.com, u.kleine-koenig@pengutronix.de

Subject: + drivers-rtc-rtc-at91sam9c-include-mach-hardwareh-explicitly.patch added to -mm tree
To: u.kleine-koenig@pengutronix.de,plagnioj@jcrosoft.com
From: akpm@linux-foundation.org
Date: Tue, 19 Nov 2013 15:55:16 -0800


The patch titled
     Subject: drivers/rtc/rtc-at91sam9.c: include <mach/hardware.h> explicitly
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-at91sam9c-include-mach-hardwareh-explicitly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-at91sam9c-include-mach-hardwareh-explicitly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-at91sam9c-include-mach-hardwareh-explicitly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Subject: drivers/rtc/rtc-at91sam9.c: include <mach/hardware.h> explicitly

The driver needs the symbol AT91_SLOW_CLOCK which is defined in
arch/arm/mach-at91/include/mach/hardware.h. This file is included
implicitly via linux/module.h -> linux/kmod.h -> linux/gfp.h ->
linux/mmzone.h -> linux/memory_hotplug.h -> linux/notifier.h ->
linux/srcu.h -> linux/workqueue.h -> linux/timer.h -> linux/ktime.h ->
linux/jiffies.h -> linux/timex.h -> mach/timex.h -> mach/hardware.h .

So better include it explicitly not only because the last link will go
away soon.  My intent is to get rid of <mach/timex.h>

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at91sam9.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-at91sam9.c~drivers-rtc-rtc-at91sam9c-include-mach-hardwareh-explicitly drivers/rtc/rtc-at91sam9.c
--- a/drivers/rtc/rtc-at91sam9.c~drivers-rtc-rtc-at91sam9c-include-mach-hardwareh-explicitly
+++ a/drivers/rtc/rtc-at91sam9.c
@@ -24,7 +24,7 @@
 
 #include <mach/at91_rtt.h>
 #include <mach/cpu.h>

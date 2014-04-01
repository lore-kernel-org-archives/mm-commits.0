From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-s3cc-remove-no_irq-macro.patch added to -mm
 tree
Date: Tue, 01 Apr 2014 15:54:22 -0700
Message-ID: <533b439e.+ByV9WXzr7TWstCt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39331 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaDAWyX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2014 18:54:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, a.zummo@towertech.it, pankaj.dubey@samsung.com

Subject: + drivers-rtc-rtc-s3cc-remove-no_irq-macro.patch added to -mm tree
To: pankaj.dubey@samsung.com,a.zummo@towertech.it
From: akpm@linux-foundation.org
Date: Tue, 01 Apr 2014 15:54:22 -0700


The patch titled
     Subject: drivers/rtc/rtc-s3c.c: remove NO_IRQ macro
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-s3cc-remove-no_irq-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-s3cc-remove-no_irq-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-s3cc-remove-no_irq-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: drivers/rtc/rtc-s3c.c: remove NO_IRQ macro

NO_IRQ may be defined as '(unsigned int) -1' in some architectures (arm,
sh ...), and either may not be defined in some architectures (arm64) which
can enable RTC_DRV_S3C.

Also since platform_get_irq returns err-code in case of any error, we do
not need to intialize s3c_rtc_alarmno and s3c_rtc_tickno.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~drivers-rtc-rtc-s3cc-remove-no_irq-macro drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~drivers-rtc-rtc-s3cc-remove-no_irq-macro
+++ a/drivers/rtc/rtc-s3c.c
@@ -48,8 +48,8 @@ struct s3c_rtc_drv_data {
 
 static struct clk *rtc_clk;
 static void __iomem *s3c_rtc_base;
-static int s3c_rtc_alarmno = NO_IRQ;
-static int s3c_rtc_tickno  = NO_IRQ;
+static int s3c_rtc_alarmno;
+static int s3c_rtc_tickno;
 static enum s3c_cpu_type s3c_rtc_cpu_type;
 
 static DEFINE_SPINLOCK(s3c_rtc_pie_lock);
_

Patches currently in -mm which might be from pankaj.dubey@samsung.com are

drivers-rtc-rtc-s3cc-remove-no_irq-macro.patch
linux-next.patch


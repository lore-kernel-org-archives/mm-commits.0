From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-pcf50633c-fix-use-after-free-in-pcf50633_rtc_probe.patch removed from -mm tree
Date: Thu, 03 Dec 2009 12:35:47 -0800
Message-ID: <200912032035.nB3KZlTP010682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754350AbZLCUfs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Dec 2009 15:35:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, a.zummo@towertech.it, david-b@pacbell.net, p_gortmaker@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     drivers/rtc/rtc-pcf50633.c: fix use after free in pcf50633_rtc_probe()
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-pcf50633c-fix-use-after-free-in-pcf50633_rtc_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/rtc/rtc-pcf50633.c: fix use after free in pcf50633_rtc_probe()
From: Dan Carpenter <error27@gmail.com>

"rtc" is freed and then dereferenced on the next line.  This patch fixes
that.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf50633.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-pcf50633.c~drivers-rtc-rtc-pcf50633c-fix-use-after-free-in-pcf50633_rtc_probe drivers/rtc/rtc-pcf50633.c
--- a/drivers/rtc/rtc-pcf50633.c~drivers-rtc-rtc-pcf50633c-fix-use-after-free-in-pcf50633_rtc_probe
+++ a/drivers/rtc/rtc-pcf50633.c
@@ -292,8 +292,9 @@ static int __devinit pcf50633_rtc_probe(
 				&pcf50633_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(rtc->rtc_dev)) {
+		int ret =  PTR_ERR(rtc->rtc_dev);
 		kfree(rtc);
-		return PTR_ERR(rtc->rtc_dev);
+		return ret;
 	}
 
 	pcf50633_register_irq(rtc->pcf, PCF50633_IRQ_ALARM,
_

Patches currently in -mm which might be from error27@gmail.com are

linux-next.patch
drivers-video-via-viafbdevc-fix-oops-with-no-proc.patch
kexec-premit-reduction-of-the-reserved-memory-size-fix.patch


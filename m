From: akpm@linux-foundation.org
Subject: [merged] drivers-w1-masters-w1-gpioc-fix-read_bit.patch removed from -mm tree
Date: Fri, 13 Mar 2009 11:19:20 -0700
Message-ID: <200903131819.n2DIJKbC008568@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759546AbZCMSXX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Mar 2009 14:23:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel@caiaq.de, david-b@pacbell.net, johnpol@2ka.mipt.ru, syrjala@sci.fi, mm-commits@vger.kernel.org


The patch titled
     drivers/w1/masters/w1-gpio.c: fix read_bit()
has been removed from the -mm tree.  Its filename was
     drivers-w1-masters-w1-gpioc-fix-read_bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/w1/masters/w1-gpio.c: fix read_bit()
From: Daniel Mack <daniel@caiaq.de>

W1 master implementations are expected to return 0 or 1 from their
read_bit() function.  However, not all platforms do return these values
from gpio_get_value() - namely PXAs won't.  Hence the w1 gpio-master needs
to break the result down to 0 or 1 itself.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Ville Syrjala <syrjala@sci.fi>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/w1-gpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/w1/masters/w1-gpio.c~drivers-w1-masters-w1-gpioc-fix-read_bit drivers/w1/masters/w1-gpio.c
--- a/drivers/w1/masters/w1-gpio.c~drivers-w1-masters-w1-gpioc-fix-read_bit
+++ a/drivers/w1/masters/w1-gpio.c
@@ -39,7 +39,7 @@ static u8 w1_gpio_read_bit(void *data)
 {
 	struct w1_gpio_platform_data *pdata = data;
 
-	return gpio_get_value(pdata->pin);
+	return gpio_get_value(pdata->pin) ? 1 : 0;
 }
 
 static int __init w1_gpio_probe(struct platform_device *pdev)
_

Patches currently in -mm which might be from daniel@caiaq.de are

origin.patch
linux-next.patch
drivers-misc-isl29003c-driver-for-the-isl29003-ambient-light-sensor.patch
drivers-misc-isl29003c-driver-for-the-isl29003-ambient-light-sensor-fix.patch
w1-coding-style-cleanups-in-w1_ioc.patch


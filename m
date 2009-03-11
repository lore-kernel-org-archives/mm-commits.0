From: akpm@linux-foundation.org
Subject: + drivers-w1-masters-w1-gpioc-fix-read_bit.patch added to -mm tree
Date: Tue, 10 Mar 2009 18:18:28 -0700
Message-ID: <200903110118.n2B1ISSR027971@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753935AbZCKBU1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Mar 2009 21:20:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel@caiaq.de, david-b@pacbell.net, johnpol@2ka.mipt.ru, syrjala@sci.fi


The patch titled
     drivers/w1/masters/w1-gpio.c: fix read_bit()
has been added to the -mm tree.  Its filename is
     drivers-w1-masters-w1-gpioc-fix-read_bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

drivers-w1-masters-w1-gpioc-fix-read_bit.patch
linux-next.patch
ds2760_batteryc-fix-division-by-zero.patch
w1-coding-style-cleanups-in-w1_ioc.patch


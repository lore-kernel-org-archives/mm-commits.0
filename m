From: akpm@linux-foundation.org
Subject: + gpiolib-gpio_request_one-add-missing-gpio_free.patch added to -mm tree
Date: Thu, 09 Dec 2010 12:48:58 -0800
Message-ID: <201012092048.oB9Kmwh6006170@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53279 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757012Ab0LIUte (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Dec 2010 15:49:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aaro.koskinen@nokia.com, eric.miao@canonical.com


The patch titled
     gpiolib: gpio_request_one(): add missing gpio_free()
has been added to the -mm tree.  Its filename is
     gpiolib-gpio_request_one-add-missing-gpio_free.patch

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
Subject: gpiolib: gpio_request_one(): add missing gpio_free()
From: Aaro Koskinen <aaro.koskinen@nokia.com>

If GPIO request succeeds, but configuration fails, it should be released.

Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
Acked-by: Eric Miao <eric.miao@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpiolib.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/gpio/gpiolib.c~gpiolib-gpio_request_one-add-missing-gpio_free drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpiolib-gpio_request_one-add-missing-gpio_free
+++ a/drivers/gpio/gpiolib.c
@@ -1281,6 +1281,9 @@ int gpio_request_one(unsigned gpio, unsi
 		err = gpio_direction_output(gpio,
 				(flags & GPIOF_INIT_HIGH) ? 1 : 0);
 
+	if (err)
+		gpio_free(gpio);
+
 	return err;
 }
 EXPORT_SYMBOL_GPL(gpio_request_one);
_

Patches currently in -mm which might be from aaro.koskinen@nokia.com are

linux-next.patch
gpiolib-gpio_request_one-add-missing-gpio_free.patch


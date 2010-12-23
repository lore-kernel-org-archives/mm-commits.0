From: akpm@linux-foundation.org
Subject: [merged] gpiolib-gpio_request_one-add-missing-gpio_free.patch removed from -mm tree
Date: Thu, 23 Dec 2010 14:36:29 -0800
Message-ID: <201012232240.oBNMeGhI015441@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751658Ab0LWWkZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Dec 2010 17:40:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aaro.koskinen@nokia.com, eric.miao@canonical.com, mm-commits@vger.kernel.org


The patch titled
     gpiolib: gpio_request_one(): add missing gpio_free()
has been removed from the -mm tree.  Its filename was
     gpiolib-gpio_request_one-add-missing-gpio_free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch


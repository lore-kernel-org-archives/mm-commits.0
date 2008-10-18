From: akpm@linux-foundation.org
Subject: - gpio_free-might-sleep-generic-part.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:15:53 -0700
Message-ID: <200810182315.m9INFrUf028700@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751560AbYJRXQM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:16:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ukleinek@informatik.uni-freiburg.de, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     gpio_free might sleep, generic part
has been removed from the -mm tree.  Its filename was
     gpio_free-might-sleep-generic-part.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: gpio_free might sleep, generic part
=46rom: Uwe Kleine-K=F6nig <ukleinek@informatik.uni-freiburg.de>

According to the documentation gpio_free should only be called from tas=
k
context only.  To make this more explicit add a might sleep to all
implementations.

This is the generic part which changes gpiolib and the fallback
implementation only.

Signed-off-by: Uwe Kleine-K=F6nig <ukleinek@informatik.uni-freiburg.de>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpiolib.c |    2 ++
 include/linux/gpio.h   |    3 +++
 2 files changed, 5 insertions(+)

diff -puN drivers/gpio/gpiolib.c~gpio_free-might-sleep-generic-part dri=
vers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpio_free-might-sleep-generic-part
+++ a/drivers/gpio/gpiolib.c
@@ -792,6 +792,8 @@ void gpio_free(unsigned gpio)
 	unsigned long		flags;
 	struct gpio_desc	*desc;
=20
+	might_sleep();
+
 	if (!gpio_is_valid(gpio)) {
 		WARN_ON(extra_checks);
 		return;
diff -puN include/linux/gpio.h~gpio_free-might-sleep-generic-part inclu=
de/linux/gpio.h
--- a/include/linux/gpio.h~gpio_free-might-sleep-generic-part
+++ a/include/linux/gpio.h
@@ -8,6 +8,7 @@
=20
 #else
=20
+#include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/errno.h>
=20
@@ -32,6 +33,8 @@ static inline int gpio_request(unsigned=20
=20
 static inline void gpio_free(unsigned gpio)
 {
+	might_sleep();
+
 	/* GPIO can never have been requested */
 	WARN_ON(1);
 }
_

Patches currently in -mm which might be from ukleinek@informatik.uni-fr=
eiburg.de are

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: akpm@linux-foundation.org
Subject: + gpiolib-document-that-names-can-contain-printk-format-specifiers.patch added to -mm tree
Date: Wed, 24 Mar 2010 11:25:40 -0700
Message-ID: <201003241825.o2OIPeb8017072@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56343 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756703Ab0CXS0N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Mar 2010 14:26:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, david-b@pacbell.net


The patch titled
     gpiolib: document that names can contain printk format specifiers
has been added to the -mm tree.  Its filename is
     gpiolib-document-that-names-can-contain-printk-format-specifiers.p=
atch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: gpiolib: document that names can contain printk format specifi=
ers
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/gpio.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN include/asm-generic/gpio.h~gpiolib-document-that-names-can-co=
ntain-printk-format-specifiers include/asm-generic/gpio.h
--- a/include/asm-generic/gpio.h~gpiolib-document-that-names-can-contai=
n-printk-format-specifiers
+++ a/include/asm-generic/gpio.h
@@ -61,7 +61,9 @@ struct module;
  * @names: if set, must be an array of strings to use as alternative
  *      names for the GPIOs in this chip. Any entry in the array
  *      may be NULL if there is no alias for the GPIO, however the
- *      array must be @ngpio entries long.
+ *      array must be @ngpio entries long.  A name can include a singl=
e printk
+ *      format specifier for an unsigned int.  It is substituted by th=
e actual
+ *      number of the gpio.
  *
  * A gpio_chip can help platforms abstract various sources of GPIOs so
  * they can all be accessed through a common programing interface.
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

rtc-mc13783-fix-use-after-free-bug.patch
linux-next.patch
timer-print-function-name-for-timer-callbacks-modifying-preemption-coun=
t.patch
gpiolib-make-names-array-and-its-values-const.patch
gpiolib-a-gpio-is-unsigned-so-use-%u-to-print-it.patch
gpiolib-document-that-names-can-contain-printk-format-specifiers.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

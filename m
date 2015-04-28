From: akpm@linux-foundation.org
Subject: +
 util_macrosh-have-array-pointer-point-to-array-of-constants.patch added to
 -mm tree
Date: Tue, 28 Apr 2015 15:17:53 -0700
Message-ID: <55400711.yhuqNMyMdvRA1N/X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35025 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031048AbbD1WRy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Apr 2015 18:17:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@roeck-us.net, bgolaszewski@baylibre.com, mm-commits@vger.kernel.org


The patch titled
     Subject: util_macros.h: have array pointer point to array of constants
has been added to the -mm tree.  Its filename is
     util_macrosh-have-array-pointer-point-to-array-of-constants.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/util_macrosh-have-array-pointer-point-to-array-of-constants.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/util_macrosh-have-array-pointer-point-to-array-of-constants.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Guenter Roeck <linux@roeck-us.net>
Subject: util_macros.h: have array pointer point to array of constants

Using the new find_closest() macro can result in the following sparse
warnings.

drivers/hwmon/lm85.c:194:16: warning:
		incorrect type in initializer (different modifiers)
drivers/hwmon/lm85.c:194:16:    expected int *__fc_a
drivers/hwmon/lm85.c:194:16:    got int static const [toplevel] *<noident>
drivers/hwmon/lm85.c:210:16: warning:
		incorrect type in initializer (different modifiers)
drivers/hwmon/lm85.c:210:16:    expected int *__fc_a
drivers/hwmon/lm85.c:210:16:    got int const *map

This is because the array passed to find_closest() will typically be
declared as array of constants, but the macro declares a non-constant
pointer to it.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/util_macros.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/util_macros.h~util_macrosh-have-array-pointer-point-to-array-of-constants include/linux/util_macros.h
--- a/include/linux/util_macros.h~util_macrosh-have-array-pointer-point-to-array-of-constants
+++ a/include/linux/util_macros.h
@@ -5,7 +5,7 @@
 ({									\
 	typeof(as) __fc_i, __fc_as = (as) - 1;				\
 	typeof(x) __fc_x = (x);						\
-	typeof(*a) *__fc_a = (a);					\
+	typeof(*a) const *__fc_a = (a);					\
 	for (__fc_i = 0; __fc_i < __fc_as; __fc_i++) {			\
 		if (__fc_x op DIV_ROUND_CLOSEST(__fc_a[__fc_i] +	\
 						__fc_a[__fc_i + 1], 2))	\
_

Patches currently in -mm which might be from linux@roeck-us.net are

util_macrosh-have-array-pointer-point-to-array-of-constants.patch
linux-next.patch


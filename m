From: akpm@linux-foundation.org
Subject: + util_macrosh-add-find_closest-macro.patch added to -mm tree
Date: Fri, 20 Mar 2015 13:51:23 -0700
Message-ID: <550c884b.Pz9ipDIfpv49FJqp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53193 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbbCTUvY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Mar 2015 16:51:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bgolaszewski@baylibre.com, linux@roeck-us.net, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: util_macros.h: add find_closest() macro
has been added to the -mm tree.  Its filename is
     util_macrosh-add-find_closest-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/util_macrosh-add-find_closest-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/util_macrosh-add-find_closest-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: util_macros.h: add find_closest() macro

This series unduplicates the code used to find the member in an array
closest to 'x'.

The first patch adds a macro implementing the algorithm in two flavors -
for arrays sorted in ascending and descending order.  The second updates
Documentation/CodingStyle on the naming convention for local variables in
macros resembling functions.  Other three patches replace duplicated code
with calls to one of these macros in some hwmon drivers.


This patch (of 5):

Searching for the member of an array closest to 'x' is duplicated in
several places.

Add a new include - util_macros.h - and two macros that implement this
algorithm for arrays sorted both in ascending and descending order.

Uses linear search.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/util_macros.h |   40 ++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff -puN /dev/null include/linux/util_macros.h
--- /dev/null
+++ a/include/linux/util_macros.h
@@ -0,0 +1,40 @@
+#ifndef _LINUX_HELPER_MACROS_H_
+#define _LINUX_HELPER_MACROS_H_
+
+#define __find_closest(x, a, as, op)					\
+({									\
+	typeof(as) __fc_i, __fc_as = (as) - 1;				\
+	typeof(x) __fc_x = (x);						\
+	typeof(*a) *__fc_a = (a);					\
+	for (__fc_i = 0; __fc_i < __fc_as; __fc_i++) {			\
+		if (__fc_x op DIV_ROUND_CLOSEST(__fc_a[__fc_i] +	\
+						__fc_a[__fc_i + 1], 2))	\
+			break;						\
+	}								\
+	(__fc_i);							\
+})
+
+/**
+ * find_closest - locate the closest element in a sorted array
+ * @x: The reference value.
+ * @a: The array in which to look for the closest element. Must be sorted
+ *  in ascending order.
+ * @as: Size of 'a'.
+ *
+ * Returns the index of the element closest to 'x'.
+ */
+#define find_closest(x, a, as) __find_closest(x, a, as, <=)
+
+/**
+ * find_closest_descending - locate the closest element in a sorted array
+ * @x: The reference value.
+ * @a: The array in which to look for the closest element. Must be sorted
+ *  in descending order.
+ * @as: Size of 'a'.
+ *
+ * Similar to find_closest() but 'a' is expected to be sorted in descending
+ * order.
+ */
+#define find_closest_descending(x, a, as) __find_closest(x, a, as, >=)
+
+#endif
_

Patches currently in -mm which might be from bgolaszewski@baylibre.com are

util_macrosh-add-find_closest-macro.patch
documentation-update-codingstyle-on-local-variables-naming-in-macros.patch
hwmon-ina2xx-replace-ina226_avg_bits-with-find_closest.patch
hwmon-lm85-use-find_closest-in-x_to_reg-functions.patch
hwmon-w83795-use-find_closest_descending-in-pwm_freq_to_reg.patch


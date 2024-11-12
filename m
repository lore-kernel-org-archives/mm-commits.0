Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5832D2572;
	Tue, 12 Nov 2024 01:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731374259; cv=none; b=E0lWJilfStwprVZ9NUkCAKswA3SEM9iYwIaBPIq2//15Rmin+0cxLayu/qPnih4LV78WUmJD4xLRPrulV8O2jGc9+NNNVaMQGdMbywJkUbWt+khNCGxH9y7cmN2RNldTwunemf3wexdPOZTwhXh+nXZiUPEZktNZispxUQ1dLbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731374259; c=relaxed/simple;
	bh=QqTRCqxftAuIaA6AJ0SIBQX4YKWPg9Imb7z4Ah4WJd8=;
	h=Date:To:From:Subject:Message-Id; b=DsQLK85KWfAbjkGZD+l0iYeEYFWGs3Z6oNBO7/mBOVZHGuFdQv00Ju9LjD2+FmQUEnVo6Qp24ZUq4xMaIvTeq9tLFoPA8O9lMK3FO7TGBeG/YH8R7/dvRKqP1Vd2Vez3iHx9wZS5xmrpnL2fYBUX676V2/AGl2nJ0wu4CuC1yT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fumqaX+M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fumqaX+M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC0CC4CECF;
	Tue, 12 Nov 2024 01:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731374258;
	bh=QqTRCqxftAuIaA6AJ0SIBQX4YKWPg9Imb7z4Ah4WJd8=;
	h=Date:To:From:Subject:From;
	b=fumqaX+MNA0yA3gZ/zpnkxQ19JTcaGi3G69YpY8QoyuOLcRMZ9vfOQDOo+GIBONyS
	 glRL/8vca+jg/gebLLm0w0LjEfj5lL5C9+iEigqb9mfWWkmZWrvkc75ozIfNBS9Uzq
	 AHNSmmzDfrEHqFpOMg98KHHYLg5tKscs7Ly/au0g=
Date: Mon, 11 Nov 2024 17:17:38 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,gregkh@linuxfoundation.org,bartosz.golaszewski@linaro.org,aardelean@baylibre.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] util_macrosh-fix-rework-find_closest-macros.patch removed from -mm tree
Message-Id: <20241112011738.DAC0CC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: util_macros.h: fix/rework find_closest() macros
has been removed from the -mm tree.  Its filename was
     util_macrosh-fix-rework-find_closest-macros.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexandru Ardelean <aardelean@baylibre.com>
Subject: util_macros.h: fix/rework find_closest() macros
Date: Tue, 5 Nov 2024 16:54:05 +0200

A bug was found in the find_closest() (find_closest_descending() is also
affected after some testing), where for certain values with small
progressions, the rounding (done by averaging 2 values) causes an
incorrect index to be returned.  The rounding issues occur for
progressions of 1, 2 and 3.  It goes away when the progression/interval
between two values is 4 or larger.

It's particularly bad for progressions of 1.  For example if there's an
array of 'a = { 1, 2, 3 }', using 'find_closest(2, a ...)' would return 0
(the index of '1'), rather than returning 1 (the index of '2').  This
means that for exact values (with a progression of 1), find_closest() will
misbehave and return the index of the value smaller than the one we're
searching for.

For progressions of 2 and 3, the exact values are obtained correctly; but
values aren't approximated correctly (as one would expect).  Starting with
progressions of 4, all seems to be good (one gets what one would expect).

While one could argue that 'find_closest()' should not be used for arrays
with progressions of 1 (i.e. '{1, 2, 3, ...}', the macro should still
behave correctly.

The bug was found while testing the 'drivers/iio/adc/ad7606.c',
specifically the oversampling feature.
For reference, the oversampling values are listed as:
   static const unsigned int ad7606_oversampling_avail[7] = {
          1, 2, 4, 8, 16, 32, 64,
   };

When doing:
  1. $ echo 1 > /sys/bus/iio/devices/iio\:device0/oversampling_ratio
     $ cat /sys/bus/iio/devices/iio\:device0/oversampling_ratio
     1  # this is fine
  2. $ echo 2 > /sys/bus/iio/devices/iio\:device0/oversampling_ratio
     $ cat /sys/bus/iio/devices/iio\:device0/oversampling_ratio
     1  # this is wrong; 2 should be returned here
  3. $ echo 3 > /sys/bus/iio/devices/iio\:device0/oversampling_ratio
     $ cat /sys/bus/iio/devices/iio\:device0/oversampling_ratio
     2  # this is fine
  4. $ echo 4 > /sys/bus/iio/devices/iio\:device0/oversampling_ratio
     $ cat /sys/bus/iio/devices/iio\:device0/oversampling_ratio
     4  # this is fine
And from here-on, the values are as correct (one gets what one would
expect.)

While writing a kunit test for this bug, a peculiar issue was found for the
array in the 'drivers/hwmon/ina2xx.c' & 'drivers/iio/adc/ina2xx-adc.c'
drivers. While running the kunit test (for 'ina226_avg_tab' from these
drivers):
  * idx = find_closest([-1 to 2], ina226_avg_tab, ARRAY_SIZE(ina226_avg_tab));
    This returns idx == 0, so value.
  * idx = find_closest(3, ina226_avg_tab, ARRAY_SIZE(ina226_avg_tab));
    This returns idx == 0, value 1; and now one could argue whether 3 is
    closer to 4 or to 1. This quirk only appears for value '3' in this
    array, but it seems to be a another rounding issue.
  * And from 4 onwards the 'find_closest'() works fine (one gets what one
    would expect).

This change reworks the find_closest() macros to also check the difference
between the left and right elements when 'x'. If the distance to the right
is smaller (than the distance to the left), the index is incremented by 1.
This also makes redundant the need for using the DIV_ROUND_CLOSEST() macro.

In order to accommodate for any mix of negative + positive values, the
internal variables '__fc_x', '__fc_mid_x', '__fc_left' & '__fc_right' are
forced to 'long' type. This also addresses any potential bugs/issues with
'x' being of an unsigned type. In those situations any comparison between
signed & unsigned would be promoted to a comparison between 2 unsigned
numbers; this is especially annoying when '__fc_left' & '__fc_right'
underflow.

The find_closest_descending() macro was also reworked and duplicated from
the find_closest(), and it is being iterated in reverse. The main reason
for this is to get the same indices as 'find_closest()' (but in reverse).
The comparison for '__fc_right < __fc_left' favors going the array in
ascending order.
For example for array '{ 1024, 512, 256, 128, 64, 16, 4, 1 }' and x = 3, we
get:
    __fc_mid_x = 2
    __fc_left = -1
    __fc_right = -2
    Then '__fc_right < __fc_left' evaluates to true and '__fc_i++' becomes 7
    which is not quite incorrect, but 3 is closer to 4 than to 1.

This change has been validated with the kunit from the next patch.

Link: https://lkml.kernel.org/r/20241105145406.554365-1-aardelean@baylibre.com
Fixes: 95d119528b0b ("util_macros.h: add find_closest() macro")
Signed-off-by: Alexandru Ardelean <aardelean@baylibre.com>
Cc: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/util_macros.h |   56 ++++++++++++++++++++++++----------
 1 file changed, 40 insertions(+), 16 deletions(-)

--- a/include/linux/util_macros.h~util_macrosh-fix-rework-find_closest-macros
+++ a/include/linux/util_macros.h
@@ -4,19 +4,6 @@
 
 #include <linux/math.h>
 
-#define __find_closest(x, a, as, op)					\
-({									\
-	typeof(as) __fc_i, __fc_as = (as) - 1;				\
-	typeof(x) __fc_x = (x);						\
-	typeof(*a) const *__fc_a = (a);					\
-	for (__fc_i = 0; __fc_i < __fc_as; __fc_i++) {			\
-		if (__fc_x op DIV_ROUND_CLOSEST(__fc_a[__fc_i] +	\
-						__fc_a[__fc_i + 1], 2))	\
-			break;						\
-	}								\
-	(__fc_i);							\
-})
-
 /**
  * find_closest - locate the closest element in a sorted array
  * @x: The reference value.
@@ -25,8 +12,27 @@
  * @as: Size of 'a'.
  *
  * Returns the index of the element closest to 'x'.
+ * Note: If using an array of negative numbers (or mixed positive numbers),
+ *       then be sure that 'x' is of a signed-type to get good results.
  */
-#define find_closest(x, a, as) __find_closest(x, a, as, <=)
+#define find_closest(x, a, as)						\
+({									\
+	typeof(as) __fc_i, __fc_as = (as) - 1;				\
+	long __fc_mid_x, __fc_x = (x);					\
+	long __fc_left, __fc_right;					\
+	typeof(*a) const *__fc_a = (a);					\
+	for (__fc_i = 0; __fc_i < __fc_as; __fc_i++) {			\
+		__fc_mid_x = (__fc_a[__fc_i] + __fc_a[__fc_i + 1]) / 2;	\
+		if (__fc_x <= __fc_mid_x) {				\
+			__fc_left = __fc_x - __fc_a[__fc_i];		\
+			__fc_right = __fc_a[__fc_i + 1] - __fc_x;	\
+			if (__fc_right < __fc_left)			\
+				__fc_i++;				\
+			break;						\
+		}							\
+	}								\
+	(__fc_i);							\
+})
 
 /**
  * find_closest_descending - locate the closest element in a sorted array
@@ -36,9 +42,27 @@
  * @as: Size of 'a'.
  *
  * Similar to find_closest() but 'a' is expected to be sorted in descending
- * order.
+ * order. The iteration is done in reverse order, so that the comparison
+ * of '__fc_right' & '__fc_left' also works for unsigned numbers.
  */
-#define find_closest_descending(x, a, as) __find_closest(x, a, as, >=)
+#define find_closest_descending(x, a, as)				\
+({									\
+	typeof(as) __fc_i, __fc_as = (as) - 1;				\
+	long __fc_mid_x, __fc_x = (x);					\
+	long __fc_left, __fc_right;					\
+	typeof(*a) const *__fc_a = (a);					\
+	for (__fc_i = __fc_as; __fc_i >= 1; __fc_i--) {			\
+		__fc_mid_x = (__fc_a[__fc_i] + __fc_a[__fc_i - 1]) / 2;	\
+		if (__fc_x <= __fc_mid_x) {				\
+			__fc_left = __fc_x - __fc_a[__fc_i];		\
+			__fc_right = __fc_a[__fc_i - 1] - __fc_x;	\
+			if (__fc_right < __fc_left)			\
+				__fc_i--;				\
+			break;						\
+		}							\
+	}								\
+	(__fc_i);							\
+})
 
 /**
  * is_insidevar - check if the @ptr points inside the @var memory range.
_

Patches currently in -mm which might be from aardelean@baylibre.com are



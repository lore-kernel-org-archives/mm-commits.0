From: akpm@linux-foundation.org
Subject: [merged]
 include-kernelh-change-abs-macro-so-it-uses-consistent-return-type.patch
 removed from -mm tree
Date: Tue, 19 Jan 2016 12:14:33 -0800
Message-ID: <569e9929.jacAlkxCn0n9FYYH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44496 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933140AbcASUOe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:14:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mina86@mina86.com, nico@linaro.org, srinivas.pandruvada@linux.intel.com, wey-yi.w.guy@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/kernel.h: change abs() macro so it uses consistent return type
has been removed from the -mm tree.  Its filename was
     include-kernelh-change-abs-macro-so-it-uses-consistent-return-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Nazarewicz <mina86@mina86.com>
Subject: include/linux/kernel.h: change abs() macro so it uses consistent return type

Rewrite abs() so that its return type does not depend on the architecture
and no unexpected type conversion happen inside of it.  The only
conversion is from unsigned to signed type.  char is left as a return type
but treated as a signed type regradless of it's actual signedness.

With the old version, int arguments were promoted to long and depending on
architecture a long argument might result in s64 or long return type
(which may or may not be the same).

This came after some back and forth with Nicolas.  The current macro has
different return type (for the same input type) depending on architecture
which might be midly iritating.

An alternative version would promote to int like so:

	#define abs(x)	__abs_choose_expr(x, long long,			\
			__abs_choose_expr(x, long,			\
			__builtin_choose_expr(				\
				sizeof(x) <= sizeof(int),		\
				({ int __x = (x); __x<0?-__x:__x; }),	\
				((void)0))))

I have no preference but imagine Linus might.  :] Nicolas argument against
is that promoting to int causes iconsistent behaviour:

	int main(void) {
		unsigned short a = 0, b = 1, c = a - b;
		unsigned short d = abs(a - b);
		unsigned short e = abs(c);
		printf("%u %u\n", d, e);  // prints: 1 65535
	}

Then again, no sane person expects consistent behaviour from C integer
arithmetic.  ;)

Note:

__builtin_types_compatible_p(unsigned char, char) is always false, and
__builtin_types_compatible_p(signed char, char) is also always false.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Reviewed-by: Nicolas Pitre <nico@linaro.org>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iio/industrialio-core.c                |    9 +--
 drivers/net/wireless/intel/iwlwifi/dvm/calib.c |    2 
 include/linux/kernel.h                         |   36 +++++++--------
 3 files changed, 23 insertions(+), 24 deletions(-)

diff -puN drivers/iio/industrialio-core.c~include-kernelh-change-abs-macro-so-it-uses-consistent-return-type drivers/iio/industrialio-core.c
--- a/drivers/iio/industrialio-core.c~include-kernelh-change-abs-macro-so-it-uses-consistent-return-type
+++ a/drivers/iio/industrialio-core.c
@@ -433,16 +433,15 @@ ssize_t iio_format_value(char *buf, unsi
 		scale_db = true;
 	case IIO_VAL_INT_PLUS_MICRO:
 		if (vals[1] < 0)
-			return sprintf(buf, "-%ld.%06u%s\n", abs(vals[0]),
-					-vals[1],
-				scale_db ? " dB" : "");
+			return sprintf(buf, "-%d.%06u%s\n", abs(vals[0]),
+				       -vals[1], scale_db ? " dB" : "");
 		else
 			return sprintf(buf, "%d.%06u%s\n", vals[0], vals[1],
 				scale_db ? " dB" : "");
 	case IIO_VAL_INT_PLUS_NANO:
 		if (vals[1] < 0)
-			return sprintf(buf, "-%ld.%09u\n", abs(vals[0]),
-					-vals[1]);
+			return sprintf(buf, "-%d.%09u\n", abs(vals[0]),
+				       -vals[1]);
 		else
 			return sprintf(buf, "%d.%09u\n", vals[0], vals[1]);
 	case IIO_VAL_FRACTIONAL:
diff -puN drivers/net/wireless/intel/iwlwifi/dvm/calib.c~include-kernelh-change-abs-macro-so-it-uses-consistent-return-type drivers/net/wireless/intel/iwlwifi/dvm/calib.c
--- a/drivers/net/wireless/intel/iwlwifi/dvm/calib.c~include-kernelh-change-abs-macro-so-it-uses-consistent-return-type
+++ a/drivers/net/wireless/intel/iwlwifi/dvm/calib.c
@@ -901,7 +901,7 @@ static void iwlagn_gain_computation(stru
 		/* bound gain by 2 bits value max, 3rd bit is sign */
 		data->delta_gain_code[i] =
 			min(abs(delta_g),
-			(long) CHAIN_NOISE_MAX_DELTA_GAIN_CODE);
+			(s32) CHAIN_NOISE_MAX_DELTA_GAIN_CODE);
 
 		if (delta_g < 0)
 			/*
diff -puN include/linux/kernel.h~include-kernelh-change-abs-macro-so-it-uses-consistent-return-type include/linux/kernel.h
--- a/include/linux/kernel.h~include-kernelh-change-abs-macro-so-it-uses-consistent-return-type
+++ a/include/linux/kernel.h
@@ -202,26 +202,26 @@ extern int _cond_resched(void);
 
 /**
  * abs - return absolute value of an argument
- * @x: the value.  If it is unsigned type, it is converted to signed type first
- *   (s64, long or int depending on its size).
+ * @x: the value.  If it is unsigned type, it is converted to signed type first.
+ *     char is treated as if it was signed (regardless of whether it really is)
+ *     but the macro's return type is preserved as char.
  *
- * Return: an absolute value of x.  If x is 64-bit, macro's return type is s64,
- *   otherwise it is signed long.
+ * Return: an absolute value of x.
  */
-#define abs(x) __builtin_choose_expr(sizeof(x) == sizeof(s64), ({	\
-		s64 __x = (x);						\
-		(__x < 0) ? -__x : __x;					\
-	}), ({								\
-		long ret;						\
-		if (sizeof(x) == sizeof(long)) {			\
-			long __x = (x);					\
-			ret = (__x < 0) ? -__x : __x;			\
-		} else {						\
-			int __x = (x);					\
-			ret = (__x < 0) ? -__x : __x;			\
-		}							\
-		ret;							\
-	}))
+#define abs(x)	__abs_choose_expr(x, long long,				\
+		__abs_choose_expr(x, long,				\
+		__abs_choose_expr(x, int,				\
+		__abs_choose_expr(x, short,				\
+		__abs_choose_expr(x, char,				\
+		__builtin_choose_expr(					\
+			__builtin_types_compatible_p(typeof(x), char),	\
+			(char)({ signed char __x = (x); __x<0?-__x:__x; }), \
+			((void)0)))))))
+
+#define __abs_choose_expr(x, type, other) __builtin_choose_expr(	\
+	__builtin_types_compatible_p(typeof(x),   signed type) ||	\
+	__builtin_types_compatible_p(typeof(x), unsigned type),		\
+	({ signed type __x = (x); __x < 0 ? -__x : __x; }), other)
 
 /**
  * reciprocal_scale - "scale" a value into range [0, ep_ro)
_

Patches currently in -mm which might be from mina86@mina86.com are



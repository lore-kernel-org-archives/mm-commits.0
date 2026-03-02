Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458152F9D82
	for <mm-commits@vger.kernel.org>; Mon,  2 Mar 2026 23:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772492891; cv=none; b=cQ0+sNJEnKIl88q3YRGQzCJHgKMkmJHKhp0XEg963UbeuOY9XncbydOewR00qCqyROEXe9bv7ZoP1Gcm6isEZIpH8mug89psDWv5ZrKqvXWwpNUzIxU2ljAfs9fL3QfRSrTrkEx1j85UiLXMuHZvEdpnwk9siOwnmwO8IA7lcHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772492891; c=relaxed/simple;
	bh=dfbnEBAgtoxJQWW/Bvl4s6xndhi0/qE8fdwzvmFYCmY=;
	h=Date:To:From:Subject:Message-Id; b=YCzfwYC74O17Mr7WUCmOEtwnI84AIMOjpswAbbLRISh/84gIWLZBT0hVmBH16ntka/gj2gDbkIiobQ8xuq3Elwnj9lHUkveqef1qf+rCFf2LtXpU81IEtBZwL8HXmnGnlhiBr7BquIqatBQdLwRZmR3uM9i2tos4aZxGH71LraQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kYTUX/a5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kYTUX/a5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03EF4C19423;
	Mon,  2 Mar 2026 23:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772492891;
	bh=dfbnEBAgtoxJQWW/Bvl4s6xndhi0/qE8fdwzvmFYCmY=;
	h=Date:To:From:Subject:From;
	b=kYTUX/a5ZDDHAGQyeBnTYsJGfS2Wu8gymztx4W6blJdeUQiQrL01d0xf2ymnLDlt6
	 yywC2mLdRN0k7r/KG75wKtyYK4EYT6EldcDaUQWiaFerCxdmU9WIdRNrJ+q6zXViYn
	 t4RFYCKZM/hfv35rXVJH36dWx1kjJeF3zqBuMDqQ=
Date: Mon, 02 Mar 2026 15:08:10 -0800
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,rdunlap@infradead.org,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-polynomial-move-to-math-subfolder.patch added to mm-nonmm-unstable branch
Message-Id: <20260302230811.03EF4C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: polynomial: move to math/ subfolder
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-polynomial-move-to-math-subfolder.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-polynomial-move-to-math-subfolder.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib: polynomial: move to math/ subfolder
Date: Mon, 2 Mar 2026 10:28:07 +0100

Patch series "lib: polynomial: Move to math/ and clean up", v2.

While removing Baikal SoC and platform code pieces I found that this code
belongs to lib/math/ rather than generic lib/.  Hence the move and
followed up cleanups.


This patch (of 3):

The algorithm behind polynomial belongs to our collection of math
equations and expressions handling.  Move it to math/ subfolder where
others of the kind are located.

Link: https://lkml.kernel.org/r/20260302092831.2267785-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig           |    3 -
 lib/Makefile          |    2 
 lib/math/Kconfig      |    3 +
 lib/math/Makefile     |    1 
 lib/math/polynomial.c |  108 ++++++++++++++++++++++++++++++++++++++++
 lib/polynomial.c      |  108 ----------------------------------------
 6 files changed, 112 insertions(+), 113 deletions(-)

--- a/lib/Kconfig~lib-polynomial-move-to-math-subfolder
+++ a/lib/Kconfig
@@ -638,9 +638,6 @@ config PLDMFW
 config ASN1_ENCODER
        tristate
 
-config POLYNOMIAL
-       tristate
-
 config FIRMWARE_TABLE
 	bool
 
--- a/lib/Makefile~lib-polynomial-move-to-math-subfolder
+++ a/lib/Makefile
@@ -244,8 +244,6 @@ obj-$(CONFIG_MEMREGION) += memregion.o
 obj-$(CONFIG_STMP_DEVICE) += stmp_device.o
 obj-$(CONFIG_IRQ_POLL) += irq_poll.o
 
-obj-$(CONFIG_POLYNOMIAL) += polynomial.o
-
 # stackdepot.c should not be instrumented or call instrumented functions.
 # Prevent the compiler from calling builtins like memcmp() or bcmp() from this
 # file.
--- a/lib/math/Kconfig~lib-polynomial-move-to-math-subfolder
+++ a/lib/math/Kconfig
@@ -5,6 +5,9 @@ config CORDIC
 	  This option provides an implementation of the CORDIC algorithm;
 	  calculations are in fixed point. Module will be called cordic.
 
+config POLYNOMIAL
+       tristate
+
 config PRIME_NUMBERS
 	tristate "Simple prime number generator for testing"
 	help
--- a/lib/math/Makefile~lib-polynomial-move-to-math-subfolder
+++ a/lib/math/Makefile
@@ -2,6 +2,7 @@
 obj-y += div64.o gcd.o lcm.o int_log.o int_pow.o int_sqrt.o reciprocal_div.o
 
 obj-$(CONFIG_CORDIC)		+= cordic.o
+obj-$(CONFIG_POLYNOMIAL)	+= polynomial.o
 obj-$(CONFIG_PRIME_NUMBERS)	+= prime_numbers.o
 obj-$(CONFIG_RATIONAL)		+= rational.o
 
diff --git a/lib/math/polynomial.c a/lib/math/polynomial.c
new file mode 100664
--- /dev/null
+++ a/lib/math/polynomial.c
@@ -0,0 +1,108 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Generic polynomial calculation using integer coefficients.
+ *
+ * Copyright (C) 2020 BAIKAL ELECTRONICS, JSC
+ *
+ * Authors:
+ *   Maxim Kaurkin <maxim.kaurkin@baikalelectronics.ru>
+ *   Serge Semin <Sergey.Semin@baikalelectronics.ru>
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/polynomial.h>
+
+/*
+ * Originally this was part of drivers/hwmon/bt1-pvt.c.
+ * There the following conversion is used and should serve as an example here:
+ *
+ * The original translation formulae of the temperature (in degrees of Celsius)
+ * to PVT data and vice-versa are following:
+ *
+ * N = 1.8322e-8*(T^4) + 2.343e-5*(T^3) + 8.7018e-3*(T^2) + 3.9269*(T^1) +
+ *     1.7204e2
+ * T = -1.6743e-11*(N^4) + 8.1542e-8*(N^3) + -1.8201e-4*(N^2) +
+ *     3.1020e-1*(N^1) - 4.838e1
+ *
+ * where T = [-48.380, 147.438]C and N = [0, 1023].
+ *
+ * They must be accordingly altered to be suitable for the integer arithmetics.
+ * The technique is called 'factor redistribution', which just makes sure the
+ * multiplications and divisions are made so to have a result of the operations
+ * within the integer numbers limit. In addition we need to translate the
+ * formulae to accept millidegrees of Celsius. Here what they look like after
+ * the alterations:
+ *
+ * N = (18322e-20*(T^4) + 2343e-13*(T^3) + 87018e-9*(T^2) + 39269e-3*T +
+ *     17204e2) / 1e4
+ * T = -16743e-12*(D^4) + 81542e-9*(D^3) - 182010e-6*(D^2) + 310200e-3*D -
+ *     48380
+ * where T = [-48380, 147438] mC and N = [0, 1023].
+ *
+ * static const struct polynomial poly_temp_to_N = {
+ *         .total_divider = 10000,
+ *         .terms = {
+ *                 {4, 18322, 10000, 10000},
+ *                 {3, 2343, 10000, 10},
+ *                 {2, 87018, 10000, 10},
+ *                 {1, 39269, 1000, 1},
+ *                 {0, 1720400, 1, 1}
+ *         }
+ * };
+ *
+ * static const struct polynomial poly_N_to_temp = {
+ *         .total_divider = 1,
+ *         .terms = {
+ *                 {4, -16743, 1000, 1},
+ *                 {3, 81542, 1000, 1},
+ *                 {2, -182010, 1000, 1},
+ *                 {1, 310200, 1000, 1},
+ *                 {0, -48380, 1, 1}
+ *         }
+ * };
+ */
+
+/**
+ * polynomial_calc - calculate a polynomial using integer arithmetic
+ *
+ * @poly: pointer to the descriptor of the polynomial
+ * @data: input value of the polynimal
+ *
+ * Calculate the result of a polynomial using only integer arithmetic. For
+ * this to work without too much loss of precision the coefficients has to
+ * be altered. This is called factor redistribution.
+ *
+ * Returns the result of the polynomial calculation.
+ */
+long polynomial_calc(const struct polynomial *poly, long data)
+{
+	const struct polynomial_term *term = poly->terms;
+	long total_divider = poly->total_divider ?: 1;
+	long tmp, ret = 0;
+	int deg;
+
+	/*
+	 * Here is the polynomial calculation function, which performs the
+	 * redistributed terms calculations. It's pretty straightforward.
+	 * We walk over each degree term up to the free one, and perform
+	 * the redistributed multiplication of the term coefficient, its
+	 * divider (as for the rationale fraction representation), data
+	 * power and the rational fraction divider leftover. Then all of
+	 * this is collected in a total sum variable, which value is
+	 * normalized by the total divider before being returned.
+	 */
+	do {
+		tmp = term->coef;
+		for (deg = 0; deg < term->deg; ++deg)
+			tmp = mult_frac(tmp, data, term->divider);
+		ret += tmp / term->divider_leftover;
+	} while ((term++)->deg);
+
+	return ret / total_divider;
+}
+EXPORT_SYMBOL_GPL(polynomial_calc);
+
+MODULE_DESCRIPTION("Generic polynomial calculations");
+MODULE_LICENSE("GPL");
diff --git a/lib/polynomial.c a/lib/polynomial.c
deleted file mode 100644
--- a/lib/polynomial.c
+++ /dev/null
@@ -1,108 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Generic polynomial calculation using integer coefficients.
- *
- * Copyright (C) 2020 BAIKAL ELECTRONICS, JSC
- *
- * Authors:
- *   Maxim Kaurkin <maxim.kaurkin@baikalelectronics.ru>
- *   Serge Semin <Sergey.Semin@baikalelectronics.ru>
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/polynomial.h>
-
-/*
- * Originally this was part of drivers/hwmon/bt1-pvt.c.
- * There the following conversion is used and should serve as an example here:
- *
- * The original translation formulae of the temperature (in degrees of Celsius)
- * to PVT data and vice-versa are following:
- *
- * N = 1.8322e-8*(T^4) + 2.343e-5*(T^3) + 8.7018e-3*(T^2) + 3.9269*(T^1) +
- *     1.7204e2
- * T = -1.6743e-11*(N^4) + 8.1542e-8*(N^3) + -1.8201e-4*(N^2) +
- *     3.1020e-1*(N^1) - 4.838e1
- *
- * where T = [-48.380, 147.438]C and N = [0, 1023].
- *
- * They must be accordingly altered to be suitable for the integer arithmetics.
- * The technique is called 'factor redistribution', which just makes sure the
- * multiplications and divisions are made so to have a result of the operations
- * within the integer numbers limit. In addition we need to translate the
- * formulae to accept millidegrees of Celsius. Here what they look like after
- * the alterations:
- *
- * N = (18322e-20*(T^4) + 2343e-13*(T^3) + 87018e-9*(T^2) + 39269e-3*T +
- *     17204e2) / 1e4
- * T = -16743e-12*(D^4) + 81542e-9*(D^3) - 182010e-6*(D^2) + 310200e-3*D -
- *     48380
- * where T = [-48380, 147438] mC and N = [0, 1023].
- *
- * static const struct polynomial poly_temp_to_N = {
- *         .total_divider = 10000,
- *         .terms = {
- *                 {4, 18322, 10000, 10000},
- *                 {3, 2343, 10000, 10},
- *                 {2, 87018, 10000, 10},
- *                 {1, 39269, 1000, 1},
- *                 {0, 1720400, 1, 1}
- *         }
- * };
- *
- * static const struct polynomial poly_N_to_temp = {
- *         .total_divider = 1,
- *         .terms = {
- *                 {4, -16743, 1000, 1},
- *                 {3, 81542, 1000, 1},
- *                 {2, -182010, 1000, 1},
- *                 {1, 310200, 1000, 1},
- *                 {0, -48380, 1, 1}
- *         }
- * };
- */
-
-/**
- * polynomial_calc - calculate a polynomial using integer arithmetic
- *
- * @poly: pointer to the descriptor of the polynomial
- * @data: input value of the polynimal
- *
- * Calculate the result of a polynomial using only integer arithmetic. For
- * this to work without too much loss of precision the coefficients has to
- * be altered. This is called factor redistribution.
- *
- * Returns the result of the polynomial calculation.
- */
-long polynomial_calc(const struct polynomial *poly, long data)
-{
-	const struct polynomial_term *term = poly->terms;
-	long total_divider = poly->total_divider ?: 1;
-	long tmp, ret = 0;
-	int deg;
-
-	/*
-	 * Here is the polynomial calculation function, which performs the
-	 * redistributed terms calculations. It's pretty straightforward.
-	 * We walk over each degree term up to the free one, and perform
-	 * the redistributed multiplication of the term coefficient, its
-	 * divider (as for the rationale fraction representation), data
-	 * power and the rational fraction divider leftover. Then all of
-	 * this is collected in a total sum variable, which value is
-	 * normalized by the total divider before being returned.
-	 */
-	do {
-		tmp = term->coef;
-		for (deg = 0; deg < term->deg; ++deg)
-			tmp = mult_frac(tmp, data, term->divider);
-		ret += tmp / term->divider_leftover;
-	} while ((term++)->deg);
-
-	return ret / total_divider;
-}
-EXPORT_SYMBOL_GPL(polynomial_calc);
-
-MODULE_DESCRIPTION("Generic polynomial calculations");
-MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-polynomial-move-to-math-subfolder.patch
lib-math-polynomial-dont-use-proxy-headers.patch
lib-math-polynomial-remove-link-to-non-exist-file-and-fix-spelling.patch


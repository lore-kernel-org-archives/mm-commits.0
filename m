Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0750A33557B
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671914; cv=none; b=ajf3Mp9PXG6vT44dfdXluhbvEE2mT6BWdylZdzpcjzKDFFUEuKALS60k6Sjc6uthgv0y++xfdN0jHb2dTtOq3N6MDwVjJ3UWkhY+aloNmmfyGHjQaZZzc0wOA/f32rRvv36uhza1/RlyJStaw7hYRpJvBchxo1M4AoX7n5tVb08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671914; c=relaxed/simple;
	bh=pL1ZcolZb5pS4dd8HrmeSt3yCbKPkxhHK6t/dBtmJws=;
	h=Date:To:From:Subject:Message-Id; b=WghL6hQwC91EgApyaj21C5mPL37NP96loBM2QnOnpQzjb4pHUxqTbJxARXCBTkrJqLtRW2xtk9S2QMZqO5RH82aMpQ6QqQryBn4Myg29vYSux3X9oZKCaJUpKdgwO4EFerybNoYSHvsLz1Ym5ZioTHiAemwEUtCwGBWgYOdMiKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rXsB+LVs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rXsB+LVs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F50CC4CEF7;
	Sat, 28 Mar 2026 04:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671913;
	bh=pL1ZcolZb5pS4dd8HrmeSt3yCbKPkxhHK6t/dBtmJws=;
	h=Date:To:From:Subject:From;
	b=rXsB+LVsZW0TplT9SgDo5EfO5+JqNuoSxw5hQJ/E7HiZVamnryTSh1aqnm7h+C8MK
	 NfnlrVHkEyGzoblk/A3eIqllTx8ugfUnE8/G24g8AtsF494cgtCrRTfSF5qIS1NYC8
	 aeprQbPVOe1/0AiPMbOcszE4izkRSuX2pwtcBx64=
Date: Fri, 27 Mar 2026 21:25:13 -0700
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,rdunlap@infradead.org,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-math-polynomial-remove-link-to-non-exist-file-and-fix-spelling.patch removed from -mm tree
Message-Id: <20260328042513.9F50CC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: math: polynomial: remove link to non-exist file and fix spelling
has been removed from the -mm tree.  Its filename was
     lib-math-polynomial-remove-link-to-non-exist-file-and-fix-spelling.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib: math: polynomial: remove link to non-exist file and fix spelling
Date: Mon, 2 Mar 2026 10:28:09 +0100

The Baikal SoC and platform support was dropped from the kernel, remove
the reference to non-exist file.  While at it, fix spelling.

Link: https://lkml.kernel.org/r/20260302092831.2267785-4-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/math/polynomial.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

--- a/lib/math/polynomial.c~lib-math-polynomial-remove-link-to-non-exist-file-and-fix-spelling
+++ a/lib/math/polynomial.c
@@ -16,16 +16,13 @@
 #include <linux/polynomial.h>
 
 /*
- * Originally this was part of drivers/hwmon/bt1-pvt.c.
- * There the following conversion is used and should serve as an example here:
+ * The following conversion is an example:
  *
  * The original translation formulae of the temperature (in degrees of Celsius)
  * to PVT data and vice-versa are following:
  *
- * N = 1.8322e-8*(T^4) + 2.343e-5*(T^3) + 8.7018e-3*(T^2) + 3.9269*(T^1) +
- *     1.7204e2
- * T = -1.6743e-11*(N^4) + 8.1542e-8*(N^3) + -1.8201e-4*(N^2) +
- *     3.1020e-1*(N^1) - 4.838e1
+ * N = 1.8322e-8*(T^4) + 2.343e-5*(T^3) + 8.7018e-3*(T^2) + 3.9269*(T^1) + 1.7204e2
+ * T = -1.6743e-11*(N^4) + 8.1542e-8*(N^3) + -1.8201e-4*(N^2) + 3.1020e-1*(N^1) - 4.838e1
  *
  * where T = [-48.380, 147.438]C and N = [0, 1023].
  *
@@ -36,10 +33,9 @@
  * formulae to accept millidegrees of Celsius. Here what they look like after
  * the alterations:
  *
- * N = (18322e-20*(T^4) + 2343e-13*(T^3) + 87018e-9*(T^2) + 39269e-3*T +
- *     17204e2) / 1e4
- * T = -16743e-12*(D^4) + 81542e-9*(D^3) - 182010e-6*(D^2) + 310200e-3*D -
- *     48380
+ * N = (18322e-20*(T^4) + 2343e-13*(T^3) + 87018e-9*(T^2) + 39269e-3*T + 17204e2) / 1e4
+ * T = -16743e-12*(D^4) + 81542e-9*(D^3) - 182010e-6*(D^2) + 310200e-3*D - 48380
+ *
  * where T = [-48380, 147438] mC and N = [0, 1023].
  *
  * static const struct polynomial poly_temp_to_N = {
@@ -69,13 +65,13 @@
  * polynomial_calc - calculate a polynomial using integer arithmetic
  *
  * @poly: pointer to the descriptor of the polynomial
- * @data: input value of the polynimal
+ * @data: input value of the polynomial
  *
  * Calculate the result of a polynomial using only integer arithmetic. For
  * this to work without too much loss of precision the coefficients has to
  * be altered. This is called factor redistribution.
  *
- * Returns the result of the polynomial calculation.
+ * Return: the result of the polynomial calculation.
  */
 long polynomial_calc(const struct polynomial *poly, long data)
 {
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are



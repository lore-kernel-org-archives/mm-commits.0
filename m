Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26354C81
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006483; cv=none; b=agiMb2QLbv9UJc692o+Taso3r3x/TN60GEX2z1n8QT6T4b+vLH572vYJ6RaIRUQ0fwq46jpcX3IkxxY70iQoW5TZ4m+q8tO2az13wP3uJf9BPDFRMWITXRULLB6n4Wl/sHR2qyPKf/ch1/UDcaBph9HZoCqR4Qpu2MsRF2omY/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006483; c=relaxed/simple;
	bh=xtvggyJWiYBj+BCM/+sAKFYJQlyUi3zPwl9sbeTYPeg=;
	h=Date:To:From:Subject:Message-Id; b=YPzBxlZlp2CFtjOr9O0zfNoa3cuEmkYNh5CgqRk4T4DciNvjdY80gXN93kTj0Fa6YkTvW7Wagvyel492Kqh4sAfkZHcgg6vAAzeTvc1XGM/U6BIp+OFeDjIVd5FF50USl4PzlpCmF0qRNoVrnFYKmRJoToFj5cYM/+z1/eqoUNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QkNXi3St; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QkNXi3St"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48FD5C4CED6;
	Thu, 16 Jan 2025 05:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006483;
	bh=xtvggyJWiYBj+BCM/+sAKFYJQlyUi3zPwl9sbeTYPeg=;
	h=Date:To:From:Subject:From;
	b=QkNXi3StokYN/ttiFUzmyZbn+Ma6m+cwYnU1RA9vLsfu066beeHKTXG6Cr3DNru8G
	 A3vzxFgGjx93bjukjCNhvmDYzIVCMOwmk9SrQlG42ZeiuqEHATGK4ETyLdBOpJV6ns
	 QNl8jg0mXY1tTFgIbdcJ8bu+S7eUhYJ1zh5KHP4Q=
Date: Wed, 15 Jan 2025 21:48:02 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,pedro.falcato@gmail.com,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,Jason@zx2c4.com,hch@infradead.org,david.laight@aculab.com,dan.carpenter@linaro.org,axboe@kernel.dk,arnd@kernel.org,andriy.shevchenko@linux.intel.com,David.Laight@ACULAB.COM,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] minmaxh-reduce-the-define-expansion-of-min-max-and-clamp.patch removed from -mm tree
Message-Id: <20250116054803.48FD5C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: minmax.h: reduce the #define expansion of min(), max() and clamp()
has been removed from the -mm tree.  Its filename was
     minmaxh-reduce-the-define-expansion-of-min-max-and-clamp.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Laight <David.Laight@ACULAB.COM>
Subject: minmax.h: reduce the #define expansion of min(), max() and clamp()
Date: Mon, 18 Nov 2024 19:12:50 +0000

Since the test for signed values being non-negative only relies on
__builtion_constant_p() (not is_constexpr()) it can use the 'ux' variable
instead of the caller supplied expression.  This means that the #define
parameters are only expanded twice.  Once in the code and once quoted in
the error message.

Link: https://lkml.kernel.org/r/051afc171806425da991908ed8688a98@AcuMS.aculab.com
Signed-off-by: David Laight <david.laight@aculab.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnd Bergmann <arnd@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/minmax.h |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/include/linux/minmax.h~minmaxh-reduce-the-define-expansion-of-min-max-and-clamp
+++ a/include/linux/minmax.h
@@ -46,10 +46,10 @@
  * comparison, and these expressions only need to be careful to not cause
  * warnings for pointer use.
  */
-#define __signed_type_use(x, ux) (2 + __is_nonneg(x, ux))
-#define __unsigned_type_use(x, ux) (1 + 2 * (sizeof(ux) < 4))
-#define __sign_use(x, ux) (is_signed_type(typeof(ux)) ? \
-	__signed_type_use(x, ux) : __unsigned_type_use(x, ux))
+#define __signed_type_use(ux) (2 + __is_nonneg(ux))
+#define __unsigned_type_use(ux) (1 + 2 * (sizeof(ux) < 4))
+#define __sign_use(ux) (is_signed_type(typeof(ux)) ? \
+	__signed_type_use(ux) : __unsigned_type_use(ux))
 
 /*
  * Check whether a signed value is always non-negative.
@@ -71,13 +71,13 @@
 #else
   #define __signed_type(ux) typeof(__builtin_choose_expr(sizeof(ux) > 4, 1LL, 1L))
 #endif
-#define __is_nonneg(x, ux) statically_true((__signed_type(ux))(x) >= 0)
+#define __is_nonneg(ux) statically_true((__signed_type(ux))(ux) >= 0)
 
-#define __types_ok(x, y, ux, uy) \
-	(__sign_use(x, ux) & __sign_use(y, uy))
+#define __types_ok(ux, uy) \
+	(__sign_use(ux) & __sign_use(uy))
 
-#define __types_ok3(x, y, z, ux, uy, uz) \
-	(__sign_use(x, ux) & __sign_use(y, uy) & __sign_use(z, uz))
+#define __types_ok3(ux, uy, uz) \
+	(__sign_use(ux) & __sign_use(uy) & __sign_use(uz))
 
 #define __cmp_op_min <
 #define __cmp_op_max >
@@ -92,7 +92,7 @@
 
 #define __careful_cmp_once(op, x, y, ux, uy) ({		\
 	__auto_type ux = (x); __auto_type uy = (y);	\
-	BUILD_BUG_ON_MSG(!__types_ok(x, y, ux, uy),	\
+	BUILD_BUG_ON_MSG(!__types_ok(ux, uy),		\
 		#op"("#x", "#y") signedness error");	\
 	__cmp(op, ux, uy); })
 
@@ -109,7 +109,7 @@
 	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
 			(lo) <= (hi), true),					\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
-	BUILD_BUG_ON_MSG(!__types_ok3(val, lo, hi, uval, ulo, uhi),		\
+	BUILD_BUG_ON_MSG(!__types_ok3(uval, ulo, uhi),				\
 		"clamp("#val", "#lo", "#hi") signedness error");		\
 	__clamp(uval, ulo, uhi); })
 
@@ -149,7 +149,7 @@
 
 #define __careful_op3(op, x, y, z, ux, uy, uz) ({			\
 	__auto_type ux = (x); __auto_type uy = (y);__auto_type uz = (z);\
-	BUILD_BUG_ON_MSG(!__types_ok3(x, y, z, ux, uy, uz),		\
+	BUILD_BUG_ON_MSG(!__types_ok3(ux, uy, uz),			\
 		#op"3("#x", "#y", "#z") signedness error");		\
 	__cmp(op, ux, __cmp(op, uy, uz)); })
 
_

Patches currently in -mm which might be from David.Laight@ACULAB.COM are



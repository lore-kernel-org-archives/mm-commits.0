Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E2B14A62A
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006488; cv=none; b=SnoGcNkU+jb73BKrb2h6QsB/k+iHN6vSv7zTNo4YlwxFRT9XefTbR8OyPVIfR/QrK3zxtgDkr6uXYBfyMQRKbmlvcbKupmfBalCsNbdSFYKl14TqRGwVeMO9PiVPJ1HxfjE8wTkct1yGpN17CL9vzJWx2w46WzouxRex7i6D7n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006488; c=relaxed/simple;
	bh=BUdLgTaBaU5eaX1GpgB6L6YF0dlbOiZy15rbatqfn6Q=;
	h=Date:To:From:Subject:Message-Id; b=Rh1wFOW4Z6pUst9qpYpUZ8zs7pyD9m1yq9WUJJSC4cDac2Vc360ly4rPQyLy6y+M/8bW777b1STveu04Pdq1WDLmU7qBlGsRI6jvWRk11nWnp5VvnvH2/5/r6YhCIgZa+BYT3CG/S2rD0z9Oiigy0/WnkUnzkvdPECEZY83aKG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dIR7GLuR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dIR7GLuR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E78C4CEDD;
	Thu, 16 Jan 2025 05:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006488;
	bh=BUdLgTaBaU5eaX1GpgB6L6YF0dlbOiZy15rbatqfn6Q=;
	h=Date:To:From:Subject:From;
	b=dIR7GLuRiAmsOxBKzQx7cF3pf/k7LgO/tZdvvQWYa68/PKUf+Wo8kLBPOMPrT9kIo
	 Vli6nFL4LQuCdLo25/w9CuNXPyKH3fSm1QPkzxxrJxZo/rvyq0uEy2h5ZxaiHZH3gF
	 drIbPDhldI18vPaS7+WNyOzUPWzHdrw/ZMie+arU=
Date: Wed, 15 Jan 2025 21:48:07 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,pedro.falcato@gmail.com,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,Jason@zx2c4.com,hch@infradead.org,david.laight@aculab.com,dan.carpenter@linaro.org,axboe@kernel.dk,arnd@kernel.org,andriy.shevchenko@linux.intel.com,David.Laight@ACULAB.COM,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] minmaxh-remove-some-defines-that-are-only-expanded-once.patch removed from -mm tree
Message-Id: <20250116054808.48E78C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: minmax.h: remove some #defines that are only expanded once
has been removed from the -mm tree.  Its filename was
     minmaxh-remove-some-defines-that-are-only-expanded-once.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Laight <David.Laight@ACULAB.COM>
Subject: minmax.h: remove some #defines that are only expanded once
Date: Mon, 18 Nov 2024 19:15:51 +0000

The bodies of __signed_type_use() and __unsigned_type_use() are much the
same size as their names - so put the bodies in the only line that expands
them.

Similarly __signed_type() is defined separately for 64bit and then used
exactly once just below.

Change the test for __signed_type from CONFIG_64BIT to one based on gcc
defined macros so that the code is valid if it gets used outside of a
kernel build.

Link: https://lkml.kernel.org/r/9386d1ebb8974fbabbed2635160c3975@AcuMS.aculab.com
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

 include/linux/minmax.h |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/include/linux/minmax.h~minmaxh-remove-some-defines-that-are-only-expanded-once
+++ a/include/linux/minmax.h
@@ -46,10 +46,8 @@
  * comparison, and these expressions only need to be careful to not cause
  * warnings for pointer use.
  */
-#define __signed_type_use(ux) (2 + __is_nonneg(ux))
-#define __unsigned_type_use(ux) (1 + 2 * (sizeof(ux) < 4))
 #define __sign_use(ux) (is_signed_type(typeof(ux)) ? \
-	__signed_type_use(ux) : __unsigned_type_use(ux))
+	(2 + __is_nonneg(ux)) : (1 + 2 * (sizeof(ux) < 4)))
 
 /*
  * Check whether a signed value is always non-negative.
@@ -57,7 +55,7 @@
  * A cast is needed to avoid any warnings from values that aren't signed
  * integer types (in which case the result doesn't matter).
  *
- * On 64-bit any integer or pointer type can safely be cast to 'long'.
+ * On 64-bit any integer or pointer type can safely be cast to 'long long'.
  * But on 32-bit we need to avoid warnings about casting pointers to integers
  * of different sizes without truncating 64-bit values so 'long' or 'long long'
  * must be used depending on the size of the value.
@@ -66,12 +64,12 @@
  * them, but we do not use s128 types in the kernel (we do use 'u128',
  * but they are handled by the !is_signed_type() case).
  */
-#ifdef CONFIG_64BIT
-  #define __signed_type(ux) long
+#if __SIZEOF_POINTER__ == __SIZEOF_LONG_LONG__
+#define __is_nonneg(ux) statically_true((long long)(ux) >= 0)
 #else
-  #define __signed_type(ux) typeof(__builtin_choose_expr(sizeof(ux) > 4, 1LL, 1L))
+#define __is_nonneg(ux) statically_true( \
+	(typeof(__builtin_choose_expr(sizeof(ux) > 4, 1LL, 1L)))(ux) >= 0)
 #endif
-#define __is_nonneg(ux) statically_true((__signed_type(ux))(ux) >= 0)
 
 #define __types_ok(ux, uy) \
 	(__sign_use(ux) & __sign_use(uy))
_

Patches currently in -mm which might be from David.Laight@ACULAB.COM are



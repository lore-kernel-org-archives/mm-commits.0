Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9360C382F33
	for <mm-commits@vger.kernel.org>; Wed, 13 May 2026 03:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778644767; cv=none; b=UH6enQ1mDsoYTSJ5a9LacTYOBM+1JlCSz2xiqLP22PMrIeuMTZggxlwgYLcF6MjX2F9AkKA1vszJ70T8zsz8iEkeAP/ersheK48d9B3nsQScqjnmWhefqgfbakK5sU4sOxVyAY3tpvyKejsJLChcExLarB6MUFAFsucERDYqZ38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778644767; c=relaxed/simple;
	bh=U5y9FYmNQ1GDQXKMZKnO0PKDRYYUB5H0iCh4Mq1ye08=;
	h=Date:To:From:Subject:Message-Id; b=A01zAF59KoF/UA8Nfbwv2rxOd6/Li/lenpTmlPc5BhTWFhU54ZaYxwBYsJpCDXuWA2uofcFcaFx1qjeYPtxvmXEVYZYG8rYDKQ9HJ7QMUkkt25euv+z8ufTiH/FN9g5u0aP/BO+ZRPqQVyXFDbGzRnjEELdRjnm4ZcpFYeut8MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yTCgkuo5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yTCgkuo5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A375C2BCC7;
	Wed, 13 May 2026 03:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778644767;
	bh=U5y9FYmNQ1GDQXKMZKnO0PKDRYYUB5H0iCh4Mq1ye08=;
	h=Date:To:From:Subject:From;
	b=yTCgkuo5pqaVZ4055X+x5rbU5vXA2M+QSZSz0GOY+5nltwERdiBgSrmacz6Q6R2xP
	 a6wgTv6XXQ/pQVt3PUd/hoqUoP+lzuZYzI1+DWr8f6N70J21iHi8F/SBo8V2+el4UG
	 FqSgXRJzAiGSgWehKp6eaH40LEy6UZfV1zfqyeoE=
Date: Tue, 12 May 2026 20:59:26 -0700
To: mm-commits@vger.kernel.org,pjw@kernel.org,palmer@dabbelt.com,nathan@kernel.org,kees@kernel.org,djwong@kernel.org,ardb@kernel.org,aou@eecs.berkeley.edu,andriy.shevchenko@intel.com,alex@ghiti.fr,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] lib-fix-_parse_integer_limit-to-handle-overflow.patch removed from -mm tree
Message-Id: <20260513035927.2A375C2BCC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: fix _parse_integer_limit() to handle overflow
has been removed from the -mm tree.  Its filename was
     lib-fix-_parse_integer_limit-to-handle-overflow.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: lib: fix _parse_integer_limit() to handle overflow
Date: Fri, 3 Apr 2026 13:33:33 +0300

Patch series "lib and lib/cmdline enhancements", v9.

Adjust '_parse_integer_limit()' and 'memparse()' to not ignore overflows,
extend string to 64-bit integer conversion tests, add KUnit-based test for
'memparse()', fix kernel-doc glitches found in lib/cmdline.c and adjust
riscv32 linker script to export symbols needed for EFI stub.


This patch (of 6):

In '_parse_integer_limit()', adjust native integer arithmetic with
near-to-overflow branch where 'check_mul_overflow()' and
'check_add_overflow()' are used to check whether an intermediate result
goes out of range, and denote such a case with ULLONG_MAX, thus making the
function more similar to standard C library's 'strtoull()'.  Adjust
comment to kernel-doc style as well.

Link: https://lore.kernel.org/20260403103338.1122415-1-dmantipov@yandex.ru
Link: https://lore.kernel.org/20260403103338.1122415-2-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kstrtox.c |   37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

--- a/lib/kstrtox.c~lib-fix-_parse_integer_limit-to-handle-overflow
+++ a/lib/kstrtox.c
@@ -39,25 +39,30 @@ const char *_parse_integer_fixup_radix(c
 	return s;
 }
 
-/*
- * Convert non-negative integer string representation in explicitly given radix
- * to an integer. A maximum of max_chars characters will be converted.
+/**
+ * _parse_integer_limit - Convert integer string representation to an integer
+ * @s: Integer string representation
+ * @base: Radix
+ * @p: Where to store result
+ * @max_chars: Maximum amount of characters to convert
  *
- * Return number of characters consumed maybe or-ed with overflow bit.
- * If overflow occurs, result integer (incorrect) is still returned.
+ * Convert non-negative integer string representation in explicitly given
+ * radix to an integer. If overflow occurs, value at @p is set to ULLONG_MAX.
  *
- * Don't you dare use this function.
+ * This function is the workhorse of other string conversion functions and it
+ * is discouraged to use it explicitly. Consider kstrto*() family instead.
+ *
+ * Return: Number of characters consumed, maybe ORed with overflow bit
  */
 noinline
 unsigned int _parse_integer_limit(const char *s, unsigned int base, unsigned long long *p,
 				  size_t max_chars)
 {
+	unsigned int rv, overflow = 0;
 	unsigned long long res;
-	unsigned int rv;
 
 	res = 0;
-	rv = 0;
-	while (max_chars--) {
+	for (rv = 0; rv < max_chars; rv++, s++) {
 		unsigned int c = *s;
 		unsigned int lc = _tolower(c);
 		unsigned int val;
@@ -76,15 +81,17 @@ unsigned int _parse_integer_limit(const
 		 * it in the max base we support (16)
 		 */
 		if (unlikely(res & (~0ull << 60))) {
-			if (res > div_u64(ULLONG_MAX - val, base))
-				rv |= KSTRTOX_OVERFLOW;
+			if (check_mul_overflow(res, base, &res) ||
+			    check_add_overflow(res, val, &res)) {
+				res = ULLONG_MAX;
+				overflow = KSTRTOX_OVERFLOW;
+			}
+		} else {
+			res = res * base + val;
 		}
-		res = res * base + val;
-		rv++;
-		s++;
 	}
 	*p = res;
-	return rv;
+	return rv | overflow;
 }
 
 noinline
_

Patches currently in -mm which might be from dmantipov@yandex.ru are

lib-free-pagelist-on-error-in-iov_iter_extract_pages.patch
lib-fix-memparse-to-handle-overflow.patch
lib-add-more-string-to-64-bit-integer-conversion-overflow-tests.patch
lib-cmdline_kunit-add-test-case-for-memparse.patch
lib-cmdline-adjust-a-few-comments-to-fix-kernel-doc-wreturn-warnings.patch
riscv-export-symbols-needed-for-riscv32-efi-stub.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05F52DEA9B
	for <mm-commits@vger.kernel.org>; Fri,  3 Apr 2026 17:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775236246; cv=none; b=G3ot81Z33vMMnO97uednyCYNOu8cZjkzV3JpildfGpsNWL8PyZh90/mk4v/VtWPkkwZHXgeU33qSmgaQJ1lOUVDoaMpNab+JwcKowgiI2rV0Y3iSn98JZEXMphAyeKzpHtb/j6snMXWRbCQJ8CfNdLGWcsIDWu4e8SMtvpc+GXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775236246; c=relaxed/simple;
	bh=hob/JWASo6JeF4OrS1a0EencErXBUqQ1BxuMyv2AS18=;
	h=Date:To:From:Subject:Message-Id; b=c0HIGBfldOlkRGFlgXL2ZhP9hCnDuh5/pqnXCG7tOXvUbZEdx9nE7TnsUVeB86tf3ldBEAIDl9Zxp5k44Y0O8CajmNBI3o1JTlTSffLeYnarmrErK4Cu4O91ncw591/SoFzFX3NnVsoyj+d2+8F2Yz75hHrTtmLbmTtNlEYFIaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kc4LuYNd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kc4LuYNd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2599AC4CEF7;
	Fri,  3 Apr 2026 17:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775236246;
	bh=hob/JWASo6JeF4OrS1a0EencErXBUqQ1BxuMyv2AS18=;
	h=Date:To:From:Subject:From;
	b=kc4LuYNdCSU+yXqhfe6H4S0yVn3oB1gZNR38OGmiWbDfXUBzqWob2xMzVyYinRJ2x
	 QZwj4hzul6GAqLvB+qvUHJdZ1honG/6AS4RHhuJHH5d+11/d5/9bA0ABEO96pP6qdr
	 TwkDGjxJofEltIBDwIf7wK1uWub2ztToolMEy87g=
Date: Fri, 03 Apr 2026 10:10:45 -0700
To: mm-commits@vger.kernel.org,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-fix-_parse_integer_limit-to-handle-overflow.patch added to mm-nonmm-unstable branch
Message-Id: <20260403171046.2599AC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: fix _parse_integer_limit() to handle overflow
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-fix-_parse_integer_limit-to-handle-overflow.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-fix-_parse_integer_limit-to-handle-overflow.patch

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

Link: https://lkml.kernel.org/r/20260403103338.1122415-1-dmantipov@yandex.ru
Link: https://lkml.kernel.org/r/20260403103338.1122415-2-dmantipov@yandex.ru
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

lib-fix-_parse_integer_limit-to-handle-overflow.patch
lib-fix-memparse-to-handle-overflow.patch
lib-add-more-string-to-64-bit-integer-conversion-overflow-tests.patch
lib-cmdline_kunit-add-test-case-for-memparse.patch
lib-cmdline-adjust-a-few-comments-to-fix-kernel-doc-wreturn-warnings.patch
riscv-export-symbols-needed-for-riscv32-efi-stub.patch


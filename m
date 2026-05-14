Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AACD4A33
	for <mm-commits@vger.kernel.org>; Thu, 14 May 2026 00:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778717318; cv=none; b=CTdiEq/vRWBhVK5D+PwnNI/bxj0EAj11PbFKrEgSBBYbevZshEi3fdh99uTleyAnm7llr4w7142CTy+Ww25gVwwTX4vcvHIIGGv1efJ0vNOc+qGJkegMh2EBUOQo3D6ce6Nf78UOjuilb93v0v5/ZyjyEKVb4aUbsD9JrnAjR3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778717318; c=relaxed/simple;
	bh=vCN3ajTSgSh1k+BM9bJTzJEu77hYQm+tK9TTng4xDHk=;
	h=Date:To:From:Subject:Message-Id; b=dNl6f8OXbUrYI53THvzwRRoZ4T4pnUtABp+yrRw++kDQCJqQcemkx32X1PDDC1AW2rY8Witf83axLzagoZymr5emhjeKwwnJgZpp8AgOYdYwR7h7TDyXesAb/LrpDdzLnivm3p5E7pjpaKCO18AEZjD+7DXxbdDye6KY7FCNMCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zsF25IX4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zsF25IX4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3856C19425;
	Thu, 14 May 2026 00:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778717317;
	bh=vCN3ajTSgSh1k+BM9bJTzJEu77hYQm+tK9TTng4xDHk=;
	h=Date:To:From:Subject:From;
	b=zsF25IX4oiceH16jF6fDVZpvDAEj/93GHLgWrnwdgpUpuOuXFXsdpvaRMrRnD2xPP
	 GzqvQPvU3b9FXb5ii1LiaWUJrgrS41WpZHjGQ7Jq3rj8skAfJu3+hWteSOp8WayEu5
	 NDwUrzU+BlDqgAcBukxVsJUxkgczYJ3O5WaLc8Ok=
Date: Wed, 13 May 2026 17:08:37 -0700
To: mm-commits@vger.kernel.org,thecharlesjenkins@gmail.com,palmer@dabbelt.com,lkp@intel.com,ardb@kernel.org,aou@eecs.berkeley.edu,andriy.shevchenko@intel.com,alex@ghiti.fr,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-fix-_parse_integer_limit-to-handle-overflow.patch added to mm-nonmm-unstable branch
Message-Id: <20260514000837.A3856C19425@smtp.kernel.org>
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
Date: Wed, 13 May 2026 16:44:00 +0300

Patch series "lib and lib/cmdline enhancements", v10.

This series is a merge of the recently posted [1] and [2]. The first
one is intended to adjust '_parse_integer_limit()' and 'memparse()' to
not ignore overflows, extend string to 64-bit integer conversion tests,
add KUnit-based test for 'memparse()' and fix kernel-doc glitches found
in lib/cmdline.c. The second one was originated from RISCV-specific
build fixes needed to integrate the former and now aims to provide
platform-specific double-word shifts and corresponding KUnit test.

This series was briefly tested on X86, RISCV32, ARM, and MIPS using QEMU.

Getting feedback from RISC-V core maintainers would be very helpful.

Special thanks to Andy Shevchenko, Charlie Jenkins, and Andrew Morton.


This patch (of 8):

In '_parse_integer_limit()', adjust native integer arithmetic with
near-to-overflow branch where 'check_mul_overflow()' and
'check_add_overflow()' are used to check whether an intermediate result
goes out of range, and denote such a case with ULLONG_MAX, thus making the
function more similar to standard C library's 'strtoull()'.  Adjust
comment to kernel-doc style as well.

Link: https://lore.kernel.org/20260513134407.884033-1-dmantipov@yandex.ru
Link: https://lore.kernel.org/20260513134407.884033-2-dmantipov@yandex.ru
Link: https://lore.kernel.org/linux-riscv/20260403103338.1122415-1-dmantipov@yandex.ru [1]
Link: https://lore.kernel.org/linux-riscv/20260427090105.705529-1-dmantipov@yandex.ru [2]
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Charlie Jenkins <thecharlesjenkins@gmail.com>
Cc: kernel test robot <lkp@intel.com>
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
lib-fix-_parse_integer_limit-to-handle-overflow.patch
lib-fix-memparse-to-handle-overflow.patch
lib-add-more-string-to-64-bit-integer-conversion-overflow-tests.patch
lib-cmdline_kunit-add-test-case-for-memparse.patch
lib-cmdline-adjust-a-few-comments-to-fix-kernel-doc-wreturn-warnings.patch
riscv-add-platform-specific-double-word-shifts-for-riscv32.patch
lib-kunit-add-tests-for-__ashldi3-__ashrdi3-and-__lshrdi3.patch
riscv-fix-building-compressed-efi-image.patch


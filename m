Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E25372055
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028781; cv=none; b=SBR7/+sFLPZv+RY5Y6buGLNXklQpFFM17SrlTDIXpBmT/oyhq08saIfd9RwLxdkKwvCGOWLoz2hqDiq0Ja2DkQAckjA9/NNqbjD09iEW/YOMIhgA5sbhUGm7Xrq4UJHeFjCESFTI0n997sNRbag4wRS4OOAGcDerCYzMeA3XxAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028781; c=relaxed/simple;
	bh=NYDurJr4jiX4ASfVfhGJy9RdInseBv2Wh0G9IcC/CnE=;
	h=Date:To:From:Subject:Message-Id; b=h3YuSc67QEnVUMWCGuGnbmlAs2kpiT8Wfkvbc7q6sUZBhr6A8wZkzz7yShduWE3NOyE3uwaa+YCDa3NhwNhExSJG+JaP1B1Jra21bU7I7/3KlE7R1BUon63qW//ECFbZMUL6Alxkz6wosKeaOBqnyY5Wk1qv90K8l8UoDHUnxU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pNjxSkwV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pNjxSkwV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F96D1F00898;
	Fri, 29 May 2026 04:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028780;
	bh=ITdxqXQlJasLyKmn3pikKbr/i0NU66tUupDREF7bhIs=;
	h=Date:To:From:Subject;
	b=pNjxSkwVGy9XOeLKTzcVzcuYgfbAEoLkAG2E2mknrByWTplaoK0Hjc1xnQOUDlnob
	 0hICdwz8HNyqOa+YaCrhHB60fjr+Qa0wQrMrx0QFOMtsb8M7l7LbygQ9BC3kz+9u4L
	 5BCt8R0c+uLXfBtqihFaH8fr2Z7GvvaJDj79JfzI=
Date: Thu, 28 May 2026 21:26:20 -0700
To: mm-commits@vger.kernel.org,thecharlesjenkins@gmail.com,palmer@dabbelt.com,ardb@kernel.org,aou@eecs.berkeley.edu,andriy.shevchenko@intel.com,alex@ghiti.fr,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-fix-_parse_integer_limit-to-handle-overflow.patch removed from -mm tree
Message-Id: <20260529042620.8F96D1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: fix _parse_integer_limit() to handle overflow
has been removed from the -mm tree.  Its filename was
     lib-fix-_parse_integer_limit-to-handle-overflow.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: lib: fix _parse_integer_limit() to handle overflow
Date: Tue, 19 May 2026 20:22:52 +0300

Patch series "lib and lib/cmdline enhancements", v11.

This series is a merge of the recently posted [1] and [2].  The first one
is intended to adjust '_parse_integer_limit()' and 'memparse()' to not
ignore overflows, extend string to 64-bit integer conversion tests, add
KUnit-based test for 'memparse()' and fix kernel-doc glitches found in
lib/cmdline.c.  The second one was originated from RISCV-specific build
fixes needed to integrate the former and now aims to provide
platform-specific double-word shifts and corresponding KUnit test.

Getting feedback from RISCV core maintainers would be very helpful.

Special thanks to Andy Shevchenko, Charlie Jenkins, and Andrew Morton.


This patch (of 8):

In '_parse_integer_limit()', adjust native integer arithmetic with
near-to-overflow branch where 'check_mul_overflow()' and
'check_add_overflow()' are used to check whether an intermediate result
goes out of range, and denote such a case with ULLONG_MAX, thus making the
function more similar to standard C library's 'strtoull()'.  Adjust
comment to kernel-doc style as well.

Link: https://lore.kernel.org/20260519172259.908980-1-dmantipov@yandex.ru
Link: https://lore.kernel.org/20260519172259.908980-2-dmantipov@yandex.ru
Link: https://lore.kernel.org/linux-riscv/20260403103338.1122415-1-dmantipov@yandex.ru [1]
Link: https://lore.kernel.org/linux-riscv/20260427090105.705529-1-dmantipov@yandex.ru [2]
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andriy Shevchenko <andriy.shevchenko@intel.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Charlie Jenkins <thecharlesjenkins@gmail.com>
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


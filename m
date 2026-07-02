Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BC53932D5
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 21:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783027781; cv=none; b=ujilUXfvepBhqBsDUUPFTyNm4CgQLV11bIRq8s5OSxAkJu+i/JJDRqe+WaLCJL1JWIEcilSItmGVpDfbPpITMner3LKMt/2xvuEiuNJjrw9T27AuQ5oYT9XMTpYZYNQ1kWFUCEqtFFVoQj4AyrKVbEVMyhEWEz7zWttbKBQOGc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783027781; c=relaxed/simple;
	bh=rtK635P3OJKg4zpFF732ATW/ajBYmWjZZZ0ahA87p9c=;
	h=Date:To:From:Subject:Message-Id; b=tIDYaLwyGuZEEWCn1sHccCpCv6ZUksQc1s7Sak/QYVqBwqLZeY4VHHzGtNNxn0QvBBd7tCS7XY17gFzSkrQOT/LkXRNnpf8AcjiLS8gQXQBew/0bVU4sTj2c/hj//2hisXYMd6rjB8WZPk7Lj5zA6w7niH/DZ/aN3kSJXVFcX7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YOYya/PJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YOYya/PJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC271F000E9;
	Thu,  2 Jul 2026 21:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783027779;
	bh=yeZfeaunaA/l18Sfxz6+ljIrb5pZB7iFUprlSzXw/8M=;
	h=Date:To:From:Subject;
	b=YOYya/PJ0/fSxM269txrNWQIUYl3NR2zsk5Q+P0nvmaatCpq/6dHhw1bQwb2sZpXf
	 yLyljJa7CHGIj18GRxwpe1Oc1agy5w9jaaoqYdzrPunD5n2VQDxiDCEmnPy49rahAX
	 ep4YMw3AzeK/DJyNFbq8d+ba+FRtkDZCpjeRENuY=
Date: Thu, 02 Jul 2026 14:29:39 -0700
To: mm-commits@vger.kernel.org,dmantipov@yandex.ru,andriy.shevchenko@intel.com,adobriyan@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-lib-fix-_parse_integer_limit-to-handle-overflow.patch added to mm-nonmm-unstable branch
Message-Id: <20260702212939.BDC271F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Revert "lib: fix _parse_integer_limit() to handle overflow"
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     revert-lib-fix-_parse_integer_limit-to-handle-overflow.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-lib-fix-_parse_integer_limit-to-handle-overflow.patch

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
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Revert "lib: fix _parse_integer_limit() to handle overflow"
Date: Thu, 2 Jul 2026 21:06:38 +0300

This reverts commit 6e30111dbb40 ("lib: fix _parse_integer_limit() to
handle overflow").

1) this patch breaks scanf() which uses _parse_integer_limit()
   internally, and is supposed to get overflowed result
   (however incorrect it may be)

2) using check_mul_overflow() and check_add_overflow() as written
   doesn't add any overflow protection because it is under branch
   where such overflow can't happen if radix is kept <=16,

3) kernel-doc comment legitimize the function while exactly
   the opposite should be done. Not a fan.

Link: https://lore.kernel.org/20260702180638.39196-1-adobriyan@gmail.com
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andriy Shevchenko <andriy.shevchenko@intel.com>
Cc: Dmitry Antipov <dmantipov@yandex.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kstrtox.c |   37 +++++++++++++++----------------------
 1 file changed, 15 insertions(+), 22 deletions(-)

--- a/lib/kstrtox.c~revert-lib-fix-_parse_integer_limit-to-handle-overflow
+++ a/lib/kstrtox.c
@@ -39,30 +39,25 @@ const char *_parse_integer_fixup_radix(c
 	return s;
 }
 
-/**
- * _parse_integer_limit - Convert integer string representation to an integer
- * @s: Integer string representation
- * @base: Radix
- * @p: Where to store result
- * @max_chars: Maximum amount of characters to convert
+/*
+ * Convert non-negative integer string representation in explicitly given radix
+ * to an integer. A maximum of max_chars characters will be converted.
  *
- * Convert non-negative integer string representation in explicitly given
- * radix to an integer. If overflow occurs, value at @p is set to ULLONG_MAX.
+ * Return number of characters consumed maybe or-ed with overflow bit.
+ * If overflow occurs, result integer (incorrect) is still returned.
  *
- * This function is the workhorse of other string conversion functions and it
- * is discouraged to use it explicitly. Consider kstrto*() family instead.
- *
- * Return: Number of characters consumed, maybe ORed with overflow bit
+ * Don't you dare use this function.
  */
 noinline
 unsigned int _parse_integer_limit(const char *s, unsigned int base, unsigned long long *p,
 				  size_t max_chars)
 {
-	unsigned int rv, overflow = 0;
 	unsigned long long res;
+	unsigned int rv;
 
 	res = 0;
-	for (rv = 0; rv < max_chars; rv++, s++) {
+	rv = 0;
+	while (max_chars--) {
 		unsigned int c = *s;
 		unsigned int lc = _tolower(c);
 		unsigned int val;
@@ -81,17 +76,15 @@ unsigned int _parse_integer_limit(const
 		 * it in the max base we support (16)
 		 */
 		if (unlikely(res & (~0ull << 60))) {
-			if (check_mul_overflow(res, base, &res) ||
-			    check_add_overflow(res, val, &res)) {
-				res = ULLONG_MAX;
-				overflow = KSTRTOX_OVERFLOW;
-			}
-		} else {
-			res = res * base + val;
+			if (res > div_u64(ULLONG_MAX - val, base))
+				rv |= KSTRTOX_OVERFLOW;
 		}
+		res = res * base + val;
+		rv++;
+		s++;
 	}
 	*p = res;
-	return rv | overflow;
+	return rv;
 }
 
 noinline
_

Patches currently in -mm which might be from adobriyan@gmail.com are

revert-lib-fix-_parse_integer_limit-to-handle-overflow.patch


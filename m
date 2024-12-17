Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4488F77
	for <mm-commits@vger.kernel.org>; Tue, 17 Dec 2024 05:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734411920; cv=none; b=BMI07XYslR4GuNDFPJE0vggd6m2E0cBSV5GRGN0bC5a0myESW+K2cPmobKEXAt92jwpfsMXRK+07M9SUxdtq1NCkBrceToKw9UlzNU4efsR2MQM+AooL5ZxKmIN11QC2GzmLZaNNowyq8LDgfz52AsZwMwXasvgad9gnhH0WAow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734411920; c=relaxed/simple;
	bh=K1wZVyb8J1trP+aTaDzUCOgDAn6gsgcnGmnVMMTr8q4=;
	h=Date:To:From:Subject:Message-Id; b=Cj/E/W5H0RpRhjr0dqvnJ8tRD6EyHSBVvqsoYVQ+CSRO2q8kPJrx5DiW8FWqadCMwsxWFeq4xO34S0suEDH+AMoziWcnrfThI2oOLWObmtTsxTEKACRrq8MqOuxKNllIaLspLui1piVGDSW94LZ+RU4ual+lsw90Yn6/YhcEQlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lHZkd2d/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lHZkd2d/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6FDC4CED3;
	Tue, 17 Dec 2024 05:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734411919;
	bh=K1wZVyb8J1trP+aTaDzUCOgDAn6gsgcnGmnVMMTr8q4=;
	h=Date:To:From:Subject:From;
	b=lHZkd2d/7BRiZVpJV7VXPy8EzjXipwp4T6A5k/uJ1JOUFEAtMMo3x0BC1weNHrErF
	 vbNd9oQnudV2zof9b2SKgBRJDd6zihbgFDN/hzBS2xTY9kSisLKVapPJz4hQxA4WoB
	 /Tm8RgkcYV0hXW22SHrgJepUsBpi3H/t3nm6S97Y=
Date: Mon, 16 Dec 2024 21:05:18 -0800
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,torvalds@linux-foundation.org,masahiroy@kernel.org,mailhol.vincent@wanadoo.fr,linux@rasmusvillemoes.dk,david.laight@aculab.com,David.Laight@ACULAB.COM,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] linux-bitsh-simplify-genmask.patch removed from -mm tree
Message-Id: <20241217050519.9A6FDC4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: linux/bits.h: simplify GENMASK()
has been removed from the -mm tree.  Its filename was
     linux-bitsh-simplify-genmask.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: David Laight <David.Laight@ACULAB.COM>
Subject: linux/bits.h: simplify GENMASK()
Date: Mon, 16 Dec 2024 09:39:23 +0000

Change 95b980d62d52c replaced ~0ul and ~0ull with ~UL(0) and ~ULL(0) in
the GENMASK() defines as part of a change to allow the bitops definitions
be used from assembly.

The definitions have since been moved to a uapi header which probably
shouldn't require some other header be included first.

The definition of __GENMASK() is also overcomplicated partially due to
avoiding overflow warnings from shifting ~0u left.

Implement GENMASK() using the simpler (1u << hi) * 2 - (1u << lo) formula.
This doesn't rely on right shifts and doesn't need to know the number of
bits in the integral type.  It can be used for different types by just
changing the type of the 1u.  __GENMASK() __GENMASK_ULL() and
__GENMASK_U128() can now implemeted using a single ___GENMASK(one, hi,
lo).

Overflow warnings (from shifting out the MSB) are avoided by subtracting 1
before the multiply and adding two back in later.  The complers see
straight through the subterfuge when generating code.

Since there are already conditionals for ASSEMBLY in bits.h, for ASSEMBLY
directly expand GENMASK() and GENMASK_ULL() as ___GENMASK(1, hi, lo)
rather than through the __GENMASK() and __GENMASK_ULL() uapi defines. 
Remove the UL(x) and ULL(x) from the uapi file.

GENMASK() and GENMASK_ULL() now generate the correct values when ASSEMBLY
is defined.  Fortunately they've never been used.

Rename 'h' to 'hi' and 'l' to 'lo' because 'l' looks like '1' in many fonts.

Link: https://lkml.kernel.org/r/7a1b1534e51342769740985db773d5e1@AcuMS.aculab.com
Signed-off-by: David Laight <david.laight@aculab.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bits.h      |   43 ++++++++++++++----------------------
 include/uapi/linux/bits.h |   15 +++++-------
 2 files changed, 24 insertions(+), 34 deletions(-)

--- a/include/linux/bits.h~linux-bitsh-simplify-genmask
+++ a/include/linux/bits.h
@@ -14,41 +14,32 @@
 #define BITS_PER_BYTE		8
 
 /*
- * Create a contiguous bitmask starting at bit position @l and ending at
- * position @h. For example
+ * Create a contiguous bitmask starting at bit position @lo and ending at
+ * position @hi. For example
  * GENMASK_ULL(39, 21) gives us the 64bit vector 0x000000ffffe00000.
  */
 #if !defined(__ASSEMBLY__)
 #include <linux/build_bug.h>
-#define GENMASK_INPUT_CHECK(h, l) \
+#define GENMASK_INPUT_CHECK(hi, lo) \
 	(BUILD_BUG_ON_ZERO(__builtin_choose_expr( \
-		__is_constexpr((l) > (h)), (l) > (h), 0)))
-#else
-/*
- * BUILD_BUG_ON_ZERO is not available in h files included from asm files,
- * disable the input check if that is the case.
- */
-#define GENMASK_INPUT_CHECK(h, l) 0
-#endif
+		__is_constexpr((lo) > (hi)), (lo) > (hi), 0)))
 
-#define GENMASK(h, l) \
-	(GENMASK_INPUT_CHECK(h, l) + __GENMASK(h, l))
-#define GENMASK_ULL(h, l) \
-	(GENMASK_INPUT_CHECK(h, l) + __GENMASK_ULL(h, l))
+#define GENMASK(hi, lo) \
+	(GENMASK_INPUT_CHECK(hi, lo) + __GENMASK(hi, lo))
+#define GENMASK_ULL(hi, lo) \
+	(GENMASK_INPUT_CHECK(hi, lo) + __GENMASK_ULL(hi, lo))
 
-#if !defined(__ASSEMBLY__)
+#define GENMASK_U128(hi, lo) \
+	(GENMASK_INPUT_CHECK(hi, lo) + __GENMASK_U128(hi, lo))
+#else
 /*
- * Missing asm support
- *
- * __GENMASK_U128() depends on _BIT128() which would not work
- * in the asm code, as it shifts an 'unsigned __init128' data
- * type instead of direct representation of 128 bit constants
- * such as long and unsigned long. The fundamental problem is
- * that a 128 bit constant will get silently truncated by the
- * gcc compiler.
+ * BUILD_BUG_ON_ZERO is not available in h files included from asm files,
+ * 128bit exprssions don't work, neither can C 0UL (etc) constants be used.
+ * These definitions only have to work for constants and don't require
+ * that ~0 have any specific number of set bits.
  */
-#define GENMASK_U128(h, l) \
-	(GENMASK_INPUT_CHECK(h, l) + __GENMASK_U128(h, l))
+#define GENMASK(hi, lo) ___GENMASK(1, hi, lo)
+#define GENMASK_ULL(hi, lo) ___GENMASK(1, hi, lo)
 #endif
 
 #endif	/* __LINUX_BITS_H */
--- a/include/uapi/linux/bits.h~linux-bitsh-simplify-genmask
+++ a/include/uapi/linux/bits.h
@@ -4,15 +4,14 @@
 #ifndef _UAPI_LINUX_BITS_H
 #define _UAPI_LINUX_BITS_H
 
-#define __GENMASK(h, l) \
-        (((~_UL(0)) - (_UL(1) << (l)) + 1) & \
-         (~_UL(0) >> (__BITS_PER_LONG - 1 - (h))))
+/* Result is '(1u << (hi + 1)) - (1u << lo)' coded to avoid overflow. */
+#define ___GENMASK(one, hi, lo) \
+	((((one) << (hi)) - 1) * 2 + 1 - (((one) << (lo)) - 1))
 
-#define __GENMASK_ULL(h, l) \
-        (((~_ULL(0)) - (_ULL(1) << (l)) + 1) & \
-         (~_ULL(0) >> (__BITS_PER_LONG_LONG - 1 - (h))))
+#define __GENMASK(hi, lo) ___GENMASK(1UL, hi, lo)
 
-#define __GENMASK_U128(h, l) \
-	((_BIT128((h)) << 1) - (_BIT128(l)))
+#define __GENMASK_ULL(hi, lo) ___GENMASK(1ULL, hi, lo)
+
+#define __GENMASK_U128(hi, lo) ___GENMASK((unsigned __int128)1, hi, lo)
 
 #endif /* _UAPI_LINUX_BITS_H */
_

Patches currently in -mm which might be from David.Laight@ACULAB.COM are

minmaxh-add-whitespace-around-operators-and-after-commas.patch
minmaxh-update-some-comments.patch
minmaxh-reduce-the-define-expansion-of-min-max-and-clamp.patch
minmaxh-use-build_bug_on_msg-for-the-lo-hi-test-in-clamp.patch
minmaxh-move-all-the-clamp-definitions-after-the-min-max-ones.patch
minmaxh-simplify-the-variants-of-clamp.patch
minmaxh-remove-some-defines-that-are-only-expanded-once.patch


From: akpm@linux-foundation.org
Subject: + lib-vsprintfc-even-faster-decimal-conversion.patch added to -mm tree
Date: Wed, 11 Mar 2015 14:54:15 -0700
Message-ID: <5500b987.kerYYCYfIffruy3Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51176 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbbCKVyQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Mar 2015 17:54:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, joe@perches.com, peterz@infradead.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: even faster binary to decimal conversion
has been added to the -mm tree.  Its filename is
     lib-vsprintfc-even-faster-decimal-conversion.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-vsprintfc-even-faster-decimal-conversion.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-vsprintfc-even-faster-decimal-conversion.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/vsprintf.c: even faster binary to decimal conversion

The most expensive part of decimal conversion is the divisions by 10
(albeit done using reciprocal multiplication with appropriately chosen
constants).  I decided to see if one could eliminate around half of these
multiplications by emitting two digits at a time, at the cost of a 200
byte lookup table, and it does indeed seem like there is something to be
gained, especially on 64 bits.  Microbenchmarking shows improvements
ranging from -50% (for numbers uniformly distributed in [0, 2^64-1]) to
-25% (for numbers heavily biased toward the smaller end, a more realistic
distribution).

On a larger scale, perf shows that top, one of the big consumers of /proc
data, uses 0.5-1.0% fewer cpu cycles.

I had to jump through some hoops to get the 32 bit code to compile and run
on my 64 bit machine, so I'm not sure how relevant these numbers are, but
just for comparison the microbenchmark showed improvements between -30%
and -10%.

The bloat-o-meter costs are around 150 bytes (the generated code is a
little smaller, so it's not the full 200 bytes) on both 32 and 64 bit. 
I'm aware that extra cache misses won't show up in a microbenchmark as
used above, but on the other hand decimal conversions often happen in bulk
(for example in the case of top).

I have of course tested that the new code generates the same output as the
old, for both the first and last 1e10 numbers in [0,2^64-1] and 4e9
'random' numbers in-between.

Test and verification code on github
<https://github.com/Villemoes/dec>.  It would be nice if someone could
verify the code on architectures other than x86 - in particular, I
believe it _should_ work on big-endian, but I have no way of testing
that. Benchmark numbers would be nice too, of course.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |  248 ++++++++++++++++++++++++-----------------------
 1 file changed, 129 insertions(+), 119 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-even-faster-decimal-conversion lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-even-faster-decimal-conversion
+++ a/lib/vsprintf.c
@@ -33,6 +33,7 @@
 
 #include <asm/page.h>		/* for PAGE_SIZE */
 #include <asm/sections.h>	/* for dereference_function_descriptor() */
+#include <asm/byteorder.h>	/* cpu_to_le16 */
 
 #include <linux/string_helpers.h>
 #include "kstrtox.h"
@@ -122,142 +123,147 @@ int skip_atoi(const char **s)
 	return i;
 }
 
-/* Decimal conversion is by far the most typical, and is used
- * for /proc and /sys data. This directly impacts e.g. top performance
- * with many processes running. We optimize it for speed
- * using ideas described at <http://www.cs.uiowa.edu/~jones/bcd/divide.html>
- * (with permission from the author, Douglas W. Jones).
+/*
+ * Decimal conversion is by far the most typical, and is used for
+ * /proc and /sys data. This directly impacts e.g. top performance
+ * with many processes running. We optimize it for speed by emitting
+ * two characters at a time, using a 200 byte lookup table. This
+ * roughly halves the number of multiplications compared to computing
+ * the digits one at a time. Implementation strongly inspired by the
+ * previous version, which in turn used ideas described at
+ * <http://www.cs.uiowa.edu/~jones/bcd/divide.html> (with permission
+ * from the author, Douglas W. Jones).
+ *
+ * It turns out there is precisely one 26 bit fixed-point
+ * approximation a of 64/100 for which x/100 == (x * (u64)a) >> 32
+ * holds for all x in [0, 10^8-1], namely a = 0x28f5c29. The actual
+ * range happens to be somewhat larger (x <= 1073741898), but that's
+ * irrelevant for our purpose.
+ *
+ * For dividing a number in the range [10^4, 10^6-1] by 100, we still
+ * need a 32x32->64 bit multiply, so we simply use the same constant.
+ *
+ * For dividing a number in the range [100, 10^4-1] by 100, there are
+ * several options. The simplest is (x * 0x147b) >> 19, which is valid
+ * for all x <= 43698.
  */
 
-#if BITS_PER_LONG != 32 || BITS_PER_LONG_LONG != 64
-/* Formats correctly any integer in [0, 999999999] */
+static const u16 decpair[100] = {
+#define _(x) cpu_to_le16(((x % 10) | ((x / 10) << 8)) + 0x3030)
+	_( 0), _( 1), _( 2), _( 3), _( 4), _( 5), _( 6), _( 7), _( 8), _( 9),
+	_(10), _(11), _(12), _(13), _(14), _(15), _(16), _(17), _(18), _(19),
+	_(20), _(21), _(22), _(23), _(24), _(25), _(26), _(27), _(28), _(29),
+	_(30), _(31), _(32), _(33), _(34), _(35), _(36), _(37), _(38), _(39),
+	_(40), _(41), _(42), _(43), _(44), _(45), _(46), _(47), _(48), _(49),
+	_(50), _(51), _(52), _(53), _(54), _(55), _(56), _(57), _(58), _(59),
+	_(60), _(61), _(62), _(63), _(64), _(65), _(66), _(67), _(68), _(69),
+	_(70), _(71), _(72), _(73), _(74), _(75), _(76), _(77), _(78), _(79),
+	_(80), _(81), _(82), _(83), _(84), _(85), _(86), _(87), _(88), _(89),
+	_(90), _(91), _(92), _(93), _(94), _(95), _(96), _(97), _(98), _(99),
+#undef _
+};
+
+/*
+ * This will print a single '0' even if r == 0, since we would
+ * immediately jump to out_r where two 0s would be written and one of
+ * them then discarded. This is needed by ip4_string below. All other
+ * callers pass a non-zero value of r.
+*/
 static noinline_for_stack
-char *put_dec_full9(char *buf, unsigned q)
+char *put_dec_trunc8(char *buf, unsigned r)
 {
-	unsigned r;
+	unsigned q;
 
-	/*
-	 * Possible ways to approx. divide by 10
-	 * (x * 0x1999999a) >> 32 x < 1073741829 (multiply must be 64-bit)
-	 * (x * 0xcccd) >> 19     x <      81920 (x < 262149 when 64-bit mul)
-	 * (x * 0x6667) >> 18     x <      43699
-	 * (x * 0x3334) >> 17     x <      16389
-	 * (x * 0x199a) >> 16     x <      16389
-	 * (x * 0x0ccd) >> 15     x <      16389
-	 * (x * 0x0667) >> 14     x <       2739
-	 * (x * 0x0334) >> 13     x <       1029
-	 * (x * 0x019a) >> 12     x <       1029
-	 * (x * 0x00cd) >> 11     x <       1029 shorter code than * 0x67 (on i386)
-	 * (x * 0x0067) >> 10     x <        179
-	 * (x * 0x0034) >>  9     x <         69 same
-	 * (x * 0x001a) >>  8     x <         69 same
-	 * (x * 0x000d) >>  7     x <         69 same, shortest code (on i386)
-	 * (x * 0x0007) >>  6     x <         19
-	 * See <http://www.cs.uiowa.edu/~jones/bcd/divide.html>
-	 */
-	r      = (q * (uint64_t)0x1999999a) >> 32;
-	*buf++ = (q - 10 * r) + '0'; /* 1 */
-	q      = (r * (uint64_t)0x1999999a) >> 32;
-	*buf++ = (r - 10 * q) + '0'; /* 2 */
-	r      = (q * (uint64_t)0x1999999a) >> 32;
-	*buf++ = (q - 10 * r) + '0'; /* 3 */
-	q      = (r * (uint64_t)0x1999999a) >> 32;
-	*buf++ = (r - 10 * q) + '0'; /* 4 */
-	r      = (q * (uint64_t)0x1999999a) >> 32;
-	*buf++ = (q - 10 * r) + '0'; /* 5 */
-	/* Now value is under 10000, can avoid 64-bit multiply */
-	q      = (r * 0x199a) >> 16;
-	*buf++ = (r - 10 * q)  + '0'; /* 6 */
-	r      = (q * 0xcd) >> 11;
-	*buf++ = (q - 10 * r)  + '0'; /* 7 */
-	q      = (r * 0xcd) >> 11;
-	*buf++ = (r - 10 * q) + '0'; /* 8 */
-	*buf++ = q + '0'; /* 9 */
+	/* 1 <= r < 10^8 */
+	if (r < 100)
+		goto out_r;
+
+	/* 100 <= r < 10^8 */
+	q = (r * (u64)0x28f5c29) >> 32;
+	*((u16 *)buf) = decpair[r - 100*q];
+	buf += 2;
+
+	/* 1 <= q < 10^6 */
+	if (q < 100)
+		goto out_q;
+
+	/*  100 <= q < 10^6 */
+	r = (q * (u64)0x28f5c29) >> 32;
+	*((u16 *)buf) = decpair[q - 100*r];
+	buf += 2;
+
+	/* 1 <= r < 10^4 */
+	if (r < 100)
+		goto out_r;
+
+	/* 100 <= r < 10^4 */
+	q = (r * 0x147b) >> 19;
+	*((u16 *)buf) = decpair[r - 100*q];
+	buf += 2;
+out_q:
+	/* 1 <= q < 100 */
+	r = q;
+out_r:
+	/* 1 <= r < 100 */
+	*((u16 *)buf) = decpair[r];
+	buf += 2;
+	if (buf[-1] == '0')
+		buf--;
 	return buf;
 }
-#endif
 
-/* Similar to above but do not pad with zeros.
- * Code can be easily arranged to print 9 digits too, but our callers
- * always call put_dec_full9() instead when the number has 9 decimal digits.
- */
+#if BITS_PER_LONG == 64 && BITS_PER_LONG_LONG == 64
 static noinline_for_stack
-char *put_dec_trunc8(char *buf, unsigned r)
+char *put_dec_full8(char *buf, unsigned r)
 {
 	unsigned q;
 
-	/* Copy of previous function's body with added early returns */
-	while (r >= 10000) {
-		q = r + '0';
-		r  = (r * (uint64_t)0x1999999a) >> 32;
-		*buf++ = q - 10*r;
-	}
-
-	q      = (r * 0x199a) >> 16;	/* r <= 9999 */
-	*buf++ = (r - 10 * q)  + '0';
-	if (q == 0)
-		return buf;
-	r      = (q * 0xcd) >> 11;	/* q <= 999 */
-	*buf++ = (q - 10 * r)  + '0';
-	if (r == 0)
-		return buf;
-	q      = (r * 0xcd) >> 11;	/* r <= 99 */
-	*buf++ = (r - 10 * q) + '0';
-	if (q == 0)
-		return buf;
-	*buf++ = q + '0';		 /* q <= 9 */
+	/* 0 <= r < 10^8 */
+	q = (r * (u64)0x28f5c29) >> 32;
+	*((u16 *)buf) = decpair[r - 100*q];
+	buf += 2;
+
+	/* 0 <= q < 10^6 */
+	r = (q * (u64)0x28f5c29) >> 32;
+	*((u16 *)buf) = decpair[q - 100*r];
+	buf += 2;
+
+	/* 0 <= r < 10^4 */
+	q = (r * 0x147b) >> 19;
+	*((u16 *)buf) = decpair[r - 100*q];
+	buf += 2;
+
+	/* 0 <= q < 100 */
+	*((u16 *)buf) = decpair[q];
+	buf += 2;
 	return buf;
 }
 
-/* There are two algorithms to print larger numbers.
- * One is generic: divide by 1000000000 and repeatedly print
- * groups of (up to) 9 digits. It's conceptually simple,
- * but requires a (unsigned long long) / 1000000000 division.
- *
- * Second algorithm splits 64-bit unsigned long long into 16-bit chunks,
- * manipulates them cleverly and generates groups of 4 decimal digits.
- * It so happens that it does NOT require long long division.
- *
- * If long is > 32 bits, division of 64-bit values is relatively easy,
- * and we will use the first algorithm.
- * If long long is > 64 bits (strange architecture with VERY large long long),
- * second algorithm can't be used, and we again use the first one.
- *
- * Else (if long is 32 bits and long long is 64 bits) we use second one.
- */
-
-#if BITS_PER_LONG != 32 || BITS_PER_LONG_LONG != 64
-
-/* First algorithm: generic */
-
-static
+static noinline_for_stack
 char *put_dec(char *buf, unsigned long long n)
 {
-	if (n >= 100*1000*1000) {
-		while (n >= 1000*1000*1000)
-			buf = put_dec_full9(buf, do_div(n, 1000*1000*1000));
-		if (n >= 100*1000*1000)
-			return put_dec_full9(buf, n);
-	}
+	if (n >= 100*1000*1000)
+		buf = put_dec_full8(buf, do_div(n, 100*1000*1000));
+	/* 1 <= n <= 1.6e11 */
+	if (n >= 100*1000*1000)
+		buf = put_dec_full8(buf, do_div(n, 100*1000*1000));
+	/* 1 <= n < 1e8 */
 	return put_dec_trunc8(buf, n);
 }
 
-#else
-
-/* Second algorithm: valid only for 64-bit long longs */
+#elif BITS_PER_LONG == 32 && BITS_PER_LONG_LONG == 64
 
-/* See comment in put_dec_full9 for choice of constants */
-static noinline_for_stack
-void put_dec_full4(char *buf, unsigned q)
+static void
+put_dec_full4(char *buf, unsigned r)
 {
-	unsigned r;
-	r      = (q * 0xccd) >> 15;
-	buf[0] = (q - 10 * r) + '0';
-	q      = (r * 0xcd) >> 11;
-	buf[1] = (r - 10 * q)  + '0';
-	r      = (q * 0xcd) >> 11;
-	buf[2] = (q - 10 * r)  + '0';
-	buf[3] = r + '0';
+	unsigned q;
+
+	/* 0 <= r < 10^4 */
+	q = (r * 0x147b) >> 19;
+	*((u16 *)buf) = decpair[r - 100*q];
+	buf += 2;
+	/* 0 <= q < 100 */
+	*((u16 *)buf) = decpair[q];
 }
 
 /*
@@ -265,9 +271,9 @@ void put_dec_full4(char *buf, unsigned q
  * The approximation x/10000 == (x * 0x346DC5D7) >> 43
  * holds for all x < 1,128,869,999.  The largest value this
  * helper will ever be asked to convert is 1,125,520,955.
- * (d1 in the put_dec code, assuming n is all-ones).
+ * (second call in the put_dec code, assuming n is all-ones).
  */
-static
+static noinline_for_stack
 unsigned put_dec_helper4(char *buf, unsigned x)
 {
         uint32_t q = (x * (uint64_t)0x346DC5D7) >> 43;
@@ -294,6 +300,8 @@ char *put_dec(char *buf, unsigned long l
 	d2  = (h      ) & 0xffff;
 	d3  = (h >> 16); /* implicit "& 0xffff" */
 
+	/* n = 2^48 d3 + 2^32 d2 + 2^16 d1 + d0
+	     = 281_4749_7671_0656 d3 + 42_9496_7296 d2 + 6_5536 d1 + d0 */
 	q   = 656 * d3 + 7296 * d2 + 5536 * d1 + ((uint32_t)n & 0xffff);
 	q = put_dec_helper4(buf, q);
 
@@ -323,7 +331,8 @@ char *put_dec(char *buf, unsigned long l
  */
 int num_to_str(char *buf, int size, unsigned long long num)
 {
-	char tmp[sizeof(num) * 3];
+	/* put_dec requires 2-byte alignment of the buffer. */
+	char tmp[sizeof(num) * 3] __aligned(2);
 	int idx, len;
 
 	/* put_dec() may work incorrectly for num = 0 (generate "", not "0") */
@@ -384,7 +393,8 @@ static noinline_for_stack
 char *number(char *buf, char *end, unsigned long long num,
 	     struct printf_spec spec)
 {
-	char tmp[3 * sizeof(num)];
+	/* put_dec requires 2-byte alignment of the buffer. */
+	char tmp[3 * sizeof(num)] __aligned(2);
 	char sign;
 	char locase;
 	int need_pfx = ((spec.flags & SPECIAL) && spec.base != 10);
@@ -944,7 +954,7 @@ char *ip4_string(char *p, const u8 *addr
 		break;
 	}
 	for (i = 0; i < 4; i++) {
-		char temp[3];	/* hold each IP quad in reverse order */
+		char temp[4] __aligned(2);	/* hold each IP quad in reverse order */
 		int digits = put_dec_trunc8(temp, addr[index]) - temp;
 		if (leading_zeros) {
 			if (digits < 3)
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

include-linux-remove-empty-conditionals.patch
lib-vsprintfc-eliminate-some-branches.patch
lib-vsprintfc-reduce-stack-use-in-number.patch
lib-vsprintfc-eliminate-duplicate-hex-string-array.patch
lib-vsprintfc-another-small-hack.patch
lib-vsprintfc-fix-potential-null-deref-in-hex_string.patch
lib-string_helpersc-refactor-string_escape_mem.patch
lib-string_helpersc-change-semantics-of-string_escape_mem.patch
linux-bitmaph-improve-bitmap_lastfirst_word_mask.patch
lib-find__bit-reimplementation.patch
lib-find__bit-reimplementation-fix.patch
lib-move-find_last_bit-to-lib-find_next_bitc.patch
lib-rename-lib-find_next_bitc-to-lib-find_bitc.patch
lib-vsprintfc-even-faster-decimal-conversion.patch
binfmt_misc-simplify-entry_status.patch
binfmt_misc-simplify-entry_status-fix.patch
rtc-mc13xxx-fix-obfuscated-and-wrong-format-string.patch
lib-lz4-pull-out-constant-tables.patch
linux-next.patch


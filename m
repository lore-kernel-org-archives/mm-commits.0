From: akpm@linux-foundation.org
Subject: [merged] lib-rework-bitmap_parse.patch removed from -mm
 tree
Date: Tue, 04 Feb 2020 10:42:31 -0800
Message-ID: <20200204184231.1Ss1R9BXu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727559AbgBDSme (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 Feb 2020 13:42:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: acme@redhat.com, amritha.nambiar@intel.com, andriy.shevchenko@linux.intel.com, chris@chris-wilson.co.uk, keescook@chromium.org, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org, mszeredi@redhat.com, steffen.klassert@secunet.com, tobin@kernel.org, vineet.gupta1@synopsys.com, will.deacon@arm.com, willemb@google.com, willy@infradead.org, yury.norov@gmail.com


The patch titled
     Subject: lib: rework bitmap_parse()
has been removed from the -mm tree.  Its filename was
     lib-rework-bitmap_parse.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: lib: rework bitmap_parse()

bitmap_parse() is ineffective and full of opaque variables and opencoded
parts.  It leads to hard understanding and usage of it.  This rework
includes:

- remove bitmap_shift_left() call from the cycle.  Now it makes the
  complexity of the algorithm as O(nbits^2).  In the suggested approach
  the input string is parsed in reverse direction, so no shifts needed;

- relax requirement on a single comma and no white spaces between
  chunks.  It is considered useful in scripting, and it aligns with
  bitmap_parselist();

- split bitmap_parse() to small readable helpers;

- make an explicit calculation of the end of input line at the
  beginning, so users of the bitmap_parse() won't bother doing this.

Link: http://lkml.kernel.org/r/20200102043031.30357-6-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Cc: Amritha Nambiar <amritha.nambiar@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: "Tobin C . Harding" <tobin@kernel.org>
Cc: Vineet Gupta <vineet.gupta1@synopsys.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    8 -
 lib/bitmap.c           |  175 ++++++++++++++++++---------------------
 2 files changed, 84 insertions(+), 99 deletions(-)

--- a/include/linux/bitmap.h~lib-rework-bitmap_parse
+++ a/include/linux/bitmap.h
@@ -186,7 +186,7 @@ bitmap_find_next_zero_area(unsigned long
 					      align_mask, 0);
 }
 
-extern int __bitmap_parse(const char *buf, unsigned int buflen, int is_user,
+extern int bitmap_parse(const char *buf, unsigned int buflen,
 			unsigned long *dst, int nbits);
 extern int bitmap_parse_user(const char __user *ubuf, unsigned int ulen,
 			unsigned long *dst, int nbits);
@@ -454,12 +454,6 @@ static inline void bitmap_replace(unsign
 		__bitmap_replace(dst, old, new, mask, nbits);
 }
 
-static inline int bitmap_parse(const char *buf, unsigned int buflen,
-			unsigned long *maskp, int nmaskbits)
-{
-	return __bitmap_parse(buf, buflen, 0, maskp, nmaskbits);
-}
-
 static inline void bitmap_next_clear_region(unsigned long *bitmap,
 					    unsigned int *rs, unsigned int *re,
 					    unsigned int end)
--- a/lib/bitmap.c~lib-rework-bitmap_parse
+++ a/lib/bitmap.c
@@ -431,97 +431,6 @@ EXPORT_SYMBOL(bitmap_find_next_zero_area
  * second version by Paul Jackson, third by Joe Korty.
  */
 
-#define CHUNKSZ				32
-#define nbits_to_hold_value(val)	fls(val)
-#define BASEDEC 10		/* fancier cpuset lists input in decimal */
-
-/**
- * __bitmap_parse - convert an ASCII hex string into a bitmap.
- * @buf: pointer to buffer containing string.
- * @buflen: buffer size in bytes.  If string is smaller than this
- *    then it must be terminated with a \0.
- * @is_user: location of buffer, 0 indicates kernel space
- * @maskp: pointer to bitmap array that will contain result.
- * @nmaskbits: size of bitmap, in bits.
- *
- * Commas group hex digits into chunks.  Each chunk defines exactly 32
- * bits of the resultant bitmask.  No chunk may specify a value larger
- * than 32 bits (%-EOVERFLOW), and if a chunk specifies a smaller value
- * then leading 0-bits are prepended.  %-EINVAL is returned for illegal
- * characters and for grouping errors such as "1,,5", ",44", "," and "".
- * Leading and trailing whitespace accepted, but not embedded whitespace.
- */
-int __bitmap_parse(const char *buf, unsigned int buflen,
-		int is_user, unsigned long *maskp,
-		int nmaskbits)
-{
-	int c, old_c, totaldigits, ndigits, nchunks, nbits;
-	u32 chunk;
-	const char __user __force *ubuf = (const char __user __force *)buf;
-
-	bitmap_zero(maskp, nmaskbits);
-
-	nchunks = nbits = totaldigits = c = 0;
-	do {
-		chunk = 0;
-		ndigits = totaldigits;
-
-		/* Get the next chunk of the bitmap */
-		while (buflen) {
-			old_c = c;
-			if (is_user) {
-				if (__get_user(c, ubuf++))
-					return -EFAULT;
-			}
-			else
-				c = *buf++;
-			buflen--;
-			if (isspace(c))
-				continue;
-
-			/*
-			 * If the last character was a space and the current
-			 * character isn't '\0', we've got embedded whitespace.
-			 * This is a no-no, so throw an error.
-			 */
-			if (totaldigits && c && isspace(old_c))
-				return -EINVAL;
-
-			/* A '\0' or a ',' signal the end of the chunk */
-			if (c == '\0' || c == ',')
-				break;
-
-			if (!isxdigit(c))
-				return -EINVAL;
-
-			/*
-			 * Make sure there are at least 4 free bits in 'chunk'.
-			 * If not, this hexdigit will overflow 'chunk', so
-			 * throw an error.
-			 */
-			if (chunk & ~((1UL << (CHUNKSZ - 4)) - 1))
-				return -EOVERFLOW;
-
-			chunk = (chunk << 4) | hex_to_bin(c);
-			totaldigits++;
-		}
-		if (ndigits == totaldigits)
-			return -EINVAL;
-		if (nchunks == 0 && chunk == 0)
-			continue;
-
-		__bitmap_shift_left(maskp, maskp, CHUNKSZ, nmaskbits);
-		*maskp |= chunk;
-		nchunks++;
-		nbits += (nchunks == 1) ? nbits_to_hold_value(chunk) : CHUNKSZ;
-		if (nbits > nmaskbits)
-			return -EOVERFLOW;
-	} while (buflen && c == ',');
-
-	return 0;
-}
-EXPORT_SYMBOL(__bitmap_parse);
-
 /**
  * bitmap_parse_user - convert an ASCII hex string in a user buffer into a bitmap
  *
@@ -542,7 +451,7 @@ int bitmap_parse_user(const char __user
 	if (IS_ERR(buf))
 		return PTR_ERR(buf);
 
-	ret = bitmap_parse(buf, ulen, maskp, nmaskbits);
+	ret = bitmap_parse(buf, UINT_MAX, maskp, nmaskbits);
 
 	kfree(buf);
 	return ret;
@@ -653,6 +562,14 @@ static const char *bitmap_find_region(co
 	return end_of_str(*str) ? NULL : str;
 }
 
+static const char *bitmap_find_region_reverse(const char *start, const char *end)
+{
+	while (start <= end && __end_of_region(*end))
+		end--;
+
+	return end;
+}
+
 static const char *bitmap_parse_region(const char *str, struct region *r)
 {
 	str = bitmap_getnum(str, &r->start);
@@ -776,6 +693,80 @@ int bitmap_parselist_user(const char __u
 }
 EXPORT_SYMBOL(bitmap_parselist_user);
 
+static const char *bitmap_get_x32_reverse(const char *start,
+					const char *end, u32 *num)
+{
+	u32 ret = 0;
+	int c, i;
+
+	for (i = 0; i < 32; i += 4) {
+		c = hex_to_bin(*end--);
+		if (c < 0)
+			return ERR_PTR(-EINVAL);
+
+		ret |= c << i;
+
+		if (start > end || __end_of_region(*end))
+			goto out;
+	}
+
+	if (hex_to_bin(*end--) >= 0)
+		return ERR_PTR(-EOVERFLOW);
+out:
+	*num = ret;
+	return end;
+}
+
+/**
+ * bitmap_parse - convert an ASCII hex string into a bitmap.
+ * @start: pointer to buffer containing string.
+ * @buflen: buffer size in bytes.  If string is smaller than this
+ *    then it must be terminated with a \0 or \n. In that case,
+ *    UINT_MAX may be provided instead of string length.
+ * @maskp: pointer to bitmap array that will contain result.
+ * @nmaskbits: size of bitmap, in bits.
+ *
+ * Commas group hex digits into chunks.  Each chunk defines exactly 32
+ * bits of the resultant bitmask.  No chunk may specify a value larger
+ * than 32 bits (%-EOVERFLOW), and if a chunk specifies a smaller value
+ * then leading 0-bits are prepended.  %-EINVAL is returned for illegal
+ * characters. Grouping such as "1,,5", ",44", "," or "" is allowed.
+ * Leading, embedded and trailing whitespace accepted.
+ */
+int bitmap_parse(const char *start, unsigned int buflen,
+		unsigned long *maskp, int nmaskbits)
+{
+	const char *end = strnchrnul(start, buflen, '\n') - 1;
+	int chunks = BITS_TO_U32(nmaskbits);
+	u32 *bitmap = (u32 *)maskp;
+	int unset_bit;
+
+	while (1) {
+		end = bitmap_find_region_reverse(start, end);
+		if (start > end)
+			break;
+
+		if (!chunks--)
+			return -EOVERFLOW;
+
+		end = bitmap_get_x32_reverse(start, end, bitmap++);
+		if (IS_ERR(end))
+			return PTR_ERR(end);
+	}
+
+	unset_bit = (BITS_TO_U32(nmaskbits) - chunks) * 32;
+	if (unset_bit < nmaskbits) {
+		bitmap_clear(maskp, unset_bit, nmaskbits - unset_bit);
+		return 0;
+	}
+
+	if (find_next_bit(maskp, unset_bit, nmaskbits) != unset_bit)
+		return -EOVERFLOW;
+
+	return 0;
+}
+EXPORT_SYMBOL(bitmap_parse);
+
 
 #ifdef CONFIG_NUMA
 /**
_

Patches currently in -mm which might be from yury.norov@gmail.com are

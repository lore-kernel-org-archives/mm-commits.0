From: akpm@linux-foundation.org
Subject: + bitmap-new-bitmap_copy_safe-and-bitmap_fromto_arr32.patch added to -mm tree
Date: Thu, 28 Dec 2017 15:22:44 -0800
Message-ID: <5a457cc4.ELfPZZFZYk6hNbPn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37016 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752029AbdL1XWr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Dec 2017 18:22:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ynorov@caviumnetworks.com, ben@decadent.org.uk, davem@davemloft.net, decot@googlers.com, geert@linux-m68k.org, linux@rasmusvillemoes.dk, mawilcox@microsoft.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bitmap: new bitmap_copy_safe and bitmap_{from,to}_arr32
has been added to the -mm tree.  Its filename is
     bitmap-new-bitmap_copy_safe-and-bitmap_fromto_arr32.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bitmap-new-bitmap_copy_safe-and-bitmap_fromto_arr32.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bitmap-new-bitmap_copy_safe-and-bitmap_fromto_arr32.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yury Norov <ynorov@caviumnetworks.com>
Subject: bitmap: new bitmap_copy_safe and bitmap_{from,to}_arr32

This patchset replaces bitmap_{to,from}_u32array with more simple and
standard looking copy-like functions.

bitmap_from_u32array() takes 4 arguments (bitmap_to_u32array is similar):
 - unsigned long *bitmap, which is destination;
 - unsigned int nbits, the length of destination bitmap, in bits;
 - const u32 *buf, the source; and
 - unsigned int nwords, the length of source buffer in ints.

In description to the function it is detailed like:
* copy min(nbits, 32*nwords) bits from @buf to @bitmap, remaining
* bits between nword and nbits in @bitmap (if any) are cleared.

Having two size arguments looks unneeded and potentially dangerous.

It is unneeded because normally user of copy-like function should
take care of the size of destination and make it big enough to fit
source data.

And it is dangerous because function may hide possible error if user
doesn't provide big enough bitmap, and data becomes silently dropped.

That's why all copy-like functions have 1 argument for size of copying
data, and I don't see any reason to make bitmap_from_u32array()
different.

One exception that comes in mind is strncpy() which also provides size
of destination in arguments, but it's strongly argued by the possibility
of taking broken strings in source. This is not the case of
bitmap_{from,to}_u32array().

There is no many real users of bitmap_{from,to}_u32array(), and they all
very clearly provide size of destination matched with the size of
source, so additional functionality is not used in fact. Like this:
bitmap_from_u32array(to->link_modes.supported,
		__ETHTOOL_LINK_MODE_MASK_NBITS,
		link_usettings.link_modes.supported,
		__ETHTOOL_LINK_MODE_MASK_NU32);
Where:
#define __ETHTOOL_LINK_MODE_MASK_NU32 \
	DIV_ROUND_UP(__ETHTOOL_LINK_MODE_MASK_NBITS, 32)

In this patch, bitmap_copy_safe and bitmap_{from,to}_arr32 are introduced.

'Safe' in bitmap_copy_safe() stands for clearing unused bits in bitmap
beyond last bit till the end of last word. It is useful for hardening
API when bitmap is assumed to be exposed to userspace.

bitmap_{from,to}_arr32 functions are replacements for
bitmap_{from,to}_u32array. They don't take unneeded nwords argument, and
so simpler in implementation and understanding.

This patch suggests optimization for 32-bit systems - aliasing
bitmap_{from,to}_arr32 to bitmap_copy_safe.

Other possible optimization is aliasing 64-bit LE bitmap_{from,to}_arr32 to
more generic function(s). But I didn't end up with the function that would
be helpful by itself, and can be used to alias 64-bit LE
bitmap_{from,to}_arr32, like bitmap_copy_safe() does. So I preferred to
leave things as is.

The following patch switches kernel to new API and introduces test for it.

Discussion is here: https://lkml.org/lkml/2017/11/15/592

Link: http://lkml.kernel.org/r/20171228150019.27953-1-ynorov@caviumnetworks.com
Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: David Decotigny <decot@googlers.com>,
Cc: David S. Miller <davem@davemloft.net>,
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |   31 +++++++++++++++++++++
 lib/bitmap.c           |   56 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 87 insertions(+)

diff -puN include/linux/bitmap.h~bitmap-new-bitmap_copy_safe-and-bitmap_fromto_arr32 include/linux/bitmap.h
--- a/include/linux/bitmap.h~bitmap-new-bitmap_copy_safe-and-bitmap_fromto_arr32
+++ a/include/linux/bitmap.h
@@ -66,6 +66,8 @@
  *  bitmap_allocate_region(bitmap, pos, order)  Allocate specified bit region
  *  bitmap_from_u32array(dst, nbits, buf, nwords)  *dst = *buf (nwords 32b words)
  *  bitmap_to_u32array(buf, nwords, src, nbits) *buf = *dst (nwords 32b words)
+ *  bitmap_from_arr32(dst, buf, nbits)          Copy nbits from u32[] buf to dst
+ *  bitmap_to_arr32(buf, src, nbits)            Copy nbits from buf to u32[] dst
  *
  */
 
@@ -228,6 +230,35 @@ static inline void bitmap_copy(unsigned
 	}
 }
 
+/*
+ * Copy bitmap and clear tail bits in last word.
+ */
+static inline void bitmap_copy_safe(unsigned long *dst,
+		const unsigned long *src, unsigned int nbits)
+{
+	bitmap_copy(dst, src, nbits);
+	if (nbits % BITS_PER_LONG)
+		dst[nbits / BITS_PER_LONG] &= BITMAP_LAST_WORD_MASK(nbits);
+}
+
+/*
+ * On 32-bit systems bitmaps are represented as u32 arrays internally, and
+ * therefore conversion is not needed when copying data from/to arrays of u32.
+ */
+#if BITS_PER_LONG == 64
+extern void bitmap_from_arr32(unsigned long *bitmap, const u32 *buf,
+							unsigned int nbits);
+extern void bitmap_to_arr32(u32 *buf, const unsigned long *bitmap,
+							unsigned int nbits);
+#else
+#define bitmap_from_arr32(bitmap, buf, nbits)		\
+	bitmap_copy_safe((unsigned long *) (bitmap),	\
+			(const unsigned long *) (buf), (nbits))
+#define bitmap_to_arr32(buf, bitmap, nbits)		\
+	bitmap_copy_safe((unsigned long *) (buf),	\
+			(const unsigned long *) (bitmap), (nbits))
+#endif
+
 static inline int bitmap_and(unsigned long *dst, const unsigned long *src1,
 			const unsigned long *src2, unsigned int nbits)
 {
diff -puN lib/bitmap.c~bitmap-new-bitmap_copy_safe-and-bitmap_fromto_arr32 lib/bitmap.c
--- a/lib/bitmap.c~bitmap-new-bitmap_copy_safe-and-bitmap_fromto_arr32
+++ a/lib/bitmap.c
@@ -1214,3 +1214,59 @@ void bitmap_copy_le(unsigned long *dst,
 }
 EXPORT_SYMBOL(bitmap_copy_le);
 #endif
+
+#if BITS_PER_LONG == 64
+/**
+ * bitmap_from_arr32 - copy the contents of u32 array of bits to bitmap
+ *	@bitmap: array of unsigned longs, the destination bitmap
+ *	@buf: array of u32 (in host byte order), the source bitmap
+ *	@nbits: number of bits in @bitmap
+ */
+void bitmap_from_arr32(unsigned long *bitmap, const u32 *buf,
+						unsigned int nbits)
+{
+	unsigned int i, halfwords;
+
+	if (!nbits)
+		return;
+
+	halfwords = DIV_ROUND_UP(nbits, 32);
+	for (i = 0; i < halfwords; i++) {
+		bitmap[i/2] = (unsigned long) buf[i];
+		if (++i < halfwords)
+			bitmap[i/2] |= ((unsigned long) buf[i]) << 32;
+	}
+
+	/* Clear tail bits in last word beyond nbits. */
+	if (nbits % BITS_PER_LONG)
+		bitmap[(halfwords - 1) / 2] &= BITMAP_LAST_WORD_MASK(nbits);
+}
+EXPORT_SYMBOL(bitmap_from_arr32);
+
+/**
+ * bitmap_to_arr32 - copy the contents of bitmap to a u32 array of bits
+ *	@buf: array of u32 (in host byte order), the dest bitmap
+ *	@bitmap: array of unsigned longs, the source bitmap
+ *	@nbits: number of bits in @bitmap
+ */
+void bitmap_to_arr32(u32 *buf, const unsigned long *bitmap, unsigned int nbits)
+{
+	unsigned int i, halfwords;
+
+	if (!nbits)
+		return;
+
+	halfwords = DIV_ROUND_UP(nbits, 32);
+	for (i = 0; i < halfwords; i++) {
+		buf[i] = (u32) (bitmap[i/2] & UINT_MAX);
+		if (++i < halfwords)
+			buf[i] = (u32) (bitmap[i/2] >> 32);
+	}
+
+	/* Clear tail bits in last element of array beyond nbits. */
+	if (nbits % BITS_PER_LONG)
+		buf[halfwords - 1] &= (u32) (UINT_MAX >> ((-nbits) & 31));
+}
+EXPORT_SYMBOL(bitmap_to_arr32);
+
+#endif
_

Patches currently in -mm which might be from ynorov@caviumnetworks.com are

bitmap-new-bitmap_copy_safe-and-bitmap_fromto_arr32.patch
bitmap-replace-bitmap_fromto_u32array.patch
lib-test_find_bitc-rename-to-find_bit_benchmarkc.patch
lib-find_bit_benchmarkc-improvements.patch


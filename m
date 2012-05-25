From: akpm@linux-foundation.org
Subject: [withdrawn] bitmap_weight-optimize-for-large-bitmaps.patch removed from -mm tree
Date: Fri, 25 May 2012 15:59:30 -0700
Message-ID: <20120525225931.09775A0210@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:56234 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932334Ab2EYW7d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 May 2012 18:59:33 -0400
Received: by eaao13 with SMTP id o13so74472eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 25 May 2012 15:59:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bitmap_weight(): optimize for large bitmaps
has been removed from the -mm tree.  Its filename was
     bitmap_weight-optimize-for-large-bitmaps.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: bitmap_weight(): optimize for large bitmaps

The current implementation of bitmap_weight() simply evaluates the
population count for each long word of the array, and adds.

The subsection "Counting 1-bits in an Array" in the revisions of the book
'Hacker's Delight' explains more superior methods than the naive method.

http://www.hackersdelight.org/revisions.pdf
http://www.hackersdelight.org/HDcode/newCode/pop_arrayHS.c.txt

My benchmark results on Intel Core i3 CPU with 32-bit kernel showed 50%
faster for 8192 bits bitmap.  However, it is not faster for small bitmap
(< BITS_PER_LONG * 8) than the naive method.  So if the bitmap size is
known to be small at compile time, use the naive method.

/*
 * userspace bitmap_weight() benchmark program
 */
extern int __bitmap_weight(const unsigned long *bitmap, int bits);
extern int __bitmap_weight_fast(const unsigned long *bitmap, int bits);

int main(int argc, char **argv)
{
	int i;
	struct timeval start[2], stop[2], diff[2];
	unsigned int bits;
	unsigned long bitmap[1024 * 1024];
	int n, m;
	int iterations;

	if (argc != 4) {
		fprintf(stderr, "Usage: %s SEED BITS ITERATIONS\n", argv[0]);
		return -1;
	}

	srand(atoi(argv[1]));
	bits = atoi(argv[2]) % (sizeof(bitmap) * 8);
	iterations = atoi(argv[3]);

	for (i = 0; i < sizeof(bitmap); i++)
		((unsigned char *)bitmap)[i] = rand();

	/* dummy call */
	gettimeofday(&start[0], NULL);
	n = __bitmap_weight(bitmap, bits);
	gettimeofday(&stop[0], NULL);
	gettimeofday(&start[1], NULL);
	m = __bitmap_weight_fast(bitmap, bits);
	gettimeofday(&stop[1], NULL);

	if (n != m) {
		fprintf(stderr, "Oops %d != %d (%d)\n", n, m, atoi(argv[1]));
		return -1;
	}

	gettimeofday(&start[0], NULL);
	for (i = 0; i < iterations; i++)
		n += __bitmap_weight(bitmap, bits);
	gettimeofday(&stop[0], NULL);

	gettimeofday(&start[1], NULL);
	for (i = 0; i < iterations; i++)
		m += __bitmap_weight_fast(bitmap, bits);
	gettimeofday(&stop[1], NULL);

	if (n != m)
		return -1;

	timersub(&stop[0], &start[0], &diff[0]);
	timersub(&stop[1], &start[1], &diff[1]);
	printf("%d %d: %lu.%06lu %lu.%06lu\n", bits, iterations,
		diff[0].tv_sec, diff[0].tv_usec,
		diff[1].tv_sec, diff[1].tv_usec);

	return 0;
}


Which callsites are running btimap_weight() against large bitmaps?

- Some filesystems (udf, omfs, ntfs, and hpfs) use bitmap_weight() to
  the block size bytes region in statfs() path.

- num_online_cpus() and the variants are bitmap_weight() to the NR_CPUS
  bitmap and num_online_nodes() and the variants are to the MAX_NUMNODES
  bitmap.  So these bitmaps could be large on extremely large system.

- bm_count_bits() in drivers/block/drbd/drbd_bitmap.c computes the
  population count for multiple pages.  But it is currently open-coded
  loops with hweight_long() which can be converted to bitmap_weight().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    5 +++
 lib/bitmap.c           |   49 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 1 deletion(-)

diff -puN include/linux/bitmap.h~bitmap_weight-optimize-for-large-bitmaps include/linux/bitmap.h
--- a/include/linux/bitmap.h~bitmap_weight-optimize-for-large-bitmaps
+++ a/include/linux/bitmap.h
@@ -111,6 +111,7 @@ extern int __bitmap_intersects(const uns
 extern int __bitmap_subset(const unsigned long *bitmap1,
 			const unsigned long *bitmap2, int bits);
 extern int __bitmap_weight(const unsigned long *bitmap, int bits);
+extern int __bitmap_weight_fast(const unsigned long *bitmap, int bits);
 
 extern void bitmap_set(unsigned long *map, int i, int len);
 extern void bitmap_clear(unsigned long *map, int start, int nr);
@@ -277,7 +278,9 @@ static inline int bitmap_weight(const un
 {
 	if (small_const_nbits(nbits))
 		return hweight_long(*src & BITMAP_LAST_WORD_MASK(nbits));
-	return __bitmap_weight(src, nbits);
+	else if (__builtin_constant_p(nbits) && (nbits) < BITS_PER_LONG * 8)
+		return __bitmap_weight(src, nbits);
+	return __bitmap_weight_fast(src, nbits);
 }
 
 static inline void bitmap_shift_right(unsigned long *dst,
diff -puN lib/bitmap.c~bitmap_weight-optimize-for-large-bitmaps lib/bitmap.c
--- a/lib/bitmap.c~bitmap_weight-optimize-for-large-bitmaps
+++ a/lib/bitmap.c
@@ -273,6 +273,55 @@ int __bitmap_weight(const unsigned long 
 }
 EXPORT_SYMBOL(__bitmap_weight);
 
+#define CSA(h, l, a, b, c) \
+	{ \
+		unsigned long u = a ^ b; \
+		unsigned long v = c; \
+		h = (a & b) | (u & v); \
+		l = u ^ v; \
+	} while (0)
+
+/**
+ * __bitmap_weight_fast - count the set bits in a bitmap
+ * @bitmap: pointer to bitmap
+ * @bits: bitmap size, in bits
+ *
+ * This implementation is based on the algorithm from the subsection
+ * "Counting 1-bits in an Array" in the revisions of the book
+ * 'Hacker's Delight'.
+ *
+ * http://www.hackersdelight.org/revisions.pdf
+ * http://www.hackersdelight.org/HDcode/newCode/pop_arrayHS.c.txt
+ */
+int __bitmap_weight_fast(const unsigned long *bitmap, int bits)
+{
+	int k, w = 0, lim = bits / BITS_PER_LONG;
+	unsigned long ones, twos, twosA, twosB, fours, foursA, foursB, eights;
+	fours = twos = ones = 0;
+
+	for (k = 0; k < lim - 7; k += 8) {
+		CSA(twosA, ones, ones, bitmap[k], bitmap[k + 1]);
+		CSA(twosB, ones, ones, bitmap[k + 2], bitmap[k + 3]);
+		CSA(foursA, twos, twos, twosA, twosB);
+		CSA(twosA, ones, ones, bitmap[k + 4], bitmap[k + 5]);
+		CSA(twosB, ones, ones, bitmap[k + 6], bitmap[k + 7]);
+		CSA(foursB, twos, twos, twosA, twosB);
+		CSA(eights, fours, fours, foursA, foursB);
+		w += hweight_long(eights);
+	}
+	w = 8 * w + 4 * hweight_long(fours) + 2 * hweight_long(twos) +
+		hweight_long(ones);
+
+	for (; k < lim; k++)
+		w += hweight_long(bitmap[k]);
+
+	if (bits % BITS_PER_LONG)
+		w += hweight_long(bitmap[k] & BITMAP_LAST_WORD_MASK(bits));
+
+	return w;
+}
+EXPORT_SYMBOL(__bitmap_weight_fast);
+
 void bitmap_set(unsigned long *map, int start, int nr)
 {
 	unsigned long *p = map + BIT_WORD(start);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
ocfs2-use-find_last_bit.patch
ocfs2-use-bitmap_weight.patch


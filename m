From: akpm@linux-foundation.org
Subject: + bitmap-test-for-constant-as-well-as-small-size-for-inline-versions.patch added to -mm tree
Date: Sat, 15 Nov 2008 14:46:50 -0800
Message-ID: <200811152246.mAFMko1W000962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751319AbYKOWrT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 15 Nov 2008 17:47:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, mingo@elte.hu, travis@sgi.com


The patch titled
     bitmap: test for constant as well as small size for inline versions
has been added to the -mm tree.  Its filename is
     bitmap-test-for-constant-as-well-as-small-size-for-inline-versions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bitmap: test for constant as well as small size for inline versions
From: Rusty Russell <rusty@rustcorp.com.au>

bitmap_zero et al have a fastpath for nbits <= BITS_PER_LONG, but this
should really only apply where the nbits is known at compile time.

This only saves about 1200 bytes on an allyesconfig kernel, but with
cpumasks going variable that number will increase.

   text		data	bss	dec		hex	filename
35327852        5035607 6782976 47146435        2cf65c3 vmlinux-before
35326640        5035607 6782976 47145223        2cf6107 vmlinux-after

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |   35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff -puN include/linux/bitmap.h~bitmap-test-for-constant-as-well-as-small-size-for-inline-versions include/linux/bitmap.h
--- a/include/linux/bitmap.h~bitmap-test-for-constant-as-well-as-small-size-for-inline-versions
+++ a/include/linux/bitmap.h
@@ -137,9 +137,12 @@ extern void bitmap_copy_le(void *dst, co
 		(1UL<<((nbits) % BITS_PER_LONG))-1 : ~0UL		\
 )
 
+#define small_const_nbits(nbits) \
+	(__builtin_constant_p(nbits) && (nbits) <= BITS_PER_LONG)
+
 static inline void bitmap_zero(unsigned long *dst, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		*dst = 0UL;
 	else {
 		int len = BITS_TO_LONGS(nbits) * sizeof(unsigned long);
@@ -150,7 +153,7 @@ static inline void bitmap_zero(unsigned 
 static inline void bitmap_fill(unsigned long *dst, int nbits)
 {
 	size_t nlongs = BITS_TO_LONGS(nbits);
-	if (nlongs > 1) {
+	if (!small_const_nbits(nbits)) {
 		int len = (nlongs - 1) * sizeof(unsigned long);
 		memset(dst, 0xff,  len);
 	}
@@ -160,7 +163,7 @@ static inline void bitmap_fill(unsigned 
 static inline void bitmap_copy(unsigned long *dst, const unsigned long *src,
 			int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		*dst = *src;
 	else {
 		int len = BITS_TO_LONGS(nbits) * sizeof(unsigned long);
@@ -171,7 +174,7 @@ static inline void bitmap_copy(unsigned 
 static inline void bitmap_and(unsigned long *dst, const unsigned long *src1,
 			const unsigned long *src2, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		*dst = *src1 & *src2;
 	else
 		__bitmap_and(dst, src1, src2, nbits);
@@ -180,7 +183,7 @@ static inline void bitmap_and(unsigned l
 static inline void bitmap_or(unsigned long *dst, const unsigned long *src1,
 			const unsigned long *src2, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		*dst = *src1 | *src2;
 	else
 		__bitmap_or(dst, src1, src2, nbits);
@@ -189,7 +192,7 @@ static inline void bitmap_or(unsigned lo
 static inline void bitmap_xor(unsigned long *dst, const unsigned long *src1,
 			const unsigned long *src2, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		*dst = *src1 ^ *src2;
 	else
 		__bitmap_xor(dst, src1, src2, nbits);
@@ -198,7 +201,7 @@ static inline void bitmap_xor(unsigned l
 static inline void bitmap_andnot(unsigned long *dst, const unsigned long *src1,
 			const unsigned long *src2, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		*dst = *src1 & ~(*src2);
 	else
 		__bitmap_andnot(dst, src1, src2, nbits);
@@ -207,7 +210,7 @@ static inline void bitmap_andnot(unsigne
 static inline void bitmap_complement(unsigned long *dst, const unsigned long *src,
 			int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		*dst = ~(*src) & BITMAP_LAST_WORD_MASK(nbits);
 	else
 		__bitmap_complement(dst, src, nbits);
@@ -216,7 +219,7 @@ static inline void bitmap_complement(uns
 static inline int bitmap_equal(const unsigned long *src1,
 			const unsigned long *src2, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		return ! ((*src1 ^ *src2) & BITMAP_LAST_WORD_MASK(nbits));
 	else
 		return __bitmap_equal(src1, src2, nbits);
@@ -225,7 +228,7 @@ static inline int bitmap_equal(const uns
 static inline int bitmap_intersects(const unsigned long *src1,
 			const unsigned long *src2, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		return ((*src1 & *src2) & BITMAP_LAST_WORD_MASK(nbits)) != 0;
 	else
 		return __bitmap_intersects(src1, src2, nbits);
@@ -234,7 +237,7 @@ static inline int bitmap_intersects(cons
 static inline int bitmap_subset(const unsigned long *src1,
 			const unsigned long *src2, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		return ! ((*src1 & ~(*src2)) & BITMAP_LAST_WORD_MASK(nbits));
 	else
 		return __bitmap_subset(src1, src2, nbits);
@@ -242,7 +245,7 @@ static inline int bitmap_subset(const un
 
 static inline int bitmap_empty(const unsigned long *src, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		return ! (*src & BITMAP_LAST_WORD_MASK(nbits));
 	else
 		return __bitmap_empty(src, nbits);
@@ -250,7 +253,7 @@ static inline int bitmap_empty(const uns
 
 static inline int bitmap_full(const unsigned long *src, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		return ! (~(*src) & BITMAP_LAST_WORD_MASK(nbits));
 	else
 		return __bitmap_full(src, nbits);
@@ -258,7 +261,7 @@ static inline int bitmap_full(const unsi
 
 static inline int bitmap_weight(const unsigned long *src, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		return hweight_long(*src & BITMAP_LAST_WORD_MASK(nbits));
 	return __bitmap_weight(src, nbits);
 }
@@ -266,7 +269,7 @@ static inline int bitmap_weight(const un
 static inline void bitmap_shift_right(unsigned long *dst,
 			const unsigned long *src, int n, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		*dst = *src >> n;
 	else
 		__bitmap_shift_right(dst, src, n, nbits);
@@ -275,7 +278,7 @@ static inline void bitmap_shift_right(un
 static inline void bitmap_shift_left(unsigned long *dst,
 			const unsigned long *src, int n, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		*dst = (*src << n) & BITMAP_LAST_WORD_MASK(nbits);
 	else
 		__bitmap_shift_left(dst, src, n, nbits);
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
linux-next.patch
alpha-use-generic-percpu-support.patch
bitmap-test-for-constant-as-well-as-small-size-for-inline-versions.patch
module-add-within_module_core-and-within_module_init.patch
module-add-module_state_live-notify.patch
kmod-fix-varargs-kernel-doc.patch
docs-document-how-to-write-varargs-in-kernel-doc.patch
reiser4.patch


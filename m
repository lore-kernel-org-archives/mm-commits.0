From: akpm@linux-foundation.org
Subject: + bitmap-make-bitmap_fill-and-bitmap_zero-consistent.patch added
 to -mm tree
Date: Tue, 09 Jan 2018 15:25:22 -0800
Message-ID: <5a554f62.NHqO1KNAqZyFnAAY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58506 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753895AbeAIXZX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jan 2018 18:25:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, rdunlap@infradead.org, ynorov@caviumnetworks.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/bitmap.h: make bitmap_fill() and bitmap_zero() consistent
has been added to the -mm tree.  Its filename is
     bitmap-make-bitmap_fill-and-bitmap_zero-consistent.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bitmap-make-bitmap_fill-and-bitmap_zero-consistent.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bitmap-make-bitmap_fill-and-bitmap_zero-consistent.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: include/linux/bitmap.h: make bitmap_fill() and bitmap_zero() consistent

Behaviour of bitmap_fill() differs from bitmap_zero() in a way how bits
behind bitmap are handed.  bitmap_zero() clears entire bitmap by unsigned
long boundary, while bitmap_fill() mimics bitmap_set().

Here we change bitmap_fill() behaviour to be consistent with bitmap_zero()
and add a note to documentation.

The change might reveal some bugs in the code where unused bits are
handled differently and in such cases bitmap_set() has to be used.

Link: http://lkml.kernel.org/r/20180109172430.87452-4-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yury Norov <ynorov@caviumnetworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN include/linux/bitmap.h~bitmap-make-bitmap_fill-and-bitmap_zero-consistent include/linux/bitmap.h
--- a/include/linux/bitmap.h~bitmap-make-bitmap_fill-and-bitmap_zero-consistent
+++ a/include/linux/bitmap.h
@@ -67,6 +67,11 @@
  *  bitmap_from_arr32(dst, buf, nbits)          Copy nbits from u32[] buf to dst
  *  bitmap_to_arr32(buf, src, nbits)            Copy nbits from buf to u32[] dst
  *
+ * Note, bitmap_zero() and bitmap_fill() operate over the region of
+ * unsigned longs, that is, bits behind bitmap till the unsigned long
+ * boundary will be zeroed or filled as well. Consider to use
+ * bitmap_clear() or bitmap_set() to make explicit zeroing or filling
+ * respectively.
  */
 
 /**
@@ -202,12 +207,12 @@ static inline void bitmap_zero(unsigned
 
 static inline void bitmap_fill(unsigned long *dst, unsigned int nbits)
 {
-	unsigned int nlongs = BITS_TO_LONGS(nbits);
-	if (!small_const_nbits(nbits)) {
-		unsigned int len = (nlongs - 1) * sizeof(unsigned long);
-		memset(dst, 0xff,  len);
+	if (small_const_nbits(nbits))
+		*dst = ~0UL;
+	else {
+		unsigned int len = BITS_TO_LONGS(nbits) * sizeof(unsigned long);
+		memset(dst, 0xff, len);
 	}
-	dst[nlongs - 1] = BITMAP_LAST_WORD_MASK(nbits);
 }
 
 static inline void bitmap_copy(unsigned long *dst, const unsigned long *src,
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

scripts-decodecode-make-it-take-multiline-code-line.patch
bitmap-add-bitmap_zero-bitmap_clear-test-cases.patch
bitmap-add-bitmap_fill-bitmap_set-test-cases.patch
bitmap-clean-up-test_zero_fill_copy-test-case-and-rename.patch
bitmap-make-bitmap_fill-and-bitmap_zero-consistent.patch


From: akpm@linux-foundation.org
Subject: + tools-add-more-bitmap-functions.patch added to -mm tree
Date: Tue, 06 Dec 2016 12:50:31 -0800
Message-ID: <58472497.8zgvGAMOYMxQrEJY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36926 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751905AbcLFUuB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Dec 2016 15:50:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools: add more bitmap functions
has been added to the -mm tree.  Its filename is
     tools-add-more-bitmap-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tools-add-more-bitmap-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tools-add-more-bitmap-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: tools: add more bitmap functions

I need the following functions for the radix tree:

bitmap_fill
bitmap_empty
bitmap_full

Copy the implementations from include/linux/bitmap.h

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/include/linux/bitmap.h |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff -puN tools/include/linux/bitmap.h~tools-add-more-bitmap-functions tools/include/linux/bitmap.h
--- a/tools/include/linux/bitmap.h~tools-add-more-bitmap-functions
+++ a/tools/include/linux/bitmap.h
@@ -35,6 +35,32 @@ static inline void bitmap_zero(unsigned
 	}
 }
 
+static inline void bitmap_fill(unsigned long *dst, unsigned int nbits)
+{
+	unsigned int nlongs = BITS_TO_LONGS(nbits);
+	if (!small_const_nbits(nbits)) {
+		unsigned int len = (nlongs - 1) * sizeof(unsigned long);
+		memset(dst, 0xff,  len);
+	}
+	dst[nlongs - 1] = BITMAP_LAST_WORD_MASK(nbits);
+}
+
+static inline int bitmap_empty(const unsigned long *src, unsigned nbits)
+{
+	if (small_const_nbits(nbits))
+		return ! (*src & BITMAP_LAST_WORD_MASK(nbits));
+
+	return find_first_bit(src, nbits) == nbits;
+}
+
+static inline int bitmap_full(const unsigned long *src, unsigned int nbits)
+{
+	if (small_const_nbits(nbits))
+		return ! (~(*src) & BITMAP_LAST_WORD_MASK(nbits));
+
+	return find_first_zero_bit(src, nbits) == nbits;
+}
+
 static inline int bitmap_weight(const unsigned long *src, int nbits)
 {
 	if (small_const_nbits(nbits))
_

Patches currently in -mm which might be from willy@linux.intel.com are

tools-add-warn_on_once.patch
radix-tree-test-suite-allow-gfp_atomic-allocations-to-fail.patch
tools-add-more-bitmap-functions.patch
radix-tree-test-suite-use-common-find-bit-code.patch
radix-tree-fix-typo.patch
radix-tree-create-node_tag_set.patch
radix-tree-make-radix_tree_find_next_bit-more-useful.patch
radix-tree-add-radix_tree_join.patch
radix-tree-add-radix_tree_split.patch
radix-tree-add-radix_tree_split_preload.patch
idr-add-ida_is_empty.patch
idr-reduce-the-number-of-bits-per-level-from-8-to-6.patch
radix-tree-test-suite-add-some-more-functionality.patch
reimplement-idr-and-ida-using-the-radix-tree.patch


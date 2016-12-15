From: akpm@linux-foundation.org
Subject: [merged] tools-add-more-bitmap-functions.patch removed from -mm
 tree
Date: Thu, 15 Dec 2016 10:48:28 -0800
Message-ID: <5852e57c.D7jaE9BMJHZhh88b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49184 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932852AbcLOSs3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:48:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools: add more bitmap functions
has been removed from the -mm tree.  Its filename was
     tools-add-more-bitmap-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Matthew Wilcox <mawilcox@microsoft.com>
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

reimplement-idr-and-ida-using-the-radix-tree.patch


From: akpm@linux-foundation.org
Subject: [merged] lib-bitmap-add-missing-mask-in-bitmap_shift_right.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:08:33 -0700
Message-ID: <53e3dcc1.+qFpABzT3jtafe1E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f201.google.com ([209.85.223.201]:41037 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbaHGUIe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:08:34 -0400
Received: by mail-ie0-f201.google.com with SMTP id tr6so842226ieb.4
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:08:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: add missing mask in bitmap_shift_right
has been removed from the -mm tree.  Its filename was
     lib-bitmap-add-missing-mask-in-bitmap_shift_right.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib: bitmap: add missing mask in bitmap_shift_right

There is no guarantee that *src does not contain garbage bits outside the
lower nbits, so we need to mask it before the shift-and-assign.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/bitmap.h~lib-bitmap-add-missing-mask-in-bitmap_shift_right include/linux/bitmap.h
--- a/include/linux/bitmap.h~lib-bitmap-add-missing-mask-in-bitmap_shift_right
+++ a/include/linux/bitmap.h
@@ -284,7 +284,7 @@ static inline void bitmap_shift_right(un
 			const unsigned long *src, int n, int nbits)
 {
 	if (small_const_nbits(nbits))
-		*dst = *src >> n;
+		*dst = (*src & BITMAP_LAST_WORD_MASK(nbits)) >> n;
 	else
 		__bitmap_shift_right(dst, src, n, nbits);
 }
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch


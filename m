From: akpm@linux-foundation.org
Subject: [merged]
 lib-bitmap-eliminate-branch-in-__bitmap_shift_right.patch removed from -mm
 tree
Date: Mon, 16 Feb 2015 12:15:21 -0800
Message-ID: <54e24fd9.UwF/NtV38uEXHFsB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50805 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbbBPUP5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:15:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: eliminate branch in __bitmap_shift_right
has been removed from the -mm tree.  Its filename was
     lib-bitmap-eliminate-branch-in-__bitmap_shift_right.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib: bitmap: eliminate branch in __bitmap_shift_right

We can shift the bits from lower and upper into place before assembling
dst[k]; moving the shift of upper into the branch where we already know
that rem is non-zero allows us to remove a conditional.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/bitmap.c~lib-bitmap-eliminate-branch-in-__bitmap_shift_right lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-eliminate-branch-in-__bitmap_shift_right
+++ a/lib/bitmap.c
@@ -129,13 +129,13 @@ void __bitmap_shift_right(unsigned long
 			upper = src[off + k + 1];
 			if (off + k + 1 == lim - 1 && left)
 				upper &= mask;
+			upper <<= (BITS_PER_LONG - rem);
 		}
 		lower = src[off + k];
 		if (left && off + k == lim - 1)
 			lower &= mask;
-		dst[k] = lower >> rem;
-		if (rem)
-			dst[k] |= upper << (BITS_PER_LONG - rem);
+		lower >>= rem;
+		dst[k] = lower | upper;
 		if (left && k == lim - 1)
 			dst[k] &= mask;
 	}
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch


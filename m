From: akpm@linux-foundation.org
Subject: [merged]
 lib-bitmap-remove-redundant-code-from-__bitmap_shift_right.patch removed
 from -mm tree
Date: Mon, 16 Feb 2015 12:15:23 -0800
Message-ID: <54e24fdb./zToHSa48+WWtWvP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50807 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbbBPUP7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:15:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: remove redundant code from __bitmap_shift_right
has been removed from the -mm tree.  Its filename was
     lib-bitmap-remove-redundant-code-from-__bitmap_shift_right.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib: bitmap: remove redundant code from __bitmap_shift_right

If the condition k==lim-1 is true, we must have off == 0 (otherwise, k
could never become that big).  But in that case we have upper == 0 and
hence dst[k] == (src[k] & mask) >> rem.  Since mask consists of a
consecutive range of bits starting from the LSB, anding dst[k] with mask
is a no-op.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN lib/bitmap.c~lib-bitmap-remove-redundant-code-from-__bitmap_shift_right lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-remove-redundant-code-from-__bitmap_shift_right
+++ a/lib/bitmap.c
@@ -136,8 +136,6 @@ void __bitmap_shift_right(unsigned long
 			lower &= mask;
 		lower >>= rem;
 		dst[k] = lower | upper;
-		if (left && k == lim - 1)
-			dst[k] &= mask;
 	}
 	if (off)
 		memset(&dst[lim - off], 0, off*sizeof(unsigned long));
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch


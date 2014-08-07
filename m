From: akpm@linux-foundation.org
Subject: [merged] lib-bitmap-micro-optimize-bitmap_allocate_region.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:08:31 -0700
Message-ID: <53e3dcbf.jSAvpAL/uq16S0kn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f74.google.com ([209.85.192.74]:56635 "EHLO
	mail-qg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417AbaHGUIc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:08:32 -0400
Received: by mail-qg0-f74.google.com with SMTP id z60so611293qgd.1
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:08:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: micro-optimize bitmap_allocate_region
has been removed from the -mm tree.  Its filename was
     lib-bitmap-micro-optimize-bitmap_allocate_region.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib: bitmap: micro-optimize bitmap_allocate_region

__reg_op(..., REG_OP_ALLOC) always returns 0, so we might as well use that
and save an instruction.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN lib/bitmap.c~lib-bitmap-micro-optimize-bitmap_allocate_region lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-micro-optimize-bitmap_allocate_region
+++ a/lib/bitmap.c
@@ -1154,8 +1154,7 @@ int bitmap_allocate_region(unsigned long
 {
 	if (!__reg_op(bitmap, pos, order, REG_OP_ISFREE))
 		return -EBUSY;
-	__reg_op(bitmap, pos, order, REG_OP_ALLOC);
-	return 0;
+	return __reg_op(bitmap, pos, order, REG_OP_ALLOC);
 }
 EXPORT_SYMBOL(bitmap_allocate_region);
 
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch


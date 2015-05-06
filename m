From: akpm@linux-foundation.org
Subject: [merged] lib-delete-lib-find_last_bitc.patch removed from -mm
 tree
Date: Wed, 06 May 2015 11:58:11 -0700
Message-ID: <554a6443.g0cZpL8LAbTh4fM0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51843 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbbEFS6L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 May 2015 14:58:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yury.norov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: delete lib/find_last_bit.c
has been removed from the -mm tree.  Its filename was
     lib-delete-lib-find_last_bitc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: lib: delete lib/find_last_bit.c

File find_next_bit.c was deleted in patch "lib: move find_last_bit to
lib/find_next_bit.c" from Feb, 22, but not in master (commit 8f6f19dd51). 
This is just a fix for wrong merge.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/find_last_bit.c |   41 -----------------------------------------
 1 file changed, 41 deletions(-)

diff -puN lib/find_last_bit.c~lib-delete-lib-find_last_bitc /dev/null
--- a/lib/find_last_bit.c
+++ /dev/null
@@ -1,41 +0,0 @@
-/* find_last_bit.c: fallback find next bit implementation
- *
- * Copyright (C) 2008 IBM Corporation
- * Written by Rusty Russell <rusty@rustcorp.com.au>
- * (Inspired by David Howell's find_next_bit implementation)
- *
- * Rewritten by Yury Norov <yury.norov@gmail.com> to decrease
- * size and improve performance, 2015.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#include <linux/bitops.h>
-#include <linux/bitmap.h>
-#include <linux/export.h>
-#include <linux/kernel.h>
-
-#ifndef find_last_bit
-
-unsigned long find_last_bit(const unsigned long *addr, unsigned long size)
-{
-	if (size) {
-		unsigned long val = BITMAP_LAST_WORD_MASK(size);
-		unsigned long idx = (size-1) / BITS_PER_LONG;
-
-		do {
-			val &= addr[idx];
-			if (val)
-				return idx * BITS_PER_LONG + __fls(val);
-
-			val = ~0ul;
-		} while (idx--);
-	}
-	return size;
-}
-EXPORT_SYMBOL(find_last_bit);

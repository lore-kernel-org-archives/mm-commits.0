From: akpm@linux-foundation.org
Subject: [merged] lib-dynamic_queue_limitsc-simplify-includes.patch
 removed from -mm tree
Date: Fri, 13 Feb 2015 12:22:46 -0800
Message-ID: <54de5d16.3PGLRR3VClExA5Bh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49138 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587AbbBMUWr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:22:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/dynamic_queue_limits.c: simplify includes
has been removed from the -mm tree.  Its filename was
     lib-dynamic_queue_limitsc-simplify-includes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/dynamic_queue_limits.c: simplify includes

The file doesn't use anything from ctype.h.  Instead of module.h, just use
export.h for EXPORT_SYMBOL.  The latter requires the user to include
compiler.h, so do that explicitly instead of relying on some other header
pulling it in.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dynamic_queue_limits.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/dynamic_queue_limits.c~lib-dynamic_queue_limitsc-simplify-includes lib/dynamic_queue_limits.c
--- a/lib/dynamic_queue_limits.c~lib-dynamic_queue_limitsc-simplify-includes
+++ a/lib/dynamic_queue_limits.c
@@ -3,12 +3,12 @@
  *
  * Copyright (c) 2011, Tom Herbert <therbert@google.com>
  */
-#include <linux/module.h>
 #include <linux/types.h>
-#include <linux/ctype.h>
 #include <linux/kernel.h>
 #include <linux/jiffies.h>
 #include <linux/dynamic_queue_limits.h>
+#include <linux/compiler.h>
+#include <linux/export.h>
 
 #define POSDIFF(A, B) ((int)((A) - (B)) > 0 ? (A) - (B) : 0)
 #define AFTER_EQ(A, B) ((int)((A) - (B)) >= 0)
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
lib-bitmapc-change-prototype-of-bitmap_copy_le.patch
lib-bitmapc-elide-bitmap_copy_le-on-little-endian.patch
lib-bitmap-change-bitmap_shift_right-to-take-unsigned-parameters.patch
lib-bitmap-eliminate-branch-in-__bitmap_shift_right.patch
lib-bitmap-remove-redundant-code-from-__bitmap_shift_right.patch
lib-bitmap-yet-another-simplification-in-__bitmap_shift_right.patch
lib-bitmap-change-bitmap_shift_left-to-take-unsigned-parameters.patch
lib-bitmap-eliminate-branch-in-__bitmap_shift_left.patch
lib-bitmap-remove-redundant-code-from-__bitmap_shift_left.patch
lib-stringc-improve-strrchr.patch
checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch
linux-next.patch


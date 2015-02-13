From: akpm@linux-foundation.org
Subject: [merged] lib-radix-treec-change-to-simpler-include.patch removed
 from -mm tree
Date: Fri, 13 Feb 2015 12:23:06 -0800
Message-ID: <54de5d2a.ZlOA5/YgRKgvO8pr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49159 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbbBMUXH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:23:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/radix-tree.c: change to simpler include
has been removed from the -mm tree.  Its filename was
     lib-radix-treec-change-to-simpler-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/radix-tree.c: change to simpler include

The comment helpfully explains why hardirq.h is included, but since
2d4b84739f0a ("hardirq: Split preempt count mask definitions")
in_interrupt() has been provided by preempt_mask.h.  Use that instead,
saving around 40 lines in the generated dependency file.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/radix-tree.c~lib-radix-treec-change-to-simpler-include lib/radix-tree.c
--- a/lib/radix-tree.c~lib-radix-treec-change-to-simpler-include
+++ a/lib/radix-tree.c
@@ -33,7 +33,7 @@
 #include <linux/string.h>
 #include <linux/bitops.h>
 #include <linux/rcupdate.h>
-#include <linux/hardirq.h>		/* in_interrupt() */
+#include <linux/preempt_mask.h>		/* in_interrupt() */
 
 
 /*
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


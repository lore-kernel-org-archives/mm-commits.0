From: akpm@linux-foundation.org
Subject: [merged] lib-interval_treec-simplify-includes.patch removed from
 -mm tree
Date: Fri, 13 Feb 2015 12:22:42 -0800
Message-ID: <54de5d12.VNcD6KYRtPoe4vuF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49133 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbbBMUWn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:22:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/interval_tree.c: simplify includes
has been removed from the -mm tree.  Its filename was
     lib-interval_treec-simplify-includes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/interval_tree.c: simplify includes

The file uses nothing from init.h, and also doesn't need the full module.h
machinery; export.h is sufficient.  The latter requires the user to ensure
compiler.h is included, so do that explicitly instead of relying on some
other header pulling it in.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/interval_tree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/interval_tree.c~lib-interval_treec-simplify-includes lib/interval_tree.c
--- a/lib/interval_tree.c~lib-interval_treec-simplify-includes
+++ a/lib/interval_tree.c
@@ -1,7 +1,7 @@
-#include <linux/init.h>
 #include <linux/interval_tree.h>
 #include <linux/interval_tree_generic.h>
-#include <linux/module.h>
+#include <linux/compiler.h>
+#include <linux/export.h>
 
 #define START(node) ((node)->start)
 #define LAST(node)  ((node)->last)
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


From: akpm@linux-foundation.org
Subject: [merged] lib-sortc-use-simpler-includes.patch removed from -mm
 tree
Date: Fri, 13 Feb 2015 12:22:44 -0800
Message-ID: <54de5d14.BZEBJyNnUzm/TxIS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49136 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbbBMUWp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:22:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/sort.c: use simpler includes
has been removed from the -mm tree.  Its filename was
     lib-sortc-use-simpler-includes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/sort.c: use simpler includes

sort.c doesn't use facilities from kernel.h, but does use some types
defined in linux/types.h.  Include the latter directly instead of relying
on some other header doing it.  Similarly, include linux/export.h directly
instead of through module.h.  This removes 80 lines from the dependency
file .sort.o.cmd.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/sort.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/sort.c~lib-sortc-use-simpler-includes lib/sort.c
--- a/lib/sort.c~lib-sortc-use-simpler-includes
+++ a/lib/sort.c
@@ -4,8 +4,8 @@
  * Jan 23 2005  Matt Mackall <mpm@selenic.com>
  */
 
-#include <linux/kernel.h>
-#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/export.h>
 #include <linux/sort.h>
 #include <linux/slab.h>
 
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


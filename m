From: akpm@linux-foundation.org
Subject: [merged] lib-list_sortc-rearrange-includes.patch removed from -mm tree
Date: Fri, 13 Feb 2015 12:22:54 -0800
Message-ID: <54de5d1e.QunFsVt1KqZHtqOw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49147 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbbBMUWz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:22:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/list_sort.c: rearrange includes
has been removed from the -mm tree.  Its filename was
     lib-list_sortc-rearrange-includes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/list_sort.c: rearrange includes

Memory allocation only happens in the self test, just as random numbers
are only used there.  So move the inclusion of slab.h inside the
CONFIG_TEST_LIST_SORT.

We don't need module.h and all of the stuff it carries with it, so replace
with export.h and compiler.h.  Unfortunately, the ARRAY_SIZE macro from
kernel.h requires the user to ensure bug.h is also included (for
BUILD_BUG_ON_ZERO, used by __must_be_array).  We used to get that through
some maze of nested includes, but just include it explicitly.

linux/string.h is then only included implicitly through
kernel.h->printk.h->dynamic_debug.h, but only if !CONFIG_DYNAMIC_DEBUG, so
just include it explicitly (for memset).

objdump -d says the generated code is the same, and wc -l says that
lib/.list_sort.o.cmd went from 579 to 165 lines.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list_sort.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN lib/list_sort.c~lib-list_sortc-rearrange-includes lib/list_sort.c
--- a/lib/list_sort.c~lib-list_sortc-rearrange-includes
+++ a/lib/list_sort.c
@@ -2,9 +2,11 @@
 #define pr_fmt(fmt) "list_sort_test: " fmt
 
 #include <linux/kernel.h>
-#include <linux/module.h>
+#include <linux/bug.h>
+#include <linux/compiler.h>
+#include <linux/export.h>
+#include <linux/string.h>
 #include <linux/list_sort.h>
-#include <linux/slab.h>
 #include <linux/list.h>
 
 #define MAX_LIST_LENGTH_BITS 20
@@ -146,6 +148,7 @@ EXPORT_SYMBOL(list_sort);
 
 #ifdef CONFIG_TEST_LIST_SORT
 
+#include <linux/slab.h>
 #include <linux/random.h>
 
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


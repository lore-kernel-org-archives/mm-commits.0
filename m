From: akpm@linux-foundation.org
Subject: + lib-sortc-move-include-inside-if-0.patch added to -mm tree
Date: Fri, 02 Jan 2015 14:56:49 -0800
Message-ID: <54a72231.7QGprJakprhfO4Ws%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34139 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbbABW4u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jan 2015 17:56:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/sort.c: move include inside #if 0
has been added to the -mm tree.  Its filename is
     lib-sortc-move-include-inside-if-0.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-sortc-move-include-inside-if-0.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-sortc-move-include-inside-if-0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/sort.c: move include inside #if 0

The sort function and its helpers don't do memory allocation, so the
slab.h include is redundant.  Move it inside the #if 0 protecting the
self-test, similar to how it is done in lib/list_sort.c.  This removes
over 450 lines from the generated dependency file.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/sort.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/sort.c~lib-sortc-move-include-inside-if-0 lib/sort.c
--- a/lib/sort.c~lib-sortc-move-include-inside-if-0
+++ a/lib/sort.c
@@ -7,7 +7,6 @@
 #include <linux/types.h>
 #include <linux/export.h>
 #include <linux/sort.h>
-#include <linux/slab.h>
 
 static void u32_swap(void *a, void *b, int size)
 {
@@ -85,6 +84,7 @@ void sort(void *base, size_t num, size_t
 EXPORT_SYMBOL(sort);
 
 #if 0
+#include <linux/slab.h>
 /* a simple boot-time regression test */
 
 int cmpint(const void *a, const void *b)
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

lib-string_get_size-remove-redundant-prefixes.patch
lib-string_get_size-use-32-bit-arithmetic-when-possible.patch
lib-string_get_size-return-void.patch
lib-bitmap-more-signed-unsigned-conversions.patch
linux-nodemaskh-update-bitmap-wrappers-to-take-unsigned-int.patch
linux-cpumaskh-update-bitmap-wrappers-to-take-unsigned-int.patch
lib-bitmap-update-bitmap_onto-to-unsigned.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned.patch
lib-bitmap-simplify-bitmap_pos_to_ord.patch
lib-bitmap-simplify-bitmap_ord_to_pos.patch
lib-bitmap-make-the-bits-parameter-of-bitmap_remap-unsigned.patch
lib-remove-strnicmp.patch
lib-interval_treec-simplify-includes.patch
lib-sortc-use-simpler-includes.patch
lib-dynamic_queue_limitsc-simplify-includes.patch
lib-halfmd4c-simplify-includes.patch
lib-idrc-remove-redundant-include.patch
lib-genallocc-remove-redundant-include.patch
lib-list_sortc-rearrange-includes.patch
lib-md5c-simplify-include.patch
lib-llistc-remove-redundant-include.patch
lib-kobject_ueventc-remove-redundant-include.patch
lib-nlattrc-remove-redundant-include.patch
lib-plistc-remove-redundant-include.patch
lib-radix-treec-change-to-simpler-include.patch
lib-show_memc-remove-redundant-include.patch
lib-sortc-move-include-inside-if-0.patch
lib-stmp_devicec-replace-moduleh-include.patch
lib-strncpy_from_userc-replace-moduleh-include.patch
lib-percpu_idac-remove-redundant-includes.patch
lib-lcmc-replace-include.patch
checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch
linux-next.patch


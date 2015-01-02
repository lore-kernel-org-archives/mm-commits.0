From: akpm@linux-foundation.org
Subject: + lib-interval_treec-simplify-includes.patch added to -mm tree
Date: Fri, 02 Jan 2015 14:56:21 -0800
Message-ID: <54a72215.8YSAe9wCqgjUDAHQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34111 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbbABW4W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jan 2015 17:56:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/interval_tree.c: simplify includes
has been added to the -mm tree.  Its filename is
     lib-interval_treec-simplify-includes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-interval_treec-simplify-includes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-interval_treec-simplify-includes.patch

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


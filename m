From: akpm@linux-foundation.org
Subject: + lib-halfmd4c-simplify-includes.patch added to -mm tree
Date: Fri, 02 Jan 2015 14:56:27 -0800
Message-ID: <54a7221b.o0opNEPHL3ObLDsM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34117 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbbABW42 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jan 2015 17:56:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/halfmd4.c: simplify includes
has been added to the -mm tree.  Its filename is
     lib-halfmd4c-simplify-includes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-halfmd4c-simplify-includes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-halfmd4c-simplify-includes.patch

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
Subject: lib/halfmd4.c: simplify includes

We only need EXPORT_SYMBOL, so compiler.h and export.h suffice.  This
means linux/types.h is no longer implicitly included, so add an include of
uapi/linux/types.h to linux/cryptohash.h for __u32.  Other users of
cryptohash.h cannot be affected, since they must already have been
including uapi/linux/types.h in order for gcc not to complain about
unknown types.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cryptohash.h |    2 ++
 lib/halfmd4.c              |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/cryptohash.h~lib-halfmd4c-simplify-includes include/linux/cryptohash.h
--- a/include/linux/cryptohash.h~lib-halfmd4c-simplify-includes
+++ a/include/linux/cryptohash.h
@@ -1,6 +1,8 @@
 #ifndef __CRYPTOHASH_H
 #define __CRYPTOHASH_H
 
+#include <uapi/linux/types.h>
+
 #define SHA_DIGEST_WORDS 5
 #define SHA_MESSAGE_BYTES (512 /*bits*/ / 8)
 #define SHA_WORKSPACE_WORDS 16
diff -puN lib/halfmd4.c~lib-halfmd4c-simplify-includes lib/halfmd4.c
--- a/lib/halfmd4.c~lib-halfmd4c-simplify-includes
+++ a/lib/halfmd4.c
@@ -1,4 +1,4 @@
-#include <linux/kernel.h>
+#include <linux/compiler.h>
 #include <linux/export.h>
 #include <linux/cryptohash.h>
 
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


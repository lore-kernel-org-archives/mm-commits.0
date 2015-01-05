From: akpm@linux-foundation.org
Subject: + lib-bitmap-eliminate-branch-in-__bitmap_shift_right.patch added to -mm tree
Date: Mon, 05 Jan 2015 13:42:20 -0800
Message-ID: <54ab053c.avh8GeE6niwzI19y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58191 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488AbbAEVmV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2015 16:42:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: eliminate branch in __bitmap_shift_right
has been added to the -mm tree.  Its filename is
     lib-bitmap-eliminate-branch-in-__bitmap_shift_right.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-bitmap-eliminate-branch-in-__bitmap_shift_right.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-bitmap-eliminate-branch-in-__bitmap_shift_right.patch

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
Subject: lib: bitmap: eliminate branch in __bitmap_shift_right

We can shift the bits from lower and upper into place before assembling
dst[k]; moving the shift of upper into the branch where we already know
that rem is non-zero allows us to remove a conditional.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/bitmap.c~lib-bitmap-eliminate-branch-in-__bitmap_shift_right lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-eliminate-branch-in-__bitmap_shift_right
+++ a/lib/bitmap.c
@@ -129,13 +129,13 @@ void __bitmap_shift_right(unsigned long
 			upper = src[off + k + 1];
 			if (off + k + 1 == lim - 1 && left)
 				upper &= mask;
+			upper <<= (BITS_PER_LONG - rem);
 		}
 		lower = src[off + k];
 		if (left && off + k == lim - 1)
 			lower &= mask;
-		dst[k] = lower >> rem;
-		if (rem)
-			dst[k] |= upper << (BITS_PER_LONG - rem);
+		lower >>= rem;
+		dst[k] = lower | upper;
 		if (left && k == lim - 1)
 			dst[k] &= mask;
 	}
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
lib-bitmapc-change-prototype-of-bitmap_copy_le.patch
lib-bitmapc-elide-bitmap_copy_le-on-little-endian.patch
lib-bitmap-change-bitmap_shift_right-to-take-unsigned-parameters.patch
lib-bitmap-eliminate-branch-in-__bitmap_shift_right.patch
lib-bitmap-remove-redundant-code-from-__bitmap_shift_right.patch
lib-bitmap-yet-another-simplification-in-__bitmap_shift_right.patch
lib-bitmap-change-bitmap_shift_left-to-take-unsigned-parameters.patch
lib-bitmap-eliminate-branch-in-__bitmap_shift_left.patch
lib-bitmap-remove-redundant-code-from-__bitmap_shift_left.patch
checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch
linux-next.patch


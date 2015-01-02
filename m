From: akpm@linux-foundation.org
Subject: + lib-bitmapc-change-prototype-of-bitmap_copy_le.patch added to
 -mm tree
Date: Fri, 02 Jan 2015 15:16:48 -0800
Message-ID: <54a726e0.e2qDAanTh3lecWmA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34247 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbbABXQt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jan 2015 18:16:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/bitmap.c: change prototype of bitmap_copy_le
has been added to the -mm tree.  Its filename is
     lib-bitmapc-change-prototype-of-bitmap_copy_le.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-bitmapc-change-prototype-of-bitmap_copy_le.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-bitmapc-change-prototype-of-bitmap_copy_le.patch

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
Subject: lib/bitmap.c: change prototype of bitmap_copy_le

Make the prototype of bitmap_copy_le the same as bitmap_copy's.  All other
bitmap_* functions take unsigned long* parameters; there's no reason this
should be special.

The only current user is the static inline uwb_mas_bm_copy_le, which
already does the void* laundering, so the end users can pass their u8 or
__le32 buffers without a cast.

Furthermore, this allows us to simply let bitmap_copy_le be an alias for
bitmap_copy on little-endian; see next patch.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    2 +-
 lib/bitmap.c           |    9 ++++-----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff -puN include/linux/bitmap.h~lib-bitmapc-change-prototype-of-bitmap_copy_le include/linux/bitmap.h
--- a/include/linux/bitmap.h~lib-bitmapc-change-prototype-of-bitmap_copy_le
+++ a/include/linux/bitmap.h
@@ -170,7 +170,7 @@ extern void bitmap_fold(unsigned long *d
 extern int bitmap_find_free_region(unsigned long *bitmap, unsigned int bits, int order);
 extern void bitmap_release_region(unsigned long *bitmap, unsigned int pos, int order);
 extern int bitmap_allocate_region(unsigned long *bitmap, unsigned int pos, int order);
-extern void bitmap_copy_le(void *dst, const unsigned long *src, int nbits);
+extern void bitmap_copy_le(unsigned long *dst, const unsigned long *src, unsigned int nbits);
 extern unsigned int bitmap_ord_to_pos(const unsigned long *bitmap, unsigned int ord, unsigned int nbits);
 extern int bitmap_print_to_pagebuf(bool list, char *buf,
 				   const unsigned long *maskp, int nmaskbits);
diff -puN lib/bitmap.c~lib-bitmapc-change-prototype-of-bitmap_copy_le lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmapc-change-prototype-of-bitmap_copy_le
+++ a/lib/bitmap.c
@@ -1191,16 +1191,15 @@ EXPORT_SYMBOL(bitmap_allocate_region);
  *
  * Require nbits % BITS_PER_LONG == 0.
  */
-void bitmap_copy_le(void *dst, const unsigned long *src, int nbits)
+void bitmap_copy_le(unsigned long *dst, const unsigned long *src, unsigned int nbits)
 {
-	unsigned long *d = dst;
-	int i;
+	unsigned int i;
 
 	for (i = 0; i < nbits/BITS_PER_LONG; i++) {
 		if (BITS_PER_LONG == 64)
-			d[i] = cpu_to_le64(src[i]);
+			dst[i] = cpu_to_le64(src[i]);
 		else
-			d[i] = cpu_to_le32(src[i]);
+			dst[i] = cpu_to_le32(src[i]);
 	}
 }
 EXPORT_SYMBOL(bitmap_copy_le);
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
checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch
linux-next.patch


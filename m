From: akpm@linux-foundation.org
Subject: + lib-bitmapc-elide-bitmap_copy_le-on-little-endian.patch added
 to -mm tree
Date: Fri, 02 Jan 2015 15:16:50 -0800
Message-ID: <54a726e2.miUzFoSXu1y1NM5Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34248 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbbABXQv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jan 2015 18:16:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/bitmap.c: elide bitmap_copy_le on little-endian
has been added to the -mm tree.  Its filename is
     lib-bitmapc-elide-bitmap_copy_le-on-little-endian.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-bitmapc-elide-bitmap_copy_le-on-little-endian.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-bitmapc-elide-bitmap_copy_le-on-little-endian.patch

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
Subject: lib/bitmap.c: elide bitmap_copy_le on little-endian

On little-endian, there's no reason to have an extra, presumably less
efficient, way of copying a bitmap.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    4 ++++
 lib/bitmap.c           |    2 ++
 2 files changed, 6 insertions(+)

diff -puN include/linux/bitmap.h~lib-bitmapc-elide-bitmap_copy_le-on-little-endian include/linux/bitmap.h
--- a/include/linux/bitmap.h~lib-bitmapc-elide-bitmap_copy_le-on-little-endian
+++ a/include/linux/bitmap.h
@@ -170,7 +170,11 @@ extern void bitmap_fold(unsigned long *d
 extern int bitmap_find_free_region(unsigned long *bitmap, unsigned int bits, int order);
 extern void bitmap_release_region(unsigned long *bitmap, unsigned int pos, int order);
 extern int bitmap_allocate_region(unsigned long *bitmap, unsigned int pos, int order);
+#ifdef __BIG_ENDIAN
 extern void bitmap_copy_le(unsigned long *dst, const unsigned long *src, unsigned int nbits);
+#else
+#define bitmap_copy_le bitmap_copy
+#endif
 extern unsigned int bitmap_ord_to_pos(const unsigned long *bitmap, unsigned int ord, unsigned int nbits);
 extern int bitmap_print_to_pagebuf(bool list, char *buf,
 				   const unsigned long *maskp, int nmaskbits);
diff -puN lib/bitmap.c~lib-bitmapc-elide-bitmap_copy_le-on-little-endian lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmapc-elide-bitmap_copy_le-on-little-endian
+++ a/lib/bitmap.c
@@ -1191,6 +1191,7 @@ EXPORT_SYMBOL(bitmap_allocate_region);
  *
  * Require nbits % BITS_PER_LONG == 0.
  */
+#ifdef __BIG_ENDIAN
 void bitmap_copy_le(unsigned long *dst, const unsigned long *src, unsigned int nbits)
 {
 	unsigned int i;
@@ -1203,3 +1204,4 @@ void bitmap_copy_le(unsigned long *dst,
 	}
 }
 EXPORT_SYMBOL(bitmap_copy_le);
+#endif
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


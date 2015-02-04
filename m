From: akpm@linux-foundation.org
Subject: + kernelh-remove-ancient-__function__-hack.patch added to -mm
 tree
Date: Wed, 04 Feb 2015 14:35:43 -0800
Message-ID: <54d29ebf.BxcVd7mgQ0/b9vQK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47147 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161137AbbBDWfo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Feb 2015 17:35:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, joe@perches.com, mina86@mina86.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel.h: remove ancient __FUNCTION__ hack
has been added to the -mm tree.  Its filename is
     kernelh-remove-ancient-__function__-hack.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernelh-remove-ancient-__function__-hack.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernelh-remove-ancient-__function__-hack.patch

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
Subject: kernel.h: remove ancient __FUNCTION__ hack

__FUNCTION__ hasn't been treated as a string literal since gcc 3.4, so
this only helps people who only test-compile using 3.3 (compiler-gcc3.h
barks at anything older than that).  Besides, there are almost no
occurrences of __FUNCTION__ left in the tree.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN include/linux/kernel.h~kernelh-remove-ancient-__function__-hack include/linux/kernel.h
--- a/include/linux/kernel.h~kernelh-remove-ancient-__function__-hack
+++ a/include/linux/kernel.h
@@ -799,9 +799,6 @@ static inline void ftrace_dump(enum ftra
 	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
 	(type *)( (char *)__mptr - offsetof(type,member) );})
 
-/* Trap pasters of __FUNCTION__ at compile-time */
-#define __FUNCTION__ (__func__)
-
 /* Rebuild everything on CONFIG_FTRACE_MCOUNT_RECORD */
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
 # define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

kernelh-remove-ancient-__function__-hack.patch
kernelh-remove-ancient-__function__-hack-fix.patch
lib-vsprintfc-consume-p-in-format_decode.patch
lib-vsprintfc-improve-sanity-check-in-vsnprintf.patch
lib-vsprintfc-replace-while-with-do-while-in-skip_atoi.patch
lib-string_get_size-remove-redundant-prefixes.patch
lib-string_get_size-use-32-bit-arithmetic-when-possible.patch
lib-string_get_size-return-void.patch
lib-bitmap-more-signed-unsigned-conversions.patch
linux-nodemaskh-update-bitmap-wrappers-to-take-unsigned-int.patch
linux-cpumaskh-update-bitmap-wrappers-to-take-unsigned-int.patch
lib-bitmap-update-bitmap_onto-to-unsigned.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
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
lib-stringc-improve-strrchr.patch
checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch
linux-next.patch


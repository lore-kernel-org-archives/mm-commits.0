From: akpm@linux-foundation.org
Subject: + lib-vsprintfc-improve-sanity-check-in-vsnprintf.patch added to
 -mm tree
Date: Fri, 09 Jan 2015 16:16:48 -0800
Message-ID: <54b06f70.ZUHvAdQ8PMth64va%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38873 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbbAJAQt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2015 19:16:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, jkosina@suse.cz, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: improve sanity check in vsnprintf()
has been added to the -mm tree.  Its filename is
     lib-vsprintfc-improve-sanity-check-in-vsnprintf.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-vsprintfc-improve-sanity-check-in-vsnprintf.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-vsprintfc-improve-sanity-check-in-vsnprintf.patch

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
Subject: lib/vsprintf.c: improve sanity check in vsnprintf()

On 64 bit, size may very well be huge even if bit 31 happens to be 0. 
Somehow it doesn't feel right that one can pass a 5 GiB buffer but not a 3
GiB one.  So cap at INT_MAX as was probably the intention all along.  This
is also the made-up value passed by sprintf and vsprintf.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-improve-sanity-check-in-vsnprintf lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-improve-sanity-check-in-vsnprintf
+++ a/lib/vsprintf.c
@@ -1727,7 +1727,7 @@ int vsnprintf(char *buf, size_t size, co
 
 	/* Reject out-of-range values early.  Large positive sizes are
 	   used for unknown buffer sizes. */
-	if (WARN_ON_ONCE((int) size < 0))
+	if (WARN_ON_ONCE(size > INT_MAX))
 		return 0;
 
 	str = buf;
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

lib-vsprintfc-consume-p-in-format_decode.patch
lib-vsprintfc-improve-sanity-check-in-vsnprintf.patch
lib-vsprintfc-dont-try-to-fix-pointer-wrap-around.patch
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
checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch
linux-next.patch


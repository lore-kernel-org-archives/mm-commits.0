From: akpm@linux-foundation.org
Subject: [failures]
 lib-vsprintfc-dont-try-to-fix-pointer-wrap-around.patch removed from -mm
 tree
Date: Fri, 16 Jan 2015 12:24:14 -0800
Message-ID: <54b9736e.Ze/1ELhyRyTuS6Qn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46854 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbbAPUYP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jan 2015 15:24:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, jkosina@suse.cz, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: don't try to fix pointer wrap-around
has been removed from the -mm tree.  Its filename was
     lib-vsprintfc-dont-try-to-fix-pointer-wrap-around.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/vsprintf.c: don't try to fix pointer wrap-around

Actual kernel buffers can't wrap into the user address space.  If someone
manages to pass a buf/size combination that wraps, it is most likely due
to a bug in the caller.  Instead of trying to fix it by using a smaller
part of the buffer, bail out.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-dont-try-to-fix-pointer-wrap-around lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-dont-try-to-fix-pointer-wrap-around
+++ a/lib/vsprintf.c
@@ -1733,11 +1733,9 @@ int vsnprintf(char *buf, size_t size, co
 	str = buf;
 	end = buf + size;
 
-	/* Make sure end is always >= buf */
-	if (end < buf) {
-		end = ((void *)-1);
-		size = end - buf;
-	}
+	/* Also bail out if buf+size wraps */
+	if (WARN_ON_ONCE(end < buf))
+		return 0;
 
 	while (*fmt) {
 		const char *old_fmt = fmt;
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
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


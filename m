Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5033BC2D0E4
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 00:36:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F199E2075B
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 00:36:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D5q8veGK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729071AbgKXAgW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Nov 2020 19:36:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:43358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727107AbgKXAgV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Nov 2020 19:36:21 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16DE120757;
        Tue, 24 Nov 2020 00:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606178180;
        bh=/9y0cQEmGkPNyuO1tkEeHDcw0aJK4cSJdf94isblF+Q=;
        h=Date:From:To:Subject:From;
        b=D5q8veGKj4PTLEG+ClRUN2rQQToZL1DRB81F43VJItE8miHl+6m7X3ltsjaI4imr8
         2FbkcUa+2/TpQczcc1zKLJHvqOaeBLN9dhCGU2IAQPCl5ypfhHtuqAxgvpiSR8r8nO
         iJ9DieeAzaCqNqT1rhbgvoqaIkpCTxJqM+XKsYas=
Date:   Mon, 23 Nov 2020 16:36:19 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, gor@linux.ibm.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  + kasan-rename-shadow-layout-macros-to-meta.patch added
 to -mm tree
Message-ID: <20201124003619.za8vsh7KS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: rename SHADOW layout macros to META
has been added to the -mm tree.  Its filename is
     kasan-rename-shadow-layout-macros-to-meta.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-rename-shadow-layout-macros-to-meta.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-rename-shadow-layout-macros-to-meta.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: rename SHADOW layout macros to META

This is a preparatory commit for the upcoming addition of a new hardware
tag-based (MTE-based) KASAN mode.

Hardware tag-based KASAN won't be using shadow memory, but will reuse
these macros.  Rename "SHADOW" to implementation-neutral "META".

No functional changes.

Link: https://lkml.kernel.org/r/f96244ec59dc17db35173ec352c5592b14aefaf8.1606161801.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Tested-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/mm/kasan/report.c~kasan-rename-shadow-layout-macros-to-meta
+++ a/mm/kasan/report.c
@@ -33,11 +33,11 @@
 #include "kasan.h"
 #include "../slab.h"
 
-/* Shadow layout customization. */
-#define SHADOW_BYTES_PER_BLOCK 1
-#define SHADOW_BLOCKS_PER_ROW 16
-#define SHADOW_BYTES_PER_ROW (SHADOW_BLOCKS_PER_ROW * SHADOW_BYTES_PER_BLOCK)
-#define SHADOW_ROWS_AROUND_ADDR 2
+/* Metadata layout customization. */
+#define META_BYTES_PER_BLOCK 1
+#define META_BLOCKS_PER_ROW 16
+#define META_BYTES_PER_ROW (META_BLOCKS_PER_ROW * META_BYTES_PER_BLOCK)
+#define META_ROWS_AROUND_ADDR 2
 
 static unsigned long kasan_flags;
 
@@ -240,7 +240,7 @@ static void print_address_description(vo
 
 static bool row_is_guilty(const void *row, const void *guilty)
 {
-	return (row <= guilty) && (guilty < row + SHADOW_BYTES_PER_ROW);
+	return (row <= guilty) && (guilty < row + META_BYTES_PER_ROW);
 }
 
 static int shadow_pointer_offset(const void *row, const void *shadow)
@@ -249,7 +249,7 @@ static int shadow_pointer_offset(const v
 	 *    3 + (BITS_PER_LONG/8)*2 chars.
 	 */
 	return 3 + (BITS_PER_LONG/8)*2 + (shadow - row)*2 +
-		(shadow - row) / SHADOW_BYTES_PER_BLOCK + 1;
+		(shadow - row) / META_BYTES_PER_BLOCK + 1;
 }
 
 static void print_memory_metadata(const void *addr)
@@ -259,15 +259,15 @@ static void print_memory_metadata(const
 	const void *shadow_row;
 
 	shadow_row = (void *)round_down((unsigned long)shadow,
-					SHADOW_BYTES_PER_ROW)
-		- SHADOW_ROWS_AROUND_ADDR * SHADOW_BYTES_PER_ROW;
+					META_BYTES_PER_ROW)
+		- META_ROWS_AROUND_ADDR * META_BYTES_PER_ROW;
 
 	pr_err("Memory state around the buggy address:\n");
 
-	for (i = -SHADOW_ROWS_AROUND_ADDR; i <= SHADOW_ROWS_AROUND_ADDR; i++) {
+	for (i = -META_ROWS_AROUND_ADDR; i <= META_ROWS_AROUND_ADDR; i++) {
 		const void *kaddr = kasan_shadow_to_mem(shadow_row);
 		char buffer[4 + (BITS_PER_LONG/8)*2];
-		char shadow_buf[SHADOW_BYTES_PER_ROW];
+		char shadow_buf[META_BYTES_PER_ROW];
 
 		snprintf(buffer, sizeof(buffer),
 			(i == 0) ? ">%px: " : " %px: ", kaddr);
@@ -276,17 +276,17 @@ static void print_memory_metadata(const
 		 * function, because generic functions may try to
 		 * access kasan mapping for the passed address.
 		 */
-		memcpy(shadow_buf, shadow_row, SHADOW_BYTES_PER_ROW);
+		memcpy(shadow_buf, shadow_row, META_BYTES_PER_ROW);
 		print_hex_dump(KERN_ERR, buffer,
-			DUMP_PREFIX_NONE, SHADOW_BYTES_PER_ROW, 1,
-			shadow_buf, SHADOW_BYTES_PER_ROW, 0);
+			DUMP_PREFIX_NONE, META_BYTES_PER_ROW, 1,
+			shadow_buf, META_BYTES_PER_ROW, 0);
 
 		if (row_is_guilty(shadow_row, shadow))
 			pr_err("%*c\n",
 				shadow_pointer_offset(shadow_row, shadow),
 				'^');
 
-		shadow_row += SHADOW_BYTES_PER_ROW;
+		shadow_row += META_BYTES_PER_ROW;
 	}
 }
 
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-drop-unnecessary-gpl-text-from-comment-headers.patch
kasan-kasan_vmalloc-depends-on-kasan_generic.patch
kasan-group-vmalloc-code.patch
kasan-shadow-declarations-only-for-software-modes.patch
kasan-rename-unpoison_shadow-to-unpoison_range.patch
kasan-rename-kasan_shadow_-to-kasan_granule_.patch
kasan-only-build-initc-for-software-modes.patch
kasan-split-out-shadowc-from-commonc.patch
kasan-define-kasan_memory_per_shadow_page.patch
kasan-rename-report-and-tags-files.patch
kasan-dont-duplicate-config-dependencies.patch
kasan-hide-invalid-free-check-implementation.patch
kasan-decode-stack-frame-only-with-kasan_stack_enable.patch
kasan-arm64-only-init-shadow-for-software-modes.patch
kasan-arm64-only-use-kasan_depth-for-software-modes.patch
kasan-arm64-move-initialization-message.patch
kasan-arm64-rename-kasan_init_tags-and-mark-as-__init.patch
kasan-rename-addr_has_shadow-to-addr_has_metadata.patch
kasan-rename-print_shadow_for_address-to-print_memory_metadata.patch
kasan-rename-shadow-layout-macros-to-meta.patch
kasan-separate-metadata_fetch_row-for-each-mode.patch
kasan-arm64-dont-allow-sw_tags-with-arm64_mte.patch
kasan-introduce-config_kasan_hw_tags.patch
arm64-kasan-align-allocations-for-hw_tags.patch
arm64-kasan-add-arch-layer-for-memory-tagging-helpers.patch
kasan-define-kasan_granule_size-for-hw_tags.patch
kasan-x86-s390-update-undef-config_kasan.patch
kasan-arm64-expand-config_kasan-checks.patch
kasan-arm64-implement-hw_tags-runtime.patch
kasan-arm64-print-report-from-tag-fault-handler.patch
kasan-mm-reset-tags-when-accessing-metadata.patch
kasan-arm64-enable-config_kasan_hw_tags.patch
kasan-add-documentation-for-hardware-tag-based-mode.patch
kasan-simplify-quarantine_put-call-site.patch
kasan-rename-get_alloc-free_info.patch
kasan-introduce-set_alloc_info.patch
kasan-arm64-unpoison-stack-only-with-config_kasan_stack.patch
kasan-allow-vmap_stack-for-hw_tags-mode.patch
kasan-remove-__kasan_unpoison_stack.patch
kasan-inline-kasan_reset_tag-for-tag-based-modes.patch
kasan-inline-random_tag-for-hw_tags.patch
kasan-open-code-kasan_unpoison_slab.patch
kasan-inline-unpoison_range-and-check_invalid_free.patch
kasan-add-and-integrate-kasan-boot-parameters.patch
kasan-mm-check-kasan_enabled-in-annotations.patch
kasan-mm-rename-kasan_poison_kfree.patch
kasan-dont-round_up-too-much.patch
kasan-simplify-assign_tag-and-set_tag-calls.patch
kasan-clarify-comment-in-__kasan_kfree_large.patch
kasan-sanitize-objects-when-metadata-doesnt-fit.patch
kasan-mm-allow-cache-merging-with-no-metadata.patch
kasan-update-documentation.patch


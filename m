Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A32D3C2BB3F
	for <mm-commits@archiver.kernel.org>; Mon, 20 Nov 2023 18:04:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234176AbjKTSE0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Nov 2023 13:04:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233944AbjKTSEX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2023 13:04:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C183BE
        for <mm-commits@vger.kernel.org>; Mon, 20 Nov 2023 10:04:15 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECAEAC433C9;
        Mon, 20 Nov 2023 18:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700503455;
        bh=8EsomR1o03FpA4WSLTV/1IJhI8O+dVuTxcfMckgUwcs=;
        h=Date:To:From:Subject:From;
        b=UQX0OTmUthEZeowpoOePLlOMb/E1O8+3+n+E84y1pzx31fuwpaqEXFumk8PPvgcnq
         sEPbCS7KzcHG094e/7u84wdQDRcmHtsrDdYp/kNcaIAluO2qEWfUI1FZCh4S6XMJlV
         lgTD4n5KzJ6MbXw3zNoPXKo5sElTmNPlRXseyTMw=
Date:   Mon, 20 Nov 2023 10:04:14 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, osalvador@suse.de,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-adjust-depot_pools_cap-for-kmsan.patch added to mm-unstable branch
Message-Id: <20231120180414.ECAEAC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: adjust DEPOT_POOLS_CAP for KMSAN
has been added to the -mm mm-unstable branch.  Its filename is
     lib-stackdepot-adjust-depot_pools_cap-for-kmsan.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-adjust-depot_pools_cap-for-kmsan.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: lib/stackdepot: adjust DEPOT_POOLS_CAP for KMSAN
Date: Mon, 20 Nov 2023 18:47:20 +0100

KMSAN is frequently used in fuzzing scenarios and thus saves a lot of
stack traces.  As KMSAN does not support evicting stack traces from the
stack depot, the stack depot capacity might be reached quickly with large
stack records.

Adjust the maximum number of stack depot pools for this case.

The average size of a stack trace saved into the stack depot is ~16
frames.  Thus, adjust the maximum pools number accordingly to keep the
maximum number of stack traces that can be saved into the stack depot
similar to the one that was allowed before the stack trace eviction
changes.

Link: https://lkml.kernel.org/r/301a115cf7ce8ddb42ef6de9151c2bb76ba728fc.1700502145.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/lib/stackdepot.c~lib-stackdepot-adjust-depot_pools_cap-for-kmsan
+++ a/lib/stackdepot.c
@@ -41,7 +41,17 @@
 #define DEPOT_OFFSET_BITS (DEPOT_POOL_ORDER + PAGE_SHIFT - DEPOT_STACK_ALIGN)
 #define DEPOT_POOL_INDEX_BITS (DEPOT_HANDLE_BITS - DEPOT_OFFSET_BITS - \
 			       STACK_DEPOT_EXTRA_BITS)
+#if IS_ENABLED(CONFIG_KMSAN) && CONFIG_STACKDEPOT_MAX_FRAMES >= 32
+/*
+ * KMSAN is frequently used in fuzzing scenarios and thus saves a lot of stack
+ * traces. As KMSAN does not support evicting stack traces from the stack
+ * depot, the stack depot capacity might be reached quickly with large stack
+ * records. Adjust the maximum number of stack depot pools for this case.
+ */
+#define DEPOT_POOLS_CAP (8192 * (CONFIG_STACKDEPOT_MAX_FRAMES / 16))
+#else
 #define DEPOT_POOLS_CAP 8192
+#endif
 #define DEPOT_MAX_POOLS \
 	(((1LL << (DEPOT_POOL_INDEX_BITS)) < DEPOT_POOLS_CAP) ? \
 	 (1LL << (DEPOT_POOL_INDEX_BITS)) : DEPOT_POOLS_CAP)
_

Patches currently in -mm which might be from andreyknvl@google.com are

lib-stackdepot-print-disabled-message-only-if-truly-disabled.patch
lib-stackdepot-check-disabled-flag-when-fetching.patch
lib-stackdepot-simplify-__stack_depot_save.patch
lib-stackdepot-drop-valid-bit-from-handles.patch
lib-stackdepot-add-depot_fetch_stack-helper.patch
lib-stackdepot-use-fixed-sized-slots-for-stack-records.patch
lib-stackdepot-fix-and-clean-up-atomic-annotations.patch
lib-stackdepot-rework-helpers-for-depot_alloc_stack.patch
lib-stackdepot-rename-next_pool_required-to-new_pool_required.patch
lib-stackdepot-store-next-pool-pointer-in-new_pool.patch
lib-stackdepot-store-free-stack-records-in-a-freelist.patch
lib-stackdepot-use-read-write-lock.patch
lib-stackdepot-use-list_head-for-stack-record-links.patch
kmsan-use-stack_depot_save-instead-of-__stack_depot_save.patch
lib-stackdepot-kasan-add-flags-to-__stack_depot_save-and-rename.patch
lib-stackdepot-add-refcount-for-records.patch
lib-stackdepot-allow-users-to-evict-stack-traces.patch
kasan-remove-atomic-accesses-to-stack-ring-entries.patch
kasan-check-object_size-in-kasan_complete_mode_report_info.patch
kasan-use-stack_depot_put-for-tag-based-modes.patch
kasan-use-stack_depot_put-for-generic-mode.patch
lib-stackdepot-adjust-depot_pools_cap-for-kmsan.patch


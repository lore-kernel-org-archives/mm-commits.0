Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D8D8C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:42:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233941AbiCYWoC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233940AbiCYWn4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:43:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C19A20A3AE
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:41:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 943D061502
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:41:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76D7C004DD;
        Fri, 25 Mar 2022 22:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248118;
        bh=1qgrorOVnG8PVnQZjGKql7SFUHRbjSzQeo2g7iQYWVg=;
        h=Date:To:From:Subject:From;
        b=eJ4lqENxV0by4utJKz24sZ/wrbICSnjubyzZ/0nprHBrHg0znRBgEjKojWTxQvpR3
         Tkq/Zm9UInAYmaaXVw8eNtBlNUqHFasUnB6ZWR1wMXrfknrsDISFuUJVfiuiYotYot
         vIC+yv1rQATJz+UP3FNWiPSexSY5965p8K9JVDvU=
Date:   Fri, 25 Mar 2022 15:41:57 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com, pcc@google.com,
        mark.rutland@arm.com, glider@google.com, eugenis@google.com,
        elver@google.com, dvyukov@google.com, catalin.marinas@arm.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kasan-page_alloc-simplify-kasan_poison_pages-call-site.patch removed from -mm tree
Message-Id: <20220325224157.E76D7C004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, page_alloc: simplify kasan_poison_pages call site
has been removed from the -mm tree.  Its filename was
     kasan-page_alloc-simplify-kasan_poison_pages-call-site.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, page_alloc: simplify kasan_poison_pages call site

Simplify the code around calling kasan_poison_pages() in
free_pages_prepare().

This patch does no functional changes.

Link: https://lkml.kernel.org/r/ae4f9bcf071577258e786bcec4798c145d718c46.1643047180.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

--- a/mm/page_alloc.c~kasan-page_alloc-simplify-kasan_poison_pages-call-site
+++ a/mm/page_alloc.c
@@ -1298,6 +1298,7 @@ static __always_inline bool free_pages_p
 {
 	int bad = 0;
 	bool skip_kasan_poison = should_skip_kasan_poison(page, fpi_flags);
+	bool init = want_init_on_free();
 
 	VM_BUG_ON_PAGE(PageTail(page), page);
 
@@ -1370,19 +1371,10 @@ static __always_inline bool free_pages_p
 	 * With hardware tag-based KASAN, memory tags must be set before the
 	 * page becomes unavailable via debug_pagealloc or arch_free_page.
 	 */
-	if (kasan_has_integrated_init()) {
-		bool init = want_init_on_free();
-
-		if (!skip_kasan_poison)
-			kasan_poison_pages(page, order, init);
-	} else {
-		bool init = want_init_on_free();
-
-		if (init)
-			kernel_init_free_pages(page, 1 << order);
-		if (!skip_kasan_poison)
-			kasan_poison_pages(page, order, init);
-	}
+	if (init && !kasan_has_integrated_init())
+		kernel_init_free_pages(page, 1 << order);
+	if (!skip_kasan_poison)
+		kasan_poison_pages(page, order, init);
 
 	/*
 	 * arch_free_page() can make the page's contents inaccessible.  s390
_

Patches currently in -mm which might be from andreyknvl@google.com are

stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch


Return-Path: <SRS0=/uUQ=ID=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD06CC433E0
	for <mm-commits@archiver.kernel.org>; Fri,  5 Mar 2021 23:47:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FB2C650A3
	for <mm-commits@archiver.kernel.org>; Fri,  5 Mar 2021 23:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhCEXqs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Mar 2021 18:46:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:56806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230260AbhCEXqm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Mar 2021 18:46:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E901650A1;
        Fri,  5 Mar 2021 23:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614988002;
        bh=BhF5os8k5Xr5ADJg1He5SclEaIjXUg/bLTzknsTDIbc=;
        h=Date:From:To:Subject:From;
        b=c9qFhqYSBPLFnQv+uIAr72A3tt3hirf3Pau3NVNom6TcIjoVUGp2Mm/wfpLeXuJXK
         NjtWboHBSsXp75eOU5xQBKeH/AVl+S5BfWxcFOG6w2+YMCa9hgFniLTwB17RGQIT3O
         hWCrWppeYAXsCIDg8Mz6l5jNo32tmL/AqFOn6AAw=
Date:   Fri, 05 Mar 2021 15:46:41 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, hch@infradead.org, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [to-be-updated]
 kasan-mm-fix-crash-with-hw_tags-and-debug_pagealloc.patch removed from -mm
 tree
Message-ID: <20210305234641.MrsZDajwt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, mm: fix crash with HW_TAGS and DEBUG_PAGEALLOC
has been removed from the -mm tree.  Its filename was
     kasan-mm-fix-crash-with-hw_tags-and-debug_pagealloc.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, mm: fix crash with HW_TAGS and DEBUG_PAGEALLOC

Currently, kasan_free_nondeferred_pages()->kasan_free_pages() is called
after debug_pagealloc_unmap_pages().  This causes a crash when
debug_pagealloc is enabled, as HW_TAGS KASAN can't set tags on an unmapped
page.

This patch puts kasan_free_nondeferred_pages() before
debug_pagealloc_unmap_pages().

Besides fixing the crash, this also makes the annotation order consistent
with debug_pagealloc_map_pages() preceding kasan_alloc_pages().

Link: https://lkml.kernel.org/r/1aa83e48627978de8068d5e3314185f3a0d7a849.1614302398.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~kasan-mm-fix-crash-with-hw_tags-and-debug_pagealloc
+++ a/mm/page_alloc.c
@@ -1288,10 +1288,14 @@ static __always_inline bool free_pages_p
 	 */
 	arch_free_page(page, order);
 
-	debug_pagealloc_unmap_pages(page, 1 << order);
-
+	/*
+	 * With hardware tag-based KASAN, memory tags must be set
+	 * before unmapping the page with debug_pagealloc.
+	 */
 	kasan_free_nondeferred_pages(page, order);
 
+	debug_pagealloc_unmap_pages(page, 1 << order);
+
 	return true;
 }
 
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-mm-fix-crash-with-hw_tags-and-debug_pagealloc-v2.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13382C43219
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354193AbiCYBMa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357171AbiCYBMW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:12:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C853FBD2CC
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:10:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82C34B81DE2
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B66C36AE2;
        Fri, 25 Mar 2022 01:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170647;
        bh=CjaBTSp8AdrOVpUvds9TYfRTmE82vd/O2yW4cPLia5U=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=m634TUXsgfuzdQ1KLfpfPojMIEaZ2SRqKOLGBsy2NlBbJ2wQEGK4NwYKAAfjST1PN
         m5fIL+uiXTJaI8j1ygZ/CggeuLOorF0kCeZVq5hECuFTSED0BmqF3WQX3UALgB+6DZ
         s6a8foaQuo7w1GGML+q8ZREwslpJqInkR5C86SkY=
Date:   Thu, 24 Mar 2022 18:10:46 -0700
To:     will@kernel.org, vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com,
        pcc@google.com, mark.rutland@arm.com, glider@google.com,
        eugenis@google.com, elver@google.com, dvyukov@google.com,
        catalin.marinas@arm.com, andreyknvl@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 044/114] kasan: clean up metadata byte definitions
Message-Id: <20220325011047.38B66C36AE2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: clean up metadata byte definitions

Most of the metadata byte values are only used for Generic KASAN.

Remove KASAN_KMALLOC_FREETRACK definition for !CONFIG_KASAN_GENERIC case,
and put it along with other metadata values for the Generic mode under a
corresponding ifdef.

Link: https://lkml.kernel.org/r/ac11d6e9e007c95e472e8fdd22efb6074ef3c6d8.1643047180.git.andreyknvl@google.com
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

 mm/kasan/kasan.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/kasan/kasan.h~kasan-clean-up-metadata-byte-definitions
+++ a/mm/kasan/kasan.h
@@ -71,15 +71,16 @@ static inline bool kasan_sync_fault_poss
 #define KASAN_PAGE_REDZONE      0xFE  /* redzone for kmalloc_large allocations */
 #define KASAN_KMALLOC_REDZONE   0xFC  /* redzone inside slub object */
 #define KASAN_KMALLOC_FREE      0xFB  /* object was freed (kmem_cache_free/kfree) */
-#define KASAN_KMALLOC_FREETRACK 0xFA  /* object was freed and has free track set */
 #else
 #define KASAN_FREE_PAGE         KASAN_TAG_INVALID
 #define KASAN_PAGE_REDZONE      KASAN_TAG_INVALID
 #define KASAN_KMALLOC_REDZONE   KASAN_TAG_INVALID
 #define KASAN_KMALLOC_FREE      KASAN_TAG_INVALID
-#define KASAN_KMALLOC_FREETRACK KASAN_TAG_INVALID
 #endif
 
+#ifdef CONFIG_KASAN_GENERIC
+
+#define KASAN_KMALLOC_FREETRACK 0xFA  /* object was freed and has free track set */
 #define KASAN_GLOBAL_REDZONE    0xF9  /* redzone for global variable */
 #define KASAN_VMALLOC_INVALID   0xF8  /* unallocated space in vmapped page */
 
@@ -110,6 +111,8 @@ static inline bool kasan_sync_fault_poss
 #define KASAN_ABI_VERSION 1
 #endif
 
+#endif /* CONFIG_KASAN_GENERIC */
+
 /* Metadata layout customization. */
 #define META_BYTES_PER_BLOCK 1
 #define META_BLOCKS_PER_ROW 16
_

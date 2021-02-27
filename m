Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03A10C433DB
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:32:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C82CD64F33
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:32:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhB0Ccb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:32:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:51606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229993AbhB0CcH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:32:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C86464F2A;
        Sat, 27 Feb 2021 02:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393092;
        bh=AIudJjowXZBBBcXMYtGhWEaiUsbHkAGfltTX1VaSnV0=;
        h=Date:From:To:Subject:From;
        b=Me/lNtwdd0CMqB1Lu8hB/xuRJwz8qKRH0tvPxufEiyY39vTHsn41V50ZdD8W1q/SU
         SX0YwQUkeACFOCxTN/BUH1hAbU+ePW/DC8a2OSgC7ngcUWPfoRE7PErFkUGy74vVWa
         6OFO0AH2R2f58dF+ot4kJrRccIW9n6ZNpdiv5Oy4=
Date:   Fri, 26 Feb 2021 18:31:32 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [merged] kasan-inline-hw_tags-helper-functions.patch
 removed from -mm tree
Message-ID: <20210227023132.d4JlIoXjL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: inline HW_TAGS helper functions
has been removed from the -mm tree.  Its filename was
     kasan-inline-hw_tags-helper-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: inline HW_TAGS helper functions

Mark all static functions in common.c and kasan.h that are used for
hardware tag-based KASAN as inline to avoid unnecessary function calls.

Link: https://lkml.kernel.org/r/2c94a2af0657f2b95b9337232339ff5ffa643ab5.1612546384.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/mm/kasan/common.c~kasan-inline-hw_tags-helper-functions
+++ a/mm/kasan/common.c
@@ -279,7 +279,8 @@ void __kasan_poison_object_data(struct k
  *    based on objects indexes, so that objects that are next to each other
  *    get different tags.
  */
-static u8 assign_tag(struct kmem_cache *cache, const void *object, bool init)
+static inline u8 assign_tag(struct kmem_cache *cache,
+					const void *object, bool init)
 {
 	if (IS_ENABLED(CONFIG_KASAN_GENERIC))
 		return 0xff;
@@ -321,8 +322,8 @@ void * __must_check __kasan_init_slab_ob
 	return (void *)object;
 }
 
-static bool ____kasan_slab_free(struct kmem_cache *cache, void *object,
-			      unsigned long ip, bool quarantine)
+static inline bool ____kasan_slab_free(struct kmem_cache *cache,
+				void *object, unsigned long ip, bool quarantine)
 {
 	u8 tag;
 	void *tagged_object;
@@ -366,7 +367,7 @@ bool __kasan_slab_free(struct kmem_cache
 	return ____kasan_slab_free(cache, object, ip, true);
 }
 
-static bool ____kasan_kfree_large(void *ptr, unsigned long ip)
+static inline bool ____kasan_kfree_large(void *ptr, unsigned long ip)
 {
 	if (ptr != page_address(virt_to_head_page(ptr))) {
 		kasan_report_invalid_free(ptr, ip);
@@ -461,8 +462,8 @@ void * __must_check __kasan_slab_alloc(s
 	return tagged_object;
 }
 
-static void *____kasan_kmalloc(struct kmem_cache *cache, const void *object,
-					size_t size, gfp_t flags)
+static inline void *____kasan_kmalloc(struct kmem_cache *cache,
+				const void *object, size_t size, gfp_t flags)
 {
 	unsigned long redzone_start;
 	unsigned long redzone_end;
_

Patches currently in -mm which might be from andreyknvl@google.com are



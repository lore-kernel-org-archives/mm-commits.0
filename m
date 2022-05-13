Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0832C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:25:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbiEMTZQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383778AbiEMTX2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:23:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B812DD4B
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:22:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DC7EB8315D
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:22:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2B2C34100;
        Fri, 13 May 2022 19:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469742;
        bh=S3dSK3TGOXHD67s1xw3COgGigUqWH9y+1dOtapOjaMk=;
        h=Date:To:From:Subject:From;
        b=jWxQOoxPqqjINMrqUFvDUjT1GwvEZWJLK0U6uVUfFAYw7P82EaiZYQbUCNDfzoPOy
         MI+2Q+gg/phU1T093gz6KQNMXT1xTI9ChyCZ2Fqfdl4ZCUrCmH9c8Feb0iCMNKGVDp
         1mkvVWoqZiuFF8hWs9SkABEVvq6Yz3eKPq5QkLw4=
Date:   Fri, 13 May 2022 12:22:22 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-use-tabs-to-align-shadow-values.patch removed from -mm tree
Message-Id: <20220513192222.BC2B2C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: use tabs to align shadow values
has been removed from the -mm tree.  Its filename was
     kasan-use-tabs-to-align-shadow-values.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: use tabs to align shadow values

Consistently use tabs instead of spaces to shadow value definitions.

Link: https://lkml.kernel.org/r/00e7e66b5fc375d58200dc1489949b3edcd096b7.1652111464.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/mm/kasan/kasan.h~kasan-use-tabs-to-align-shadow-values
+++ a/mm/kasan/kasan.h
@@ -74,29 +74,29 @@ static inline bool kasan_sync_fault_poss
 #define KASAN_MEMORY_PER_SHADOW_PAGE	(KASAN_GRANULE_SIZE << PAGE_SHIFT)
 
 #ifdef CONFIG_KASAN_GENERIC
-#define KASAN_FREE_PAGE         0xFF  /* freed page */
-#define KASAN_PAGE_REDZONE      0xFE  /* redzone for kmalloc_large allocation */
-#define KASAN_KMALLOC_REDZONE   0xFC  /* redzone for slab object */
-#define KASAN_KMALLOC_FREE      0xFB  /* freed slab object */
-#define KASAN_VMALLOC_INVALID   0xF8  /* inaccessible space in vmap area */
+#define KASAN_FREE_PAGE		0xFF  /* freed page */
+#define KASAN_PAGE_REDZONE	0xFE  /* redzone for kmalloc_large allocation */
+#define KASAN_KMALLOC_REDZONE	0xFC  /* redzone for slab object */
+#define KASAN_KMALLOC_FREE	0xFB  /* freed slab object */
+#define KASAN_VMALLOC_INVALID	0xF8  /* inaccessible space in vmap area */
 #else
-#define KASAN_FREE_PAGE         KASAN_TAG_INVALID
-#define KASAN_PAGE_REDZONE      KASAN_TAG_INVALID
-#define KASAN_KMALLOC_REDZONE   KASAN_TAG_INVALID
-#define KASAN_KMALLOC_FREE      KASAN_TAG_INVALID
-#define KASAN_VMALLOC_INVALID   KASAN_TAG_INVALID /* only used for SW_TAGS */
+#define KASAN_FREE_PAGE		KASAN_TAG_INVALID
+#define KASAN_PAGE_REDZONE	KASAN_TAG_INVALID
+#define KASAN_KMALLOC_REDZONE	KASAN_TAG_INVALID
+#define KASAN_KMALLOC_FREE	KASAN_TAG_INVALID
+#define KASAN_VMALLOC_INVALID	KASAN_TAG_INVALID /* only used for SW_TAGS */
 #endif
 
 #ifdef CONFIG_KASAN_GENERIC
 
-#define KASAN_KMALLOC_FREETRACK 0xFA  /* freed slab object with free track */
-#define KASAN_GLOBAL_REDZONE    0xF9  /* redzone for global variable */
+#define KASAN_KMALLOC_FREETRACK	0xFA  /* freed slab object with free track */
+#define KASAN_GLOBAL_REDZONE	0xF9  /* redzone for global variable */
 
 /* Stack redzone shadow values. Compiler ABI, do not change. */
-#define KASAN_STACK_LEFT        0xF1
-#define KASAN_STACK_MID         0xF2
-#define KASAN_STACK_RIGHT       0xF3
-#define KASAN_STACK_PARTIAL     0xF4
+#define KASAN_STACK_LEFT	0xF1
+#define KASAN_STACK_MID		0xF2
+#define KASAN_STACK_RIGHT	0xF3
+#define KASAN_STACK_PARTIAL	0xF4
 
 /* alloca redzone shadow values. */
 #define KASAN_ALLOCA_LEFT	0xCA
_

Patches currently in -mm which might be from andreyknvl@google.com are



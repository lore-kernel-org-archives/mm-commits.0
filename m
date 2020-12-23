Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A244C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 18:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA18B2246B
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 18:29:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbgLWS3h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Dec 2020 13:29:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:45102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728326AbgLWS3h (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Dec 2020 13:29:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B55E522286;
        Wed, 23 Dec 2020 18:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608748111;
        bh=bW/lqnCOSiEHIN6BsjkiyfPv2aNpAfobb5tvHJUibY4=;
        h=Date:From:To:Subject:From;
        b=jqqGqm6RZNakpJ+UI5D1nxz/0yWbmOjpAYB292orgfNlB2SgTZ8FI2Inpc19Sfyvy
         QACmNRp613UFd0reZX0JJv2FLRw4fZ7QdHf4nUFnkwc1Yyy9M0eM1iTUb8BtCAxxrV
         3WmsMdmbrxbcVdmJWcoR6zCZfXoaiKlm7leYKUU4=
Date:   Wed, 23 Dec 2020 10:28:30 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, gor@linux.ibm.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  [merged] kasan-define-kasan_memory_per_shadow_page.patch
 removed from -mm tree
Message-ID: <20201223182830.voRocwaYY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: define KASAN_MEMORY_PER_SHADOW_PAGE
has been removed from the -mm tree.  Its filename was
     kasan-define-kasan_memory_per_shadow_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: define KASAN_MEMORY_PER_SHADOW_PAGE

Define KASAN_MEMORY_PER_SHADOW_PAGE as (KASAN_GRANULE_SIZE << PAGE_SHIFT),
which is the same as (KASAN_GRANULE_SIZE * PAGE_SIZE) for software modes
that use shadow memory, and use it across KASAN code to simplify it.

Link: https://lkml.kernel.org/r/8329391cfe14b5cffd3decf3b5c535b6ce21eef6.1606161801.git.andreyknvl@google.com
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

 mm/kasan/init.c   |   10 ++++------
 mm/kasan/kasan.h  |    2 ++
 mm/kasan/shadow.c |   16 +++++++---------
 3 files changed, 13 insertions(+), 15 deletions(-)

--- a/mm/kasan/init.c~kasan-define-kasan_memory_per_shadow_page
+++ a/mm/kasan/init.c
@@ -441,9 +441,8 @@ void kasan_remove_zero_shadow(void *star
 	addr = (unsigned long)kasan_mem_to_shadow(start);
 	end = addr + (size >> KASAN_SHADOW_SCALE_SHIFT);
 
-	if (WARN_ON((unsigned long)start %
-			(KASAN_GRANULE_SIZE * PAGE_SIZE)) ||
-	    WARN_ON(size % (KASAN_GRANULE_SIZE * PAGE_SIZE)))
+	if (WARN_ON((unsigned long)start % KASAN_MEMORY_PER_SHADOW_PAGE) ||
+	    WARN_ON(size % KASAN_MEMORY_PER_SHADOW_PAGE))
 		return;
 
 	for (; addr < end; addr = next) {
@@ -476,9 +475,8 @@ int kasan_add_zero_shadow(void *start, u
 	shadow_start = kasan_mem_to_shadow(start);
 	shadow_end = shadow_start + (size >> KASAN_SHADOW_SCALE_SHIFT);
 
-	if (WARN_ON((unsigned long)start %
-			(KASAN_GRANULE_SIZE * PAGE_SIZE)) ||
-	    WARN_ON(size % (KASAN_GRANULE_SIZE * PAGE_SIZE)))
+	if (WARN_ON((unsigned long)start % KASAN_MEMORY_PER_SHADOW_PAGE) ||
+	    WARN_ON(size % KASAN_MEMORY_PER_SHADOW_PAGE))
 		return -EINVAL;
 
 	ret = kasan_populate_early_shadow(shadow_start, shadow_end);
--- a/mm/kasan/kasan.h~kasan-define-kasan_memory_per_shadow_page
+++ a/mm/kasan/kasan.h
@@ -8,6 +8,8 @@
 #define KASAN_GRANULE_SIZE	(1UL << KASAN_SHADOW_SCALE_SHIFT)
 #define KASAN_GRANULE_MASK	(KASAN_GRANULE_SIZE - 1)
 
+#define KASAN_MEMORY_PER_SHADOW_PAGE	(KASAN_GRANULE_SIZE << PAGE_SHIFT)
+
 #define KASAN_TAG_KERNEL	0xFF /* native kernel pointers tag */
 #define KASAN_TAG_INVALID	0xFE /* inaccessible memory tag */
 #define KASAN_TAG_MAX		0xFD /* maximum value for random tags */
--- a/mm/kasan/shadow.c~kasan-define-kasan_memory_per_shadow_page
+++ a/mm/kasan/shadow.c
@@ -161,7 +161,7 @@ static int __meminit kasan_mem_notifier(
 	shadow_end = shadow_start + shadow_size;
 
 	if (WARN_ON(mem_data->nr_pages % KASAN_GRANULE_SIZE) ||
-		WARN_ON(start_kaddr % (KASAN_GRANULE_SIZE << PAGE_SHIFT)))
+		WARN_ON(start_kaddr % KASAN_MEMORY_PER_SHADOW_PAGE))
 		return NOTIFY_BAD;
 
 	switch (action) {
@@ -432,22 +432,20 @@ void kasan_release_vmalloc(unsigned long
 	unsigned long region_start, region_end;
 	unsigned long size;
 
-	region_start = ALIGN(start, PAGE_SIZE * KASAN_GRANULE_SIZE);
-	region_end = ALIGN_DOWN(end, PAGE_SIZE * KASAN_GRANULE_SIZE);
+	region_start = ALIGN(start, KASAN_MEMORY_PER_SHADOW_PAGE);
+	region_end = ALIGN_DOWN(end, KASAN_MEMORY_PER_SHADOW_PAGE);
 
-	free_region_start = ALIGN(free_region_start,
-				  PAGE_SIZE * KASAN_GRANULE_SIZE);
+	free_region_start = ALIGN(free_region_start, KASAN_MEMORY_PER_SHADOW_PAGE);
 
 	if (start != region_start &&
 	    free_region_start < region_start)
-		region_start -= PAGE_SIZE * KASAN_GRANULE_SIZE;
+		region_start -= KASAN_MEMORY_PER_SHADOW_PAGE;
 
-	free_region_end = ALIGN_DOWN(free_region_end,
-				     PAGE_SIZE * KASAN_GRANULE_SIZE);
+	free_region_end = ALIGN_DOWN(free_region_end, KASAN_MEMORY_PER_SHADOW_PAGE);
 
 	if (end != region_end &&
 	    free_region_end > region_end)
-		region_end += PAGE_SIZE * KASAN_GRANULE_SIZE;
+		region_end += KASAN_MEMORY_PER_SHADOW_PAGE;
 
 	shadow_start = kasan_mem_to_shadow((void *)region_start);
 	shadow_end = kasan_mem_to_shadow((void *)region_end);
_

Patches currently in -mm which might be from andreyknvl@google.com are



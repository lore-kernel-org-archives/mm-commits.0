Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA3AFC433EF
	for <mm-commits@archiver.kernel.org>; Mon,  9 May 2022 18:48:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240361AbiEISwa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 May 2022 14:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240328AbiEISwX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2022 14:52:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D428202B13
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 11:48:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F37BB81906
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 18:48:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F95C385B2;
        Mon,  9 May 2022 18:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652122105;
        bh=T90aW4vbPI5N4Bu3jU9iSMWU9Du+3NN9MmiTIVFVN4E=;
        h=Date:To:From:Subject:From;
        b=gYoVP+7usxQFDgFCjvXLd/dcgsUA+7hIG9GfmDahlN8/fP7mWTb367JUkdHRtas/I
         TqUEI36dEL5Zv5NBOl1jognGnGFl4/7U6Dl2LbgIyi9MnKpYHsHNcF9qjOAcrDW2Av
         GhEAQ22+3AxEUIusC6Eb+HUM8extWbXWNIfjU6C8=
Date:   Mon, 09 May 2022 11:48:25 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-use-tabs-to-align-shadow-values.patch added to mm-unstable branch
Message-Id: <20220509184825.D4F95C385B2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: use tabs to align shadow values
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-use-tabs-to-align-shadow-values.patch

This patch should soon appear in the mm-unstable branch at
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

kasan-clean-up-comments-in-internal-kasanh.patch
kasan-use-tabs-to-align-shadow-values.patch
kasan-give-better-names-to-shadow-values.patch


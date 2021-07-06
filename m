Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B7F0C07E9C
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 20:42:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C7C461C99
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 20:42:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbhGFUpL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 16:45:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:44550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229781AbhGFUpK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 16:45:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94E8361C81;
        Tue,  6 Jul 2021 20:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625604151;
        bh=l50DFt45xOqJeoLZaTPN7gR0kq8okc27ktQjrmkX7bY=;
        h=Date:From:To:Subject:From;
        b=OSxosizpeN6a5Ig8n49rXn0Op2AgEUXVi7Ue5EEdsgGvKcAIXyxPGOD+oWOX2wB/j
         RnVX6OZIwSnM1yPB+ESjiPre6S9MVWF0nmoH/wPnWAlEpjRJsh0NplkevKowf6iecm
         PAH4K/Lzuj3poUWHyyooSzNC222Je23S5WLO/Ta4=
Date:   Tue, 06 Jul 2021 13:42:31 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        ryabinin.a.a@gmail.com, nicholas.tang@mediatek.com,
        Kuan-Ying.Lee@mediatek.com, glider@google.com, elver@google.com,
        dvyukov@google.com, chinwen.chang@mediatek.com,
        andreyknvl@gmail.com, yee.lee@mediatek.com
Subject:  + kasan-add-memzero-int-for-unaligned-size-at-debug.patch
 added to -mm tree
Message-ID: <20210706204231.9B6tB%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: add memzero int for unaligned size at DEBUG
has been added to the -mm tree.  Its filename is
     kasan-add-memzero-int-for-unaligned-size-at-debug.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-add-memzero-int-for-unaligned-size-at-debug.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-add-memzero-int-for-unaligned-size-at-debug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yee Lee <yee.lee@mediatek.com>
Subject: kasan: add memzero int for unaligned size at DEBUG

Issue: when SLUB debug is on, hwtag kasan_unpoison() would overwrite the
redzone of object with unaligned size.

An additional memzero_explicit() path is added to replacing init by hwtag
instruction for those unaligned size at SLUB debug mode.

The penalty is acceptable since they are only enabled in debug mode, not
production builds.  A block of comment is added for explanation.

Link: https://lkml.kernel.org/r/20210705103229.8505-3-yee.lee@mediatek.com
Signed-off-by: Yee Lee <yee.lee@mediatek.com>
Suggested-by: Andrey Konovalov <andreyknvl@gmail.com>
Suggested-by: Marco Elver <elver@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Nicholas Tang <nicholas.tang@mediatek.com>
Cc: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/mm/kasan/kasan.h~kasan-add-memzero-int-for-unaligned-size-at-debug
+++ a/mm/kasan/kasan.h
@@ -9,6 +9,7 @@
 #ifdef CONFIG_KASAN_HW_TAGS
 
 #include <linux/static_key.h>
+#include "../slab.h"
 
 DECLARE_STATIC_KEY_FALSE(kasan_flag_stacktrace);
 extern bool kasan_flag_async __ro_after_init;
@@ -387,6 +388,17 @@ static inline void kasan_unpoison(const
 
 	if (WARN_ON((unsigned long)addr & KASAN_GRANULE_MASK))
 		return;
+	/*
+	 * Explicitly initialize the memory with the precise object size to
+	 * avoid overwriting the SLAB redzone. This disables initialization in
+	 * the arch code and may thus lead to performance penalty. The penalty
+	 * is accepted since SLAB redzones aren't enabled in production builds.
+	 */
+	if (__slub_debug_enabled() &&
+	    init && ((unsigned long)size & KASAN_GRANULE_MASK)) {
+		init = false;
+		memzero_explicit((void *)addr, size);
+	}
 	size = round_up(size, KASAN_GRANULE_SIZE);
 
 	hw_set_mem_tag_range((void *)addr, size, tag, init);
_

Patches currently in -mm which might be from yee.lee@mediatek.com are

kasan-add-memzero-int-for-unaligned-size-at-debug.patch


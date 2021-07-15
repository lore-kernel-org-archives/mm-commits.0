Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D768C07E96
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 04:26:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0860261380
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 04:26:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236301AbhGOE3b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Jul 2021 00:29:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236290AbhGOE3a (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Jul 2021 00:29:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 995BB6136E;
        Thu, 15 Jul 2021 04:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626323198;
        bh=Yxw/iQdvu4ERPuk8Pnk2d2Jkwo9ubIWvEPxE/T+Wz2c=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ARfCsFB2i4J4dAye/bh5roieiiU3Ha4sJLZgUSyPgIx0W/tmgD5LibGca8j3IHEc3
         yq4j4xOFSjAJV+RBXToT+1nyQDXsK90wG6ZVZ1q8C3SzFjVLsePLSzp7E1uiMJk0jA
         as7wxMy1Ekk3rZAqqfOvR8kuOPT7pmQiErYY4R/Y=
Date:   Wed, 14 Jul 2021 21:26:37 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        chinwen.chang@mediatek.com, dvyukov@google.com, elver@google.com,
        glider@google.com, Kuan-Ying.Lee@mediatek.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, nicholas.tang@mediatek.com,
        ryabinin.a.a@gmail.com, torvalds@linux-foundation.org,
        willy@infradead.org, yee.lee@mediatek.com
Subject:  [patch 02/13] kasan: add memzero init for unaligned size
 at DEBUG
Message-ID: <20210715042637.B4Iu8-rX2%akpm@linux-foundation.org>
In-Reply-To: <20210714212609.fad116e584ba1194981a6294@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yee Lee <yee.lee@mediatek.com>
Subject: kasan: add memzero init for unaligned size at DEBUG

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
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
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

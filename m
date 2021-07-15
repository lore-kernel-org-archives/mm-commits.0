Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DB40C07E96
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 04:26:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66FC361362
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 04:26:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236285AbhGOE32 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Jul 2021 00:29:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:35808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230076AbhGOE31 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Jul 2021 00:29:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 687546128C;
        Thu, 15 Jul 2021 04:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626323194;
        bh=r9Dc2vpQIsIfeUy7vPPdEik9j8pDK7B1iwVP2VimDHA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=SYhkkQQ/BCTJ+5pkR+YcvfP/lA4k6KhQVlS7j2fU0Umw0ciP4bqVbOhdzwUJIauDv
         I3EBXwXScuRLJINa23tED+2d9y2jKUGHDgYsKV3aNcdBQfLskEt3nZcUeKu06MNShk
         xdGPU5nZSG7s/itF1f9d+5ecgcPc1srl8pHCGA6M=
Date:   Wed, 14 Jul 2021 21:26:34 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        chinwen.chang@mediatek.com, dvyukov@google.com, elver@google.com,
        glider@google.com, Kuan-Ying.Lee@mediatek.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, nicholas.tang@mediatek.com,
        ryabinin.a.a@gmail.com, torvalds@linux-foundation.org,
        willy@infradead.org, yee.lee@mediatek.com
Subject:  [patch 01/13] mm: move helper to check slub_debug_enabled
Message-ID: <20210715042634.Ah06LCkDl%akpm@linux-foundation.org>
In-Reply-To: <20210714212609.fad116e584ba1194981a6294@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Marco Elver <elver@google.com>
Subject: mm: move helper to check slub_debug_enabled

Move the helper to check slub_debug_enabled, so that we can confine the
use of #ifdef outside slub.c as well.

Link: https://lkml.kernel.org/r/20210705103229.8505-2-yee.lee@mediatek.com
Signed-off-by: Marco Elver <elver@google.com>
Signed-off-by: Yee Lee <yee.lee@mediatek.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: Nicholas Tang <nicholas.tang@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h |   15 +++++++++++----
 mm/slub.c |   14 --------------
 2 files changed, 11 insertions(+), 18 deletions(-)

--- a/mm/slab.h~mm-move-helper-to-check-slub_debug_enabled
+++ a/mm/slab.h
@@ -216,10 +216,18 @@ DECLARE_STATIC_KEY_FALSE(slub_debug_enab
 #endif
 extern void print_tracking(struct kmem_cache *s, void *object);
 long validate_slab_cache(struct kmem_cache *s);
+static inline bool __slub_debug_enabled(void)
+{
+	return static_branch_unlikely(&slub_debug_enabled);
+}
 #else
 static inline void print_tracking(struct kmem_cache *s, void *object)
 {
 }
+static inline bool __slub_debug_enabled(void)
+{
+	return false;
+}
 #endif
 
 /*
@@ -229,11 +237,10 @@ static inline void print_tracking(struct
  */
 static inline bool kmem_cache_debug_flags(struct kmem_cache *s, slab_flags_t flags)
 {
-#ifdef CONFIG_SLUB_DEBUG
-	VM_WARN_ON_ONCE(!(flags & SLAB_DEBUG_FLAGS));
-	if (static_branch_unlikely(&slub_debug_enabled))
+	if (IS_ENABLED(CONFIG_SLUB_DEBUG))
+		VM_WARN_ON_ONCE(!(flags & SLAB_DEBUG_FLAGS));
+	if (__slub_debug_enabled())
 		return s->flags & flags;
-#endif
 	return false;
 }
 
--- a/mm/slub.c~mm-move-helper-to-check-slub_debug_enabled
+++ a/mm/slub.c
@@ -120,25 +120,11 @@
  */
 
 #ifdef CONFIG_SLUB_DEBUG
-
 #ifdef CONFIG_SLUB_DEBUG_ON
 DEFINE_STATIC_KEY_TRUE(slub_debug_enabled);
 #else
 DEFINE_STATIC_KEY_FALSE(slub_debug_enabled);
 #endif
-
-static inline bool __slub_debug_enabled(void)
-{
-	return static_branch_unlikely(&slub_debug_enabled);
-}
-
-#else		/* CONFIG_SLUB_DEBUG */
-
-static inline bool __slub_debug_enabled(void)
-{
-	return false;
-}
-
 #endif		/* CONFIG_SLUB_DEBUG */
 
 static inline bool kmem_cache_debug(struct kmem_cache *s)
_

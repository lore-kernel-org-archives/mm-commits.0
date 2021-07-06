Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F122AC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 20:42:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C89E661C98
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 20:42:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhGFUpJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 16:45:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:44522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229781AbhGFUpJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 16:45:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9F8061C85;
        Tue,  6 Jul 2021 20:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625604149;
        bh=ObGTCeSX4KWSEw+FjVzslwECIyzWAqui4iyAS71WRvw=;
        h=Date:From:To:Subject:From;
        b=KqQK7nQeN6TkRgK7r7K7bGiUT704icFN/50VSCWCDqMG0Ie+w5CgkqjsQhSlE1VU1
         qvxGAFGIWirNtoX+blLkkQavnMPSLyVhczGR0uVaBhLapkifPGY7cnGh98TfDQKilW
         BA6GLMcpzv6vThlLcLpn6GIFj5/EB3V3PKUiAVRs=
Date:   Tue, 06 Jul 2021 13:42:28 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, yee.lee@mediatek.com,
        willy@infradead.org, ryabinin.a.a@gmail.com,
        nicholas.tang@mediatek.com, Kuan-Ying.Lee@mediatek.com,
        glider@google.com, dvyukov@google.com, chinwen.chang@mediatek.com,
        andreyknvl@gmail.com, elver@google.com
Subject:  + mm-move-helper-to-check-slub_debug_enabled.patch added to
 -mm tree
Message-ID: <20210706204228.UHkIR%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move helper to check slub_debug_enabled
has been added to the -mm tree.  Its filename is
     mm-move-helper-to-check-slub_debug_enabled.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-move-helper-to-check-slub_debug_enabled.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-move-helper-to-check-slub_debug_enabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -119,25 +119,11 @@
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

Patches currently in -mm which might be from elver@google.com are

mm-move-helper-to-check-slub_debug_enabled.patch


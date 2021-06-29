Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9582EC11F66
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:41:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E85761D0D
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:41:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbhF2Cn1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:43:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:35746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231348AbhF2Cn1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:43:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5485F61D0C;
        Tue, 29 Jun 2021 02:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934459;
        bh=7j3McdevtRxbA5VFvSxnkU9rJOJTvbC03MDt/g+lK0c=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=H54VlknOH/v90iHlfSYhCVpORhye6Z1XRZ+iXO70GOPTE4uOrTJ0tSiySTbqk262l
         Mf6G7F5bJWFVRyC/4Vc8u0zMbxX5YMMTjlibXzLqFsnoy1mj5G/H7QGVQPlKEx/yOC
         PMXyVyPovmQ5BDs4t9GgPevd5NBDLoV+6bl5ZB2A=
Date:   Mon, 28 Jun 2021 19:40:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        chinwen.chang@mediatek.com, dvyukov@google.com, elver@google.com,
        glider@google.com, gregkh@linuxfoundation.org,
        Kuan-Ying.Lee@mediatek.com, linux-mm@kvack.org,
        matthias.bgg@gmail.com, mm-commits@vger.kernel.org,
        nicholas.tang@mediatek.com, ryabinin.a.a@gmail.com,
        torvalds@linux-foundation.org
Subject:  [patch 147/192] kasan: add memory corruption
 identification support for hardware tag-based mode
Message-ID: <20210629024058.3yKEjoq_k%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Subject: kasan: add memory corruption identification support for hardware tag-based mode

Add memory corruption identification support for hardware tag-based mode. 
We store one old free pointer tag and free backtrace instead of five
because hardware tag-based kasan only has 16 different tags.

If we store as many stacks as SW tag-based kasan does(5 stacks), there is
high probability to find the same tag in the stacks when out-of-bound
issues happened and we will mistake out-of-bound issue for use-after-free.

Link: https://lkml.kernel.org/r/20210626100931.22794-4-Kuan-Ying.Lee@mediatek.com
Signed-off-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Suggested-by: Marco Elver <elver@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Nicholas Tang <nicholas.tang@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.kasan |    2 +-
 mm/kasan/kasan.h  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/lib/Kconfig.kasan~kasan-add-memory-corruption-identification-support-for-hardware-tag-based-mode
+++ a/lib/Kconfig.kasan
@@ -169,7 +169,7 @@ config KASAN_STACK
 
 config KASAN_TAGS_IDENTIFY
 	bool "Enable memory corruption identification"
-	depends on KASAN_SW_TAGS
+	depends on KASAN_SW_TAGS || KASAN_HW_TAGS
 	help
 	  This option enables best-effort identification of bug type
 	  (use-after-free or out-of-bounds) at the cost of increased
--- a/mm/kasan/kasan.h~kasan-add-memory-corruption-identification-support-for-hardware-tag-based-mode
+++ a/mm/kasan/kasan.h
@@ -153,7 +153,7 @@ struct kasan_track {
 	depot_stack_handle_t stack;
 };
 
-#ifdef CONFIG_KASAN_TAGS_IDENTIFY
+#if defined(CONFIG_KASAN_TAGS_IDENTIFY) && defined(CONFIG_KASAN_SW_TAGS)
 #define KASAN_NR_FREE_STACKS 5
 #else
 #define KASAN_NR_FREE_STACKS 1
_

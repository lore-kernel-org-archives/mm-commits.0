Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89D28C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  1 Apr 2022 18:21:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349795AbiDASXX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Apr 2022 14:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349998AbiDASXV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 1 Apr 2022 14:23:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF1150067
        for <mm-commits@vger.kernel.org>; Fri,  1 Apr 2022 11:21:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BB7B0CE2611
        for <mm-commits@vger.kernel.org>; Fri,  1 Apr 2022 18:21:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26CD4C340F3;
        Fri,  1 Apr 2022 18:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648837285;
        bh=/knbvi5deyVbrlKnCYUhqObXYTVpRvyGUO+/JJf9a/0=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=f/qUA62SZ/J6EUlq3tkH0BzbCMPtGOSBxtbLmrl4LKQfl5eGfawo81IJbtk+eSFTw
         D4r6T7wqdx3qBV0O5yPGB+6R0wIg4ruhsRMyOgLNgF/E7ogvjLfNRvWMcjsfOFQYAh
         llHqMZTBHzbtohrz0hWaiYV0X3JQKKfb3iqNBdJM=
Date:   Fri, 01 Apr 2022 11:21:24 -0700
To:     willy@infradead.org, vbabka@suse.cz, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        bigeasy@linutronix.de, andreyknvl@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <l>
Subject: [patch 12/16] mm, kasan: fix __GFP_BITS_SHIFT definition breaking LOCKDEP
Message-Id: <20220401182125.26CD4C340F3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: mm, kasan: fix __GFP_BITS_SHIFT definition breaking LOCKDEP

KASAN changes that added new GFP flags mistakenly updated __GFP_BITS_SHIFT
as the total number of GFP bits instead of as a shift used to define
__GFP_BITS_MASK.

This broke LOCKDEP, as __GFP_BITS_MASK now gets the 25th bit enabled
instead of the 28th for __GFP_NOLOCKDEP.

Update __GFP_BITS_SHIFT to always count KASAN GFP bits.

In the future, we could handle all combinations of KASAN and LOCKDEP to
occupy as few bits as possible.  For now, we have enough GFP bits to be
inefficient in this quick fix.

Link: https://lkml.kernel.org/r/462ff52742a1fcc95a69778685737f723ee4dfb3.1648400273.git.andreyknvl@google.com
Fixes: 9353ffa6e9e9 ("kasan, page_alloc: allow skipping memory init for HW_TAGS")
Fixes: 53ae233c30a6 ("kasan, page_alloc: allow skipping unpoisoning for HW_TAGS")
Fixes: f49d9c5bb15c ("kasan, mm: only define ___GFP_SKIP_KASAN_POISON with HW_TAGS")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/gfp.h~mm-kasan-fix-__gfp_bits_shift-definition-breaking-lockdep
+++ a/include/linux/gfp.h
@@ -264,9 +264,7 @@ struct vm_area_struct;
 #define __GFP_NOLOCKDEP ((__force gfp_t)___GFP_NOLOCKDEP)
 
 /* Room for N __GFP_FOO bits */
-#define __GFP_BITS_SHIFT (24 +						\
-			  3 * IS_ENABLED(CONFIG_KASAN_HW_TAGS) +	\
-			  IS_ENABLED(CONFIG_LOCKDEP))
+#define __GFP_BITS_SHIFT (27 + IS_ENABLED(CONFIG_LOCKDEP))
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 
 /**
_

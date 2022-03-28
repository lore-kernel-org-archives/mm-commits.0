Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78C08C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 28 Mar 2022 20:52:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243648AbiC1UyE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 16:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345598AbiC1UyD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 16:54:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59FE369CE2
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 13:52:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B7EFB811A2
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 20:52:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4EBFC340ED;
        Mon, 28 Mar 2022 20:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648500738;
        bh=UX0a30rfe6EMs6SmQOckl8o4J0DHyOnKIbZr7Fb8C2c=;
        h=Date:To:From:Subject:From;
        b=cpRx+SGcq31iCR5ENW4tNjpK7ZRz5CLo3l4E/TSYo83G9CxBHQfPLzVuXEa2E3oRx
         3tNqSXG7LDkUZw2/MhWlW5vekWhmzsP2D37zgcKtYx4+0Hf/hPJ3yOkU+lMVm8RhGw
         eswT1BlBDND30ETiUgDqPhs4kzXzUUldHFQYR1Vs=
Date:   Mon, 28 Mar 2022 13:52:17 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        ryabinin.a.a@gmail.com, glider@google.com, elver@google.com,
        dvyukov@google.com, bigeasy@linutronix.de, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kasan-fix-__gfp_bits_shift-definition-breaking-lockdep.patch added to -mm tree
Message-Id: <20220328205218.A4EBFC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, kasan: fix __GFP_BITS_SHIFT definition breaking LOCKDEP
has been added to the -mm tree.  Its filename is
     mm-kasan-fix-__gfp_bits_shift-definition-breaking-lockdep.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-kasan-fix-__gfp_bits_shift-definition-breaking-lockdep.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-kasan-fix-__gfp_bits_shift-definition-breaking-lockdep.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from andreyknvl@google.com are

mm-kasan-fix-__gfp_bits_shift-definition-breaking-lockdep.patch
stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch


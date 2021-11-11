Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6929CC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:40:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F2CC61260
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233929AbhKKCnQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:43:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:48842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233906AbhKKCnQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:43:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0E76610F7;
        Thu, 11 Nov 2021 02:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598427;
        bh=tLIkpZV+JrzexdE4k2yx1ssIEzWZgOnYW/KvV9Y8el4=;
        h=Date:From:To:Subject:From;
        b=lmxwcA6HUsM9yAudz/bzhPeKG5Y9SIDxrLqs86M+Qk5FsGEMbJT24e4kCAR2KGtVe
         33upsEZRiaD3O24p23FpSY5UTOvqE73gsMXO6v8TnNBg4juXzSJvoyC801PIEvZuFa
         Y7Ed6g7ecHkgzfKC5Hdn3ffCiAiwEDvPCRFxHxg8=
Date:   Wed, 10 Nov 2021 18:40:27 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, dvyukov@google.com, elver@google.com,
        glider@google.com, mm-commits@vger.kernel.org,
        ryabinin.a.a@gmail.com, willy@infradead.org
Subject:  [merged]
 kasan-fix-tag-for-large-allocations-when-using-config_slab.patch removed
 from -mm tree
Message-ID: <20211111024027.d6VJw3V-r%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix tag for large allocations when using CONFIG_SLAB
has been removed from the -mm tree.  Its filename was
     kasan-fix-tag-for-large-allocations-when-using-config_slab.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: kasan: fix tag for large allocations when using CONFIG_SLAB

If an object is allocated on a tail page of a multi-page slab, kasan will
get the wrong tag because page->s_mem is NULL for tail pages.  I'm not
quite sure what the user-visible effect of this might be.

Link: https://lkml.kernel.org/r/20211001024105.3217339-1-willy@infradead.org
Fixes: 7f94ffbc4c6a ("kasan: add hooks implementation for tag-based mode")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/common.c~kasan-fix-tag-for-large-allocations-when-using-config_slab
+++ a/mm/kasan/common.c
@@ -298,7 +298,7 @@ static inline u8 assign_tag(struct kmem_
 	/* For caches that either have a constructor or SLAB_TYPESAFE_BY_RCU: */
 #ifdef CONFIG_SLAB
 	/* For SLAB assign tags based on the object index in the freelist. */
-	return (u8)obj_to_index(cache, virt_to_page(object), (void *)object);
+	return (u8)obj_to_index(cache, virt_to_head_page(object), (void *)object);
 #else
 	/*
 	 * For SLUB assign a random tag during slab creation, otherwise reuse
_

Patches currently in -mm which might be from willy@infradead.org are

hitting-bug_on-trap-in-read_pages-mm-optimise-put_pages_list.patch


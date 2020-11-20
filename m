Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CDBAC2D0E4
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 21:24:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 303EB2242B
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 21:24:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ezr0inBg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728604AbgKTVYR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Nov 2020 16:24:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:49138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728296AbgKTVYQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 20 Nov 2020 16:24:16 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CD182240A;
        Fri, 20 Nov 2020 21:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1605907455;
        bh=QPEmobITRxdHM+GjM1qiJRizzgiPECV5Xb7/mBDD9Eg=;
        h=Date:From:To:Subject:From;
        b=Ezr0inBgBkA2XQstuPKDDsujG8p6G47nRJCpmHr82gRcwyqkCSvDZKSifPSKsLPuw
         wAaMBcmcitNEV30NJfOQ5P9G93j79OV1C3bfGNM76c/8ux0RIK5XseEtyqcdTF+JbG
         eU8V1z42SoLWwUo73ERvD0u6Z1HeDcmlA+D3m+EI=
Date:   Fri, 20 Nov 2020 13:24:14 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, glider@google.com, keescook@chromium.org,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, osalvador@suse.de,
        rppt@linux.ibm.com, vbabka@suse.cz
Subject:  +
 mm-page_alloc-clear-all-pages-in-post_alloc_hook-with-init_on_alloc=1.patch
 added to -mm tree
Message-ID: <20201120212414.KglFmsg2K%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: clear all pages in post_alloc_hook() with init_on_alloc=1
has been added to the -mm tree.  Its filename is
     mm-page_alloc-clear-all-pages-in-post_alloc_hook-with-init_on_alloc=1.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-clear-all-pages-in-post_alloc_hook-with-init_on_alloc%3D1.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-clear-all-pages-in-post_alloc_hook-with-init_on_alloc%3D1.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/page_alloc: clear all pages in post_alloc_hook() with init_on_alloc=1

commit 6471384af2a6 ("mm: security: introduce init_on_alloc=1 and
init_on_free=1 boot options") resulted with init_on_alloc=1 in all pages
leaving the buddy via alloc_pages() and friends to be
initialized/cleared/zeroed on allocation.

However, the same logic is currently not applied to alloc_contig_pages():
allocated pages leaving the buddy aren't cleared with init_on_alloc=1 and
init_on_free=0.  Let's also properly clear pages on that allocation path.

To achieve that, let's move clearing into post_alloc_hook().  This will
not only affect alloc_contig_pages() allocations but also any pages used
as migration target in compaction code via compaction_alloc().

While this sounds sub-optimal, it's the very same handling as when
allocating migration targets via alloc_migration_target() - pages will get
properly cleared with init_on_free=1.  In case we ever want to optimize
migration in that regard, we should tackle all such migration users - if
we believe migration code can be fully trusted.

With this change, we will see double clearing of pages in some cases.  One
example are gigantic pages (either allocated via CMA, or allocated
dynamically via alloc_contig_pages()) - which is the right thing to do
(and to be optimized outside of the buddy in the callers) as discussed in:
https://lkml.kernel.org/r/20201019182853.7467-1-gpiccoli@canonical.com

This change implies that with init_on_alloc=1
- All CMA allocations will be cleared
- Gigantic pages allocated via alloc_contig_pages() will be cleared
- virtio-mem memory to be unplugged will be cleared. While this is
  suboptimal, it's similar to memory balloon drivers handling, where
  all pages to be inflated will get cleared as well.
- Pages isolated for compaction will be cleared

Link: https://lkml.kernel.org/r/20201120180452.19071-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-clear-all-pages-in-post_alloc_hook-with-init_on_alloc=1
+++ a/mm/page_alloc.c
@@ -2283,6 +2283,9 @@ inline void post_alloc_hook(struct page
 	kasan_alloc_pages(page, order);
 	kernel_poison_pages(page, 1 << order, 1);
 	set_page_owner(page, order, gfp_flags);
+
+	if (!free_pages_prezeroed() && want_init_on_alloc(gfp_flags))
+		kernel_init_free_pages(page, 1 << order);
 }
 
 static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,
@@ -2290,9 +2293,6 @@ static void prep_new_page(struct page *p
 {
 	post_alloc_hook(page, order, gfp_flags);
 
-	if (!free_pages_prezeroed() && want_init_on_alloc(gfp_flags))
-		kernel_init_free_pages(page, 1 << order);
-
 	if (order && (gfp_flags & __GFP_COMP))
 		prep_compound_page(page, order);
 
_

Patches currently in -mm which might be from david@redhat.com are

mm-page_alloc-clear-pages-in-alloc_contig_pages-with-init_on_alloc=1-or-__gfp_zero.patch
mm-page_alloc-clear-all-pages-in-post_alloc_hook-with-init_on_alloc=1.patch


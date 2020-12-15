Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3846C3527E
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A59CE22D07
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgLOX7Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:32864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728367AbgLOXXd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:23:33 -0500
Date:   Tue, 15 Dec 2020 15:22:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074521;
        bh=rv0tJ/X4qlAVL04QEtEQcQSaSVhxU4EOdyvz1+3clCg=;
        h=From:To:Subject:From;
        b=ZSXHaIJYtzaoiWwJ1OkYQXJ9TZ+iXNmCXjqr9zV70Tm6nI66QD7tmoOyUZSPGKQKm
         HgGEgu4y2OXLUQaBHk49hAMbkW7TW+gTTr5DmoqKmiYsjeKU6T2+dkKmsAhesRUxkh
         0/pFoYyoptFHRzknyzDkCi1M7sr/RLTRmxMGuqwY=
From:   akpm@linux-foundation.org
To:     david@redhat.com, glider@google.com, keescook@chromium.org,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, osalvador@suse.de,
        rppt@linux.ibm.com, vbabka@suse.cz
Subject:  [merged]
 mm-page_alloc-clear-all-pages-in-post_alloc_hook-with-init_on_alloc=1.patch
 removed from -mm tree
Message-ID: <20201215232200.l39DbnE3I%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: clear all pages in post_alloc_hook() with init_on_alloc=1
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-clear-all-pages-in-post_alloc_hook-with-init_on_alloc=1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
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
@@ -2284,6 +2284,9 @@ inline void post_alloc_hook(struct page
 	kasan_alloc_pages(page, order);
 	kernel_poison_pages(page, 1 << order, 1);
 	set_page_owner(page, order, gfp_flags);
+
+	if (!free_pages_prezeroed() && want_init_on_alloc(gfp_flags))
+		kernel_init_free_pages(page, 1 << order);
 }
 
 static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,
@@ -2291,9 +2294,6 @@ static void prep_new_page(struct page *p
 {
 	post_alloc_hook(page, order, gfp_flags);
 
-	if (!free_pages_prezeroed() && want_init_on_alloc(gfp_flags))
-		kernel_init_free_pages(page, 1 << order);
-
 	if (order && (gfp_flags & __GFP_COMP))
 		prep_compound_page(page, order);
 
_

Patches currently in -mm which might be from david@redhat.com are



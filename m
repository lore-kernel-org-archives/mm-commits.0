Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E4DFC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 03:31:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43162611EE
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 03:31:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233856AbhIPDcs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Sep 2021 23:32:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234065AbhIPDcp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Sep 2021 23:32:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEC29611C4;
        Thu, 16 Sep 2021 03:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631763086;
        bh=PKBgf8xaCEGt4tg4tRnTIFZp8U8TI/0DM97Xbbi0uWQ=;
        h=Date:From:To:Subject:From;
        b=pBmh33l4ri57EGp6UBHCk5lC0NKoReOKUwQhN+aG475aZGBSLz2fqUhUo4oaFhXCA
         +R2w1D2UtcIldTDbyLBp4yGVQDUAhRwgeNKfzfLbxHsIlBjgeabz9lcCxZvQ3Se0ml
         2D/NhUlSwlvE2mfVjjctyy3rpt2gNp/IU9tVrOgc=
Date:   Wed, 15 Sep 2021 20:31:25 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        peterz@infradead.org, sfr@canb.auug.org.au, vbabka@suse.cz
Subject:  + mm-page_allocc-simplify-the-code-by-using-macro-k.patch
 added to -mm tree
Message-ID: <20210916033125.x9ZkymQ7w%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: simplify the code by using macro K()
has been added to the -mm tree.  Its filename is
     mm-page_allocc-simplify-the-code-by-using-macro-k.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_allocc-simplify-the-code-by-using-macro-k.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_allocc-simplify-the-code-by-using-macro-k.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/page_alloc.c: simplify the code by using macro K()

Use helper macro K() to convert the pages to the corresponding size. 
Minor readability improvement.

Link: https://lkml.kernel.org/r/20210902121242.41607-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-simplify-the-code-by-using-macro-k
+++ a/mm/page_alloc.c
@@ -8124,8 +8124,7 @@ unsigned long free_reserved_area(void *s
 	}
 
 	if (pages && s)
-		pr_info("Freeing %s memory: %ldK\n",
-			s, pages << (PAGE_SHIFT - 10));
+		pr_info("Freeing %s memory: %ldK\n", s, K(pages));
 
 	return pages;
 }
@@ -8170,14 +8169,13 @@ void __init mem_init_print_info(void)
 		", %luK highmem"
 #endif
 		")\n",
-		nr_free_pages() << (PAGE_SHIFT - 10),
-		physpages << (PAGE_SHIFT - 10),
+		K(nr_free_pages()), K(physpages),
 		codesize >> 10, datasize >> 10, rosize >> 10,
 		(init_data_size + init_code_size) >> 10, bss_size >> 10,
-		(physpages - totalram_pages() - totalcma_pages) << (PAGE_SHIFT - 10),
-		totalcma_pages << (PAGE_SHIFT - 10)
+		K(physpages - totalram_pages() - totalcma_pages),
+		K(totalcma_pages)
 #ifdef	CONFIG_HIGHMEM
-		, totalhigh_pages() << (PAGE_SHIFT - 10)
+		, K(totalhigh_pages())
 #endif
 		);
 }
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_allocc-remove-meaningless-vm_bug_on-in-pindex_to_order.patch
mm-page_allocc-simplify-the-code-by-using-macro-k.patch
mm-page_allocc-fix-obsolete-comment-in-free_pcppages_bulk.patch
mm-page_allocc-use-helper-function-zone_spans_pfn.patch
mm-page_allocc-avoid-allocating-highmem-pages-via-alloc_pages_exact.patch
mm-page_isolation-fix-potential-missing-call-to-unset_migratetype_isolate.patch
mm-page_isolation-guard-against-possible-putback-unisolated-page.patch
mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch


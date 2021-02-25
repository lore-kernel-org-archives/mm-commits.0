Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C551BC433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:34:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8923664F28
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234407AbhBYTdu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:33:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:38106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233944AbhBYTaC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:30:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9470264F95;
        Thu, 25 Feb 2021 19:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280603;
        bh=EPX+n834PcVzgtKe+/s9LihwmcbOB0+XDVWKm1UBATQ=;
        h=Date:From:To:Subject:From;
        b=LkTQKqQBjQcfXg8dITEzNy3PyKfvyCl131qk28vqnMmDm2emYp6DcDx7ppQN4w/M8
         aYnI3hupeS1qKOsOM10CTpSAVllbEaQhzbDMM0AJY4FPSZtqsVRUhYwxq1d5Q4ECrN
         JhR0rEem750eUwSCnB1odbGQTFTXgbhUr5cI/ei0=
Date:   Thu, 25 Feb 2021 11:16:43 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-hugetlb-use-helper-huge_page_order-and-pages_per_huge_page.patch removed
 from -mm tree
Message-ID: <20210225191643.J9OqJ-434%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: use helper huge_page_order and pages_per_huge_page
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-use-helper-huge_page_order-and-pages_per_huge_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: use helper huge_page_order and pages_per_huge_page

Since commit a5516438959d ("hugetlb: modular state for hugetlb page
size"), we can use huge_page_order to access hstate->order and
pages_per_huge_page to fetch the pages per huge page.  But
gather_bootmem_prealloc() forgot to use it.

Link: https://lkml.kernel.org/r/20210114114435.40075-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-helper-huge_page_order-and-pages_per_huge_page
+++ a/mm/hugetlb.c
@@ -2476,7 +2476,7 @@ static void __init gather_bootmem_preall
 		struct hstate *h = m->hstate;
 
 		WARN_ON(page_count(page) != 1);
-		prep_compound_huge_page(page, h->order);
+		prep_compound_huge_page(page, huge_page_order(h));
 		WARN_ON(PageReserved(page));
 		prep_new_huge_page(h, page, page_to_nid(page));
 		put_page(page); /* free it into the hugepage allocator */
@@ -2488,7 +2488,7 @@ static void __init gather_bootmem_preall
 		 * side-effects, like CommitLimit going negative.
 		 */
 		if (hstate_is_gigantic(h))
-			adjust_managed_page_count(page, 1 << h->order);
+			adjust_managed_page_count(page, pages_per_huge_page(h));
 		cond_resched();
 	}
 }
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory_hotplug-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-mlock-stop-counting-mlocked-pages-when-none-vma-is-found.patch
mm-rmap-correct-some-obsolete-comments-of-anon_vma.patch
mm-rmap-remove-unneeded-semicolon-in-page_not_mapped.patch
mm-rmap-fix-obsolete-comment-in-__page_check_anon_rmap.patch
mm-rmap-use-page_not_mapped-in-try_to_unmap.patch
mm-rmap-correct-obsolete-comment-of-page_get_anon_vma.patch
mm-rmap-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch
mm-zsmallocc-use-page_private-to-access-page-private.patch


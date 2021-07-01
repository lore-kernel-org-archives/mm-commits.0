Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B51D0C11F69
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:47:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DCE06146D
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238340AbhGABuS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:50:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:39592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237149AbhGABuS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:50:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E388F6120C;
        Thu,  1 Jul 2021 01:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104067;
        bh=0Y9TreA1BTIYY2tKgHs7riBKdzT/8e6/D20+LtH+EJA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PjIh2ONn1dtCeX+SgTUQXoa/6i9HVhxTJZcWrmkDE3n0S4iwuD/eKe9dz99T00Lz1
         FcP0jWpyZKKHte2tJiqf74D4CXhXm+PbsyshiKL30eHYf+Ujz59+rAkCJvGvIXbToP
         SOcLeiSa/5scRyuV6lhcoo3ufWZHUsY569A0smj8=
Date:   Wed, 30 Jun 2021 18:47:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com,
        david@redhat.com, hannes@cmpxchg.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mike.kravetz@oracle.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com, riel@surriel.com,
        shy828301@gmail.com, songliubraving@fb.com,
        torvalds@linux-foundation.org, william.kucharski@oracle.com,
        willy@infradead.org, ziy@nvidia.com
Subject:  [patch 013/192] mm/huge_memory.c: use page->deferred_list
Message-ID: <20210701014746.deARj1PP8%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/huge_memory.c: use page->deferred_list

Now that we can represent the location of ->deferred_list instead of
->mapping + ->index, make use of it to improve readability.

Link: https://lkml.kernel.org/r/20210511134857.1581273-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memoryc-use-page-deferred_list
+++ a/mm/huge_memory.c
@@ -2870,7 +2870,7 @@ static unsigned long deferred_split_scan
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
 	/* Take pin on all head pages to avoid freeing them under us */
 	list_for_each_safe(pos, next, &ds_queue->split_queue) {
-		page = list_entry((void *)pos, struct page, mapping);
+		page = list_entry((void *)pos, struct page, deferred_list);
 		page = compound_head(page);
 		if (get_page_unless_zero(page)) {
 			list_move(page_deferred_list(page), &list);
@@ -2885,7 +2885,7 @@ static unsigned long deferred_split_scan
 	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
 
 	list_for_each_safe(pos, next, &list) {
-		page = list_entry((void *)pos, struct page, mapping);
+		page = list_entry((void *)pos, struct page, deferred_list);
 		if (!trylock_page(page))
 			goto next;
 		/* split_huge_page() removes page from list on success */
_

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D888DC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAA386113B
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234276AbhKKCqh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:46:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:51774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234240AbhKKCqh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:46:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8266860F46;
        Thu, 11 Nov 2021 02:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598628;
        bh=2ov//rtEYUouRkhGQorzhnt1shsJltxTtopprL5ELu4=;
        h=Date:From:To:Subject:From;
        b=GCBU+RiISmW9LBfK4aWgbkHcgcBeClt1ooE6AwzbCHbkRp4ayPp+PZ+Vb0NIQKBLI
         9iz35IZWFcqMoTn/LJc+kEzEFo057vBHvuUEhBK6vPOKqwTeFPOuBfli8ZRNdqpNzs
         ICV946fOB/PWZK126nb/ZFQC/6Axv6D8CWneL+5E=
Date:   Wed, 10 Nov 2021 18:43:48 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        peterz@infradead.org, sfr@canb.auug.org.au, vbabka@suse.cz
Subject:  [merged]
 mm-page_allocc-simplify-the-code-by-using-macro-k.patch removed from -mm
 tree
Message-ID: <20211111024348.uTteCJot1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: simplify the code by using macro K()
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-simplify-the-code-by-using-macro-k.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -8130,8 +8130,7 @@ unsigned long free_reserved_area(void *s
 	}
 
 	if (pages && s)
-		pr_info("Freeing %s memory: %ldK\n",
-			s, pages << (PAGE_SHIFT - 10));
+		pr_info("Freeing %s memory: %ldK\n", s, K(pages));
 
 	return pages;
 }
@@ -8176,14 +8175,13 @@ void __init mem_init_print_info(void)
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



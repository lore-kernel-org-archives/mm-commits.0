Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 951E4C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:40:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EF0261279
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:40:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233504AbhKEUms (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:42:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233489AbhKEUmq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:42:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B18C6056B;
        Fri,  5 Nov 2021 20:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144806;
        bh=d6gn+ixdceP9Bxg3VhLYYjfPb4KMkyQcz6rHhqmc4ZA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=zdS0Bpnw4kvPHLVKiVS44SpbfPLKuYAxeKHEDyWkPltx6SBxVctSvzIXfONeSW7tc
         B8ZDYjz4ta1OOJTs8Kzjg3cmUF0Kka6MXP75ZnkrU0eqSeIE6TFd/K7V+w/5GzhYA6
         VStJj0D9PDHo2pz3JRydgNg2aA0M2TtdN6kIe2cY=
Date:   Fri, 05 Nov 2021 13:40:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        sfr@canb.auug.org.au, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 104/262] mm/page_alloc.c: simplify the code by
 using macro K()
Message-ID: <20211105204005.x38Vwho4S%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

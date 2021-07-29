Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FF52C4338F
	for <mm-commits@archiver.kernel.org>; Thu, 29 Jul 2021 21:53:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 886AC60FD7
	for <mm-commits@archiver.kernel.org>; Thu, 29 Jul 2021 21:53:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbhG2Vxx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Jul 2021 17:53:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:37884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234019AbhG2Vxw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 29 Jul 2021 17:53:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F37260F5C;
        Thu, 29 Jul 2021 21:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627595628;
        bh=0CPZlj+fWC8wwVbGpQ/ZrTe4EeZiizNkZCuDLtS81h8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=b4M0UzVWksn4kyIw0Cb4NewKZmLyixKG0CDu/gkzLB+DnWYKahTCHt8wlXLI4OLEG
         nce1VYurhzJJJwJd2UKrQB0Ioahjl/s2b2Niqu00TaxFHZfUbNz4scB2M+uL5fLhfu
         ZeEwjvbjcwy0SwUAVbFDbKsNo4uLXzb8ou0e/7l8=
Date:   Thu, 29 Jul 2021 14:53:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aik@ozlabs.ru, akpm@linux-foundation.org,
        aneesh.kumar@linux.ibm.com, david@redhat.com, linux-mm@kvack.org,
        mgorman@suse.de, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        npiggin@gmail.com, shy828301@gmail.com,
        torvalds@linux-foundation.org
Subject:  [patch 5/7] mm/migrate: fix NR_ISOLATED corruption on
 64-bit
Message-ID: <20210729215347.QTp5MNe-m%akpm@linux-foundation.org>
In-Reply-To: <20210729145259.24681c326dc3ed18194cf9e5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/migrate: fix NR_ISOLATED corruption on 64-bit

Similar to commit 2da9f6305f30 ("mm/vmscan: fix NR_ISOLATED_FILE
corruption on 64-bit") avoid using unsigned int for nr_pages.  With
unsigned int type the large unsigned int converts to a large positive
signed long.

Symptoms include CMA allocations hanging forever due to
alloc_contig_range->...->isolate_migratepages_block waiting forever in
"while (unlikely(too_many_isolated(pgdat)))".

Link: https://lkml.kernel.org/r/20210728042531.359409-1-aneesh.kumar@linux.ibm.com
Fixes: c5fc5c3ae0c8 ("mm: migrate: account THP NUMA migration counters correctly")
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reported-by: Michael Ellerman <mpe@ellerman.id.au>
Reported-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-fix-nr_isolated-corruption-on-64-bit
+++ a/mm/migrate.c
@@ -2068,7 +2068,7 @@ int migrate_misplaced_page(struct page *
 	LIST_HEAD(migratepages);
 	new_page_t *new;
 	bool compound;
-	unsigned int nr_pages = thp_nr_pages(page);
+	int nr_pages = thp_nr_pages(page);
 
 	/*
 	 * PTE mapped THP or HugeTLB page can't reach here so the page could
_

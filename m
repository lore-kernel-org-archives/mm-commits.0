Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE617C4320A
	for <mm-commits@archiver.kernel.org>; Sun,  1 Aug 2021 19:12:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F501610A1
	for <mm-commits@archiver.kernel.org>; Sun,  1 Aug 2021 19:12:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhHATMK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Aug 2021 15:12:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229937AbhHATMJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 1 Aug 2021 15:12:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94E4B61075;
        Sun,  1 Aug 2021 19:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627845120;
        bh=+sjY0YKZOzzPyfFJhRIRwzd/R2nPa9krY+F40Uot574=;
        h=Date:From:To:Subject:From;
        b=HIsN5de7q86EPtVbBIvUY5gm7yrHBuqBuv764u6PLHSTaPIMudO8TntZUjcfo6AOr
         oYE42yCfg9/QugQpw97PZEL8x+zWbaxskoOWNQvsLd+GuNZE0KZgjh85r9b3nd4nsm
         eHYUP2FR6VgkuIokg/tvrw4n/1zm3NFRWAxvXCSs=
Date:   Sun, 01 Aug 2021 12:12:00 -0700
From:   akpm@linux-foundation.org
To:     aik@ozlabs.ru, aneesh.kumar@linux.ibm.com, david@redhat.com,
        mgorman@suse.de, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        npiggin@gmail.com, shy828301@gmail.com
Subject:  [merged]
 mm-migrate-fix-nr_isolated-corruption-on-64-bit.patch removed from -mm tree
Message-ID: <20210801191200.cUQyQWvH5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: fix NR_ISOLATED corruption on 64-bit
has been removed from the -mm tree.  Its filename was
     mm-migrate-fix-nr_isolated-corruption-on-64-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are



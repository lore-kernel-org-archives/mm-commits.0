Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 670CCC4338F
	for <mm-commits@archiver.kernel.org>; Wed, 28 Jul 2021 19:31:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4673061042
	for <mm-commits@archiver.kernel.org>; Wed, 28 Jul 2021 19:31:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhG1Tbq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Jul 2021 15:31:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:59016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229542AbhG1Tbp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 28 Jul 2021 15:31:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A8A661040;
        Wed, 28 Jul 2021 19:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627500702;
        bh=70k4HwtJIAP/DebnclGmkZ8yKAgh7IoogeD4dhVB0Jo=;
        h=Date:From:To:Subject:From;
        b=JaUJJZjyD3PVKf8Z9TbhMmPDpn247aj91fdkAmAgm7ShGj2sKl/ZdUwGyQEk2p6hO
         YGWAh1h8SIk/OWtRTjVbeotfA99OalenzxPLcU2JU+/Fq/uEba5z9u0o6dza4lutFu
         JoiGissGX/iY/z70HJGSSmA/6CDLZz8/pqGVCw+8=
Date:   Wed, 28 Jul 2021 12:31:42 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, shy828301@gmail.com, npiggin@gmail.com,
        mpe@ellerman.id.au, mgorman@suse.de, david@redhat.com,
        aik@ozlabs.ru, aneesh.kumar@linux.ibm.com
Subject:  + mm-migrate-fix-nr_isolated-corruption-on-64-bit.patch
 added to -mm tree
Message-ID: <20210728193142.6nt8Z%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: fix NR_ISOLATED corruption on 64-bit
has been added to the -mm tree.  Its filename is
     mm-migrate-fix-nr_isolated-corruption-on-64-bit.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-fix-nr_isolated-corruption-on-64-bit.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-fix-nr_isolated-corruption-on-64-bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Yang Shi <shy828301@gmail.com>
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

mm-migrate-fix-nr_isolated-corruption-on-64-bit.patch


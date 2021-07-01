Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91D69C11F6A
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:51:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76E4F61241
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:51:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238478AbhGAByR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:54:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:43762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238427AbhGAByQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:54:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCF0C6146D;
        Thu,  1 Jul 2021 01:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104306;
        bh=/6mnSpYzINtTUTiv5Z/54zQUx/epEwshhh6aQvPtpas=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LAQ04JoGVc8qP0vDgViTGXL8TZF2NhNSfaSlce7MZ2e3vWh60tU7kh+Nj3UNu998c
         FynBRC3c9dlVaToXRd0T92Lsu7jckW/rmV5kClwXXqG06wy39fP56U3yZD/aim+B9H
         q6A5Xgri4Q+kler4QrAMQpXI3gI7xgIZFOXqpy2g=
Date:   Wed, 30 Jun 2021 18:51:45 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, borntraeger@de.ibm.com,
        gerald.schaefer@linux.ibm.com, gor@linux.ibm.com,
        hca@linux.ibm.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org,
        shy828301@gmail.com, torvalds@linux-foundation.org,
        ying.huang@intel.com, ziy@nvidia.com
Subject:  [patch 086/192] mm: migrate: account THP NUMA migration
 counters correctly
Message-ID: <20210701015145.SwXVL5Q0x%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yang Shi <shy828301@gmail.com>
Subject: mm: migrate: account THP NUMA migration counters correctly

Now both base page and THP NUMA migration is done via
migrate_misplaced_page(), keep the counters correctly for THP.

Link: https://lkml.kernel.org/r/20210518200801.7413-5-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/migrate.c~mm-migrate-account-thp-numa-migration-counters-correctly
+++ a/mm/migrate.c
@@ -2117,6 +2117,7 @@ int migrate_misplaced_page(struct page *
 	LIST_HEAD(migratepages);
 	new_page_t *new;
 	bool compound;
+	unsigned int nr_pages = thp_nr_pages(page);
 
 	/*
 	 * PTE mapped THP or HugeTLB page can't reach here so the page could
@@ -2155,13 +2156,13 @@ int migrate_misplaced_page(struct page *
 	if (nr_remaining) {
 		if (!list_empty(&migratepages)) {
 			list_del(&page->lru);
-			dec_node_page_state(page, NR_ISOLATED_ANON +
-					page_is_file_lru(page));
+			mod_node_page_state(page_pgdat(page), NR_ISOLATED_ANON +
+					page_is_file_lru(page), -nr_pages);
 			putback_lru_page(page);
 		}
 		isolated = 0;
 	} else
-		count_vm_numa_event(NUMA_PAGE_MIGRATE);
+		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_pages);
 	BUG_ON(!list_empty(&migratepages));
 	return isolated;
 
_

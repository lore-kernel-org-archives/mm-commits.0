Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABF0EC07E9E
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:19:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97F7461C96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:19:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbhGFTWT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:22:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:55974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231829AbhGFTWS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:22:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DD0E61C7F;
        Tue,  6 Jul 2021 19:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599180;
        bh=0h8323BYkpDr2x22YYKpSjnaOQVlWTkZwdo6zgem/GA=;
        h=Date:From:To:Subject:From;
        b=vMWM5kIEp62Ka/xQRLxpEdAQcKQbF4OpKf5YVOEpZKl/4cU+4dGcKTkO4MwKrVSE1
         sYHKlQyeY+o4noLdgDcNi+264ec1DflMZiVFXLoGTW5A72p7xEXsgBUHF7nwBg+xa1
         1hF0rXpS5/pIuB+sOtpst2ue3d7KtwtRxNRwN618=
Date:   Tue, 06 Jul 2021 12:19:39 -0700
From:   akpm@linux-foundation.org
To:     borntraeger@de.ibm.com, gerald.schaefer@linux.ibm.com,
        gor@linux.ibm.com, hca@linux.ibm.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        ying.huang@intel.com, ziy@nvidia.com
Subject:  [merged]
 mm-migrate-account-thp-numa-migration-counters-correctly.patch removed from
 -mm tree
Message-ID: <20210706191939.bx4MWW2vb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: account THP NUMA migration counters correctly
has been removed from the -mm tree.  Its filename was
     mm-migrate-account-thp-numa-migration-counters-correctly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from shy828301@gmail.com are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D47EEC43219
	for <mm-commits@archiver.kernel.org>; Mon,  4 Apr 2022 21:39:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380133AbiDDVk1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Apr 2022 17:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379968AbiDDS34 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Apr 2022 14:29:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E5313F48
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 11:27:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E70F1B818E7
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 18:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A61ADC2BBE4;
        Mon,  4 Apr 2022 18:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649096876;
        bh=UsWsru6FqYcfELEQGZ+RSq/VBF+ChxL1tiF5cM5gsPI=;
        h=Date:To:From:Subject:From;
        b=sl/VoQhTJntXgk0wue4uKYBX1xrf7sWSw23mURWm2ju7lpxvzaezu/U+JQl+aMGjq
         j2YdBwlPFor0I0U16Ky7Yr5RgbqF0eMiIo5iiIg9Qf2dDJLtHt8X43DsTLnh1MdsZ6
         yU+S0IdWcmcRXsDGQzohQ/JizAkT+UOIgF4gppFY=
Date:   Mon, 04 Apr 2022 11:27:55 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        naoya.horiguchi@linux.dev, mhocko@kernel.org, ziy@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-use-thp_order-instead-of-hpage_pmd_order-for-new-page-allocation.patch added to -mm tree
Message-Id: <20220404182756.A61ADC2BBE4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: use thp_order instead of HPAGE_PMD_ORDER for new page allocation.
has been added to the -mm tree.  Its filename is
     mm-migrate-use-thp_order-instead-of-hpage_pmd_order-for-new-page-allocation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-use-thp_order-instead-of-hpage_pmd_order-for-new-page-allocation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-use-thp_order-instead-of-hpage_pmd_order-for-new-page-allocation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm: migrate: use thp_order instead of HPAGE_PMD_ORDER for new page allocation.

Fix a VM_BUG_ON_FOLIO(folio_nr_pages(old) != nr_pages) crash.

With folios support, it is possible to have other than HPAGE_PMD_ORDER
THPs, in the form of folios, in the system.  Use thp_order() to correctly
determine the source page order during migration.

Link: https://lkml.kernel.org/r/20220404165325.1883267-1-zi.yan@sent.com
Link: https://lore.kernel.org/linux-mm/20220404132908.GA785673@u2004/
Fixes: d68eccad3706 ("mm/filemap: Allow large folios to be added to the pag=
e cache")
Reported-by: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 mm/migrate.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mempolicy.c~mm-migrate-use-thp_order-instead-of-hpage_pmd_order-for-new-page-allocation
+++ a/mm/mempolicy.c
@@ -1209,7 +1209,7 @@ static struct page *new_page(struct page
 		struct page *thp;
 
 		thp = alloc_hugepage_vma(GFP_TRANSHUGE, vma, address,
-					 HPAGE_PMD_ORDER);
+					 thp_order(page));
 		if (!thp)
 			return NULL;
 		prep_transhuge_page(thp);
--- a/mm/migrate.c~mm-migrate-use-thp_order-instead-of-hpage_pmd_order-for-new-page-allocation
+++ a/mm/migrate.c
@@ -1547,7 +1547,7 @@ struct page *alloc_migration_target(stru
 		 */
 		gfp_mask &= ~__GFP_RECLAIM;
 		gfp_mask |= GFP_TRANSHUGE;
-		order = HPAGE_PMD_ORDER;
+		order = thp_order(page);
 	}
 	zidx = zone_idx(page_zone(page));
 	if (is_highmem_idx(zidx) || zidx == ZONE_MOVABLE)
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-migrate-use-thp_order-instead-of-hpage_pmd_order-for-new-page-allocation.patch


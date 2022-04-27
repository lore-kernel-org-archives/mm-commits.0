Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C866FC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 03:08:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241919AbiD0DLO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Apr 2022 23:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357386AbiD0DKx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2022 23:10:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6113191D
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 20:07:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 567DAB824A0
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 03:07:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C88C385A0;
        Wed, 27 Apr 2022 03:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651028860;
        bh=6bJ8Q0XwVe8YPi68ZVx0G9nQEP7HlkLYyRsTHxCFJek=;
        h=Date:To:From:Subject:From;
        b=JBvT824JDB0y289U21xHvxGIKAYcneigpSR7Dvhgi0V/udx8CNttBL4q8KoGokuiA
         XUtETrqDSmJHNRQFiHLP1ITM3Uaa5rMNWT6y7bxzv/nW9ea0DVqERQ85xJ4t8A6IgO
         DssZmzaNGghEXbC5vz1tH/6e2dtPiw37YmzZdH+Y=
Date:   Tue, 26 Apr 2022 20:07:40 -0700
To:     mm-commits@vger.kernel.org, anshuman.khandual@arm.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] arm64-mm-hugetlb-enable-hugetlb_page_free_vmemmap-for-arm64-fix.patch removed from -mm tree
Message-Id: <20220427030740.D6C88C385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: mm: hugetlb: restructure the code comment inside flush_dcache_page()
has been removed from the -mm tree.  Its filename was
     arm64-mm-hugetlb-enable-hugetlb_page_free_vmemmap-for-arm64-fix.patch

This patch was dropped because it was folded into arm64-mm-hugetlb-enable-hugetlb_page_free_vmemmap-for-arm64.patch

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: arm64: mm: hugetlb: restructure the code comment inside flush_dcache_page()

Restructure the code comment inside flush_dcache_page() to make it more
clear.

Link: https://lkml.kernel.org/r/20220414072646.21910-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/flush.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/arch/arm64/mm/flush.c~arm64-mm-hugetlb-enable-hugetlb_page_free_vmemmap-for-arm64-fix
+++ a/arch/arm64/mm/flush.c
@@ -81,9 +81,10 @@ void flush_dcache_page(struct page *page
 	 * read-only when CONFIG_HUGETLB_PAGE_FREE_VMEMMAP is enabled (more
 	 * details can refer to vmemmap_remap_pte()).  Although
 	 * __sync_icache_dcache() only set PG_dcache_clean flag on the head
-	 * page struct, some tail page structs still can be seen the flag is
-	 * set since the head vmemmap page frame is reused (more details can
-	 * refer to the comments above page_fixed_fake_head()).
+	 * page struct, there is more than one page struct with PG_dcache_clean
+	 * associated with the HugeTLB page since the head vmemmap page frame
+	 * is reused (more details can refer to the comments above
+	 * page_fixed_fake_head()).
 	 */
 	if (hugetlb_free_vmemmap_enabled() && PageHuge(page))
 		page = compound_head(page);
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb_vmemmap-introduce-arch_want_hugetlb_page_free_vmemmap.patch
arm64-mm-hugetlb-enable-hugetlb_page_free_vmemmap-for-arm64.patch
mm-rmap-fix-cache-flush-on-thp-pages.patch
dax-fix-cache-flush-on-pmd-mapped-pages.patch
mm-rmap-introduce-pfn_mkclean_range-to-cleans-ptes.patch
mm-pvmw-add-support-for-walking-devmap-pages.patch
dax-fix-missing-writeprotect-the-pte-entry.patch
mm-simplify-follow_invalidate_pte.patch
mm-hugetlb_vmemmap-cleanup-hugetlb_vmemmap-related-functions.patch
mm-hugetlb_vmemmap-cleanup-hugetlb_free_vmemmap_enabled.patch
mm-hugetlb_vmemmap-cleanup-config_hugetlb_page_free_vmemmap.patch


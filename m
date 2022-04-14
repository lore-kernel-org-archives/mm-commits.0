Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C55C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 14 Apr 2022 21:00:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237557AbiDNVCm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Apr 2022 17:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346739AbiDNVCk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Apr 2022 17:02:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E9CD4C80
        for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2022 14:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDF2B61F90
        for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2022 21:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D79C385A1;
        Thu, 14 Apr 2022 21:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649970013;
        bh=CFtte09FlHDIZqlNLGA1Sf9LExqelVUjCFxi8sTZsEc=;
        h=Date:To:From:Subject:From;
        b=MAZLdyaqjFDTsk7w4D2/kr7oCKPZQNZUR3DiMQtGNTNW9v25qaQ3S1so+wog5Tkzr
         VhfY8EHwVsKn5+UFVYyBb8dbsUfTg+FPvgIC158dJ+yZdtkHoRmIdcwWIeNJcEv/ON
         F69LLLZUotJXqc3CKwoJX5Pvx/aXeHdFrfi+FLac=
Date:   Thu, 14 Apr 2022 14:00:12 -0700
To:     mm-commits@vger.kernel.org, anshuman.khandual@arm.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-hugetlb-enable-hugetlb_page_free_vmemmap-for-arm64-fix.patch added to -mm tree
Message-Id: <20220414210013.47D79C385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: mm: hugetlb: restructure the code comment inside flush_dcache_page()
has been added to the -mm tree.  Its filename is
     arm64-mm-hugetlb-enable-hugetlb_page_free_vmemmap-for-arm64-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm64-mm-hugetlb-enable-hugetlb_page_free_vmemmap-for-arm64-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm64-mm-hugetlb-enable-hugetlb_page_free_vmemmap-for-arm64-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
arm64-mm-hugetlb-enable-hugetlb_page_free_vmemmap-for-arm64-fix.patch
mm-hugetlb_vmemmap-cleanup-hugetlb_vmemmap-related-functions.patch
mm-hugetlb_vmemmap-cleanup-hugetlb_free_vmemmap_enabled.patch
mm-hugetlb_vmemmap-cleanup-config_hugetlb_page_free_vmemmap.patch
mm-rmap-fix-cache-flush-on-thp-pages.patch
dax-fix-cache-flush-on-pmd-mapped-pages.patch
mm-rmap-introduce-pfn_mkclean_range-to-cleans-ptes.patch
mm-pvmw-add-support-for-walking-devmap-pages.patch
dax-fix-missing-writeprotect-the-pte-entry.patch
mm-simplify-follow_invalidate_pte.patch


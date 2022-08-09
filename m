Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B31CC25B0C
	for <mm-commits@archiver.kernel.org>; Tue,  9 Aug 2022 01:14:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbiHIBOS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Aug 2022 21:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233226AbiHIBOS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 Aug 2022 21:14:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 140D91BEBC
        for <mm-commits@vger.kernel.org>; Mon,  8 Aug 2022 18:14:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B19A5B81116
        for <mm-commits@vger.kernel.org>; Tue,  9 Aug 2022 01:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D21C433C1;
        Tue,  9 Aug 2022 01:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660007654;
        bh=mA0/FRnn6nxYlowTlaBA5bNYcuzIYNcqqx0N0pw3VFE=;
        h=Date:To:From:Subject:From;
        b=QyO6erO0lWRwbEE+EL4ySuwgZH+bHs1YkZjPaMEH/btTpZKOXpkuv6StnWBtLUcbs
         037n1fEdlRC0YWz/KXZATBBJmrWvKJ5XbtBOyFUO1yMtZILjaq86OyExerbsi27G3s
         YDCwVMlJA3lZL15VvYh23Q54huTflmIsLNflN0aA=
Date:   Mon, 08 Aug 2022 18:14:13 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, osalvador@suse.de,
        mike.kravetz@oracle.com, duanxiongchun@bytedance.com,
        david@redhat.com, corbet@lwn.net, catalin.marinas@arm.com,
        anshuman.khandual@arm.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_vmemmap-delete-hugetlb_optimize_vmemmap_enabled.patch removed from -mm tree
Message-Id: <20220809011414.61D21C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: hugetlb_vmemmap: delete hugetlb_optimize_vmemmap_enabled()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-delete-hugetlb_optimize_vmemmap_enabled.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb_vmemmap: delete hugetlb_optimize_vmemmap_enabled()
Date: Tue, 28 Jun 2022 17:22:28 +0800

Patch series "Simplify hugetlb vmemmap and improve its readability", v2.

This series aims to simplify hugetlb vmemmap and improve its readability.


This patch (of 8):

The name hugetlb_optimize_vmemmap_enabled() a bit confusing as it tests
two conditions (enabled and pages in use).  Instead of coming up to an
appropriate name, we could just delete it.  There is already a discussion
about deleting it in thread [1].

There is only one user of hugetlb_optimize_vmemmap_enabled() outside of
hugetlb_vmemmap, that is flush_dcache_page() in arch/arm64/mm/flush.c. 
However, it does not need to call hugetlb_optimize_vmemmap_enabled() in
flush_dcache_page() since HugeTLB pages are always fully mapped and only
head page will be set PG_dcache_clean meaning only head page's flag may
need to be cleared (see commit cf5a501d985b).  So it is easy to remove
hugetlb_optimize_vmemmap_enabled().

Link: https://lore.kernel.org/all/c77c61c8-8a5a-87e8-db89-d04d8aaab4cc@oracle.com/ [1]
Link: https://lkml.kernel.org/r/20220628092235.91270-2-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/flush.c      |   13 +++----------
 include/linux/page-flags.h |   14 ++------------
 2 files changed, 5 insertions(+), 22 deletions(-)

--- a/arch/arm64/mm/flush.c~mm-hugetlb_vmemmap-delete-hugetlb_optimize_vmemmap_enabled
+++ a/arch/arm64/mm/flush.c
@@ -76,17 +76,10 @@ EXPORT_SYMBOL_GPL(__sync_icache_dcache);
 void flush_dcache_page(struct page *page)
 {
 	/*
-	 * Only the head page's flags of HugeTLB can be cleared since the tail
-	 * vmemmap pages associated with each HugeTLB page are mapped with
-	 * read-only when CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP is enabled (more
-	 * details can refer to vmemmap_remap_pte()).  Although
-	 * __sync_icache_dcache() only set PG_dcache_clean flag on the head
-	 * page struct, there is more than one page struct with PG_dcache_clean
-	 * associated with the HugeTLB page since the head vmemmap page frame
-	 * is reused (more details can refer to the comments above
-	 * page_fixed_fake_head()).
+	 * HugeTLB pages are always fully mapped and only head page will be
+	 * set PG_dcache_clean (see comments in __sync_icache_dcache()).
 	 */
-	if (hugetlb_optimize_vmemmap_enabled() && PageHuge(page))
+	if (PageHuge(page))
 		page = compound_head(page);
 
 	if (test_bit(PG_dcache_clean, &page->flags))
--- a/include/linux/page-flags.h~mm-hugetlb_vmemmap-delete-hugetlb_optimize_vmemmap_enabled
+++ a/include/linux/page-flags.h
@@ -208,12 +208,6 @@ enum pageflags {
 DECLARE_STATIC_KEY_MAYBE(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON,
 			 hugetlb_optimize_vmemmap_key);
 
-static __always_inline bool hugetlb_optimize_vmemmap_enabled(void)
-{
-	return static_branch_maybe(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON,
-				   &hugetlb_optimize_vmemmap_key);
-}
-
 /*
  * If the feature of optimizing vmemmap pages associated with each HugeTLB
  * page is enabled, the head vmemmap page frame is reused and all of the tail
@@ -232,7 +226,8 @@ static __always_inline bool hugetlb_opti
  */
 static __always_inline const struct page *page_fixed_fake_head(const struct page *page)
 {
-	if (!hugetlb_optimize_vmemmap_enabled())
+	if (!static_branch_maybe(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON,
+				 &hugetlb_optimize_vmemmap_key))
 		return page;
 
 	/*
@@ -260,11 +255,6 @@ static inline const struct page *page_fi
 {
 	return page;
 }
-
-static inline bool hugetlb_optimize_vmemmap_enabled(void)
-{
-	return false;
-}
 #endif
 
 static __always_inline int page_is_fake_head(struct page *page)
_

Patches currently in -mm which might be from songmuchun@bytedance.com are



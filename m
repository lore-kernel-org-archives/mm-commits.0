Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48CA7C433DB
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:18:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0997A64F1A
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhBZBSb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:18:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:50196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229845AbhBZBST (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:18:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E717664EE3;
        Fri, 26 Feb 2021 01:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302259;
        bh=C7dLpRKRVzopYTfQd7qjH2DJcx0pbrtj91GnrSHiYH4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=t8QZlCfZpyv4Fi7WmMjOtuP+tfsxMEOiHuC4+HjtIRkR7db4I1pKr6R1Fal3RxW0J
         oeQgwBIFuJuKEv+Q8sH4UMBkFpmDgxOxKJGaL3x9wZN6tNlZJQfu4zkv/Al1MJjNbS
         ewp5uvhPLKnZeWWhfdza64IjeovF6lQtQ/VzEsDI=
Date:   Thu, 25 Feb 2021 17:17:37 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        ardb@kernel.org, catalin.marinas@arm.com, david@redhat.com,
        gor@linux.ibm.com, hca@linux.ibm.com, jasowang@redhat.com,
        Jonathan.Cameron@huawei.com, linux-mm@kvack.org,
        mark.rutland@arm.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, mst@redhat.com, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, pankaj.gupta@cloud.ionos.com,
        richard.weiyang@linux.alibaba.com, teawaterz@linux.alibaba.com,
        torvalds@linux-foundation.org, will@kernel.org
Subject:  [patch 036/118] arm64/mm: define
 arch_get_mappable_range()
Message-ID: <20210226011737.yZfJ_esng%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: arm64/mm: define arch_get_mappable_range()

This overrides arch_get_mappable_range() on arm64 platform which will be
used with recently added generic framework.  It drops
inside_linear_region() and subsequent check in arch_add_memory() which are
no longer required.  It also adds a VM_BUG_ON() check that would ensure
that mhp_range_allowed() has already been called.

Link: https://lkml.kernel.org/r/1612149902-7867-3-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: teawater <teawaterz@linux.alibaba.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/mmu.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/arch/arm64/mm/mmu.c~arm64-mm-define-arch_get_mappable_range
+++ a/arch/arm64/mm/mmu.c
@@ -1444,16 +1444,19 @@ static void __remove_pgd_mapping(pgd_t *
 	free_empty_tables(start, end, PAGE_OFFSET, PAGE_END);
 }
 
-static bool inside_linear_region(u64 start, u64 size)
+struct range arch_get_mappable_range(void)
 {
+	struct range mhp_range;
+
 	/*
 	 * Linear mapping region is the range [PAGE_OFFSET..(PAGE_END - 1)]
 	 * accommodating both its ends but excluding PAGE_END. Max physical
 	 * range which can be mapped inside this linear mapping range, must
 	 * also be derived from its end points.
 	 */
-	return start >= __pa(_PAGE_OFFSET(vabits_actual)) &&
-	       (start + size - 1) <= __pa(PAGE_END - 1);
+	mhp_range.start = __pa(_PAGE_OFFSET(vabits_actual));
+	mhp_range.end =  __pa(PAGE_END - 1);
+	return mhp_range;
 }
 
 int arch_add_memory(int nid, u64 start, u64 size,
@@ -1461,11 +1464,7 @@ int arch_add_memory(int nid, u64 start,
 {
 	int ret, flags = 0;
 
-	if (!inside_linear_region(start, size)) {
-		pr_err("[%llx %llx] is outside linear mapping region\n", start, start + size);
-		return -EINVAL;
-	}
-
+	VM_BUG_ON(!mhp_range_allowed(start, size, true));
 	if (rodata_full || debug_pagealloc_enabled())
 		flags = NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
_

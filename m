Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91A7EC636CB
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jul 2021 00:14:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7226D613DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jul 2021 00:14:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbhGPARV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Jul 2021 20:17:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230317AbhGPARN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Jul 2021 20:17:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D825613C1;
        Fri, 16 Jul 2021 00:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626394459;
        bh=5PUcw9KTBuqB8mb4Raf25vATrJBJBF/HX2OnRNjWFeA=;
        h=Date:From:To:Subject:From;
        b=wQihA7oqcYNXG6euUJQHYyWovvvpdnTQCaD7jvm/f9yhh77iq2UHgYBWJ/xwWI65t
         e9GDd5/UCQolFbI3TCT30ZfwzDWSixHk4eD9q+hDZQeArrgg3JwtLvuTx+c2xiqL13
         Nkc/WwERECRaslc2tP7p3tGUj7P74A3+gmniWaFE=
Date:   Thu, 15 Jul 2021 17:14:18 -0700
From:   akpm@linux-foundation.org
To:     lkp@intel.com, mm-commits@vger.kernel.org
Subject:  [obsolete]
 mm-hugetlb-__unmap_hugepage_range-can-be-static.patch removed from -mm tree
Message-ID: <20210716001418.lH60aQvrJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: __unmap_hugepage_range() can be static
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-__unmap_hugepage_range-can-be-static.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: kernel test robot <lkp@intel.com>
Subject: mm/hugetlb: __unmap_hugepage_range() can be static

mm/hugetlb.c:4334:6: warning: symbol '__unmap_hugepage_range' was not declared. Should it be static?

Link: https://lkml.kernel.org/r/20210715170524.GA48547@78ef4ef0cd6c
Signed-off-by: kernel test robot <lkp@intel.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-__unmap_hugepage_range-can-be-static
+++ a/mm/hugetlb.c
@@ -4402,9 +4402,9 @@ again:
 	return ret;
 }
 
-void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
-			    unsigned long start, unsigned long end,
-			    struct page *ref_page)
+static void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
+				   unsigned long start, unsigned long end,
+				   struct page *ref_page)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long address;
_

Patches currently in -mm which might be from lkp@intel.com are

lib-fix-bugoncocci-warnings.patch


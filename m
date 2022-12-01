Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6FCAC352A1
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbiLAALg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:11:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbiLAAKi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:10:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB948E582
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:03:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDD5FB81AD6
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:03:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB441C433B5;
        Thu,  1 Dec 2022 00:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852994;
        bh=NwnvklUnBLsVsEgc6zWmitKK7T+UVoIJhK/mkIfLDeA=;
        h=Date:To:From:Subject:From;
        b=TtKiJSTLazeVMnakxqDb4DalDuw3ecAWCx9a4PXNpBUGp3TkFRcgKmiE9SHxjJDf5
         LNVsw42cHrB33xHGurASUmTqRggBZoCYIkeN2pWwLxHavTPQENjp9fr0/tMy+0z4/X
         409MPp0wDUr6qcvq1Hx0XMwPSUcATaZsoVSqlYjY=
Date:   Wed, 30 Nov 2022 16:03:13 -0800
To:     mm-commits@vger.kernel.org, hca@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, agordeev@linux.ibm.com,
        anshuman.khandual@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] s390-mm-use-pmd_pgtable_page-helper-in-__gmap_segment_gaddr.patch removed from -mm tree
Message-Id: <20221201000314.AB441C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: s390/mm: use pmd_pgtable_page() helper in __gmap_segment_gaddr()
has been removed from the -mm tree.  Its filename was
     s390-mm-use-pmd_pgtable_page-helper-in-__gmap_segment_gaddr.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: s390/mm: use pmd_pgtable_page() helper in __gmap_segment_gaddr()
Date: Fri, 25 Nov 2022 09:15:02 +0530

In __gmap_segment_gaddr() pmd level page table page is being extracted
from the pmd pointer, similar to pmd_pgtable_page() implementation.  This
reduces some redundancy by directly using pmd_pgtable_page() instead,
though first making it available.

Link: https://lkml.kernel.org/r/20221125034502.1559986-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/gmap.c |    5 ++---
 include/linux/mm.h  |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

--- a/arch/s390/mm/gmap.c~s390-mm-use-pmd_pgtable_page-helper-in-__gmap_segment_gaddr
+++ a/arch/s390/mm/gmap.c
@@ -336,12 +336,11 @@ static int gmap_alloc_table(struct gmap
 static unsigned long __gmap_segment_gaddr(unsigned long *entry)
 {
 	struct page *page;
-	unsigned long offset, mask;
+	unsigned long offset;
 
 	offset = (unsigned long) entry / sizeof(unsigned long);
 	offset = (offset & (PTRS_PER_PMD - 1)) * PMD_SIZE;
-	mask = ~(PTRS_PER_PMD * sizeof(pmd_t) - 1);
-	page = virt_to_page((void *)((unsigned long) entry & mask));
+	page = pmd_pgtable_page((pmd_t *) entry);
 	return page->index + offset;
 }
 
--- a/include/linux/mm.h~s390-mm-use-pmd_pgtable_page-helper-in-__gmap_segment_gaddr
+++ a/include/linux/mm.h
@@ -2510,7 +2510,7 @@ static inline void pgtable_pte_page_dtor
 
 #if USE_SPLIT_PMD_PTLOCKS
 
-static struct page *pmd_pgtable_page(pmd_t *pmd)
+static inline struct page *pmd_pgtable_page(pmd_t *pmd)
 {
 	unsigned long mask = ~(PTRS_PER_PMD * sizeof(pmd_t) - 1);
 	return virt_to_page((void *)((unsigned long) pmd & mask));
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B319AC4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbiLAALf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:11:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbiLAAKU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:10:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553FF8DBDD
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:03:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D2956176C
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:03:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572B8C433D6;
        Thu,  1 Dec 2022 00:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852993;
        bh=XF5R7cGXz19XdVHEzePaZ3pOMZ8V3Fd7zDNu2CSCpiY=;
        h=Date:To:From:Subject:From;
        b=mNlRN2JGBqtGNB0I88YQujm5rlRxGQxBlXUa7LWSxC9l9DpwRsKAEdSlQVmg/CTKQ
         uXS+aWAS4blL1UTpLC0K7XbTgLGEGDkO+5yfuZiQYuzfJ5+qRwp8yB79/ssgp1Rdhb
         sgJ5BXiMtu4gTROSQXZmq/5yModWun3YHEXTqJPw=
Date:   Wed, 30 Nov 2022 16:03:12 -0800
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        kirill.shutemov@linux.intel.com, anshuman.khandual@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-thp-rename-pmd_to_page-as-pmd_pgtable_page.patch removed from -mm tree
Message-Id: <20221201000313.572B8C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/thp: rename pmd_to_page() as pmd_pgtable_page()
has been removed from the -mm tree.  Its filename was
     mm-thp-rename-pmd_to_page-as-pmd_pgtable_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/thp: rename pmd_to_page() as pmd_pgtable_page()
Date: Thu, 24 Nov 2022 18:46:41 +0530

Current pmd_to_page(), which derives the page table page containing the
pmd address has a very misleading name.  The problem being, it sounds
similar to pmd_page() which derives page embedded in a given pmd entry
either for next level page or a mapped huge page.  Rename it as
pmd_pgtable_page() instead.

Link: https://lkml.kernel.org/r/20221124131641.1523772-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h~mm-thp-rename-pmd_to_page-as-pmd_pgtable_page
+++ a/include/linux/mm.h
@@ -2510,7 +2510,7 @@ static inline void pgtable_pte_page_dtor
 
 #if USE_SPLIT_PMD_PTLOCKS
 
-static struct page *pmd_to_page(pmd_t *pmd)
+static struct page *pmd_pgtable_page(pmd_t *pmd)
 {
 	unsigned long mask = ~(PTRS_PER_PMD * sizeof(pmd_t) - 1);
 	return virt_to_page((void *)((unsigned long) pmd & mask));
@@ -2518,7 +2518,7 @@ static struct page *pmd_to_page(pmd_t *p
 
 static inline spinlock_t *pmd_lockptr(struct mm_struct *mm, pmd_t *pmd)
 {
-	return ptlock_ptr(pmd_to_page(pmd));
+	return ptlock_ptr(pmd_pgtable_page(pmd));
 }
 
 static inline bool pmd_ptlock_init(struct page *page)
@@ -2537,7 +2537,7 @@ static inline void pmd_ptlock_free(struc
 	ptlock_free(page);
 }
 
-#define pmd_huge_pte(mm, pmd) (pmd_to_page(pmd)->pmd_huge_pte)
+#define pmd_huge_pte(mm, pmd) (pmd_pgtable_page(pmd)->pmd_huge_pte)
 
 #else
 
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are



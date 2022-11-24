Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F36AFC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 24 Nov 2022 21:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiKXVpJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Nov 2022 16:45:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiKXVpI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Nov 2022 16:45:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD5470A37
        for <mm-commits@vger.kernel.org>; Thu, 24 Nov 2022 13:45:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0373E62259
        for <mm-commits@vger.kernel.org>; Thu, 24 Nov 2022 21:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1AEC433C1;
        Thu, 24 Nov 2022 21:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669326306;
        bh=WOvtaGg1KO2DPGDfFgBlU0UuWPqal9D3IQL3UBolv64=;
        h=Date:To:From:Subject:From;
        b=jCIuxZdzBKA7rOnkW545a+HMf3bQCr2Qy87YeHUIkw0f/+AjYWAxtbo6+PV5OO19L
         pgwTCbd59Szq0mDPIiOBZEMGV8mFtbVTGTwiFdld1l+XtrifslYDCAGI10DeY/fFah
         KePGUZsfOQVtcCrcSBlu0CzB+kPirvW/BT/dfvCc=
Date:   Thu, 24 Nov 2022 13:45:05 -0800
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        kirill.shutemov@linux.intel.com, anshuman.khandual@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-rename-pmd_to_page-as-pmd_pgtable_page.patch added to mm-unstable branch
Message-Id: <20221124214506.4A1AEC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: rename pmd_to_page() as pmd_pgtable_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-thp-rename-pmd_to_page-as-pmd_pgtable_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-rename-pmd_to_page-as-pmd_pgtable_page.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -2480,7 +2480,7 @@ static inline void pgtable_pte_page_dtor
 
 #if USE_SPLIT_PMD_PTLOCKS
 
-static struct page *pmd_to_page(pmd_t *pmd)
+static struct page *pmd_pgtable_page(pmd_t *pmd)
 {
 	unsigned long mask = ~(PTRS_PER_PMD * sizeof(pmd_t) - 1);
 	return virt_to_page((void *)((unsigned long) pmd & mask));
@@ -2488,7 +2488,7 @@ static struct page *pmd_to_page(pmd_t *p
 
 static inline spinlock_t *pmd_lockptr(struct mm_struct *mm, pmd_t *pmd)
 {
-	return ptlock_ptr(pmd_to_page(pmd));
+	return ptlock_ptr(pmd_pgtable_page(pmd));
 }
 
 static inline bool pmd_ptlock_init(struct page *page)
@@ -2507,7 +2507,7 @@ static inline void pmd_ptlock_free(struc
 	ptlock_free(page);
 }
 
-#define pmd_huge_pte(mm, pmd) (pmd_to_page(pmd)->pmd_huge_pte)
+#define pmd_huge_pte(mm, pmd) (pmd_pgtable_page(pmd)->pmd_huge_pte)
 
 #else
 
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

documentation-mm-update-pmd_present-in-arch_pgtable_helpersrst.patch
mm-thp-rename-pmd_to_page-as-pmd_pgtable_page.patch


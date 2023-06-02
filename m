Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7A4BC7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  2 Jun 2023 20:55:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236299AbjFBUzQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Jun 2023 16:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236158AbjFBUzO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jun 2023 16:55:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E53EE44
        for <mm-commits@vger.kernel.org>; Fri,  2 Jun 2023 13:55:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05EDC61CAD
        for <mm-commits@vger.kernel.org>; Fri,  2 Jun 2023 20:55:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F676C433EF;
        Fri,  2 Jun 2023 20:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685739312;
        bh=QDQpYaIge5rlvfaK+azdDN9ZrJ0Oef/u85ZyY6/dd+I=;
        h=Date:To:From:Subject:From;
        b=RICn91TnGiv8uOhntdhv3lNoMXZ4NX18enl1GJmZYki256LUURFl4XjjDqgpGgusc
         XPVpLBmVNU1YmBUSgda9hAmorIA2QWYhekwMngomyr4jeF8VXvYrSbistU7m7WYqBO
         BWBY34dPJV/bF8XFSfioXlmjdTukhgGZM2/Tx2OE=
Date:   Fri, 02 Jun 2023 13:55:11 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, yuzhao@google.com,
        willy@infradead.org, urezki@gmail.com, sj@kernel.org,
        rppt@kernel.org, lstoakes@gmail.com,
        kirill.shutemov@linux.intel.com, hch@lst.de, hch@infradead.org,
        ryan.roberts@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-ops-common-refactor-to-use-ptepmdp_clear_young_notify.patch added to mm-unstable branch
Message-Id: <20230602205512.5F676C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/ops-common: refactor to use {pte|pmd}p_clear_young_notify()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-ops-common-refactor-to-use-ptepmdp_clear_young_notify.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-ops-common-refactor-to-use-ptepmdp_clear_young_notify.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm/damon/ops-common: refactor to use {pte|pmd}p_clear_young_notify()
Date: Fri, 2 Jun 2023 10:29:48 +0100

With the fix in place to atomically test and clear young on ptes and pmds,
simplify the code to handle the clearing for both the primary mmu and the
mmu notifier with a single API call.

Link: https://lkml.kernel.org/r/20230602092949.545577-4-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: Yu Zhao <yuzhao@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/ops-common.c |   22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

--- a/mm/damon/ops-common.c~mm-damon-ops-common-refactor-to-use-ptepmdp_clear_young_notify
+++ a/mm/damon/ops-common.c
@@ -39,21 +39,12 @@ struct folio *damon_get_folio(unsigned l
 
 void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr)
 {
-	bool referenced = false;
 	struct folio *folio = damon_get_folio(pte_pfn(*pte));
 
 	if (!folio)
 		return;
 
-	if (ptep_test_and_clear_young(vma, addr, pte))
-		referenced = true;
-
-#ifdef CONFIG_MMU_NOTIFIER
-	if (mmu_notifier_clear_young(vma->vm_mm, addr, addr + PAGE_SIZE))
-		referenced = true;
-#endif /* CONFIG_MMU_NOTIFIER */
-
-	if (referenced)
+	if (ptep_clear_young_notify(vma, addr, pte))
 		folio_set_young(folio);
 
 	folio_set_idle(folio);
@@ -63,21 +54,12 @@ void damon_ptep_mkold(pte_t *pte, struct
 void damon_pmdp_mkold(pmd_t *pmd, struct vm_area_struct *vma, unsigned long addr)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	bool referenced = false;
 	struct folio *folio = damon_get_folio(pmd_pfn(*pmd));
 
 	if (!folio)
 		return;
 
-	if (pmdp_test_and_clear_young(vma, addr, pmd))
-		referenced = true;
-
-#ifdef CONFIG_MMU_NOTIFIER
-	if (mmu_notifier_clear_young(vma->vm_mm, addr, addr + HPAGE_PMD_SIZE))
-		referenced = true;
-#endif /* CONFIG_MMU_NOTIFIER */
-
-	if (referenced)
+	if (pmdp_clear_young_notify(vma, addr, pmd))
 		folio_set_young(folio);
 
 	folio_set_idle(folio);
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-vmalloc-must-set-pte-via-arch-code.patch
mm-damon-ops-common-atomically-test-and-clear-young-on-ptes-and-pmds.patch
mm-damon-ops-common-refactor-to-use-ptepmdp_clear_young_notify.patch
mm-fix-failure-to-unmap-pte-on-highmem-systems.patch


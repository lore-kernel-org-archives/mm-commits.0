Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B57CC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 26 May 2022 18:03:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236668AbiEZSDG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 May 2022 14:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiEZSDG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 May 2022 14:03:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C657A8892
        for <mm-commits@vger.kernel.org>; Thu, 26 May 2022 11:03:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5126DB821A7
        for <mm-commits@vger.kernel.org>; Thu, 26 May 2022 18:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A3FC385A9;
        Thu, 26 May 2022 18:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653588182;
        bh=1C4V2iLj9x4ocN0VC/2EuVqJscG/C0Zr5gEjAK+yd3s=;
        h=Date:To:From:Subject:From;
        b=jGkcEJA8ol5S7fGov0W/2T1l6r2aTfNANehfX1ql5lx3pIeWEBSnpkHGUN8UhnKN2
         HWbg/aID9zFKk0rSOBo1jVvipCE28+3nWfw1SP3Qdy4yEEa36x33RTq/fPt6eou4jk
         2bGu+O2SN6WMV50yy/pj3NHkQoPACRSsmzJ5gEi4=
Date:   Thu, 26 May 2022 11:03:01 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-x86-remove-dead-code-for-hugetlbpagec.patch added to mm-unstable branch
Message-Id: <20220526180302.08A3FC385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/x86: remove dead code for hugetlbpage.c
has been added to the -mm mm-unstable branch.  Its filename is
     mm-x86-remove-dead-code-for-hugetlbpagec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-x86-remove-dead-code-for-hugetlbpagec.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/x86: remove dead code for hugetlbpage.c
Date: Wed, 25 May 2022 15:52:20 -0400

It seems to exist since the old times and never used once.  Remove them.

Link: https://lkml.kernel.org/r/20220525195220.10241-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/hugetlbpage.c |   39 ------------------------------------
 1 file changed, 39 deletions(-)

--- a/arch/x86/mm/hugetlbpage.c~mm-x86-remove-dead-code-for-hugetlbpagec
+++ a/arch/x86/mm/hugetlbpage.c
@@ -19,44 +19,6 @@
 #include <asm/tlbflush.h>
 #include <asm/elf.h>
 
-#if 0	/* This is just for testing */
-struct page *
-follow_huge_addr(struct mm_struct *mm, unsigned long address, int write)
-{
-	unsigned long start = address;
-	int length = 1;
-	int nr;
-	struct page *page;
-	struct vm_area_struct *vma;
-
-	vma = find_vma(mm, addr);
-	if (!vma || !is_vm_hugetlb_page(vma))
-		return ERR_PTR(-EINVAL);
-
-	pte = huge_pte_offset(mm, address, vma_mmu_pagesize(vma));
-
-	/* hugetlb should be locked, and hence, prefaulted */
-	WARN_ON(!pte || pte_none(*pte));
-
-	page = &pte_page(*pte)[vpfn % (HPAGE_SIZE/PAGE_SIZE)];
-
-	WARN_ON(!PageHead(page));
-
-	return page;
-}
-
-int pmd_huge(pmd_t pmd)
-{
-	return 0;
-}
-
-int pud_huge(pud_t pud)
-{
-	return 0;
-}
-
-#else
-
 /*
  * pmd_huge() returns 1 if @pmd is hugetlb related entry, that is normal
  * hugetlb entry or non-present (migration or hwpoisoned) hugetlb entry.
@@ -72,7 +34,6 @@ int pud_huge(pud_t pud)
 {
 	return !!(pud_val(pud) & _PAGE_PSE);
 }
-#endif
 
 #ifdef CONFIG_HUGETLB_PAGE
 static unsigned long hugetlb_get_unmapped_area_bottomup(struct file *file,
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-x86-remove-dead-code-for-hugetlbpagec.patch


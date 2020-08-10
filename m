Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88EEBC433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:38:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CBC5206CD
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027116;
	bh=eGgQm/clcvQHDNozh83RUZ9bMofTnNdHBFpUHHN0eAQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=HAM+/yi2yGrAkUQzBJC6IJiWfvbHCMPZS9eAyDnmcDE/KH4j2PJRP8hUPKfVila1h
	 YGf5lxQDODrKYaUsoI16klhpHFFUebYo/j3+TwtxH+vddAXstUbw4BLHlY401T5Qwd
	 3h8sNZnizlAHcPExwTKosdCKatY7eEGWl0B9RKPE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgHJCif (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:38:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:41768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726401AbgHJCif (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:38:35 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C65182073E;
        Mon, 10 Aug 2020 02:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027114;
        bh=eGgQm/clcvQHDNozh83RUZ9bMofTnNdHBFpUHHN0eAQ=;
        h=Date:From:To:Subject:From;
        b=PLVY1HcZsm08MMILGYXzPBj71lYzquXBaQoufh3SNotIhX2SHmXevJJf+DiWAc0/Z
         q7nGa2hden7EfnpwW73g5T5Yf+hgsir6dtlmYxI2XxfJQ3vLnJFRQBKaILDtKEmzok
         9MaRQ4WaTEWMI563NQ3fSqa8hS8lfAF/Xsh0CLeg=
Date:   Sun, 09 Aug 2020 19:38:33 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com,
        digetx@gmail.com, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        richard.weiyang@linux.alibaba.com, sean.j.christopherson@intel.com,
        thellstrom@vmware.com, thomas_os@shipmail.org, vbabka@suse.cz,
        willy@infradead.org, yang.shi@linux.alibaba.com
Subject:  [merged]
 =?US-ASCII?Q?mm-mremap-it-is-sure-to-have-enough-space-when-extent-mee?=
 =?US-ASCII?Q?ts-requirement.patch?= removed from -mm tree
Message-ID: <20200810023833.tlcW_eTuO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap: it is sure to have enough space when extent meets requirement
has been removed from the -mm tree.  Its filename was
     mm-mremap-it-is-sure-to-have-enough-space-when-extent-meets-requirement.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/mremap: it is sure to have enough space when extent meets requirement

Patch series "mm/mremap: cleanup move_page_tables() a little", v5.

move_page_tables() tries to move page table by PMD or PTE.

The root reason is if it tries to move PMD, both old and new range should
be PMD aligned.  But current code calculate old range and new range
separately.  This leads to some redundant check and calculation.

This cleanup tries to consolidate the range check in one place to reduce
some extra range handling.


This patch (of 3):

old_end is passed to these two functions to check whether there is enough
space to do the move, while this check is done before invoking these
functions.

These two functions only would be invoked when extent meets the
requirement and there is one check before invoking these functions:

    if (extent > old_end - old_addr)
        extent = old_end - old_addr;

This implies (old_end - old_addr) won't fail the check in these two
functions.

Link: http://lkml.kernel.org/r/20200710092835.56368-1-richard.weiyang@linux.alibaba.com
Link: http://lkml.kernel.org/r/20200710092835.56368-2-richard.weiyang@linux.alibaba.com
Link: http://lkml.kernel.org/r/20200708095028.41706-1-richard.weiyang@linux.alibaba.com
Link: http://lkml.kernel.org/r/20200708095028.41706-2-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Tested-by: Dmitry Osipenko <digetx@gmail.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Thomas Hellstrom (VMware) <thomas_os@shipmail.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    2 +-
 mm/huge_memory.c        |    7 ++-----
 mm/mremap.c             |   10 ++++------
 3 files changed, 7 insertions(+), 12 deletions(-)

--- a/include/linux/huge_mm.h~mm-mremap-it-is-sure-to-have-enough-space-when-extent-meets-requirement
+++ a/include/linux/huge_mm.h
@@ -42,7 +42,7 @@ extern int mincore_huge_pmd(struct vm_ar
 			unsigned long addr, unsigned long end,
 			unsigned char *vec);
 extern bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
-			 unsigned long new_addr, unsigned long old_end,
+			 unsigned long new_addr,
 			 pmd_t *old_pmd, pmd_t *new_pmd);
 extern int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 			unsigned long addr, pgprot_t newprot,
--- a/mm/huge_memory.c~mm-mremap-it-is-sure-to-have-enough-space-when-extent-meets-requirement
+++ a/mm/huge_memory.c
@@ -1722,17 +1722,14 @@ static pmd_t move_soft_dirty_pmd(pmd_t p
 }
 
 bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
-		  unsigned long new_addr, unsigned long old_end,
-		  pmd_t *old_pmd, pmd_t *new_pmd)
+		  unsigned long new_addr, pmd_t *old_pmd, pmd_t *new_pmd)
 {
 	spinlock_t *old_ptl, *new_ptl;
 	pmd_t pmd;
 	struct mm_struct *mm = vma->vm_mm;
 	bool force_flush = false;
 
-	if ((old_addr & ~HPAGE_PMD_MASK) ||
-	    (new_addr & ~HPAGE_PMD_MASK) ||
-	    old_end - old_addr < HPAGE_PMD_SIZE)
+	if ((old_addr & ~HPAGE_PMD_MASK) || (new_addr & ~HPAGE_PMD_MASK))
 		return false;
 
 	/*
--- a/mm/mremap.c~mm-mremap-it-is-sure-to-have-enough-space-when-extent-meets-requirement
+++ a/mm/mremap.c
@@ -193,15 +193,13 @@ static void move_ptes(struct vm_area_str
 
 #ifdef CONFIG_HAVE_MOVE_PMD
 static bool move_normal_pmd(struct vm_area_struct *vma, unsigned long old_addr,
-		  unsigned long new_addr, unsigned long old_end,
-		  pmd_t *old_pmd, pmd_t *new_pmd)
+		  unsigned long new_addr, pmd_t *old_pmd, pmd_t *new_pmd)
 {
 	spinlock_t *old_ptl, *new_ptl;
 	struct mm_struct *mm = vma->vm_mm;
 	pmd_t pmd;
 
-	if ((old_addr & ~PMD_MASK) || (new_addr & ~PMD_MASK)
-	    || old_end - old_addr < PMD_SIZE)
+	if ((old_addr & ~PMD_MASK) || (new_addr & ~PMD_MASK))
 		return false;
 
 	/*
@@ -292,7 +290,7 @@ unsigned long move_page_tables(struct vm
 				if (need_rmap_locks)
 					take_rmap_locks(vma);
 				moved = move_huge_pmd(vma, old_addr, new_addr,
-						    old_end, old_pmd, new_pmd);
+						      old_pmd, new_pmd);
 				if (need_rmap_locks)
 					drop_rmap_locks(vma);
 				if (moved)
@@ -312,7 +310,7 @@ unsigned long move_page_tables(struct vm
 			if (need_rmap_locks)
 				take_rmap_locks(vma);
 			moved = move_normal_pmd(vma, old_addr, new_addr,
-					old_end, old_pmd, new_pmd);
+						old_pmd, new_pmd);
 			if (need_rmap_locks)
 				drop_rmap_locks(vma);
 			if (moved)
_

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are



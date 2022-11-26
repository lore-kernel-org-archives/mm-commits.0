Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D81FC43217
	for <mm-commits@archiver.kernel.org>; Sat, 26 Nov 2022 00:56:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiKZA4p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Nov 2022 19:56:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiKZA4o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Nov 2022 19:56:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CFDD5985A
        for <mm-commits@vger.kernel.org>; Fri, 25 Nov 2022 16:56:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1721660C6D
        for <mm-commits@vger.kernel.org>; Sat, 26 Nov 2022 00:56:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67325C433D6;
        Sat, 26 Nov 2022 00:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669424202;
        bh=elF7Jnvka0K61U6Cdiv5q7pyVPhgMMqPzLwYFGQXM1g=;
        h=Date:To:From:Subject:From;
        b=L3KwOLuN+yLf6m3Rnbi3HLF2d43gWnGIfY8EZcmANDsa5fPHch1gxMADYgh4FVjvj
         8rzRXLZFRJ/D81JDCUcRsoVFeYAgKLt+MmY+jHtzEon0ZExvqHIc2iJjK8qPP/f2K9
         2F/+ekKsuinh5R8iphUvEQ6gHNVgdWCh6jxYrRIM=
Date:   Fri, 25 Nov 2022 16:56:40 -0800
To:     mm-commits@vger.kernel.org, hca@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, anshuman.khandual@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-mm-use-pmd_pgtable_page-helper-in-__gmap_segment_gaddr.patch added to mm-unstable branch
Message-Id: <20221126005642.67325C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: s390/mm: use pmd_pgtable_page() helper in __gmap_segment_gaddr()
has been added to the -mm mm-unstable branch.  Its filename is
     s390-mm-use-pmd_pgtable_page-helper-in-__gmap_segment_gaddr.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-mm-use-pmd_pgtable_page-helper-in-__gmap_segment_gaddr.patch

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
Subject: s390/mm: use pmd_pgtable_page() helper in __gmap_segment_gaddr()
Date: Fri, 25 Nov 2022 09:15:02 +0530

In __gmap_segment_gaddr() pmd level page table page is being extracted
from the pmd pointer, similar to pmd_pgtable_page() implementation.  This
reduces some redundancy by directly using pmd_pgtable_page() instead,
though first making it available.

Link: https://lkml.kernel.org/r/20221125034502.1559986-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
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
@@ -2480,7 +2480,7 @@ static inline void pgtable_pte_page_dtor
 
 #if USE_SPLIT_PMD_PTLOCKS
 
-static struct page *pmd_pgtable_page(pmd_t *pmd)
+static inline struct page *pmd_pgtable_page(pmd_t *pmd)
 {
 	unsigned long mask = ~(PTRS_PER_PMD * sizeof(pmd_t) - 1);
 	return virt_to_page((void *)((unsigned long) pmd & mask));
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

documentation-mm-update-pmd_present-in-arch_pgtable_helpersrst.patch
mm-thp-rename-pmd_to_page-as-pmd_pgtable_page.patch
s390-mm-use-pmd_pgtable_page-helper-in-__gmap_segment_gaddr.patch


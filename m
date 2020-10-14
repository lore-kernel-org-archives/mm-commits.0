Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61B73C433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:03:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1234922248
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709419;
	bh=Djm8DiVySOMeUYrRd0riAjZBy+XOb3/gbWgfMBUJCBw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=MBDSMc+oIBs8Y9Yeyu26bRTLvrCt2JebyjXPMwCM8ow7Q8qZc1x0r+dBgsPBcnsQD
	 dFO3R7s/5xoUftfHjd9I18TjMTSaXoCcEdLLfp02Fv8HLvp5LfR206+1ipKLiVcEFQ
	 5XrGNRGu2UseAQjrtiZJmrgdRCaNcXpVBCLhGbVg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730532AbgJNVDi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:03:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:53348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgJNVDi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:03:38 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABBA1206B2;
        Wed, 14 Oct 2020 21:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709418;
        bh=Djm8DiVySOMeUYrRd0riAjZBy+XOb3/gbWgfMBUJCBw=;
        h=Date:From:To:Subject:From;
        b=MwzyB5EtM6Vy7Hq6HwQFkwCvwDeg2s6MTu7A8w2f4mUGwzrtUoH7HpaYJrn5yv1Vl
         rBy1ojVleCeDRpRECoFlLdHA2ZvqhB5itatFGuninwdTbOUK8xR8wftIGSSnF27wea
         x5j0303Pq+onaDRxR9DyQPoANXklXZmM/8cmcULo=
Date:   Wed, 14 Oct 2020 14:03:37 -0700
From:   akpm@linux-foundation.org
To:     dave@stgolabs.net, kirill.shutemov@linux.intel.com,
        mhocko@kernel.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [merged]
 hugetlb-add-lockdep-check-for-i_mmap_rwsem-held-in-huge_pmd_share.patch
 removed from -mm tree
Message-ID: <20201014210337.Jxn4Uy_zy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: add lockdep check for i_mmap_rwsem held in huge_pmd_share
has been removed from the -mm tree.  Its filename was
     hugetlb-add-lockdep-check-for-i_mmap_rwsem-held-in-huge_pmd_share.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: add lockdep check for i_mmap_rwsem held in huge_pmd_share

As a debugging aid, huge_pmd_share should make sure i_mmap_rwsem is held
if necessary.  To clarify the 'if necessary', expand the comment block at
the beginning of huge_pmd_share.

No functional change.  The added i_mmap_assert_locked() call is only
enabled if CONFIG_LOCKDEP.

Ideally, this should have been included with commit 34ae204f1851
("hugetlbfs: remove call to huge_pte_alloc without i_mmap_rwsem").

Link: https://lkml.kernel.org/r/20200911201248.88537-1-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~hugetlb-add-lockdep-check-for-i_mmap_rwsem-held-in-huge_pmd_share
+++ a/mm/hugetlb.c
@@ -5337,10 +5337,16 @@ void adjust_range_if_pmd_sharing_possibl
  * !shared pmd case because we can allocate the pmd later as well, it makes the
  * code much cleaner.
  *
- * This routine must be called with i_mmap_rwsem held in at least read mode.
- * For hugetlbfs, this prevents removal of any page table entries associated
- * with the address space.  This is important as we are setting up sharing
- * based on existing page table entries (mappings).
+ * This routine must be called with i_mmap_rwsem held in at least read mode if
+ * sharing is possible.  For hugetlbfs, this prevents removal of any page
+ * table entries associated with the address space.  This is important as we
+ * are setting up sharing based on existing page table entries (mappings).
+ *
+ * NOTE: This routine is only called from huge_pte_alloc.  Some callers of
+ * huge_pte_alloc know that sharing is not possible and do not take
+ * i_mmap_rwsem as a performance optimization.  This is handled by the
+ * if !vma_shareable check at the beginning of the routine. i_mmap_rwsem is
+ * only required for subsequent processing.
  */
 pte_t *huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud)
 {
@@ -5357,6 +5363,7 @@ pte_t *huge_pmd_share(struct mm_struct *
 	if (!vma_shareable(vma, addr))
 		return (pte_t *)pmd_alloc(mm, pud, addr);
 
+	i_mmap_assert_locked(mapping);
 	vma_interval_tree_foreach(svma, &mapping->i_mmap, idx, idx) {
 		if (svma == vma)
 			continue;
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are



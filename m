Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88251C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 22:34:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232062AbiEMWer (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 18:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbiEMWer (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 18:34:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A041513F28
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 15:34:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5791FB831E6
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 22:34:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F17ECC34100;
        Fri, 13 May 2022 22:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652481283;
        bh=DDQKFht8lJGLT/G3ZXjlZuVG4iOuqS8K4wI2sRep/k8=;
        h=Date:To:From:Subject:From;
        b=TlxywDq4HmwpVX0q0N51VIYoE5fpFnnPPb8GtMwyJYQDJiFQhNMKpDWfxT0Xsst8v
         IwoXR3GeBgrF8qRw6merO1VTnT8OzEG5E/YXJa5svGQfO0t6N1AOcmqbsUH+g+UI7v
         +Q6qPpi5U7KGUJgg8AhEAOtPBOkjfrbJW18iZDqQ=
Date:   Fri, 13 May 2022 15:34:42 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, david@redhat.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration-v4.patch removed from -mm tree
Message-Id: <20220513223442.F17ECC34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: rmap: Fix CONT-PTE/PMD size hugetlb issue when migration
has been removed from the -mm tree.  Its filename was
     mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration-v4.patch

This patch was dropped because it was folded into mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration.patch

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: rmap: Fix CONT-PTE/PMD size hugetlb issue when migration

fix build errors for !CONFIG_MMU

Link: https://lkml.kernel.org/r/a4baca670aca637e7198d9ae4543b8873cb224dc.1652270205.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/hugetlb.h~mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration-v4
+++ a/include/linux/hugetlb.h
@@ -1094,18 +1094,16 @@ static inline void set_huge_swap_pte_at(
 {
 }
 
-#ifdef CONFIG_MMU
 static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
 					  unsigned long addr, pte_t *ptep)
 {
-	return ptep_get(ptep);
+	return *ptep;
 }
 
 static inline void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
 				   pte_t *ptep, pte_t pte)
 {
 }
-#endif
 #endif	/* CONFIG_HUGETLB_PAGE */
 
 static inline spinlock_t *huge_pte_lock(struct hstate *h,
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-change-huge_ptep_clear_flush-to-return-the-original-pte.patch
mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration.patch
mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-unmapping.patch


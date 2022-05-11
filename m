Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30DC1C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 11 May 2022 22:06:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348534AbiEKWGT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 May 2022 18:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbiEKWGT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 May 2022 18:06:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD9D22B07
        for <mm-commits@vger.kernel.org>; Wed, 11 May 2022 15:06:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55ABD61CEB
        for <mm-commits@vger.kernel.org>; Wed, 11 May 2022 22:06:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA2EC340EE;
        Wed, 11 May 2022 22:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652306776;
        bh=vs0YibubvGBG++jkUos1GSKLNdkbm0ggWefoe9+kSHc=;
        h=Date:To:From:Subject:From;
        b=v8BzxuKad7zWxtAJzEV+TkDYpC358HbwlYOryLgUY3L8PC526hyfn5uukBhT6HbCJ
         EFhviwkEY8jikTBNNrBPKphqhJjP+bm2tT6lx6L6obxnW4nJCkNLIM0zG6kO26i4gA
         FvlzbXoN/WGhWCMF7N9kiuCQcRLouWE6XGErHahg=
Date:   Wed, 11 May 2022 15:06:16 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, david@redhat.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration-v4.patch added to mm-unstable branch
Message-Id: <20220511220616.AAA2EC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rmap: Fix CONT-PTE/PMD size hugetlb issue when migration
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration-v4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration-v4.patch

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
mm-change-huge_ptep_clear_flush-to-return-the-original-pte-fix-2.patch
mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration.patch
mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration-v4.patch
mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-unmapping.patch


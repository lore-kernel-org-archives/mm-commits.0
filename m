Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F0DDC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 23:18:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234860AbiEJXSB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 19:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiEJXSA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 19:18:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F0D25A7A8
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 16:17:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84D95B82014
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 23:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29DD4C385CC;
        Tue, 10 May 2022 23:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652224677;
        bh=/H/xvQk1l/TSZMWNzIW2pd0ekxsETNdkLl1eM2EaEYE=;
        h=Date:To:From:Subject:From;
        b=NjI7Qndg1umTfDVhLPJ5sGxKopUklTvyGsKwQ9/IRPNYFiWyJ2BRyai2GNd2AxP4B
         YPOvnUGLbojYwZZ4LiCKuBdVqZZaxT+OT9eAYPEPNeEisGwxtuE8h0tYIxurAFwOEA
         +F2yJ9qvz036A6RIVoU2QWrh+aNrEezGqJFwUPfY=
Date:   Tue, 10 May 2022 16:17:56 -0700
To:     mm-commits@vger.kernel.org, baolin.wang@linux.alibaba.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration-fix.patch added to mm-unstable branch
Message-Id: <20220510231757.29DD4C385CC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration-fix

fix nommu build

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   11 -----------
 1 file changed, 11 deletions(-)

--- a/include/linux/hugetlb.h~mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration-fix
+++ a/include/linux/hugetlb.h
@@ -1093,17 +1093,6 @@ static inline void set_huge_swap_pte_at(
 					pte_t *ptep, pte_t pte, unsigned long sz)
 {
 }
-
-static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
-					  unsigned long addr, pte_t *ptep)
-{
-	return ptep_get(ptep);
-}
-
-static inline void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
-				   pte_t *ptep, pte_t pte)
-{
-}
 #endif	/* CONFIG_HUGETLB_PAGE */
 
 static inline spinlock_t *huge_pte_lock(struct hstate *h,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch
lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix.patch
mm-start-tracking-vmas-with-maple-tree-fix.patch
damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix.patch
mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch


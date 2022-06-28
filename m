Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F06FDCCA47E
	for <mm-commits@archiver.kernel.org>; Tue, 28 Jun 2022 19:53:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbiF1Tx6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Jun 2022 15:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233532AbiF1Twz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jun 2022 15:52:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D502622537
        for <mm-commits@vger.kernel.org>; Tue, 28 Jun 2022 12:52:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D52FB81FE2
        for <mm-commits@vger.kernel.org>; Tue, 28 Jun 2022 19:51:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12770C3411D;
        Tue, 28 Jun 2022 19:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656445918;
        bh=TM/Y1GnqQOOonKajlPOVjXRzuhyyvX2VixHPeEeLvA4=;
        h=Date:To:From:Subject:From;
        b=UPAynfDw4+qLE4V6mcVxKridGSNCYwo4hq3WT6pK4pRH3QsBEhSWCL00WtOAxW1T/
         GPOkj2jO+QDITxO2rF54suijcxDcu6ThK+9G/bUczHtta2pjuqelA46y5tlFhT1aSy
         y4m0wKpV6YEVd8Ln8ZxLwkOnbkp57Er3WZjUZQPA=
Date:   Tue, 28 Jun 2022 12:51:57 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-hugetlb-implement-arm64-specific-hugetlb_mask_last_page-fix.patch added to mm-unstable branch
Message-Id: <20220628195158.12770C3411D@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64-hugetlb-implement-arm64-specific-hugetlb_mask_last_page-fix
has been added to the -mm mm-unstable branch.  Its filename is
     arm64-hugetlb-implement-arm64-specific-hugetlb_mask_last_page-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-hugetlb-implement-arm64-specific-hugetlb_mask_last_page-fix.patch

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
Subject: arm64-hugetlb-implement-arm64-specific-hugetlb_mask_last_page-fix
Date: Mon, 27 Jun 2022 13:55:37 +0800

I missed the case that '__PAGETABLE_PMD_FOLDED', was defined, which PUD is
same with PMD.

Link: https://lkml.kernel.org/r/a14e7b39-6a8a-4609-b4a1-84ac574f5c96@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/hugetlbpage.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/mm/hugetlbpage.c~arm64-hugetlb-implement-arm64-specific-hugetlb_mask_last_page-fix
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -373,8 +373,10 @@ unsigned long hugetlb_mask_last_page(str
 	unsigned long hp_size = huge_page_size(h);
 
 	switch (hp_size) {
+#ifndef __PAGETABLE_PMD_FOLDED
 	case PUD_SIZE:
 		return PGDIR_SIZE - PUD_SIZE;
+#endif
 	case CONT_PMD_SIZE:
 		return PUD_SIZE - CONT_PMD_SIZE;
 	case PMD_SIZE:
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-damon-use-set_huge_pte_at-to-make-huge-pte-old.patch
mm-hugetlb-remove-unnecessary-huge_ptep_set_access_flags-in-hugetlb_mcopy_atomic_pte.patch
mm-rmap-simplify-the-hugetlb-handling-when-unmapping-or-migration.patch
arm64-hugetlb-implement-arm64-specific-hugetlb_mask_last_page.patch
arm64-hugetlb-implement-arm64-specific-hugetlb_mask_last_page-fix.patch


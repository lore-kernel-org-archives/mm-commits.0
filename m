Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7599C2B9F2
	for <mm-commits@archiver.kernel.org>; Sat, 22 May 2021 22:17:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B0FF61182
	for <mm-commits@archiver.kernel.org>; Sat, 22 May 2021 22:17:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbhEVWTW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 May 2021 18:19:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231428AbhEVWTV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 22 May 2021 18:19:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 822DF610C9;
        Sat, 22 May 2021 22:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621721875;
        bh=Ke+/fOZGK7LXWYhWNjcsGQKElMQD8ySzQp19TeVfIuI=;
        h=Date:From:To:Subject:From;
        b=dDUBycZoZac+M6gXi+FHFhxAk1mYw46nuIZERt+5dSJS14VwSl2d39H3mpimMhgLB
         kVkKtevLnT1wUXNJwOP/CWaMZNyfJjqVW97o1TH9t4ZoaI2nbCzo6zCrHIdnSS4duY
         bI1fTbErASUrUT66mMWsiz6FDlM7A0eZFGpsgYWY=
Date:   Sat, 22 May 2021 15:17:55 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, hughd@google.com,
        mm-commits@vger.kernel.org, ziy@nvidia.com
Subject:  [nacked]
 mm-thp-update-mm_structs-mm_anonpages-stat-for-huge-zero-pages.patch
 removed from -mm tree
Message-ID: <20210522221755.V5DcwaZ_n%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: update mm_struct's MM_ANONPAGES stat for huge zero pages
has been removed from the -mm tree.  Its filename was
     mm-thp-update-mm_structs-mm_anonpages-stat-for-huge-zero-pages.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/thp: update mm_struct's MM_ANONPAGES stat for huge zero pages

Although the zero huge page is being shared across various processes, each
mapping needs to update its mm_struct's MM_ANONPAGES stat by HPAGE_PMD_NR
to be consistent.  This just updates the stats in set_huge_zero_page()
after the mapping gets created and in zap_huge_pmd() when mapping gets
destroyed.

Link: https://lkml.kernel.org/r/1621313300-1118-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Zi Yan<ziy@nvidia.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/huge_memory.c~mm-thp-update-mm_structs-mm_anonpages-stat-for-huge-zero-pages
+++ a/mm/huge_memory.c
@@ -715,6 +715,7 @@ static void set_huge_zero_page(pgtable_t
 	if (pgtable)
 		pgtable_trans_huge_deposit(mm, pmd, pgtable);
 	set_pmd_at(mm, haddr, pmd, entry);
+	add_mm_counter(mm, MM_ANONPAGES, HPAGE_PMD_NR);
 	mm_inc_nr_ptes(mm);
 }
 
@@ -1627,6 +1628,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 		spin_unlock(ptl);
 	} else if (is_huge_zero_pmd(orig_pmd)) {
 		zap_deposited_table(tlb->mm, pmd);
+		add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
 		spin_unlock(ptl);
 	} else {
 		struct page *page = NULL;
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-debug_vm_pgtable-ensure-thp-availability-via-has_transparent_hugepage.patch
mm-thp-make-alloc_split_ptlocks-dependent-on-use_split_pte_ptlocks.patch
mm-define-default-value-for-first_user_address.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2462BC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 19:10:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1A4F64D8F
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 19:10:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235857AbhBXTKK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 14:10:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:40014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235954AbhBXTIz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 14:08:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAA6864F1D;
        Wed, 24 Feb 2021 19:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614193500;
        bh=W2OhRs4Uj0j6UHzUSUy5D0e1g6WebmIVTb2aLcqNF28=;
        h=Date:From:To:Subject:From;
        b=sZZ3jSrWN8eA6kQQJRew0I3aPim5vx60AvSck1hr6vuL5CCHowUv1EfmIENxgFnPl
         V8PiUBco0hVFIK8xJ25vEMOEKEXFwrVqFv70LSJoJ0IRt/jtNpRmf6HqU4YiJEsdsP
         u2nMNNpY+A9SXMGuDHNouH7s382kUgJyGr+mWKfY=
Date:   Wed, 24 Feb 2021 11:04:59 -0800
From:   akpm@linux-foundation.org
To:     mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        songmuchun@bytedance.com
Subject:  [folded-merged]
 hugetlb-convert-page_huge_active-hpagemigratable-flag-fix.patch removed
 from -mm tree
Message-ID: <20210224190459.NTHW403Bh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb-convert-page_huge_active-hpagemigratable-flag-fix
has been removed from the -mm tree.  Its filename was
     hugetlb-convert-page_huge_active-hpagemigratable-flag-fix.patch

This patch was dropped because it was folded into hugetlb-convert-page_huge_active-hpagemigratable-flag.patch

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: hugetlb-convert-page_huge_active-hpagemigratable-flag-fix

remove set_page_huge_active() declaration from include/linux/hugetlb.h

Link: https://lkml.kernel.org/r/CAMZfGtUda+KoAZscU0718TN61cSFwp4zy=y2oZ=+6Z2TAZZwng@mail.gmail.com
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/hugetlb.h~hugetlb-convert-page_huge_active-hpagemigratable-flag-fix
+++ a/include/linux/hugetlb.h
@@ -843,8 +843,6 @@ static inline void huge_ptep_modify_prot
 }
 #endif
 
-void set_page_huge_active(struct page *page);
-
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage.patch
mm-memcontrol-fix-nr_anon_thps-accounting-in-charge-moving.patch
mm-memcontrol-convert-nr_anon_thps-account-to-pages.patch
mm-memcontrol-convert-nr_file_thps-account-to-pages.patch
mm-memcontrol-convert-nr_shmem_thps-account-to-pages.patch
mm-memcontrol-convert-nr_shmem_pmdmapped-account-to-pages.patch
mm-memcontrol-convert-nr_file_pmdmapped-account-to-pages.patch
mm-memcontrol-make-the-slab-calculation-consistent.patch
mm-memcontrol-replace-the-loop-with-a-list_for_each_entry.patch
mm-memcontrol-fix-swap-undercounting-in-cgroup2.patch
mm-memcontrol-fix-get_active_memcg-return-value.patch
mm-memcontrol-fix-slub-memory-accounting.patch
hugetlb-convert-page_huge_active-hpagemigratable-flag.patch


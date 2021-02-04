Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C157C433DB
	for <mm-commits@archiver.kernel.org>; Thu,  4 Feb 2021 00:34:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEAF264F5F
	for <mm-commits@archiver.kernel.org>; Thu,  4 Feb 2021 00:34:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbhBDAeS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Feb 2021 19:34:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:35724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231817AbhBDAeR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Feb 2021 19:34:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9A6764F5C;
        Thu,  4 Feb 2021 00:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612398817;
        bh=mklPpOFVT+qUl2aV+gioXy/yT7quUyEGJqr5mDFcVsM=;
        h=Date:From:To:Subject:From;
        b=2maX69Y/xLsmzJPrPe46t5xP7wUdEQF//t+imArScuzOCQFw7sFOTWlj073jl+WAX
         VvKIbd0P085TYyTkqq6SMWQ/51wgEhO+lo6izFsb/4e//Cgs8rWD82131TkdMqOvm3
         gH2A2L6txa30ekNr+omCavbxUaoCzZ7Lqt5G+7BM=
Date:   Wed, 03 Feb 2021 16:33:36 -0800
From:   akpm@linux-foundation.org
To:     mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        songmuchun@bytedance.com
Subject:  +
 hugetlb-convert-page_huge_active-hpagemigratable-flag-fix.patch added to
 -mm tree
Message-ID: <20210204003336.Ti1A_lM3U%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb-convert-page_huge_active-hpagemigratable-flag-fix
has been added to the -mm tree.  Its filename is
     hugetlb-convert-page_huge_active-hpagemigratable-flag-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-convert-page_huge_active-hpagemigratable-flag-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-convert-page_huge_active-hpagemigratable-flag-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-hugetlbfs-fix-cannot-migrate-the-fallocated-hugetlb-page.patch
mm-hugetlb-fix-a-race-between-freeing-and-dissolving-the-page.patch
mm-hugetlb-fix-a-race-between-isolating-and-freeing-page.patch
mm-hugetlb-remove-vm_bug_on_page-from-page_huge_active.patch
mm-migrate-do-not-migrate-hugetlb-page-whose-refcount-is-one.patch
mm-hugetlb-fix-missing-put_page-in-gather_surplus_pages.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage.patch
mm-memcontrol-fix-nr_anon_thps-accounting-in-charge-moving.patch
mm-memcontrol-convert-nr_anon_thps-account-to-pages.patch
mm-memcontrol-convert-nr_file_thps-account-to-pages.patch
mm-memcontrol-convert-nr_shmem_thps-account-to-pages.patch
mm-memcontrol-convert-nr_shmem_pmdmapped-account-to-pages.patch
mm-memcontrol-convert-nr_file_pmdmapped-account-to-pages.patch
mm-memcontrol-make-the-slab-calculation-consistent.patch
hugetlb-convert-page_huge_active-hpagemigratable-flag-fix.patch


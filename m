Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67640C433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:33:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A096613EC
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:33:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbhEEBeP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:34:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231925AbhEEBeO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:34:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58E36613E4;
        Wed,  5 May 2021 01:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178397;
        bh=qgZsKn4b3HobiV8z2CTAOqzi1yT5j+ZAk1iu+6nMwcs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=owBpKrS+LawbcGZva/mrvl1Hjn0w7xh6xscJlCLGyxscWIDVFKPVjAbQ+dEf2kYUc
         IEmM1uNuSua4t5rKwuTKUkxwVWRgZaKIeTZiS9JMzomQw2JplnTx5WMx9GYrDwtZ3A
         W2ZonpDX8VIN18NtAs+fn5wkQ16MAtd9HR+0Q5GU=
Date:   Tue, 04 May 2021 18:33:16 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 010/143] mm/hugetlb: remove redundant reservation
 check condition in alloc_huge_page()
Message-ID: <20210505013316.omcrg4PPG%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: remove redundant reservation check condition in alloc_huge_page()

vma_resv_map(vma) checks if a reserve map is associated with the vma.  The
routine vma_needs_reservation() will check vma_resv_map(vma) and return 1
if no reserv map is present.  map_chg is set to the return value of
vma_needs_reservation().  Therefore, !vma_resv_map(vma) is redundant in
the expression:

	map_chg || avoid_reserve || !vma_resv_map(vma);

Remove the redundant check.

[Thanks Mike Kravetz for reshaping this commit message!]

Link: https://lkml.kernel.org/r/20210301104726.45159-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-remove-redundant-reservation-check-condition-in-alloc_huge_page
+++ a/mm/hugetlb.c
@@ -2316,7 +2316,7 @@ struct page *alloc_huge_page(struct vm_a
 
 	/* If this allocation is not consuming a reservation, charge it now.
 	 */
-	deferred_reserve = map_chg || avoid_reserve || !vma_resv_map(vma);
+	deferred_reserve = map_chg || avoid_reserve;
 	if (deferred_reserve) {
 		ret = hugetlb_cgroup_charge_cgroup_rsvd(
 			idx, pages_per_huge_page(h), &h_cg);
_

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DB63C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:46:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5175561426
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:46:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhEHWrZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:47:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhEHWrZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:47:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8254A61415;
        Sat,  8 May 2021 22:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513983;
        bh=sWAEECsz/RVezCVvo51NfDzfeSqhFI7WUKbdQcuiTXE=;
        h=Date:From:To:Subject:From;
        b=c+vayk1Z8YowrQvsyo8Unq2rH2u8b9JqJGww3k/MD/UVQCfzx0slc7rIsywI4376s
         9qtuMaLV0dDU46KO6IFxI90NrKb7UpTMBM1Ax32xEYQoFBExcxuNiqoWeOZEi8jFCO
         udpM+zxPYf9fhIv29ksLp8JxZtz7thspbJyaNCh8=
Date:   Sat, 08 May 2021 15:46:23 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?mm-hugetlb-remove-redundant-reservation-check-condition-in-a?=
 =?US-ASCII?Q?lloc=5Fhuge=5Fpage.patch?= removed from -mm tree
Message-ID: <20210508224623.k8a8bmYkW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: remove redundant reservation check condition in alloc_huge_page()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-remove-redundant-reservation-check-condition-in-alloc_huge_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are



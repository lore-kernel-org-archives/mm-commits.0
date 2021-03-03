Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B0DCC433E0
	for <mm-commits@archiver.kernel.org>; Wed,  3 Mar 2021 13:33:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEB4A64E02
	for <mm-commits@archiver.kernel.org>; Wed,  3 Mar 2021 13:33:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381334AbhCCNaL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 08:30:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:60222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232583AbhCCAMK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Mar 2021 19:12:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7AA360234;
        Wed,  3 Mar 2021 00:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614729755;
        bh=n23iScjmE6AMQAJf8609TFlTdmMUMsDa04yAdGN7sY4=;
        h=Date:From:To:Subject:From;
        b=aycWdvSk1OC3vqcDyVisi8Nk2SENLEzO7Q1FgTptx7gtEb0/ymPqxN3O0NYHLngpJ
         lpmivs3CPJvkapz1dluunZQxpE+K/NIplsGH7G2vkmmntRdwqcbSveegD7W4L1S8gX
         U00GNNW2MJw8cng9e8i/EEWL8nqr24VuVGjDtano=
Date:   Tue, 02 Mar 2021 16:02:34 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?mm-hugetlb-remove-redundant-reservation-check-condition-in-a?=
 =?US-ASCII?Q?lloc=5Fhuge=5Fpage.patch?= added to -mm tree
Message-ID: <20210303000234.WFozoLnBy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: remove redundant reservation check condition in alloc_huge_page()
has been added to the -mm tree.  Its filename is
     mm-hugetlb-remove-redundant-reservation-check-condition-in-alloc_huge_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-remove-redundant-reservation-check-condition-in-alloc_huge_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-remove-redundant-reservation-check-condition-in-alloc_huge_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2314,7 +2314,7 @@ struct page *alloc_huge_page(struct vm_a
 
 	/* If this allocation is not consuming a reservation, charge it now.
 	 */
-	deferred_reserve = map_chg || avoid_reserve || !vma_resv_map(vma);
+	deferred_reserve = map_chg || avoid_reserve;
 	if (deferred_reserve) {
 		ret = hugetlb_cgroup_charge_cgroup_rsvd(
 			idx, pages_per_huge_page(h), &h_cg);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

hugetlb_cgroup-fix-imbalanced-css_get-and-css_put-pair-for-shared-mappings.patch
mm-hugetlb-remove-redundant-reservation-check-condition-in-alloc_huge_page.patch


Return-Path: <SRS0=GeP8=CC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF7E3C433E1
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 22:19:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DCE72083B
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 22:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598307576;
	bh=CxeDB7+jFAOjPtpkvod84o0S/FsxEwhV4Su9Czjhb30=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Kd3MTOZPmCzk/Vf3JI1w3BOLZ8A/HQW66tUy+H8QVOqAtylENu1vxM7Gdkaxklo47
	 EnKGjZ4rSHkbeQ/rVRVMMzw8+YYTrV1AHKXlCG9MTbvML1JqmG98Zbhpp8deovW3+a
	 5bglH1GoUv1PR20HpGgK1WO2C0br9c9EfRfSQRGo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgHXWTg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Aug 2020 18:19:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgHXWTa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Aug 2020 18:19:30 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E705B2074D;
        Mon, 24 Aug 2020 22:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598307570;
        bh=CxeDB7+jFAOjPtpkvod84o0S/FsxEwhV4Su9Czjhb30=;
        h=Date:From:To:Subject:From;
        b=vhXkF1Omd58CDd0YVCdjN1xvKOM2dAXdjvhqvJwOGzvrxxLVtwYcYeLj+U3D5Ixcm
         dH/X+/uLUM+R4M8Z+sR4f+8PiUX1CjIDWVJfvlDXCTDZS27OuHPVQYsH8ZXHwBzoci
         aHHv/hM8ZvqU1XIWuqTE74oJAKG+VDLRESBFAl28=
Date:   Mon, 24 Aug 2020 15:19:29 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, bhe@redhat.com, david@redhat.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org
Subject:  +
 mm-hugetlbc-make-is_hugetlb_entry_hwpoisoned-return-bool.patch added to -mm
 tree
Message-ID: <20200824221929.I3G1aQFd0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: make is_hugetlb_entry_hwpoisoned return bool
has been added to the -mm tree.  Its filename is
     mm-hugetlbc-make-is_hugetlb_entry_hwpoisoned-return-bool.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlbc-make-is_hugetlb_entry_hwpoisoned-return-bool.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlbc-make-is_hugetlb_entry_hwpoisoned-return-bool.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/hugetlb.c: make is_hugetlb_entry_hwpoisoned return bool

Patch series "mm/hugetlb: Small cleanup and improvement", v2.


This patch (of 3):

Just like its neighbour is_hugetlb_entry_migration() has done.

Link: https://lkml.kernel.org/r/20200723032248.24772-1-bhe@redhat.com
Link: https://lkml.kernel.org/r/20200723032248.24772-2-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlbc-make-is_hugetlb_entry_hwpoisoned-return-bool
+++ a/mm/hugetlb.c
@@ -3780,17 +3780,17 @@ bool is_hugetlb_entry_migration(pte_t pt
 		return false;
 }
 
-static int is_hugetlb_entry_hwpoisoned(pte_t pte)
+static bool is_hugetlb_entry_hwpoisoned(pte_t pte)
 {
 	swp_entry_t swp;
 
 	if (huge_pte_none(pte) || pte_present(pte))
-		return 0;
+		return false;
 	swp = pte_to_swp_entry(pte);
 	if (non_swap_entry(swp) && is_hwpoison_entry(swp))
-		return 1;
+		return true;
 	else
-		return 0;
+		return false;
 }
 
 int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-hugetlbc-make-is_hugetlb_entry_hwpoisoned-return-bool.patch
mm-hugetlbc-remove-the-unnecessary-non_swap_entry.patch
doc-vm-fix-typo-in-the-hugetlb-admin-documentation.patch


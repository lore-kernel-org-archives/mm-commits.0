Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2FCBC433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:56:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2EF12222E
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633372;
	bh=/0x28nZleSQIZOqpAdWMf0e2k2zYxlm7HPDHDPCHGFI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Ur1rfYbmyP9M3REKdk4uvOekHuUaIlc63j+8jG5NtJ2gQ5+XA6NSl5cmsJtfkkFfY
	 SOw2ZrLn+G4A/zZhx3PmFO5+JDqYSr0NzbBhrwrBq0msWjCq7PI5fu0yqrDe9z/EVG
	 Wfo8fLpAJ1Of7ZXdz0eQN+B2aM0d1F3n6h6BzgWQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388614AbgJMX4M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:56:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387742AbgJMX4M (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:56:12 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09B072222F;
        Tue, 13 Oct 2020 23:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633371;
        bh=/0x28nZleSQIZOqpAdWMf0e2k2zYxlm7HPDHDPCHGFI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=pkgaleqhU3Q0jIQ319lL9TJDy2wV8E3yEtdSXUNtDmK5284hatBh3bcVXGhgyMTH0
         xFrcRjOIONVHrsVDf3wu7vb4ayONFO7adV3u0lJ+HD0P2/j4W7WeR2MNeAn6bOgYcv
         6UmdN6PV4qeUL0bCKC0UnYzhxxdvssHzl2USmIPQ=
Date:   Tue, 13 Oct 2020 16:56:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        bhe@redhat.com, david@redhat.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 141/181] mm/hugetlb.c: make
 is_hugetlb_entry_hwpoisoned return bool
Message-ID: <20201013235610.aiWRuN5KL%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -3805,17 +3805,17 @@ bool is_hugetlb_entry_migration(pte_t pt
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

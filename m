Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2325BC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:03:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5BEA221FF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709388;
	bh=YZfkkQgYITv3Fdhgb2oY9V6PFQopDQyeAHuhBxa9ZDc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=O/bdHL8NhHFfwdWQgm+eGTpfwD33syUmN+TnXVlWLjD86X1YS/Yg1d7O9omsrxBwi
	 26/7VuvSmsfz3tjfIS14Ikf02HhvyaVCY4NsqVHY4eKOm40YrrBCivz4QcJOD6lIWr
	 IQZk4/DcNJ8Mk4wuoWVcq/gubmy5DVhLMTmHnpNc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388300AbgJNVDI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:03:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:52916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387703AbgJNVDI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:03:08 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91D07206B2;
        Wed, 14 Oct 2020 21:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709387;
        bh=YZfkkQgYITv3Fdhgb2oY9V6PFQopDQyeAHuhBxa9ZDc=;
        h=Date:From:To:Subject:From;
        b=qNiNaRdBZooDe9QcGxUfzyLGFd/Jt70iQYb2o5XVMwZN5NYjmEK+fy3kPzaf9WuvB
         me1y5JKlDFMimYN7RRVuUm4rCxYMqksc2gDTGfeWE6QtMlH8QcqZ+yqMmpU4SSPId6
         yWH7dTMptlpXNwy7UDJ7dgsMQhOWx5Hg6zzj81hg=
Date:   Wed, 14 Oct 2020 14:03:07 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, bhe@redhat.com, david@redhat.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-hugetlbc-make-is_hugetlb_entry_hwpoisoned-return-bool.patch removed from
 -mm tree
Message-ID: <20201014210307.eGjCyJa3e%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: make is_hugetlb_entry_hwpoisoned return bool
has been removed from the -mm tree.  Its filename was
     mm-hugetlbc-make-is_hugetlb_entry_hwpoisoned-return-bool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from bhe@redhat.com are



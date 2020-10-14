Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49474C433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:03:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2128221FF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709392;
	bh=5kRAW5fq7SeK2hzK//s0v95EcUAjrAqDxufFfPAr0cA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=GFoRIV+qE5oX232PeQ8QBgAkrq6i9RFRtEjun/2fcQhY98RWbZP1WPFs60Ubc1Rhy
	 h3/pcMMH/yktIuw+3yoMRjgz8W0wu1/Xs10Hz0Niyl/1APegvn2023s+r2Wh+KAfJm
	 zSDvidqiMV3eJ2XZ+fr6c3e/lAuIo8VrA/VgLeBg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388275AbgJNVDL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:03:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387703AbgJNVDL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:03:11 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8849F206B2;
        Wed, 14 Oct 2020 21:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709390;
        bh=5kRAW5fq7SeK2hzK//s0v95EcUAjrAqDxufFfPAr0cA=;
        h=Date:From:To:Subject:From;
        b=z9ngvsALqBh8zSNJ/2mRmyEt855oWQ8qYUM/fCdL+P8y2swnnS07t/O5hKVKkatln
         ZE6mm1TvpiG/YwJr8YVhhrGWsaA4p7D/5pq4MnDW0OcSC9yIh67MYxXjW4btf1+jA6
         nJN/dSJC7sIHwcTRnb001WAOZu0JFY+NGsnfjbC4=
Date:   Wed, 14 Oct 2020 14:03:10 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, bhe@redhat.com, david@redhat.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-hugetlbc-remove-the-unnecessary-non_swap_entry.patch removed from -mm
 tree
Message-ID: <20201014210310.I53q9YA9V%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: remove the unnecessary non_swap_entry()
has been removed from the -mm tree.  Its filename was
     mm-hugetlbc-remove-the-unnecessary-non_swap_entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/hugetlb.c: remove the unnecessary non_swap_entry()

If a swap entry tests positive for either is_[migration|hwpoison]_entry(),
then its swap_type() is among SWP_MIGRATION_READ, SWP_MIGRATION_WRITE and
SWP_HWPOISON.  All these types >= MAX_SWAPFILES, exactly what is asserted
with non_swap_entry().

So the checking non_swap_entry() in is_hugetlb_entry_migration() and
is_hugetlb_entry_hwpoisoned() is redundant.

Let's remove it to optimize code.

Link: https://lkml.kernel.org/r/20200723032248.24772-3-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlbc-remove-the-unnecessary-non_swap_entry
+++ a/mm/hugetlb.c
@@ -3799,7 +3799,7 @@ bool is_hugetlb_entry_migration(pte_t pt
 	if (huge_pte_none(pte) || pte_present(pte))
 		return false;
 	swp = pte_to_swp_entry(pte);
-	if (non_swap_entry(swp) && is_migration_entry(swp))
+	if (is_migration_entry(swp))
 		return true;
 	else
 		return false;
@@ -3812,7 +3812,7 @@ static bool is_hugetlb_entry_hwpoisoned(
 	if (huge_pte_none(pte) || pte_present(pte))
 		return false;
 	swp = pte_to_swp_entry(pte);
-	if (non_swap_entry(swp) && is_hwpoison_entry(swp))
+	if (is_hwpoison_entry(swp))
 		return true;
 	else
 		return false;
_

Patches currently in -mm which might be from bhe@redhat.com are



Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D669DC433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:56:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AD8922247
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633375;
	bh=QDroUX7GZvfkiHVE6W4p674+VkmKCAJG001MUTSWoXY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=F0aYc/SVrJKjCCjWfqyB/3EyjpVLtCrj8XyNEQwh/jnaZeN58EKdQHSf9zxi6ABOP
	 ua+b8aC1bdACsAejIJe7OpxrewNcELuAZCc77PEgdhfUvQSrRSxpv+ZywvuYGA6/d6
	 DKGK5jE3EQuFcOtSGcVWeoqRqY471/ll/fhU6jWY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388617AbgJMX4P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:56:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:41864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387742AbgJMX4P (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:56:15 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F2962222F;
        Tue, 13 Oct 2020 23:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633374;
        bh=QDroUX7GZvfkiHVE6W4p674+VkmKCAJG001MUTSWoXY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=usYMWorS2EEBkAdwm9NoVJG1if2+uAXK5HZso08L3ODRxejJaJxY0JD636l5c845o
         65Io83Q5L+Nn61sDEYdhFaK9VRKj+IxCckDDDCZbL+C6AktNamDSjKzSjaZQ/v+m6i
         q7x8lTptN32CZ6r88LFkBPMJZjHvYGaS9lZkA8X0=
Date:   Tue, 13 Oct 2020 16:56:14 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        bhe@redhat.com, david@redhat.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 142/181] mm/hugetlb.c: remove the unnecessary
 non_swap_entry()
Message-ID: <20201013235614.pL2sFGpWr%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

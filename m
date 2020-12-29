Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D2D4C433E0
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 19:21:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 218B9207B2
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 19:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbgL2TVn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Dec 2020 14:21:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:49534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726158AbgL2TVn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 29 Dec 2020 14:21:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EE8A207B2;
        Tue, 29 Dec 2020 19:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609269662;
        bh=fFWgpPcHiM+7jh858UcS7i8c0VkSG7lkxvrVQnO8Sfw=;
        h=Date:From:To:Subject:From;
        b=xQXhpEcd2xDKE+kjMIu0ZyZQSk9cTaFWRPQVyeIH095n7TQo6hvyRn5iXF6gvXVGH
         d4wVuqkAWmm/YZ+rJpZ6gPo8u4Po35lBm4ij9+jZAzPwcmq5pNynl/U3uNe8BVEJJY
         pjgSfPmARH+2oP3yCXvUIg3KJ/6KuyikEnHFgE6o=
Date:   Tue, 29 Dec 2020 11:21:02 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, peterx@redhat.com,
        mike.kravetz@oracle.com, lixinhai.lxh@gmail.com
Subject:  +
 mm-hugetlbc-fix-unnecessary-address-expansion-of-pmd-sharing.patch added to
 -mm tree
Message-ID: <20201229192102.RO1Sq%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: fix unnecessary address expansion of pmd sharing
has been added to the -mm tree.  Its filename is
     mm-hugetlbc-fix-unnecessary-address-expansion-of-pmd-sharing.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlbc-fix-unnecessary-address-expansion-of-pmd-sharing.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlbc-fix-unnecessary-address-expansion-of-pmd-sharing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Li Xinhai <lixinhai.lxh@gmail.com>
Subject: mm/hugetlb.c: fix unnecessary address expansion of pmd sharing

The current code would unnecessarily expand the address range.  Consider
one example, (start, end) = (1G-2M, 3G+2M), and (vm_start, vm_end) =
(1G-4M, 3G+4M), the expected adjustment should be keep (1G-2M, 3G+2M)
without expand.  But the current result will be (1G-4M, 3G+4M).  Actually,
the range (1G-4M, 1G) and (3G, 3G+4M) would never been involved in pmd
sharing.

After this patch, if pud aligned *start across vm_start, then we know the
*start and vm_start are in same pud_index, and vm_start is not pud
aligned, so don't adjust *start.  Same logic applied to *end.

Link: https://lkml.kernel.org/r/20201229042125.2663029-1-lixinhai.lxh@gmail.com
Fixes: commit 75802ca66354 ("mm/hugetlb: fix calculation of adjust_range_if_pmd_sharing_possible")
Signed-off-by: Li Xinhai <lixinhai.lxh@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlbc-fix-unnecessary-address-expansion-of-pmd-sharing
+++ a/mm/hugetlb.c
@@ -5269,11 +5269,16 @@ void adjust_range_if_pmd_sharing_possibl
 	a_end = ALIGN(*end, PUD_SIZE);
 
 	/*
-	 * Intersect the range with the vma range, since pmd sharing won't be
-	 * across vma after all
+	 * If the PUD aligned address across vma range, then it means the
+	 * vm_start/vm_end is not PUD aligned. In that case, we must don't
+	 * adjust range because pmd sharing is not possbile at the start and/or
+	 * end part of vma.
 	 */
-	*start = max(vma->vm_start, a_start);
-	*end = min(vma->vm_end, a_end);
+	if (a_start >= vma->vm_start)
+		*start = a_start;
+
+	if (a_end <= vma->vm_end)
+		*end = a_end;
 }
 
 /*
_

Patches currently in -mm which might be from lixinhai.lxh@gmail.com are

mm-hugetlbc-fix-unnecessary-address-expansion-of-pmd-sharing.patch


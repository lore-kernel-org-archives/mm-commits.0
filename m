Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9DA2C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:08:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8942264F1B
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:08:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234654AbhBXUIQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:08:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:59720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232446AbhBXUHg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:07:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A59664E20;
        Wed, 24 Feb 2021 20:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197215;
        bh=J32eFDCcaWW6E+PJ6XnxGzyIKiT/onRMncTa6LqCYJU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=MMCQZTSa3Ylo2UUgV2x95HqASRPIIcOmN8XP5qfVFlQjJIALEjARMLfEToxjlgtAz
         /V1LiIqNAAg9QzpzmmGlJcJsTg1lvqIWJfkoViWsFNgDceoZbXuWijoDGSMlUHcGAx
         Ii2o3aaJR15i8LSPYiPB7QZpwqsBvFqw0nUjyBFU=
Date:   Wed, 24 Feb 2021 12:06:54 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        lixinhai.lxh@gmail.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        torvalds@linux-foundation.org
Subject:  [patch 114/173] mm/hugetlb.c: fix unnecessary address
 expansion of pmd sharing
Message-ID: <20210224200654.pgKWTyt9O%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Li Xinhai <lixinhai.lxh@gmail.com>
Subject: mm/hugetlb.c: fix unnecessary address expansion of pmd sharing

The current code would unnecessarily expand the address range.  Consider
one example, (start, end) = (1G-2M, 3G+2M), and (vm_start, vm_end) =
(1G-4M, 3G+4M), the expected adjustment should be keep (1G-2M, 3G+2M)
without expand.  But the current result will be (1G-4M, 3G+4M).  Actually,
the range (1G-4M, 1G) and (3G, 3G+4M) would never been involved in pmd
sharing.

After this patch, we will check that the vma span at least one PUD aligned
size and the start,end range overlap the aligned range of vma.

With above example, the aligned vma range is (1G, 3G), so if (start, end)
range is within (1G-4M, 1G), or within (3G, 3G+4M), then no adjustment to
both start and end.  Otherwise, we will have chance to adjust start
downwards or end upwards without exceeding (vm_start, vm_end).

Mike:

: The 'adjusted range' is used for calls to mmu notifiers and cache(tlb)
: flushing.  Since the current code unnecessarily expands the range in some
: cases, more entries than necessary would be flushed.  This would/could
: result in performance degradation.  However, this is highly dependent on
: the user runtime.  Is there a combination of vma layout and calls to
: actually hit this issue?  If the issue is hit, will those entries
: unnecessarily flushed be used again and need to be unnecessarily reloaded?

Link: https://lkml.kernel.org/r/20210104081631.2921415-1-lixinhai.lxh@gmail.com
Fixes: 75802ca66354 ("mm/hugetlb: fix calculation of adjust_range_if_pmd_sharing_possible")
Signed-off-by: Li Xinhai <lixinhai.lxh@gmail.com>
Suggested-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlbc-fix-unnecessary-address-expansion-of-pmd-sharing
+++ a/mm/hugetlb.c
@@ -5288,21 +5288,23 @@ static bool vma_shareable(struct vm_area
 void adjust_range_if_pmd_sharing_possible(struct vm_area_struct *vma,
 				unsigned long *start, unsigned long *end)
 {
-	unsigned long a_start, a_end;
+	unsigned long v_start = ALIGN(vma->vm_start, PUD_SIZE),
+		v_end = ALIGN_DOWN(vma->vm_end, PUD_SIZE);
 
-	if (!(vma->vm_flags & VM_MAYSHARE))
+	/*
+	 * vma need span at least one aligned PUD size and the start,end range
+	 * must at least partialy within it.
+	 */
+	if (!(vma->vm_flags & VM_MAYSHARE) || !(v_end > v_start) ||
+		(*end <= v_start) || (*start >= v_end))
 		return;
 
 	/* Extend the range to be PUD aligned for a worst case scenario */
-	a_start = ALIGN_DOWN(*start, PUD_SIZE);
-	a_end = ALIGN(*end, PUD_SIZE);
+	if (*start > v_start)
+		*start = ALIGN_DOWN(*start, PUD_SIZE);
 
-	/*
-	 * Intersect the range with the vma range, since pmd sharing won't be
-	 * across vma after all
-	 */
-	*start = max(vma->vm_start, a_start);
-	*end = min(vma->vm_end, a_end);
+	if (*end < v_end)
+		*end = ALIGN(*end, PUD_SIZE);
 }
 
 /*
_

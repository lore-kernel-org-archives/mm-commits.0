Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6483C433E0
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 20:29:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F8882225E
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 20:29:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbhADU3E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Jan 2021 15:29:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:34824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbhADU3D (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 4 Jan 2021 15:29:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 219E72072C;
        Mon,  4 Jan 2021 20:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609792103;
        bh=9hly7RkdiYUiB7ajmEeiUU3I7xdDaTlor6hnyHjJx+o=;
        h=Date:From:To:Subject:From;
        b=cHxo09NezILczM7SCKwBxZj7nBQzfy7+Efff1HrgbMYP5lu8LlTIDFc2fLWrjqiOS
         q9Zz1fwJBh1GXrg9zKX4tOi0OkFlPORnsVaPIrEpBgn6llUhvpszhJQi4Ji4ciPLkv
         BjIIFJTkTuLaC7ErS5o+2vMxlQqKYBxHxWAKAavc=
Date:   Mon, 04 Jan 2021 12:28:22 -0800
From:   akpm@linux-foundation.org
To:     lixinhai.lxh@gmail.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, peterx@redhat.com
Subject:  [to-be-updated]
 mm-hugetlbc-fix-unnecessary-address-expansion-of-pmd-sharing.patch removed
 from -mm tree
Message-ID: <20210104202822.PUbfPfd-D%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: fix unnecessary address expansion of pmd sharing
has been removed from the -mm tree.  Its filename was
     mm-hugetlbc-fix-unnecessary-address-expansion-of-pmd-sharing.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
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

Link: https://lkml.kernel.org/r/20210104081631.2921415-1-lixinhai.lxh@gmail.com
Fixes: 75802ca66354 ("mm/hugetlb: fix calculation of adjust_range_if_pmd_sharing_possible")
Signed-off-by: Li Xinhai <lixinhai.lxh@gmail.com>
Suggested-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlbc-fix-unnecessary-address-expansion-of-pmd-sharing
+++ a/mm/hugetlb.c
@@ -5259,21 +5259,23 @@ static bool vma_shareable(struct vm_area
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

Patches currently in -mm which might be from lixinhai.lxh@gmail.com are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB530C433E0
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 20:25:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88FC522273
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 20:25:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbhADUZZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Jan 2021 15:25:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:34284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725840AbhADUZY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 4 Jan 2021 15:25:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD83B2225E;
        Mon,  4 Jan 2021 20:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609791884;
        bh=fE4iBWmfuKOXviLveyTPHWtcnnWHlpBafq18p9icCUM=;
        h=Date:From:To:Subject:From;
        b=gn80Y4JkuaDm5l5CCN6oz6lrcZUq5l8vIyyRxJ+gelTACgsz7r8YNVwBk/+5Ks9Ou
         AKnRG80RFO3hmlHHpyZTwwJmn8DKU1xX8Rxj/Z0BLHvqNgRkfBukB9RRQNzkYZBVAA
         Wwq/SAGimTYj+I88HBuavAZdp9Ov0HSuxjBcglcE=
Date:   Mon, 04 Jan 2021 12:24:43 -0800
From:   akpm@linux-foundation.org
To:     lixinhai.lxh@gmail.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, peterx@redhat.com
Subject:  [to-be-updated]
 mm-hugetlbc-fix-unnecessary-address-expansion-of-pmd-sharing.patch removed
 from -mm tree
Message-ID: <20210104202443.DKANyQl3O%akpm@linux-foundation.org>
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

Mike said:

: The 'adjusted range' is used for calls to mmu notifiers and cache(tlb)
: flushing.  Since the current code unnecessarily expands the range in
: some cases, more entries than necessary would be flushed.  This
: would/could result in performance degradation.  However, this is highly
: dependent on the user runtime.  Is there a combination of vma layout
: and calls to actually hit this issue?  If the issue is hit, will those
: entries unnecessarily flushed be used again and need to be
: unnecessarily reloaded?

Link: https://lkml.kernel.org/r/20201229042125.2663029-1-lixinhai.lxh@gmail.com
Fixes: commit 75802ca66354 ("mm/hugetlb: fix calculation of adjust_range_if_pmd_sharing_possible")
Signed-off-by: Li Xinhai <lixinhai.lxh@gmail.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
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



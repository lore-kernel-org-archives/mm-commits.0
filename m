Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 179E0C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:54:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 037596141A
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:54:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238505AbhGAB4x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:56:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238429AbhGAB4w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:56:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E12E96146D;
        Thu,  1 Jul 2021 01:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104463;
        bh=6Pji3cq4i9A9CHhjXB2IEQFixwrlJYwoxrsU8PnJmPs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Az/a3r2eq3VcZvK3iLX/T5N4nM28HBIlDAIuiT3L+YrmJxHQ3S5wLW6kdVfyCsBxk
         GyvlR6NHOxZlAAOp4LZImFeBZDj3creGwfXShSx7dXHf/k/QENMjdIbRp9z3+kNxKN
         J9AEj4ixgJzwvADxBf8u8rXHowu8fyuAiGHbxWvM=
Date:   Wed, 30 Jun 2021 18:54:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, apopple@nvidia.com, bskeggs@redhat.com,
        hch@lst.de, hughd@google.com, jgg@nvidia.com, jhubbard@nvidia.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, peterx@redhat.com,
        rcampbell@nvidia.com, shakeelb@google.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 135/192] mm/memory.c: allow different return codes
 for copy_nonpresent_pte()
Message-ID: <20210701015422.fnRcl9cvh%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alistair Popple <apopple@nvidia.com>
Subject: mm/memory.c: allow different return codes for copy_nonpresent_pte()

Currently if copy_nonpresent_pte() returns a non-zero value it is assumed
to be a swap entry which requires further processing outside the loop in
copy_pte_range() after dropping locks.  This prevents other values being
returned to signal conditions such as failure which a subsequent change
requires.

Instead make copy_nonpresent_pte() return an error code if further
processing is required and read the value for the swap entry in the main
loop under the ptl.

Link: https://lkml.kernel.org/r/20210616105937.23201-7-apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

--- a/mm/memory.c~mm-memoryc-allow-different-return-codes-for-copy_nonpresent_pte
+++ a/mm/memory.c
@@ -717,7 +717,7 @@ copy_nonpresent_pte(struct mm_struct *ds
 
 	if (likely(!non_swap_entry(entry))) {
 		if (swap_duplicate(entry) < 0)
-			return entry.val;
+			return -EIO;
 
 		/* make sure dst_mm is on swapoff's mmlist. */
 		if (unlikely(list_empty(&dst_mm->mmlist))) {
@@ -973,12 +973,14 @@ again:
 			continue;
 		}
 		if (unlikely(!pte_present(*src_pte))) {
-			entry.val = copy_nonpresent_pte(dst_mm, src_mm,
-							dst_pte, src_pte,
-							dst_vma, src_vma,
-							addr, rss);
-			if (entry.val)
+			ret = copy_nonpresent_pte(dst_mm, src_mm,
+						  dst_pte, src_pte,
+						  dst_vma, src_vma,
+						  addr, rss);
+			if (ret == -EIO) {
+				entry = pte_to_swp_entry(*src_pte);
 				break;
+			}
 			progress += 8;
 			continue;
 		}
@@ -1011,20 +1013,24 @@ again:
 	pte_unmap_unlock(orig_dst_pte, dst_ptl);
 	cond_resched();
 
-	if (entry.val) {
+	if (ret == -EIO) {
+		VM_WARN_ON_ONCE(!entry.val);
 		if (add_swap_count_continuation(entry, GFP_KERNEL) < 0) {
 			ret = -ENOMEM;
 			goto out;
 		}
 		entry.val = 0;
-	} else if (ret) {
-		WARN_ON_ONCE(ret != -EAGAIN);
+	} else if (ret ==  -EAGAIN) {
 		prealloc = page_copy_prealloc(src_mm, src_vma, addr);
 		if (!prealloc)
 			return -ENOMEM;
-		/* We've captured and resolved the error. Reset, try again. */
-		ret = 0;
+	} else if (ret) {
+		VM_WARN_ON_ONCE(1);
 	}
+
+	/* We've captured and resolved the error. Reset, try again. */
+	ret = 0;
+
 	if (addr != end)
 		goto again;
 out:
_

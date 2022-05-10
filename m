Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6160CC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:16:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236099AbiEJEUq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236185AbiEJET7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:19:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793EF2AC6D0
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:14:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1687861766
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651F4C385A6;
        Tue, 10 May 2022 04:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156089;
        bh=EtDbHzryj5piznpOdfKJOHiay2EdWuOgz6nlAG+zSa8=;
        h=Date:To:From:Subject:From;
        b=roY/gMGA2Wlz4js/KjOWW+jAbdEtDjMV0SE65HvD+9BjijqNSXCxsTVFJccwzkt74
         21Sz1m+60fB6CCVZq3BoqjGZoB2mzE6FccA0OQM0HVF2cI0PX9Dm2ltvCwvfgkh+jU
         Ht1GtlMdiBixQve5qr1EMzc6CFgbeGa0k1x9zSQ4=
Date:   Mon, 09 May 2022 21:14:48 -0700
To:     mm-commits@vger.kernel.org, zhangliang5@huawei.com,
        willy@infradead.org, vbabka@suse.cz, shy828301@gmail.com,
        shakeelb@google.com, rppt@linux.ibm.com, rientjes@google.com,
        riel@surriel.com, peterx@redhat.com, pedrodemargomes@gmail.com,
        oleg@redhat.com, oded.gabbay@gmail.com, namit@vmware.com,
        mike.kravetz@oracle.com, mhocko@kernel.org,
        kirill.shutemov@linux.intel.com, khalid.aziz@oracle.com,
        jhubbard@nvidia.com, jgg@nvidia.com, jannh@google.com,
        jack@suse.cz, hughd@google.com, hch@lst.de, guro@fb.com,
        ddutile@redhat.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-disallow-follow_pagefoll_pin.patch removed from -mm tree
Message-Id: <20220510041449.651F4C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup: disallow follow_page(FOLL_PIN)
has been removed from the -mm tree.  Its filename was
     mm-gup-disallow-follow_pagefoll_pin.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/gup: disallow follow_page(FOLL_PIN)

We want to change the way we handle R/O pins on anonymous pages that might
be shared: if we detect a possibly shared anonymous page -- mapped R/O and
not !PageAnonExclusive() -- we want to trigger unsharing via a page fault,
resulting in an exclusive anonymous page that can be pinned reliably
without getting replaced via COW on the next write fault.

However, the required page fault will be problematic for follow_page(): in
contrast to ordinary GUP, follow_page() doesn't trigger faults internally.
So we would have to end up failing a R/O pin via follow_page(), although
there is something mapped R/O into the page table, which might be rather
surprising.

We don't seem to have follow_page(FOLL_PIN) users, and it's a purely
internal MM function.  Let's just make our life easier and the semantics
of follow_page() clearer by just disallowing FOLL_PIN for follow_page()
completely.

Link: https://lkml.kernel.org/r/20220428083441.37290-15-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Liang Zhang <zhangliang5@huawei.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Nadav Amit <namit@vmware.com>
Cc: Oded Gabbay <oded.gabbay@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c     |    3 +++
 mm/hugetlb.c |    8 +++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

--- a/mm/gup.c~mm-gup-disallow-follow_pagefoll_pin
+++ a/mm/gup.c
@@ -787,6 +787,9 @@ struct page *follow_page(struct vm_area_
 	if (vma_is_secretmem(vma))
 		return NULL;
 
+	if (foll_flags & FOLL_PIN)
+		return NULL;
+
 	page = follow_page_mask(vma, address, foll_flags, &ctx);
 	if (ctx.pgmap)
 		put_dev_pagemap(ctx.pgmap);
--- a/mm/hugetlb.c~mm-gup-disallow-follow_pagefoll_pin
+++ a/mm/hugetlb.c
@@ -6719,9 +6719,11 @@ follow_huge_pmd(struct mm_struct *mm, un
 	spinlock_t *ptl;
 	pte_t pte;
 
-	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
-	if (WARN_ON_ONCE((flags & (FOLL_PIN | FOLL_GET)) ==
-			 (FOLL_PIN | FOLL_GET)))
+	/*
+	 * FOLL_PIN is not supported for follow_page(). Ordinary GUP goes via
+	 * follow_hugetlb_page().
+	 */
+	if (WARN_ON_ONCE(flags & FOLL_PIN))
 		return NULL;
 
 retry:
_

Patches currently in -mm which might be from david@redhat.com are



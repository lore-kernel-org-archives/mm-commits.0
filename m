Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A62D5C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:13:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357195AbiCYBPS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357203AbiCYBPO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:15:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37EC6AA45
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:13:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41AACB82709
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:13:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1DA0C340EC;
        Fri, 25 Mar 2022 01:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170817;
        bh=1+c7G0iIHC1u7fAlZ10RX8tSDjNAa1xxcZ6EfqUb/sE=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=HjvAzmHaa2T3OGLBrGqaa0CLAyXtFIBVN67InZS4Rz5M7tExAqW+IgiAsjbNm183D
         +X37qIGvh3IvqlQy4LwSJxcwSx4nEUIZUfjm5EbAOKRAoD1Yrmlgf6QHHds02Pavl2
         2034+huGRiwnSVN+0Ddme+5tJWPjWpVuTgRXIXgI=
Date:   Thu, 24 Mar 2022 18:13:37 -0700
To:     zhangliang5@huawei.com, willy@infradead.org, vbabka@suse.cz,
        shy828301@gmail.com, shakeelb@google.com, rppt@linux.ibm.com,
        roman.gushchin@linux.dev, rientjes@google.com, riel@surriel.com,
        peterx@redhat.com, oleg@redhat.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, mhocko@kernel.org,
        kirill.shutemov@linux.intel.com, jhubbard@nvidia.com,
        jgg@nvidia.com, jannh@google.com, jack@suse.cz, hughd@google.com,
        hch@lst.de, ddutile@redhat.com, aarcange@redhat.com,
        david@redhat.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 101/114] mm: slightly clarify KSM logic in do_swap_page()
Message-Id: <20220325011337.D1DA0C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: mm: slightly clarify KSM logic in do_swap_page()

Let's make it clearer that KSM might only have to copy a page in case we
have a page in the swapcache, not if we allocated a fresh page and
bypassed the swapcache.  While at it, add a comment why this is usually
necessary and merge the two swapcache conditions.

[akpm@linux-foundation.org: fix comment, per David]
Link: https://lkml.kernel.org/r/20220131162940.210846-4-david@redhat.com
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
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Liang Zhang <zhangliang5@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

--- a/mm/memory.c~mm-slightly-clarify-ksm-logic-in-do_swap_page
+++ a/mm/memory.c
@@ -3607,21 +3607,29 @@ vm_fault_t do_swap_page(struct vm_fault
 		goto out_release;
 	}
 
-	/*
-	 * Make sure try_to_free_swap or reuse_swap_page or swapoff did not
-	 * release the swapcache from under us.  The page pin, and pte_same
-	 * test below, are not enough to exclude that.  Even if it is still
-	 * swapcache, we need to check that the page's swap has not changed.
-	 */
-	if (unlikely((!PageSwapCache(page) ||
-			page_private(page) != entry.val)) && swapcache)
-		goto out_page;
+	if (swapcache) {
+		/*
+		 * Make sure try_to_free_swap or swapoff did not release the
+		 * swapcache from under us.  The page pin, and pte_same test
+		 * below, are not enough to exclude that.  Even if it is still
+		 * swapcache, we need to check that the page's swap has not
+		 * changed.
+		 */
+		if (unlikely(!PageSwapCache(page) ||
+			     page_private(page) != entry.val))
+			goto out_page;
 
-	page = ksm_might_need_to_copy(page, vma, vmf->address);
-	if (unlikely(!page)) {
-		ret = VM_FAULT_OOM;
-		page = swapcache;
-		goto out_page;
+		/*
+		 * KSM sometimes has to copy on read faults, for example, if
+		 * page->index of !PageKSM() pages would be nonlinear inside the
+		 * anon VMA -- PageKSM() is lost on actual swapout.
+		 */
+		page = ksm_might_need_to_copy(page, vma, vmf->address);
+		if (unlikely(!page)) {
+			ret = VM_FAULT_OOM;
+			page = swapcache;
+			goto out_page;
+		}
 	}
 
 	cgroup_throttle_swaprate(page, GFP_KERNEL);
_

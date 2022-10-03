Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3D41C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:17:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiJCVRV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiJCVPT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:15:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3BF1F9FD
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:09:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFDEA610D5
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45357C433D7;
        Mon,  3 Oct 2022 21:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831395;
        bh=aLLmk3pTcp37CIhHo9L99TNnMNjz956EB/2Ab171w9k=;
        h=Date:To:From:Subject:From;
        b=LeeiZ2ahSonpEMDYrT5yiUDA9kOJ3/J2u/GNfKLl5rjdK0S2gwNJ9Z6pDzCJA4Tt5
         4wkiISOhAAbA4EGxkO9SYgfSnxzcpair7QDwDrBPn88A1eExFCV24EKhg4Qh5LFkWo
         PW2LnWrdO7pPYeTIg33csf90brCu9EIMo9j45uv8=
Date:   Mon, 03 Oct 2022 14:09:54 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        songliubraving@fb.com, sj@kernel.org, shy828301@gmail.com,
        rongwei.wang@linux.alibaba.com, rientjes@google.com,
        peterx@redhat.com, pasha.tatashin@soleen.com, minchan@kernel.org,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jthoughton@google.com, hughd@google.com, david@redhat.com,
        ckennelly@google.com, axelrasmussen@google.com, zokeefe@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-check-compound_order-in-collapse_pte_mapped_thp.patch removed from -mm tree
Message-Id: <20221003210955.45357C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: check compound_order() in collapse_pte_mapped_thp()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-check-compound_order-in-collapse_pte_mapped_thp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: mm/khugepaged: check compound_order() in collapse_pte_mapped_thp()
Date: Thu, 22 Sep 2022 15:27:31 -0700

By the time we lock a page in collapse_pte_mapped_thp(), the page mapped
by the address pushed onto the slot's .pte_mapped_thp[] array might have
changed arbitrarily since we last looked at it.  We revalidate that the
page is still the head of a compound page, but we don't revalidate if the
compound page is of order HPAGE_PMD_ORDER before applying rmap and page
table updates.

Since the kernel now supports large folios of arbitrary order, and since
replacing page's pte mappings by a pmd mapping only makes sense for
compound pages of order HPAGE_PMD_ORDER, revalidate that the compound
order is indeed of order HPAGE_PMD_ORDER before proceeding.

Link: https://lore.kernel.org/linux-mm/CAHbLzkon+2ky8v9ywGcsTUgXM_B35jt5NThYqQKXW2YV_GUacw@mail.gmail.com/
Link: https://lkml.kernel.org/r/20220922222731.1124481-1-zokeefe@google.com
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Suggested-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Kennelly <ckennelly@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/khugepaged.c~mm-khugepaged-check-compound_order-in-collapse_pte_mapped_thp
+++ a/mm/khugepaged.c
@@ -1399,6 +1399,9 @@ void collapse_pte_mapped_thp(struct mm_s
 	if (!PageHead(hpage))
 		goto drop_hpage;
 
+	if (compound_order(hpage) != HPAGE_PMD_ORDER)
+		goto drop_hpage;
+
 	if (find_pmd_or_thp_or_none(mm, haddr, &pmd) != SCAN_SUCCEED)
 		goto drop_hpage;
 
_

Patches currently in -mm which might be from zokeefe@google.com are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0648AC433FE
	for <mm-commits@archiver.kernel.org>; Fri,  4 Nov 2022 22:53:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbiKDWx1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Nov 2022 18:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbiKDWwk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Nov 2022 18:52:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B6092D1C7
        for <mm-commits@vger.kernel.org>; Fri,  4 Nov 2022 15:52:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 994C962361
        for <mm-commits@vger.kernel.org>; Fri,  4 Nov 2022 22:52:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3218C433C1;
        Fri,  4 Nov 2022 22:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667602357;
        bh=Pzzd/qeCNUi4z3HVeDjQIxX8s240U/p9stAXd98ectQ=;
        h=Date:To:From:Subject:From;
        b=aDSdBVL2+EJSKAM3QaZ7r7/7N8WIBkM3b8jwGv/TBu6iBoavD0rOwSpEO9CXVwYdu
         wQ+RgfMmjplnMi0+dRn4iXGWC2zf5DJQqQQjuNmHYkFfB+WmtGAc0lPa2xEDnLZ/mj
         KQ46a8SNiaCEra1sRG0TMmMH9TDHGA8X3yx6Bqj0=
Date:   Fri, 04 Nov 2022 15:52:36 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, svens@linux.ibm.com,
        peterz@infradead.org, npiggin@gmail.com, nadav.amit@gmail.com,
        jhubbard@nvidia.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, borntraeger@linux.ibm.com,
        aneesh.kumar@linux.ibm.com, agordeev@linux.ibm.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-inline-simpler-case-of-page_remove_file_rmap.patch added to mm-unstable branch
Message-Id: <20221104225236.F3218C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: inline simpler case of page_remove_file_rmap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-inline-simpler-case-of-page_remove_file_rmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-inline-simpler-case-of-page_remove_file_rmap.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: mm: inline simpler case of page_remove_file_rmap()
Date: Sun Oct 30 13:50:39 2022 -0700

Now that we have a simplified special case of 'page_remove_rmap()' that
doesn't deal with the 'compound' case and always gets a file-mapped (ie
not anonymous) page, it ended up doing just

        lock_page_memcg(page);
        page_remove_file_rmap(page, false);
        unlock_page_memcg(page);

but 'page_remove_file_rmap()' is actually trivial when 'compound' is
false.

So just inline that non-compound case in the caller, and - like we did in
the previous commit for the anon pages - only do the memcg locking for the
parts that actually matter: the page statistics.

Also, as the previous commit did for anonymous pages, knowing we only get
called for the last-level page table entries allows for a further
simplification: we can get rid of the 'PageHuge(page)' case too.

You can't map a huge-page in a pte without splitting it (and the full code
in the generic page_remove_file_rmap() function has a comment to that
effect: "hugetlb pages are always mapped with pmds").

That means that the page_zap_file_rmap() case of that whole function is
really small and trivial.

Link: https://lore.kernel.org/all/B88D3073-440A-41C7-95F4-895D3F657EF2@gmail.com/
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Aneesh Kumar <aneesh.kumar@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/rmap.c~mm-inline-simpler-case-of-page_remove_file_rmap
+++ a/mm/rmap.c
@@ -1426,8 +1426,11 @@ static void page_remove_anon_compound_rm
  */
 void page_zap_file_rmap(struct page *page)
 {
+	if (!atomic_add_negative(-1, &page->_mapcount))
+		return;
+
 	lock_page_memcg(page);
-	page_remove_file_rmap(page, false);
+	__dec_lruvec_page_state(page, NR_FILE_MAPPED);
 	unlock_page_memcg(page);
 }
 
_

Patches currently in -mm which might be from torvalds@linux-foundation.org are

mm-introduce-simplified-versions-of-page_remove_rmap.patch
mm-inline-simpler-case-of-page_remove_file_rmap.patch
mm-re-unify-the-simplified-page_zap__rmap-function.patch
mm-delay-rmap-removal-until-after-tlb-flush.patch


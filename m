Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F050C001B0
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 19:58:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbjGBT6E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 15:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233160AbjGBT5s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 15:57:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C878F273B
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 12:55:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D62960C84
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 19:54:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B15C433C7;
        Sun,  2 Jul 2023 19:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688327685;
        bh=ECvqEDQacCr2RlU9xIWj/Zujs1ZJMXNUxy6OFBD8Pdo=;
        h=Date:To:From:Subject:From;
        b=o82Vy5BDeoPvlvCvzr0FzNiren3KvFYyq1SZPvrL/1pl0uusO4W83tS4TOqYrM1ar
         sBrL1N0w30CbJEdGNQDbj9OJV//FInqc8XeIPDGa9CNI+vleLExtHEdxXD3hli445G
         PlqQcPgQ4uAMnyUUy2zS1C8LYZ2dY9u8ITYvEf/U=
Date:   Sun, 02 Jul 2023 12:54:44 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shy828301@gmail.com, rppt@kernel.org, mike.kravetz@oracle.com,
        lstoakes@gmail.com, kirill@shutemov.name, jthoughton@google.com,
        jhubbard@nvidia.com, jgg@nvidia.com, hughd@google.com,
        david@redhat.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-handle-foll_dump-well-in-follow_page_mask.patch added to mm-unstable branch
Message-Id: <20230702195445.66B15C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: handle FOLL_DUMP well in follow_page_mask()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-handle-foll_dump-well-in-follow_page_mask.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-handle-foll_dump-well-in-follow_page_mask.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: handle FOLL_DUMP well in follow_page_mask()
Date: Wed, 28 Jun 2023 17:53:03 -0400

Patch series "mm/gup: Unify hugetlb, speed up thp", v4.

Hugetlb has a special path for slow gup that follow_page_mask() is
actually skipped completely along with faultin_page().  It's not only
confusing, but also duplicating a lot of logics that generic gup already
has, making hugetlb slightly special.

This patchset tries to dedup the logic, by first touching up the slow gup
code to be able to handle hugetlb pages correctly with the current follow
page and faultin routines (where we're mostly there..  due to 10 years ago
we did try to optimize thp, but half way done; more below), then at the
last patch drop the special path, then the hugetlb gup will always go the
generic routine too via faultin_page().

Note that hugetlb is still special for gup, mostly due to the pgtable
walking (hugetlb_walk()) that we rely on which is currently per-arch.  But
this is still one small step forward, and the diffstat might be a proof
too that this might be worthwhile.

Then for the "speed up thp" side: as a side effect, when I'm looking at
the chunk of code, I found that thp support is actually partially done. 
It doesn't mean that thp won't work for gup, but as long as **pages
pointer passed over, the optimization will be skipped too.  Patch 6 should
address that, so for thp we now get full speed gup.

For a quick number, "chrt -f 1 ./gup_test -m 512 -t -L -n 1024 -r 10"
gives me 13992.50us -> 378.50us.  Gup_test is an extreme case, but just to
show how it affects thp gups.


This patch (of 8):

Firstly, the no_page_table() is meaningless for hugetlb which is a no-op
there, because a hugetlb page always satisfies:

  - vma_is_anonymous() == false
  - vma->vm_ops->fault != NULL

So we can already safely remove it in hugetlb_follow_page_mask(), alongside
with the page* variable.

Meanwhile, what we do in follow_hugetlb_page() actually makes sense for a
dump: we try to fault in the page only if the page cache is already
allocated.  Let's do the same here for follow_page_mask() on hugetlb.

It should so far has zero effect on real dumps, because that still goes
into follow_hugetlb_page().  But this may start to influence a bit on
follow_page() users who mimics a "dump page" scenario, but hopefully in a
good way.  This also paves way for unifying the hugetlb gup-slow.

Link: https://lkml.kernel.org/r/20230628215310.73782-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20230628215310.73782-2-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A . Shutemov <kirill@shutemov.name>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c     |    9 ++-------
 mm/hugetlb.c |    9 +++++++++
 2 files changed, 11 insertions(+), 7 deletions(-)

--- a/mm/gup.c~mm-hugetlb-handle-foll_dump-well-in-follow_page_mask
+++ a/mm/gup.c
@@ -811,7 +811,6 @@ static struct page *follow_page_mask(str
 			      struct follow_page_context *ctx)
 {
 	pgd_t *pgd;
-	struct page *page;
 	struct mm_struct *mm = vma->vm_mm;
 
 	ctx->page_mask = 0;
@@ -824,12 +823,8 @@ static struct page *follow_page_mask(str
 	 * hugetlb_follow_page_mask is only for follow_page() handling here.
 	 * Ordinary GUP uses follow_hugetlb_page for hugetlb processing.
 	 */
-	if (is_vm_hugetlb_page(vma)) {
-		page = hugetlb_follow_page_mask(vma, address, flags);
-		if (!page)
-			page = no_page_table(vma, flags);
-		return page;
-	}
+	if (is_vm_hugetlb_page(vma))
+		return hugetlb_follow_page_mask(vma, address, flags);
 
 	pgd = pgd_offset(mm, address);
 
--- a/mm/hugetlb.c~mm-hugetlb-handle-foll_dump-well-in-follow_page_mask
+++ a/mm/hugetlb.c
@@ -6498,6 +6498,15 @@ out:
 	spin_unlock(ptl);
 out_unlock:
 	hugetlb_vma_unlock_read(vma);
+
+	/*
+	 * Fixup retval for dump requests: if pagecache doesn't exist,
+	 * don't try to allocate a new page but just skip it.
+	 */
+	if (!page && (flags & FOLL_DUMP) &&
+	    !hugetlbfs_pagecache_present(h, vma, address))
+		page = ERR_PTR(-EFAULT);
+
 	return page;
 }
 
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-hugetlb-handle-foll_dump-well-in-follow_page_mask.patch
mm-hugetlb-prepare-hugetlb_follow_page_mask-for-foll_pin.patch
mm-hugetlb-add-page_mask-for-hugetlb_follow_page_mask.patch
mm-gup-cleanup-next_page-handling.patch
mm-gup-accelerate-thp-gup-even-for-pages-=-null.patch
mm-gup-retire-follow_hugetlb_page.patch
selftests-mm-add-a-to-run_vmtestssh.patch
selftests-mm-add-gup-test-matrix-in-run_vmtestssh.patch


Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EE58C77B76
	for <mm-commits@archiver.kernel.org>; Fri, 21 Apr 2023 21:52:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbjDUVwl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Apr 2023 17:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233563AbjDUVwf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Apr 2023 17:52:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B037A10E4
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 14:52:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A09265334
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 21:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D93C4339B;
        Fri, 21 Apr 2023 21:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682113953;
        bh=u3nQJDTX4JZw5t/uiBdqMHKTXazapUrffgaomw5Fjnk=;
        h=Date:To:From:Subject:From;
        b=NZ8l677HB6hBeDzWoGvADgy0YAOPBImM5FCl8FXa7AVelUsUIVOC4D6NaSqRw0NXx
         WI+Y8czq6+EKJHGvOYdWWcJgZ5UVUwaFjS6S0HuEjlg8Zskrf6dDsGHuMJxDwTDqGe
         fPeoCcgx5xR2G2wk7OjMkNT9oJmahswCQvgmmDEE=
Date:   Fri, 21 Apr 2023 14:52:33 -0700
To:     mm-commits@vger.kernel.org, nadav.amit@gmail.com,
        mpenttil@redhat.com, mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-fix-uffd-wp-bit-lost-when-unsharing-happens.patch removed from -mm tree
Message-Id: <20230421215233.A0D93C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: fix uffd-wp bit lost when unsharing happens
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-uffd-wp-bit-lost-when-unsharing-happens.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: fix uffd-wp bit lost when unsharing happens
Date: Mon, 17 Apr 2023 15:53:13 -0400

When we try to unshare a pinned page for a private hugetlb, uffd-wp bit
can get lost during unsharing.

When above condition met, one can lose uffd-wp bit on the privately mapped
hugetlb page.  It allows the page to be writable even if it should still be
wr-protected.  I assume it can mean data loss.

This should be very rare, only if an unsharing happened on a private
hugetlb page with uffd-wp protected (e.g.  in a child which shares the
same page with parent with UFFD_FEATURE_EVENT_FORK enabled).

When I wrote the reproducer (provided in the last patch) I needed to
use the newest gup_test cmd introduced by David to trigger it because I
don't even know another way to do a proper RO longerm pin.

Besides that, it needs a bunch of other conditions all met:

        (1) hugetlb being mapped privately,
        (2) userfaultfd registered with WP and EVENT_FORK,
        (3) the user app fork()s, then,
        (4) RO longterm pin onto a wr-protected anonymous page.

If it's not impossible to hit in production I'd say extremely rare.

Link: https://lkml.kernel.org/r/20230417195317.898696-3-peterx@redhat.com
Fixes: 166f3ecc0daf ("mm/hugetlb: hook page faults for uffd write protection")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-uffd-wp-bit-lost-when-unsharing-happens
+++ a/mm/hugetlb.c
@@ -5644,13 +5644,16 @@ retry_avoidcopy:
 	spin_lock(ptl);
 	ptep = hugetlb_walk(vma, haddr, huge_page_size(h));
 	if (likely(ptep && pte_same(huge_ptep_get(ptep), pte))) {
+		pte_t newpte = make_huge_pte(vma, &new_folio->page, !unshare);
+
 		/* Break COW or unshare */
 		huge_ptep_clear_flush(vma, haddr, ptep);
 		mmu_notifier_invalidate_range(mm, range.start, range.end);
 		page_remove_rmap(old_page, vma, true);
 		hugepage_add_new_anon_rmap(new_folio, vma, haddr);
-		set_huge_pte_at(mm, haddr, ptep,
-				make_huge_pte(vma, &new_folio->page, !unshare));
+		if (huge_pte_uffd_wp(pte))
+			newpte = huge_pte_mkuffd_wp(newpte);
+		set_huge_pte_at(mm, haddr, ptep, newpte);
 		folio_set_hugetlb_migratable(new_folio);
 		/* Make the old page be freed below */
 		new_folio = page_folio(old_page);
_

Patches currently in -mm which might be from peterx@redhat.com are



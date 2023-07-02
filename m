Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA000C001DD
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 19:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232729AbjGBT6H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 15:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233203AbjGBT5z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 15:57:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D77419B3
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 12:55:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4EB560C96
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 19:54:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A78C433C8;
        Sun,  2 Jul 2023 19:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688327689;
        bh=SmI/NVcD7P7MN17abwEXlA/p3F+BGjm4rGrfu5Rxlls=;
        h=Date:To:From:Subject:From;
        b=DD/35SxTE1eObL6auGjTQFc5RAXNNFRu4pX70QRFrr48eIpScJ92yz0c8WoezgCXY
         epmIdKxlnFgFRE/bPlAS0P3he1h/W1UHI9B0Z1pwkOFb3OJZmvJRzVeGamdiYgrL3Q
         JOa3l9XlzjePxxf6Yq3eO/Bi+MgXes9VuworbZz4=
Date:   Sun, 02 Jul 2023 12:54:48 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shy828301@gmail.com, rppt@kernel.org, mike.kravetz@oracle.com,
        lstoakes@gmail.com, kirill@shutemov.name, jthoughton@google.com,
        jhubbard@nvidia.com, jgg@nvidia.com, hughd@google.com,
        david@redhat.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-prepare-hugetlb_follow_page_mask-for-foll_pin.patch added to mm-unstable branch
Message-Id: <20230702195449.37A78C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: prepare hugetlb_follow_page_mask() for FOLL_PIN
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-prepare-hugetlb_follow_page_mask-for-foll_pin.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-prepare-hugetlb_follow_page_mask-for-foll_pin.patch

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
Subject: mm/hugetlb: prepare hugetlb_follow_page_mask() for FOLL_PIN
Date: Wed, 28 Jun 2023 17:53:04 -0400

follow_page() doesn't use FOLL_PIN, meanwhile hugetlb seems to not be the
target of FOLL_WRITE either.  However add the checks.

Namely, either the need to CoW due to missing write bit, or proper
unsharing on !AnonExclusive pages over R/O pins to reject the follow page.
That brings this function closer to follow_hugetlb_page().

So we don't care before, and also for now.  But we'll care if we switch
over slow-gup to use hugetlb_follow_page_mask().  We'll also care when to
return -EMLINK properly, as that's the gup internal api to mean "we should
unshare".  Not really needed for follow page path, though.

When at it, switching the try_grab_page() to use WARN_ON_ONCE(), to be
clear that it just should never fail.  When error happens, instead of
setting page==NULL, capture the errno instead.

Link: https://lkml.kernel.org/r/20230628215310.73782-3-peterx@redhat.com
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

 mm/hugetlb.c |   33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-prepare-hugetlb_follow_page_mask-for-foll_pin
+++ a/mm/hugetlb.c
@@ -6462,13 +6462,7 @@ struct page *hugetlb_follow_page_mask(st
 	struct page *page = NULL;
 	spinlock_t *ptl;
 	pte_t *pte, entry;
-
-	/*
-	 * FOLL_PIN is not supported for follow_page(). Ordinary GUP goes via
-	 * follow_hugetlb_page().
-	 */
-	if (WARN_ON_ONCE(flags & FOLL_PIN))
-		return NULL;
+	int ret;
 
 	hugetlb_vma_lock_read(vma);
 	pte = hugetlb_walk(vma, haddr, huge_page_size(h));
@@ -6478,8 +6472,23 @@ struct page *hugetlb_follow_page_mask(st
 	ptl = huge_pte_lock(h, mm, pte);
 	entry = huge_ptep_get(pte);
 	if (pte_present(entry)) {
-		page = pte_page(entry) +
-				((address & ~huge_page_mask(h)) >> PAGE_SHIFT);
+		page = pte_page(entry);
+
+		if (!huge_pte_write(entry)) {
+			if (flags & FOLL_WRITE) {
+				page = NULL;
+				goto out;
+			}
+
+			if (gup_must_unshare(vma, flags, page)) {
+				/* Tell the caller to do unsharing */
+				page = ERR_PTR(-EMLINK);
+				goto out;
+			}
+		}
+
+		page += ((address & ~huge_page_mask(h)) >> PAGE_SHIFT);
+
 		/*
 		 * Note that page may be a sub-page, and with vmemmap
 		 * optimizations the page struct may be read only.
@@ -6489,8 +6498,10 @@ struct page *hugetlb_follow_page_mask(st
 		 * try_grab_page() should always be able to get the page here,
 		 * because we hold the ptl lock and have verified pte_present().
 		 */
-		if (try_grab_page(page, flags)) {
-			page = NULL;
+		ret = try_grab_page(page, flags);
+
+		if (WARN_ON_ONCE(ret)) {
+			page = ERR_PTR(ret);
 			goto out;
 		}
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


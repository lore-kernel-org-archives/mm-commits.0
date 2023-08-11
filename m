Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F32FEC001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:58:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234033AbjHKW6w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236861AbjHKW6o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:58:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F30B7358E
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:58:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88880659F0
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:58:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7830C433C8;
        Fri, 11 Aug 2023 22:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794721;
        bh=c2WoRkn5W3PLG8876XQeJcZjOkMI3DPwsYT4z2kq+6E=;
        h=Date:To:From:Subject:From;
        b=Aq9ciXPrEYHOoyEEuAauwrGZOL7DVAnxn5O/OvXNIlpC0ii3JBi3EkwBysV8UtAgw
         Mtp3Yy8NzBuVExMcGS5lyFsrzw193wrN9aGiV/Zr/BejMnHimwwU1Jxb9cFeuK1k53
         nXJJXXLRnhgPQl2CdfG0krA3fTpv2HWhBwTYZrMM=
Date:   Fri, 11 Aug 2023 15:58:41 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shy828301@gmail.com, rppt@kernel.org, mike.kravetz@oracle.com,
        lstoakes@gmail.com, kirill@shutemov.name, jthoughton@google.com,
        jhubbard@nvidia.com, jgg@nvidia.com, hughd@google.com,
        david@redhat.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-prepare-hugetlb_follow_page_mask-for-foll_pin.patch removed from -mm tree
Message-Id: <20230811225841.D7830C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: prepare hugetlb_follow_page_mask() for FOLL_PIN
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-prepare-hugetlb_follow_page_mask-for-foll_pin.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B92AC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:21:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383709AbiEMTV3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383765AbiEMTVD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:21:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54CC437028
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1A64B8310B
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:20:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FB1C34100;
        Fri, 13 May 2022 19:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469657;
        bh=kDqFdpVjxsFUJPrxjkNcqIr6Ssz47N3B1+6JeDqCDog=;
        h=Date:To:From:Subject:From;
        b=lwoqvUTHGJMwRp+0dD+rYwZ2TPoi21/Z0W6Eq9Ti5Z9jmTCJY0dGqQLK+LxMbPk4H
         Dc0Yudy5Ao2hHgwpVKx23hCD+uJLNMq0aKNpsL7vv/DP3np2qO4xJnXD+04pm6WxC9
         268XGRhi8XaaOa31zAq7Ehdd9CxzEEL+wM6zESZk=
Date:   Fri, 13 May 2022 12:20:57 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, kirill@shutemov.name, jglisse@redhat.com,
        hughd@google.com, david@redhat.com, axelrasmussen@google.com,
        apopple@nvidia.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-allows-file-back-mem-to-be-uffd-wr-protected-on-thps.patch removed from -mm tree
Message-Id: <20220513192057.A2FB1C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/shmem: allows file-back mem to be uffd wr-protected on thps
has been removed from the -mm tree.  Its filename was
     mm-shmem-allows-file-back-mem-to-be-uffd-wr-protected-on-thps.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/shmem: allows file-back mem to be uffd wr-protected on thps

We don't have "huge" version of pte markers, instead when necessary we
split the thp.

However split the thp is not enough, because file-backed thp is handled
totally differently comparing to anonymous thps: rather than doing a real
split, the thp pmd will simply got cleared in __split_huge_pmd_locked().

That is not enough if e.g.  when there is a thp covers range [0, 2M) but
we want to wr-protect small page resides in [4K, 8K) range, because after
__split_huge_pmd() returns, there will be a none pmd, and
change_pmd_range() will just skip it right after the split.

Here we leverage the previously introduced change_pmd_prepare() macro so
that we'll populate the pmd with a pgtable page after the pmd split (in
which process the pmd will be cleared for cases like shmem).  Then
change_pte_range() will do all the rest for us by installing the uffd-wp
pte marker at any none pte that we'd like to wr-protect.

Link: https://lkml.kernel.org/r/20220405014852.14413-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/mprotect.c~mm-shmem-allows-file-back-mem-to-be-uffd-wr-protected-on-thps
+++ a/mm/mprotect.c
@@ -338,8 +338,15 @@ static inline unsigned long change_pmd_r
 		}
 
 		if (is_swap_pmd(*pmd) || pmd_trans_huge(*pmd) || pmd_devmap(*pmd)) {
-			if (next - addr != HPAGE_PMD_SIZE) {
+			if ((next - addr != HPAGE_PMD_SIZE) ||
+			    uffd_wp_protect_file(vma, cp_flags)) {
 				__split_huge_pmd(vma, pmd, addr, false, NULL);
+				/*
+				 * For file-backed, the pmd could have been
+				 * cleared; make sure pmd populated if
+				 * necessary, then fall-through to pte level.
+				 */
+				change_pmd_prepare(vma, pmd, cp_flags);
 			} else {
 				/*
 				 * change_huge_pmd() does not defer TLB flushes,
_

Patches currently in -mm which might be from peterx@redhat.com are



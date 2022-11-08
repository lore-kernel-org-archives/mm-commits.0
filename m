Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4915C4321E
	for <mm-commits@archiver.kernel.org>; Tue,  8 Nov 2022 23:58:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiKHX6e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 18:58:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbiKHX6Q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 18:58:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D2FB60352
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 15:58:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40759B81CC8
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 23:58:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30B7C433D7;
        Tue,  8 Nov 2022 23:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667951893;
        bh=OUeUPlSJAFBf1rLIVq+EfL2R9Y8w1wYKglUJ/GwBTPM=;
        h=Date:To:From:Subject:From;
        b=V4SFkLU7k2xKyxhkkUw5rfeyiwCI1AVkSelzzQ4jddhg4pheU3M58flERN+SlCF7x
         wr1oOpbJl1hYBBuaM29TNOJ/I6OB181KLyIBkEn0VO7C3ush2RDTyhmSNTlfGLHgi6
         TutYpWB4zavd4HzAp1XLx8w6galkjD7+J9HNNZp0=
Date:   Tue, 08 Nov 2022 15:58:12 -0800
To:     mm-commits@vger.kernel.org, ying.huang@intel.com, vbabka@suse.cz,
        nadav.amit@gmail.com, minchan@kernel.org, matorola@gmail.com,
        kirill@shutemov.name, hughd@google.com, david@redhat.com,
        davem@davemloft.net, apopple@nvidia.com, andi.kleen@intel.com,
        aarcange@redhat.com, peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] partly-revert-mm-thp-carry-over-dirty-bit-when-thp-splits-on-pmd.patch removed from -mm tree
Message-Id: <20221108235812.E30B7C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Partly revert "mm/thp: carry over dirty bit when thp splits  on pmd"
has been removed from the -mm tree.  Its filename was
     partly-revert-mm-thp-carry-over-dirty-bit-when-thp-splits-on-pmd.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: Partly revert "mm/thp: carry over dirty bit when thp splits  on pmd"
Content-type: text/plain

Anatoly Pugachev reported sparc64 breakage on the patch:

https://lore.kernel.org/r/20221021160603.GA23307@u164.east.ru

The sparc64 impl of pte_mkdirty() is definitely slightly special in that
it leverages a code patching mechanism for sun4u/sun4v on relevant pgtable
entry operations.

Before having a clue of why the sparc64 is special and caused the patch to
SIGSEGV the processes, revert the patch for now.  The swap path of dirty
bit inheritage is kept because that's using the swap shared code so we
assume it'll not be affected.

Link: https://lkml.kernel.org/r/Y1Wbi4yyVvDtg4zN@x1n
Fixes: 0ccf7f168e17 ("mm/thp: carry over dirty bit when thp splits on pmd")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: Anatoly Pugachev <matorola@gmail.com> 
Tested-by: Anatoly Pugachev <matorola@gmail.com> 
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andi Kleen <andi.kleen@intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/huge_memory.c~partly-revert-mm-thp-carry-over-dirty-bit-when-thp-splits-on-pmd
+++ a/mm/huge_memory.c
@@ -2206,9 +2206,12 @@ static void __split_huge_pmd_locked(stru
 				entry = pte_wrprotect(entry);
 			if (!young)
 				entry = pte_mkold(entry);
-			/* NOTE: this may set soft-dirty too on some archs */
-			if (dirty)
-				entry = pte_mkdirty(entry);
+			/*
+			 * NOTE: we don't do pte_mkdirty when dirty==true
+			 * because it breaks sparc64 which can sigsegv
+			 * random process.  Need to revisit when we figure
+			 * out what is special with sparc64.
+			 */
 			if (soft_dirty)
 				entry = pte_mksoft_dirty(entry);
 			if (uffd_wp)
_

Patches currently in -mm which might be from peterx@redhat.com are

selftests-vm-use-memfd-for-uffd-hugetlb-tests.patch
selftests-vm-use-memfd-for-hugetlb-madvise-test.patch
selftests-vm-use-memfd-for-hugepage-mremap-test.patch
selftests-vm-drop-mnt-point-for-hugetlb-in-run_vmtestssh.patch
mm-hugetlb-unify-clearing-of-restorereserve-for-private-pages.patch
revert-mm-uffd-fix-warning-without-pte_marker_uffd_wp-compiled-in.patch
mm-always-compile-in-pte-markers.patch
mm-use-pte-markers-for-swap-errors.patch


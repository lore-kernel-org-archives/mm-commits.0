Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BBBFC4708D
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:11:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbiLAALw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:11:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbiLAAKj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:10:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6DED9075E
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:03:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C3FFB81D81
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:03:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDB7C433B5;
        Thu,  1 Dec 2022 00:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852997;
        bh=5uk39Mu/PbA5k1bgJ//bASHms3YDxOzryKfnA9CkKlA=;
        h=Date:To:From:Subject:From;
        b=fqk9Vx4XDs5PzY/U0gwTiOLRcCuiHx5lgaNCEXCdx0WnnycmtgyDAQrSiNe7P/qa4
         E/rBI9SsNIRVPUC7lzneYpebpUCVbfwB8I60G3xX5URrJD5H0rXYJg2pOu3bCvdRhS
         KQ9Dj6HuMaai4d6nWXRiDUGl2wCDZVzp9WGfmdq4=
Date:   Wed, 30 Nov 2022 16:03:16 -0800
To:     mm-commits@vger.kernel.org, r@hev.cc, regressions@leemhuis.info,
        raghavendra.kt@amd.com, mike.kravetz@oracle.com,
        matorola@gmail.com, kirill.shutemov@linux.intel.com,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-thp-re-apply-mkdirty-for-small-pages-after-split.patch removed from -mm tree
Message-Id: <20221201000317.3FDB7C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/thp: re-apply mkdirty for small pages after split
has been removed from the -mm tree.  Its filename was
     mm-thp-re-apply-mkdirty-for-small-pages-after-split.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/thp: re-apply mkdirty for small pages after split
Date: Fri, 25 Nov 2022 13:58:57 -0500

We used to have 624a2c94f5b7 (Partly revert "mm/thp: carry over dirty bit
when thp splits on pmd") fixing the regression reported here by Anatoly
Pugachev on sparc64:

https://lore.kernel.org/r/20221021160603.GA23307@u164.east.ru

Where we temporarily ignored the dirty bit for small pages.

Then, Hev also reported similar issue on loongarch:

(the original mail was private, but Anatoly copied the list here)

https://lore.kernel.org/r/CADxRZqxqb7f_WhMh=jweZP+ynf_JwGd-0VwbYgp4P+T0-AXosw@mail.gmail.com

Hev pointed out that the issue is having HW write bit set within the
pte_mkdirty() so the split pte can be written after split even if e.g. 
they were shared by more than one processes, causing data corrupt.

Hev also tried to explain why loongarch set HW write bit in mkdirty:

https://lore.kernel.org/r/CAHirt9itKO_K_HPboXh5AyJtt16Zf0cD73PtHvM=na39u_ztxA@mail.gmail.com

One way to fix it is as what Huacai proposed here for loongarch (then we
can re-apply the dirty bit in thp split):

https://lore.kernel.org/r/20221117042532.4064448-1-chenhuacai@loongson.cnn

We may need similar thing for sparc64, though.

For now since we've found the root cause of the dirty bit issue the
simpler solution (which won't lose the dirty bit for small) that will work
for both is we wr-protect after pte_mkdirty(), so the HW write bit can be
persistent after thp split.

Add a comment for wrprotect, so we will not mess up the ordering later.

With 624a2c94f5b7 (Partly revert "mm/thp: carry over dirty bit when thp
splits on pmd") this is not a fix anymore, but just brings back the dirty
bit for thp split safely, so we re-apply the optimization but in safe way.

Provide a Tested-by credit to Hev too (not the exact same patch but the
same outcome) for loongarch.

Link: https://lkml.kernel.org/r/20221125185857.3110155-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Tested-by: Hev <r@hev.cc> # loongarch
Cc: Anatoly Pugachev <matorola@gmail.com>
Cc: Raghavendra K T <raghavendra.kt@amd.com>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/mm/huge_memory.c~mm-thp-re-apply-mkdirty-for-small-pages-after-split
+++ a/mm/huge_memory.c
@@ -2238,16 +2238,18 @@ static void __split_huge_pmd_locked(stru
 			entry = maybe_mkwrite(entry, vma);
 			if (anon_exclusive)
 				SetPageAnonExclusive(page + i);
-			if (!write)
-				entry = pte_wrprotect(entry);
 			if (!young)
 				entry = pte_mkold(entry);
+			/* NOTE: this may set soft-dirty too on some archs */
+			if (dirty)
+				entry = pte_mkdirty(entry);
 			/*
-			 * NOTE: we don't do pte_mkdirty when dirty==true
-			 * because it breaks sparc64 which can sigsegv
-			 * random process.  Need to revisit when we figure
-			 * out what is special with sparc64.
+			 * NOTE: this needs to happen after pte_mkdirty,
+			 * because some archs (sparc64, loongarch) could
+			 * set hw write bit when mkdirty.
 			 */
+			if (!write)
+				entry = pte_wrprotect(entry);
 			if (soft_dirty)
 				entry = pte_mksoft_dirty(entry);
 			if (uffd_wp)
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-migrate-fix-read-only-page-got-writable-when-recover-pte.patch
mm-hugetlb-let-vma_offset_start-to-return-start.patch
mm-hugetlb-dont-wait-for-migration-entry-during-follow-page.patch
mm-hugetlb-document-huge_pte_offset-usage.patch
mm-hugetlb-move-swap-entry-handling-into-vma-lock-when-faulted.patch
mm-hugetlb-make-userfaultfd_huge_must_wait-safe-to-pmd-unshare.patch
mm-hugetlb-make-hugetlb_follow_page_mask-safe-to-pmd-unshare.patch
mm-hugetlb-make-follow_hugetlb_page-safe-to-pmd-unshare.patch
mm-hugetlb-make-walk_hugetlb_range-safe-to-pmd-unshare.patch
mm-hugetlb-make-page_vma_mapped_walk-safe-to-pmd-unshare.patch
mm-hugetlb-introduce-hugetlb_walk.patch
mm-hugetlb-introduce-hugetlb_walk-fix.patch
mm-hugetlb-introduce-hugetlb_walk-fix-2.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BE49C19F2A
	for <mm-commits@archiver.kernel.org>; Thu, 11 Aug 2022 21:17:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233685AbiHKVRr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Aug 2022 17:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235867AbiHKVRq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2022 17:17:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D149D9AFF4
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 14:17:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68F876144F
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 21:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA061C433D6;
        Thu, 11 Aug 2022 21:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660252664;
        bh=TU1ZpRmrAJeR4jl8me3iAXvbqMGQ2wYCC3iIYfgVrgI=;
        h=Date:To:From:Subject:From;
        b=fSoDq3z/hcIYoCRCLX+mnp+VoCLNm43FCjmhxl00q882ILgntMe8PJpRCOFundSX2
         mOTa+valsID9cahUsJxtOdh+Di1SzQcpEg4m3fDvDWbORjjWIxSL6tIA0AtyOXZiF2
         qUwelgPjhCBrbnHHJSOeM7Fx9hNys/0/ifkw+TmU=
Date:   Thu, 11 Aug 2022 14:17:44 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com, vbabka@suse.cz,
        nadav.amit@gmail.com, minchan@kernel.org, kirill@shutemov.name,
        hughd@google.com, david@redhat.com, apopple@nvidia.com,
        andi.kleen@intel.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-carry-over-dirty-bit-when-thp-splits-on-pmd.patch added to mm-unstable branch
Message-Id: <20220811211744.BA061C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: carry over dirty bit when thp splits on pmd
has been added to the -mm mm-unstable branch.  Its filename is
     mm-thp-carry-over-dirty-bit-when-thp-splits-on-pmd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-carry-over-dirty-bit-when-thp-splits-on-pmd.patch

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
Subject: mm/thp: carry over dirty bit when thp splits on pmd
Date: Thu, 11 Aug 2022 12:13:28 -0400

Carry over the dirty bit from pmd to pte when a huge pmd splits.  It
shouldn't be a correctness issue since when pmd_dirty() we'll have the
page marked dirty anyway, however having dirty bit carried over helps the
next initial writes of split ptes on some archs like x86.

Link: https://lkml.kernel.org/r/20220811161331.37055-5-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Huang Ying <ying.huang@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andi Kleen <andi.kleen@intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-thp-carry-over-dirty-bit-when-thp-splits-on-pmd
+++ a/mm/huge_memory.c
@@ -2027,7 +2027,7 @@ static void __split_huge_pmd_locked(stru
 	pgtable_t pgtable;
 	pmd_t old_pmd, _pmd;
 	bool young, write, soft_dirty, pmd_migration = false, uffd_wp = false;
-	bool anon_exclusive = false;
+	bool anon_exclusive = false, dirty = false;
 	unsigned long addr;
 	int i;
 
@@ -2116,8 +2116,10 @@ static void __split_huge_pmd_locked(stru
 		uffd_wp = pmd_swp_uffd_wp(old_pmd);
 	} else {
 		page = pmd_page(old_pmd);
-		if (pmd_dirty(old_pmd))
+		if (pmd_dirty(old_pmd)) {
+			dirty = true;
 			SetPageDirty(page);
+		}
 		write = pmd_write(old_pmd);
 		young = pmd_young(old_pmd);
 		soft_dirty = pmd_soft_dirty(old_pmd);
@@ -2183,6 +2185,9 @@ static void __split_huge_pmd_locked(stru
 				entry = pte_wrprotect(entry);
 			if (!young)
 				entry = pte_mkold(entry);
+			/* NOTE: this may set soft-dirty too on some archs */
+			if (dirty)
+				entry = pte_mkdirty(entry);
 			if (soft_dirty)
 				entry = pte_mksoft_dirty(entry);
 			if (uffd_wp)
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-smaps-dont-access-young-dirty-bit-if-pte-unpresent.patch
mm-uffd-reset-write-protection-when-unregister-with-wp-mode.patch
mm-x86-use-swp_type_bits-in-3-level-swap-macros.patch
mm-swap-comment-all-the-ifdef-in-swapopsh.patch
mm-swap-add-swp_offset_pfn-to-fetch-pfn-from-swap-entry.patch
mm-thp-carry-over-dirty-bit-when-thp-splits-on-pmd.patch
mm-remember-young-dirty-bit-for-page-migrations.patch
mm-swap-cache-maximum-swapfile-size-when-init-swap.patch
mm-swap-cache-swap-migration-a-d-bits-support.patch


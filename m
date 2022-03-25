Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 878A3C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:33:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357365AbiCYBfF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353542AbiCYBdx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB515BF01E
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FF1560A50
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C568EC340ED;
        Fri, 25 Mar 2022 01:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171939;
        bh=j6pNTE90JWRWH/A6A5RIjLRX/LexmJ4Oxm01JPltVtk=;
        h=Date:To:From:Subject:From;
        b=Ul8Pttz++oxqNz0PyMkdIA7y7roJOpzs4aJdxWnZCfrKlDulWX0Ivzg+AP3oWq//W
         a6PdSuJXMlqlAfV5M6tQwoJp39eaIkdGgVQb39QVuWdeX1cPgrOUvxKbEU7EyVqs7l
         cZkR/OZoLULPOSZA0oSWCRfSl5jbQXtqxEqo21rA=
Date:   Thu, 24 Mar 2022 18:32:19 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, shy828301@gmail.com,
        rcampbell@nvidia.com, kirill.shutemov@linux.intel.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-thp-refix-__split_huge_pmd_locked-for-migration-pmd.patch removed from -mm tree
Message-Id: <20220325013219.C568EC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: refix __split_huge_pmd_locked() for migration PMD
has been removed from the -mm tree.  Its filename was
     mm-thp-refix-__split_huge_pmd_locked-for-migration-pmd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/thp: refix __split_huge_pmd_locked() for migration PMD

Migration entries do not contribute to a page's reference count: move
__split_huge_pmd_locked()'s page_ref_add() into pmd_migration's else block
(along with the page_count() check - a page is quite likely to have
reference count frozen to 0 when a migration entry is found).

This will fix a very rare anonymous memory leak, after a split_huge_pmd()
raced with an anon split_huge_page() or an anon THP migrate_pages(): since
the wrongly raised refcount stopped the page (perhaps small, perhaps huge,
depending on when the race hit) from ever being freed.  At first I thought
there were worse risks, from prematurely unfreezing a frozen page: but now
think that would only affect page cache pages, which do not come this way
(except for anonymous pages in swap cache, perhaps).

Link: https://lkml.kernel.org/r/84792468-f512-e48f-378c-e34c3641e97@google.com
Fixes: ec0abae6dcdf ("mm/thp: fix __split_huge_pmd_locked() for migration PMD")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-thp-refix-__split_huge_pmd_locked-for-migration-pmd
+++ a/mm/huge_memory.c
@@ -2055,9 +2055,9 @@ static void __split_huge_pmd_locked(stru
 		young = pmd_young(old_pmd);
 		soft_dirty = pmd_soft_dirty(old_pmd);
 		uffd_wp = pmd_uffd_wp(old_pmd);
+		VM_BUG_ON_PAGE(!page_count(page), page);
+		page_ref_add(page, HPAGE_PMD_NR - 1);
 	}
-	VM_BUG_ON_PAGE(!page_count(page), page);
-	page_ref_add(page, HPAGE_PMD_NR - 1);
 
 	/*
 	 * Withdraw the table only after we mark the pmd entry invalid.
_

Patches currently in -mm which might be from hughd@google.com are

mm-delete-__clearpagewaiters.patch
mm-filemap_unaccount_folio-large-skip-mapcount-fixup.patch
mm-thp-fix-nr_file_mapped-accounting-in-page__file_rmap.patch
mm-warn-on-deleting-redirtied-only-if-accounted.patch
mm-unmap_mapping_range_tree-with-i_mmap_rwsem-shared.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68C83C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  4 Mar 2022 04:04:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237865AbiCDEEt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Mar 2022 23:04:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237869AbiCDEEr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Mar 2022 23:04:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3973D8567B
        for <mm-commits@vger.kernel.org>; Thu,  3 Mar 2022 20:04:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B34B3B82750
        for <mm-commits@vger.kernel.org>; Fri,  4 Mar 2022 04:03:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F30DC340F0;
        Fri,  4 Mar 2022 04:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646366638;
        bh=ZzDAu+tbIB7/0OcBmE829NbpfQn4ZDB1VXTaIkXrFQQ=;
        h=Date:To:From:Subject:From;
        b=HcCEMtXQSktr1o/0hsHYV1GuozEFiCf4Yyei5ObxrkpZSUL3sfm30ElXBgYbeAWV4
         c04y55D5S5471RKWFOCjQM/ok1+JAsRfagj/fZuz90XtA064yE+7QgqiAR7kq4fcQC
         J4CKYF25/K9dOOetSUWq9COC6+yEUGo79Y8sK6Rc=
Date:   Thu, 03 Mar 2022 20:03:57 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, shy828301@gmail.com,
        rcampbell@nvidia.com, kirill.shutemov@linux.intel.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-refix-__split_huge_pmd_locked-for-migration-pmd.patch added to -mm tree
Message-Id: <20220304040358.2F30DC340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: refix __split_huge_pmd_locked() for migration PMD
has been added to the -mm tree.  Its filename is
     mm-thp-refix-__split_huge_pmd_locked-for-migration-pmd.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-thp-refix-__split_huge_pmd_locked-for-migration-pmd.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-refix-__split_huge_pmd_locked-for-migration-pmd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/thp: refix __split_huge_pmd_locked() for migration PMD

Migration entries do not contribute to a page's reference count: move
__split_huge_pmd_locked()'s page_ref_add() into pmd_migration's else block
(along with the page_count() check - a page is quite likely to to have
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

memfd-fix-f_seal_write-after-shmem-huge-page-allocated.patch
tmpfs-support-for-file-creation-time-fix.patch
mm-thp-refix-__split_huge_pmd_locked-for-migration-pmd.patch
mm-thp-fix-nr_file_mapped-accounting-in-page__file_rmap.patch
mm-thp-clearpagedoublemap-in-first-page_add_file_rmap.patch


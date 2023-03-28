Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE3D8C77B60
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:22:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbjC1XWE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbjC1XVi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:21:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD44A30DE
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 575DC619AC
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA2D5C4339B;
        Tue, 28 Mar 2023 23:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045687;
        bh=AJ/34Oqh5a6WTvxjGkxypuI1gR844K5FqOJ9A5ZwMDg=;
        h=Date:To:From:Subject:From;
        b=QbUDGNYuZUnM3A1Vo2IR2KGgV6xYMV4RxNOyrpmbOhKneynqvDf6TLSs7GV7x5+T7
         Jf1oqBkU2hDy+6f+ZubcIDujEphUI0QCL+/Xp/IvmbZz9A3gRBSQyEUMa5WwK5rTLA
         88/MpWP/QB0DgNQIcl2XGE3Xs3kX/E1WEHH57+oU=
Date:   Tue, 28 Mar 2023 16:21:27 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        david@redhat.com, christophe.leroy@csgroup.eu,
        anshuman.khandual@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-drop-pte_mkhuge-in-remove_migration_pte.patch removed from -mm tree
Message-Id: <20230328232127.AA2D5C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/migrate: drop pte_mkhuge() in remove_migration_pte()
has been removed from the -mm tree.  Its filename was
     mm-migrate-drop-pte_mkhuge-in-remove_migration_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/migrate: drop pte_mkhuge() in remove_migration_pte()
Date: Thu, 2 Mar 2023 08:23:49 +0530

Since the following commit, arch_make_huge_pte() should be used directly
in generic memory subsystem as a platform provided page table helper,
instead of pte_mkhuge().  This just drops pte_mkhuge() from
remove_migration_pte(), which has now become redundant.

'commit 16785bd77431 ("mm: merge pte_mkhuge() call into arch_make_huge_pte()")'

Link: https://lkml.kernel.org/r/20230302025349.358341-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reported-by: Christophe Leroy <christophe.leroy@csgroup.eu>
  Link: https://lore.kernel.org/all/1ea45095-0926-a56a-a273-816709e9075e@csgroup.eu/
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-drop-pte_mkhuge-in-remove_migration_pte
+++ a/mm/migrate.c
@@ -249,7 +249,6 @@ static bool remove_migration_pte(struct
 		if (folio_test_hugetlb(folio)) {
 			unsigned int shift = huge_page_shift(hstate_vma(vma));
 
-			pte = pte_mkhuge(pte);
 			pte = arch_make_huge_pte(pte, shift, vma->vm_flags);
 			if (folio_test_anon(folio))
 				hugepage_add_anon_rmap(new, vma, pvmw.address,
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 822A2C352A1
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:05:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbiLAAF5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:05:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbiLAADx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:03:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBDAB8EE6F
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:01:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BF07B81D81
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC78C433D6;
        Thu,  1 Dec 2022 00:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852910;
        bh=lyjYtvNYWTD25L/qW0Z2dcfcu2TT++pbl9DtV9t4xR0=;
        h=Date:To:From:Subject:From;
        b=Mb+jJYT7/p8TjmXVW70QsJ+Ddv2tOA3Ag52ZAixHIWXdV48N2x5qkyhuc37+ySktt
         Jjz77dCHS1YtQGBGJnhGgWg7qk2ol15/yePQJ5evo5QaMGPhr9ew2BTVjSOsIiyN9Z
         pNnihZC4Zn4zwasVAts8I4Pqz5K+iggB7j4eAdWY=
Date:   Wed, 30 Nov 2022 16:01:49 -0800
To:     mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com,
        nadav.amit@gmail.com, axelrasmussen@google.com, apopple@nvidia.com,
        aarcange@redhat.com, peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-uffd-sanity-check-write-bit-for-uffd-wp-protected-ptes.patch removed from -mm tree
Message-Id: <20221201000150.1CC78C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/uffd: sanity check write bit for uffd-wp protected ptes
has been removed from the -mm tree.  Its filename was
     mm-uffd-sanity-check-write-bit-for-uffd-wp-protected-ptes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/uffd: sanity check write bit for uffd-wp protected ptes
Date: Sun, 13 Nov 2022 19:04:47 -0500

Let's add one sanity check for CONFIG_DEBUG_VM on the write bit in
whatever chance we have when walking through the pgtables.  It can bring
the error earlier even before the app notices the data was corrupted on
the snapshot.  Also it helps us to identify this is a wrong pgtable setup,
so hopefully a great information to have for debugging too.

Link: https://lkml.kernel.org/r/20221114000447.1681003-3-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/pgtable.h~mm-uffd-sanity-check-write-bit-for-uffd-wp-protected-ptes
+++ a/arch/x86/include/asm/pgtable.h
@@ -292,7 +292,23 @@ static inline pte_t pte_clear_flags(pte_
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
 static inline int pte_uffd_wp(pte_t pte)
 {
-	return pte_flags(pte) & _PAGE_UFFD_WP;
+	bool wp = pte_flags(pte) & _PAGE_UFFD_WP;
+
+#ifdef CONFIG_DEBUG_VM
+	/*
+	 * Having write bit for wr-protect-marked present ptes is fatal,
+	 * because it means the uffd-wp bit will be ignored and write will
+	 * just go through.
+	 *
+	 * Use any chance of pgtable walking to verify this (e.g., when
+	 * page swapped out or being migrated for all purposes). It means
+	 * something is already wrong.  Tell the admin even before the
+	 * process crashes. We also nail it with wrong pgtable setup.
+	 */
+	WARN_ON_ONCE(wp && pte_write(pte));
+#endif
+
+	return wp;
 }
 
 static inline pte_t pte_mkuffd_wp(pte_t pte)
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


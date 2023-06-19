Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 443C3C0015E
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:23:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjFSXXG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbjFSXVw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:21:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3061E76
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:21:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 517B360F79
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:21:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1ADDC433C8;
        Mon, 19 Jun 2023 23:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216899;
        bh=MTFhHwlkvhm/G8iDjXbyfSH8/8IKpXK+J/3mnzTd99g=;
        h=Date:To:From:Subject:From;
        b=OKtmIfZ+vzEc3gwdgZ00b34D/cGEPZUF2HYkQUjOUzync33HbQnTXODgjk+JayWZY
         0e7/RjU8OprrIvSgXZjFaYXF7SAHZn7uYTr2CI9Sq8McFV9vrTSngDH6esXQKYI1g7
         HgWyYFOAhUz1HHah9GJyj2P0NA+GuLi3wMoa/zME=
Date:   Mon, 19 Jun 2023 16:21:39 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        zackr@vmware.com, yuzhao@google.com, ying.huang@intel.com,
        willy@infradead.org, will@kernel.org,
        thomas.hellstrom@linux.intel.com, surenb@google.com,
        steven.price@arm.com, song@kernel.org, sj@kernel.org,
        shy828301@gmail.com, ryan.roberts@arm.com, rppt@kernel.org,
        rcampbell@nvidia.com, peterz@infradead.org, peterx@redhat.com,
        pasha.tatashin@soleen.com, naoya.horiguchi@nec.com,
        minchan@kernel.org, mike.kravetz@oracle.com,
        mgorman@techsingularity.net, lstoakes@gmail.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jgg@ziepe.ca, ira.weiny@intel.com, hch@infradead.org,
        david@redhat.com, christophe.leroy@csgroup.eu,
        axelrasmussen@google.com, apopple@nvidia.com,
        anshuman.khandual@arm.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmwgfx-simplify-pmd-pud-mapping-dirty-helpers.patch removed from -mm tree
Message-Id: <20230619232139.A1ADDC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmwgfx: simplify pmd & pud mapping dirty helpers
has been removed from the -mm tree.  Its filename was
     mm-vmwgfx-simplify-pmd-pud-mapping-dirty-helpers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/vmwgfx: simplify pmd & pud mapping dirty helpers
Date: Thu, 8 Jun 2023 18:20:04 -0700 (PDT)

wp_clean_pmd_entry() need not check pmd_trans_unstable() or pmd_none(),
wp_clean_pud_entry() need not check pud_trans_unstable() or pud_none():
it's just the ACTION_CONTINUE when trans_huge or devmap that's needed to
prevent splitting, and we're hoping to remove pmd_trans_unstable().  Is
that PUD #ifdef necessary?  Maybe some configs are missing a stub.

Link: https://lkml.kernel.org/r/d3379c7-65db-26d3-1764-8e866490925f@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Steven Price <steven.price@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zack Rusin <zackr@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mapping_dirty_helpers.c |   34 +++++++++-------------------------
 1 file changed, 9 insertions(+), 25 deletions(-)

--- a/mm/mapping_dirty_helpers.c~mm-vmwgfx-simplify-pmd-pud-mapping-dirty-helpers
+++ a/mm/mapping_dirty_helpers.c
@@ -128,19 +128,11 @@ static int wp_clean_pmd_entry(pmd_t *pmd
 {
 	pmd_t pmdval = pmdp_get_lockless(pmd);
 
-	if (!pmd_trans_unstable(&pmdval))
-		return 0;
-
-	if (pmd_none(pmdval)) {
-		walk->action = ACTION_AGAIN;
-		return 0;
-	}
-
-	/* Huge pmd, present or migrated */
-	walk->action = ACTION_CONTINUE;
-	if (pmd_trans_huge(pmdval) || pmd_devmap(pmdval))
+	/* Do not split a huge pmd, present or migrated */
+	if (pmd_trans_huge(pmdval) || pmd_devmap(pmdval)) {
 		WARN_ON(pmd_write(pmdval) || pmd_dirty(pmdval));
-
+		walk->action = ACTION_CONTINUE;
+	}
 	return 0;
 }
 
@@ -156,23 +148,15 @@ static int wp_clean_pmd_entry(pmd_t *pmd
 static int wp_clean_pud_entry(pud_t *pud, unsigned long addr, unsigned long end,
 			      struct mm_walk *walk)
 {
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
 	pud_t pudval = READ_ONCE(*pud);
 
-	if (!pud_trans_unstable(&pudval))
-		return 0;
-
-	if (pud_none(pudval)) {
-		walk->action = ACTION_AGAIN;
-		return 0;
-	}
-
-#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
-	/* Huge pud */
-	walk->action = ACTION_CONTINUE;
-	if (pud_trans_huge(pudval) || pud_devmap(pudval))
+	/* Do not split a huge pud */
+	if (pud_trans_huge(pudval) || pud_devmap(pudval)) {
 		WARN_ON(pud_write(pudval) || pud_dirty(pudval));
+		walk->action = ACTION_CONTINUE;
+	}
 #endif
-
 	return 0;
 }
 
_

Patches currently in -mm which might be from hughd@google.com are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9C08C11F6B
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:51:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AC1561474
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:51:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238481AbhGAByZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:54:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238427AbhGAByZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:54:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6802C6146D;
        Thu,  1 Jul 2021 01:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104315;
        bh=uANmw+e78nTpk2QCb7SCehF0iEDyB5ErkP6kLyFncNc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=CIx1tKBzGtNTzULqGpeMh/fc9oAN6u8a9mlSlvjux/QODdy+exnsPo30KCeQ7PzIy
         MJxVwx542wawMebhkHYU/MjDJCdD892Oua2HQn+G7g+mb8VswMU354uXJBcjtRkgMY
         sWyz3vVlQZ09SIxHNrF+KT92lffKPHi8uxEJpkYw=
Date:   Wed, 30 Jun 2021 18:51:55 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, borntraeger@de.ibm.com,
        gerald.schaefer@linux.ibm.com, gor@linux.ibm.com,
        hca@linux.ibm.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org,
        shy828301@gmail.com, torvalds@linux-foundation.org,
        ying.huang@intel.com, ziy@nvidia.com
Subject:  [patch 089/192] mm: thp: skip make PMD PROT_NONE if THP
 migration is not supported
Message-ID: <20210701015155.l-dNiqU7C%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yang Shi <shy828301@gmail.com>
Subject: mm: thp: skip make PMD PROT_NONE if THP migration is not supported

A quick grep shows x86_64, PowerPC (book3s), ARM64 and S390 support both
NUMA balancing and THP.  But S390 doesn't support THP migration so NUMA
balancing actually can't migrate any misplaced pages.

Skip make PMD PROT_NONE for such case otherwise CPU cycles may be wasted
by pointless NUMA hinting faults on S390.

Link: https://lkml.kernel.org/r/20210518200801.7413-8-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/huge_memory.c~mm-thp-skip-make-pmd-prot_none-if-thp-migration-is-not-supported
+++ a/mm/huge_memory.c
@@ -1742,6 +1742,7 @@ bool move_huge_pmd(struct vm_area_struct
  * Returns
  *  - 0 if PMD could not be locked
  *  - 1 if PMD was locked but protections unchanged and TLB flush unnecessary
+ *      or if prot_numa but THP migration is not supported
  *  - HPAGE_PMD_NR if protections changed and TLB flush necessary
  */
 int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
@@ -1756,6 +1757,9 @@ int change_huge_pmd(struct vm_area_struc
 	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
 	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
 
+	if (prot_numa && !thp_migration_supported())
+		return 1;
+
 	ptl = __pmd_trans_huge_lock(pmd, vma);
 	if (!ptl)
 		return 0;
_

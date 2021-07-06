Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB589C07E9E
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:19:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFCFA61C91
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:19:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbhGFTW3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:22:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:56104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231922AbhGFTW2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:22:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A787761C7A;
        Tue,  6 Jul 2021 19:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599189;
        bh=ZhWt1F4VBtEkOhgrfuE7U4gUOlrGWQNCuleieIeudCE=;
        h=Date:From:To:Subject:From;
        b=TdzYOnabdIWbeNHB2dYy4pSbeyLcqfJlKH2jN/R5OpkqRSSnte4DRzIgi8RsWn5+F
         Bglrn2Mi6B/Qdtel3Y1PLH8cR1nd63goKS9iwLWLNKyq9kKlBSWw9WCg4J5dP/6adY
         Jj5eeorC3M2HMZpo28Q2snA1VQqQhXYry+Nm7bcQ=
Date:   Tue, 06 Jul 2021 12:19:48 -0700
From:   akpm@linux-foundation.org
To:     borntraeger@de.ibm.com, gerald.schaefer@linux.ibm.com,
        gor@linux.ibm.com, hca@linux.ibm.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        ying.huang@intel.com, ziy@nvidia.com
Subject:  [merged]
 mm-thp-skip-make-pmd-prot_none-if-thp-migration-is-not-supported.patch
 removed from -mm tree
Message-ID: <20210706191948.GNiM_h6FM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: skip make PMD PROT_NONE if THP migration is not supported
has been removed from the -mm tree.  Its filename was
     mm-thp-skip-make-pmd-prot_none-if-thp-migration-is-not-supported.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from shy828301@gmail.com are



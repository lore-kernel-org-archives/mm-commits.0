Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3BE3C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:21:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383624AbiEMTVz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383778AbiEMTVD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:21:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A982CE71
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 541C9B83132
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6E6C34116;
        Fri, 13 May 2022 19:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469660;
        bh=RWLNIfEdWbKUKKnRPhcJoI/uXKsmP/THo4VPmI8n0Mo=;
        h=Date:To:From:Subject:From;
        b=M7iL2jAgYcL0oPFaNQitLNNugWfbSojpCHbHwkzfSIjaEOSdH+yxDjP53qD2cUzsv
         DxVNFrSYiqG1u7ClUPcwQaLwYhMkipDYTLf2CFFBms89xLsI00FpNA/lGX4QtrJ7ok
         2r8RLaXy+9JUDLxx2N7GFvY2vKgkBz55p6qVHzq8=
Date:   Fri, 13 May 2022 12:20:59 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, kirill@shutemov.name, jglisse@redhat.com,
        hughd@google.com, david@redhat.com, axelrasmussen@google.com,
        apopple@nvidia.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-introduce-huge-pte-version-of-uffd-wp-helpers.patch removed from -mm tree
Message-Id: <20220513192059.DF6E6C34116@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: introduce huge pte version of uffd-wp helpers
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-introduce-huge-pte-version-of-uffd-wp-helpers.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: introduce huge pte version of uffd-wp helpers

They will be used in the follow up patches to either check/set/clear
uffd-wp bit of a huge pte.

So far it reuses all the small pte helpers.  Archs can overwrite these
versions when necessary (with __HAVE_ARCH_HUGE_PTE_UFFD_WP* macros) in the
future.

Link: https://lkml.kernel.org/r/20220405014858.14531-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/hugetlb.h |   15 +++++++++++++++
 include/asm-generic/hugetlb.h   |   15 +++++++++++++++
 2 files changed, 30 insertions(+)

--- a/arch/s390/include/asm/hugetlb.h~mm-hugetlb-introduce-huge-pte-version-of-uffd-wp-helpers
+++ a/arch/s390/include/asm/hugetlb.h
@@ -120,6 +120,21 @@ static inline pte_t huge_pte_modify(pte_
 	return pte_modify(pte, newprot);
 }
 
+static inline pte_t huge_pte_mkuffd_wp(pte_t pte)
+{
+	return pte;
+}
+
+static inline pte_t huge_pte_clear_uffd_wp(pte_t pte)
+{
+	return pte;
+}
+
+static inline int huge_pte_uffd_wp(pte_t pte)
+{
+	return 0;
+}
+
 static inline bool gigantic_page_runtime_supported(void)
 {
 	return true;
--- a/include/asm-generic/hugetlb.h~mm-hugetlb-introduce-huge-pte-version-of-uffd-wp-helpers
+++ a/include/asm-generic/hugetlb.h
@@ -35,6 +35,21 @@ static inline pte_t huge_pte_modify(pte_
 	return pte_modify(pte, newprot);
 }
 
+static inline pte_t huge_pte_mkuffd_wp(pte_t pte)
+{
+	return pte_mkuffd_wp(pte);
+}
+
+static inline pte_t huge_pte_clear_uffd_wp(pte_t pte)
+{
+	return pte_clear_uffd_wp(pte);
+}
+
+static inline int huge_pte_uffd_wp(pte_t pte)
+{
+	return pte_uffd_wp(pte);
+}
+
 #ifndef __HAVE_ARCH_HUGE_PTE_CLEAR
 static inline void huge_pte_clear(struct mm_struct *mm, unsigned long addr,
 		    pte_t *ptep, unsigned long sz)
_

Patches currently in -mm which might be from peterx@redhat.com are



Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60724E728D8
	for <mm-commits@archiver.kernel.org>; Fri, 29 Sep 2023 19:08:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233833AbjI2TIw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Sep 2023 15:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233837AbjI2TIv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Sep 2023 15:08:51 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19371B0
        for <mm-commits@vger.kernel.org>; Fri, 29 Sep 2023 12:08:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BCDEC433C7;
        Fri, 29 Sep 2023 19:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696014528;
        bh=WTV9zvlcyncKUcWu0OCLmldxsMHdkbOlN6p2l4ZbHnQ=;
        h=Date:To:From:Subject:From;
        b=SfzpfA9eZCZbpVhDOwjDS5HmUBv/GRwv1p02KBdRLqjyUiMtRDcKHcL4dQuUAEBhd
         iVYN+WMt+cDwIcDKFdkZj3FwMFImf5lmdOGRWTzac9EMYlTnUDSixkt7njCKeQQVik
         DHTblNnuEcXZzE6Qg0qbkJMf4RIcsa0UTMenLbcA=
Date:   Fri, 29 Sep 2023 12:08:47 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, yuzhao@google.com,
        ying.huang@intel.com, willy@infradead.org, vbabka@suse.cz,
        shy828301@gmail.com, rientjes@google.com, mcgrof@kernel.org,
        kirill.shutemov@linux.intel.com, jhubbard@nvidia.com,
        itaru.kitayama@gmail.com, hughd@google.com, fengwei.yin@intel.com,
        david@redhat.com, catalin.marinas@arm.com,
        anshuman.khandual@arm.com, ryan.roberts@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-add-recommend-option-for-anon_orders.patch added to mm-unstable branch
Message-Id: <20230929190848.3BCDEC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: add "recommend" option for anon_orders
has been added to the -mm mm-unstable branch.  Its filename is
     mm-thp-add-recommend-option-for-anon_orders.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-add-recommend-option-for-anon_orders.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: thp: add "recommend" option for anon_orders
Date: Fri, 29 Sep 2023 12:44:17 +0100

In addition to passing a bitfield of folio orders to enable for THP, allow
the string "recommend" to be written, which has the effect of causing the
system to enable the orders preferred by the architecture and by the mm. 
The user can see what these orders are by subsequently reading back the
file.

Note that these recommended orders are expected to be static for a given
boot of the system, and so the keyword "auto" was deliberately not used,
as I want to reserve it for a possible future use where the "best" order
is chosen more dynamically at runtime.

Recommended orders are determined as follows:
  - PMD_ORDER: The traditional THP size
  - arch_wants_pte_order() if implemented by the arch
  - PAGE_ALLOC_COSTLY_ORDER: The largest order kept on per-cpu free list

arch_wants_pte_order() can be overridden by the architecture if desired. 
Some architectures (e.g.  arm64) can coalsece TLB entries if a contiguous
set of ptes map physically contigious, naturally aligned memory, so this
mechanism allows the architecture to optimize as required.

Here we add the default implementation of arch_wants_pte_order(), used
when the architecture does not define it, which returns -1, implying that
the HW has no preference.

Link: https://lkml.kernel.org/r/20230929114421.3761121-7-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Itaru Kitayama <itaru.kitayama@gmail.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    4 ++++
 include/linux/pgtable.h                    |   13 +++++++++++++
 mm/huge_memory.c                           |   14 +++++++++++---
 3 files changed, 28 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-thp-add-recommend-option-for-anon_orders
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -187,6 +187,10 @@ pages (=16K if the page size is 4K). The
 By enabling multiple orders, allocation of each order will be
 attempted, highest to lowest, until a successful allocation is made.
 If the PMD-order is unset, then no PMD-sized THPs will be allocated.
+It is also possible to enable the recommended set of orders, which
+will be optimized for the architecture and mm::
+
+	echo recommend >/sys/kernel/mm/transparent_hugepage/anon_orders
 
 The kernel will ignore any orders that it does not support so read the
 file back to determine which orders are enabled::
--- a/include/linux/pgtable.h~mm-thp-add-recommend-option-for-anon_orders
+++ a/include/linux/pgtable.h
@@ -393,6 +393,19 @@ static inline void arch_check_zapped_pmd
 }
 #endif
 
+#ifndef arch_wants_pte_order
+/*
+ * Returns preferred folio order for pte-mapped memory. Must be in range [0,
+ * PMD_ORDER) and must not be order-1 since THP requires large folios to be at
+ * least order-2. Negative value implies that the HW has no preference and mm
+ * will choose it's own default order.
+ */
+static inline int arch_wants_pte_order(void)
+{
+	return -1;
+}
+#endif
+
 #ifndef __HAVE_ARCH_PTEP_GET_AND_CLEAR
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 				       unsigned long address,
--- a/mm/huge_memory.c~mm-thp-add-recommend-option-for-anon_orders
+++ a/mm/huge_memory.c
@@ -464,10 +464,18 @@ static ssize_t anon_orders_store(struct
 	int err;
 	int ret = count;
 	unsigned int orders;
+	int arch;
 
-	err = kstrtouint(buf, 0, &orders);
-	if (err)
-		ret = -EINVAL;
+	if (sysfs_streq(buf, "recommend")) {
+		arch = max(arch_wants_pte_order(), PAGE_ALLOC_COSTLY_ORDER);
+		orders = BIT(arch);
+		orders |= BIT(PAGE_ALLOC_COSTLY_ORDER);
+		orders |= BIT(PMD_ORDER);
+	} else {
+		err = kstrtouint(buf, 0, &orders);
+		if (err)
+			ret = -EINVAL;
+	}
 
 	if (ret > 0) {
 		orders &= THP_ORDERS_ALL_ANON;
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-hugetlb-add-huge-page-size-param-to-set_huge_pte_at.patch
arm64-hugetlb-fix-set_huge_pte_at-to-work-with-all-swap-entries.patch
mm-allow-deferred-splitting-of-arbitrary-anon-large-folios.patch
mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch
mm-thp-account-pte-mapped-anonymous-thp-usage.patch
mm-thp-introduce-anon_orders-and-anon_always_mask-sysfs-files.patch
mm-thp-extend-thp-to-allocate-anonymous-large-folios.patch
mm-thp-add-recommend-option-for-anon_orders.patch
arm64-mm-override-arch_wants_pte_order.patch
selftests-mm-cow-generalize-do_run_with_thp-helper.patch
selftests-mm-cow-add-tests-for-small-order-anon-thp.patch


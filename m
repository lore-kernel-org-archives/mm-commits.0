Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABDE6C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 21 Apr 2022 20:36:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392427AbiDUUj0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Apr 2022 16:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392429AbiDUUjZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2022 16:39:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B744DF6A
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 13:36:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EE6261D7F
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 20:36:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 872C4C385A5;
        Thu, 21 Apr 2022 20:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650573392;
        bh=q9bk+b9LrCsUjVXyeoL04E92+HETVAguG83BxWyjSvA=;
        h=Date:To:From:Subject:From;
        b=p8IkIBQXa/vH7YgKn0WEYns18W9aTdzSU4DYJI2v7X2OiSHC+OxUUnLkkey2JouwN
         onmSQy1BLOzQCIn21i4QoSa8dMwaFyIuUwIzjSF3ZU6+wtd7+xmmXqTYkGOzA9uXc6
         YGdBVhXYwXYBj/yhW/BS0EfIDs/zItMIzq0MHHYY=
Date:   Thu, 21 Apr 2022 13:36:31 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        tongtiangen@huawei.com, tglx@linutronix.de,
        paul.walmsley@sifive.com, pasha.tatashin@soleen.com,
        palmer@dabbelt.com, mingo@redhat.com, hpa@zytor.com,
        guohanjun@huawei.com, dave.hansen@linux.intel.com,
        catalin.marinas@arm.com, bp@alien8.de, aou@eecs.berkeley.edu,
        anshuman.khandual@arm.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_table_check-move-pxx_user_accessible_page-into-x86.patch added to -mm tree
Message-Id: <20220421203632.872C4C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_table_check: move pxx_user_accessible_page into x86
has been added to the -mm tree.  Its filename is
     mm-page_table_check-move-pxx_user_accessible_page-into-x86.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_table_check-move-pxx_user_accessible_page-into-x86.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_table_check-move-pxx_user_accessible_page-into-x86.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: page_table_check: move pxx_user_accessible_page into x86

The pxx_user_accessible_page() check the PTE bit, it's
architecture-specific code, move them into x86's pgtable.h,

Link: https://lkml.kernel.org/r/20220421082042.1167967-3-tongtiangen@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Guohanjun <guohanjun@huawei.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |   19 +++++++++++++++++++
 mm/page_table_check.c          |   17 -----------------
 2 files changed, 19 insertions(+), 17 deletions(-)

--- a/arch/x86/include/asm/pgtable.h~mm-page_table_check-move-pxx_user_accessible_page-into-x86
+++ a/arch/x86/include/asm/pgtable.h
@@ -1430,6 +1430,25 @@ static inline bool arch_faults_on_old_pt
 	return false;
 }
 
+#ifdef CONFIG_PAGE_TABLE_CHECK
+static inline bool pte_user_accessible_page(pte_t pte)
+{
+	return (pte_val(pte) & _PAGE_PRESENT) && (pte_val(pte) & _PAGE_USER);
+}
+
+static inline bool pmd_user_accessible_page(pmd_t pmd)
+{
+	return pmd_leaf(pmd) && (pmd_val(pmd) & _PAGE_PRESENT) &&
+		(pmd_val(pmd) & _PAGE_USER);
+}
+
+static inline bool pud_user_accessible_page(pud_t pud)
+{
+	return pud_leaf(pud) && (pud_val(pud) & _PAGE_PRESENT) &&
+		(pud_val(pud) & _PAGE_USER);
+}
+#endif
+
 #endif	/* __ASSEMBLY__ */
 
 #endif /* _ASM_X86_PGTABLE_H */
--- a/mm/page_table_check.c~mm-page_table_check-move-pxx_user_accessible_page-into-x86
+++ a/mm/page_table_check.c
@@ -52,23 +52,6 @@ static struct page_table_check *get_page
 	return (void *)(page_ext) + page_table_check_ops.offset;
 }
 
-static inline bool pte_user_accessible_page(pte_t pte)
-{
-	return (pte_val(pte) & _PAGE_PRESENT) && (pte_val(pte) & _PAGE_USER);
-}
-
-static inline bool pmd_user_accessible_page(pmd_t pmd)
-{
-	return pmd_leaf(pmd) && (pmd_val(pmd) & _PAGE_PRESENT) &&
-		(pmd_val(pmd) & _PAGE_USER);
-}
-
-static inline bool pud_user_accessible_page(pud_t pud)
-{
-	return pud_leaf(pud) && (pud_val(pud) & _PAGE_PRESENT) &&
-		(pud_val(pud) & _PAGE_USER);
-}
-
 /*
  * An enty is removed from the page table, decrement the counters for that page
  * verify that it is of correct type and counters do not become negative.
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-page_table_check-move-pxx_user_accessible_page-into-x86.patch
arm64-mm-add-support-for-page-table-check.patch


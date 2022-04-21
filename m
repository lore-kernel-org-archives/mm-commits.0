Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7085EC43217
	for <mm-commits@archiver.kernel.org>; Thu, 21 Apr 2022 20:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392429AbiDUUj1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Apr 2022 16:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392409AbiDUUjW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2022 16:39:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63CE4DF68
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 13:36:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55A3361D7F
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 20:36:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A61FAC385A7;
        Thu, 21 Apr 2022 20:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650573390;
        bh=T49BKFriIBKSSCQ5xv8ZiSx2G2tENRCRegtPm7f4SSc=;
        h=Date:To:From:Subject:From;
        b=fdaH61UHjdSVEYWNAzs3PNBrS7h8QSiKrllt770xcvjjYsQlUXEnHF36kyOzZslF1
         z9CGEEONTb26Vc3/yzMtN0KHiC+cXmK6OkusWF2LQxRdNJTDjAFbtFHF5rei2FAMoL
         ZmHgiCzIB0SfI2jLsE16R2+kk0TatsY+PH/hbYEc=
Date:   Thu, 21 Apr 2022 13:36:29 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        wangkefeng.wang@huawei.com, tglx@linutronix.de,
        paul.walmsley@sifive.com, palmer@dabbelt.com, mingo@redhat.com,
        hpa@zytor.com, guohanjun@huawei.com, dave.hansen@linux.intel.com,
        catalin.marinas@arm.com, bp@alien8.de, aou@eecs.berkeley.edu,
        anshuman.khandual@arm.com, tongtiangen@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_table_check-using-pxd_size-instead-of-pxd_page_size.patch added to -mm tree
Message-Id: <20220421203630.A61FAC385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_table_check: use PxD_SIZE instead of PxD_PAGE_SIZE
has been added to the -mm tree.  Its filename is
     mm-page_table_check-using-pxd_size-instead-of-pxd_page_size.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_table_check-using-pxd_size-instead-of-pxd_page_size.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_table_check-using-pxd_size-instead-of-pxd_page_size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tong Tiangen <tongtiangen@huawei.com>
Subject: mm: page_table_check: use PxD_SIZE instead of PxD_PAGE_SIZE

Patch series "mm: page_table_check: add support on arm64 and riscv", v5.

Page table check performs extra verifications at the time when new pages
become accessible from the userspace by getting their page table entries
(PTEs PMDs etc.) added into the table.  It is supported on X86[1].

This patchset made some simple changes and make it easier to support new
architecture, then we support this feature on ARM64 and RISCV.

[1]https://lore.kernel.org/lkml/20211123214814.3756047-1-pasha.tatashin@soleen.com/


This patch (of 5):

Macro PUD_SIZE/PMD_SIZE is more general in various architectures.  Using
PUD_SIZE/PMD_SIZE instead of PUD_PAGE_SIZE/PMD_PAGE_SIZE can better
support page table check in architectures other than x86 and it is no
functional impact on x86.

Link: https://lkml.kernel.org/r/20220421082042.1167967-1-tongtiangen@huawei.com
Link: https://lkml.kernel.org/r/20220421082042.1167967-2-tongtiangen@huawei.com
Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
Suggested-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Guohanjun <guohanjun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_table_check.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/page_table_check.c~mm-page_table_check-using-pxd_size-instead-of-pxd_page_size
+++ a/mm/page_table_check.c
@@ -177,7 +177,7 @@ void __page_table_check_pmd_clear(struct
 
 	if (pmd_user_accessible_page(pmd)) {
 		page_table_check_clear(mm, addr, pmd_pfn(pmd),
-				       PMD_PAGE_SIZE >> PAGE_SHIFT);
+				       PMD_SIZE >> PAGE_SHIFT);
 	}
 }
 EXPORT_SYMBOL(__page_table_check_pmd_clear);
@@ -190,7 +190,7 @@ void __page_table_check_pud_clear(struct
 
 	if (pud_user_accessible_page(pud)) {
 		page_table_check_clear(mm, addr, pud_pfn(pud),
-				       PUD_PAGE_SIZE >> PAGE_SHIFT);
+				       PUD_SIZE >> PAGE_SHIFT);
 	}
 }
 EXPORT_SYMBOL(__page_table_check_pud_clear);
@@ -219,7 +219,7 @@ void __page_table_check_pmd_set(struct m
 	__page_table_check_pmd_clear(mm, addr, *pmdp);
 	if (pmd_user_accessible_page(pmd)) {
 		page_table_check_set(mm, addr, pmd_pfn(pmd),
-				     PMD_PAGE_SIZE >> PAGE_SHIFT,
+				     PMD_SIZE >> PAGE_SHIFT,
 				     pmd_write(pmd));
 	}
 }
@@ -234,7 +234,7 @@ void __page_table_check_pud_set(struct m
 	__page_table_check_pud_clear(mm, addr, *pudp);
 	if (pud_user_accessible_page(pud)) {
 		page_table_check_set(mm, addr, pud_pfn(pud),
-				     PUD_PAGE_SIZE >> PAGE_SHIFT,
+				     PUD_SIZE >> PAGE_SHIFT,
 				     pud_write(pud));
 	}
 }
_

Patches currently in -mm which might be from tongtiangen@huawei.com are

mm-page_table_check-using-pxd_size-instead-of-pxd_page_size.patch
mm-page_table_check-add-hooks-to-public-helpers.patch
riscv-mm-add-support-for-page-table-check.patch


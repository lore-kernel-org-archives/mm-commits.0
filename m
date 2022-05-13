Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA88FC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:24:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383736AbiEMTY5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383858AbiEMTXP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:23:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9DA3DDC5
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:22:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 226A1B83193
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:22:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8469C34100;
        Fri, 13 May 2022 19:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469727;
        bh=3IDjU19mD8JOcwBr3vBEuPu8gjUBrzavwG1Uz2N5H/I=;
        h=Date:To:From:Subject:From;
        b=B6QTj2xjWTnLrrXwpKaDXtx8T02KIuy/uDok7mtpHe7Yvdb4/Dtw8pA88ZtlbjtJi
         EP9pdFT0QUBqfnkDjYCEQfsUxkSi9R8QlNsw59WrviC73icdKVxcGlDf5KJbWASy0D
         4la58YXs6xYLz9CJAPlzO1EmErXojA35vFi/anFY=
Date:   Fri, 13 May 2022 12:22:07 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        wangkefeng.wang@huawei.com, paul.walmsley@sifive.com,
        pasha.tatashin@soleen.com, palmer@dabbelt.com, mingo@redhat.com,
        hpa@zytor.com, dave.hansen@linux.intel.com,
        catalin.marinas@arm.com, bp@alien8.de, anshuman.khandual@arm.com,
        tongtiangen@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_table_check-using-pxd_size-instead-of-pxd_page_size.patch removed from -mm tree
Message-Id: <20220513192207.C8469C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: page_table_check: using PxD_SIZE instead of PxD_PAGE_SIZE
has been removed from the -mm tree.  Its filename was
     mm-page_table_check-using-pxd_size-instead-of-pxd_page_size.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tong Tiangen <tongtiangen@huawei.com>
Subject: mm: page_table_check: using PxD_SIZE instead of PxD_PAGE_SIZE

Patch series "mm: page_table_check: add support on arm64 and riscv", v7.

Page table check performs extra verifications at the time when new pages
become accessible from the userspace by getting their page table entries
(PTEs PMDs etc.) added into the table.  It is supported on X86[1].

This patchset made some simple changes and make it easier to support new
architecture, then we support this feature on ARM64 and RISCV.

[1]https://lore.kernel.org/lkml/20211123214814.3756047-1-pasha.tatashin@soleen.com/


This patch (of 6):

Compared with PxD_PAGE_SIZE, which is defined and used only on X86,
PxD_SIZE is more common in each architecture.  Therefore, it is more
reasonable to use PxD_SIZE instead of PxD_PAGE_SIZE in page_table_check.c.
At the same time, it is easier to support page table check in other
architectures.  The substitution has no functional impact on the x86.

Link: https://lkml.kernel.org/r/20220507110114.4128854-1-tongtiangen@huawei.com
Link: https://lkml.kernel.org/r/20220507110114.4128854-2-tongtiangen@huawei.com
Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
Suggested-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
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



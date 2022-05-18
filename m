Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D264C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 18 May 2022 17:14:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240739AbiERROD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 May 2022 13:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240738AbiERRN7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 May 2022 13:13:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F9418C067
        for <mm-commits@vger.kernel.org>; Wed, 18 May 2022 10:13:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C90006176D
        for <mm-commits@vger.kernel.org>; Wed, 18 May 2022 17:13:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22386C385A9;
        Wed, 18 May 2022 17:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652894036;
        bh=jvfkZdM+InBVkh23B5nfLn1HCry5D+ZjIAySPeZjDmU=;
        h=Date:To:From:Subject:From;
        b=Bg6lP+rXO27EAugAX2OXGWEn0bY3ch59k8Ha33LTYaDrQqrLfLQYmZjxdXlZ59r9F
         reO6b6L8WAXoxnMWZvF6L4NKUAJ4EYkayg0sdfEzHoTHwq3IwdnaNyapaXVu64RUXX
         Khk9nlpjYrWX/QcR8ZeEgIxNM9IOl5AhnhljwtOY=
Date:   Wed, 18 May 2022 10:13:55 -0700
To:     mm-commits@vger.kernel.org, xiexiuqi@huawei.com, will@kernel.org,
        paul.walmsley@sifive.com, pasha.tatashin@soleen.com,
        palmer@dabbelt.com, lkp@intel.com, guohanjun@huawei.com,
        catalin.marinas@arm.com, arnd@arndb.de, aou@eecs.berkeley.edu,
        anshuman.khandual@arm.com, tongtiangen@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-mm-fix-two-page-table-check-related-issues.patch added to mm-unstable branch
Message-Id: <20220518171356.22386C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: riscv/mm: fix two page table check related issues
has been added to the -mm mm-unstable branch.  Its filename is
     riscv-mm-fix-two-page-table-check-related-issues.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-mm-fix-two-page-table-check-related-issues.patch

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
From: Tong Tiangen <tongtiangen@huawei.com>
Subject: riscv/mm: fix two page table check related issues
Date: Tue, 17 May 2022 07:45:47 +0000

Two page table check related issues have been fixed here.

1. Open CONFIG_PAGE_TABLE_CHECK in riscv32, we got a compile error[1]:

   error: implicit declaration of function 'pud_leaf'

   Add pud_leaf() definition to incluce/asm-generic/pgtable-nopmd.h to fix
   this issue.

2. Keep consistent with other pud_xxx() helpers, move pud_user() to
   pgtable-64.h and add pud_user() to pgtable-nopmd.h.

[1]https://lore.kernel.org/linux-mm/202205161811.2nLxmN2O-lkp@intel.com/T/

Link: https://lkml.kernel.org/r/20220517074548.2227779-2-tongtiangen@huawei.com
Fixes: 856eed79f8d3 ("riscv/mm: enable ARCH_SUPPORTS_PAGE_TABLE_CHECK")
Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Guohanjun <guohanjun@huawei.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Will Deacon <will@kernel.org>
Cc: Xie XiuQi <xiexiuqi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/include/asm/pgtable-64.h |    5 +++++
 arch/riscv/include/asm/pgtable.h    |    5 -----
 include/asm-generic/pgtable-nopmd.h |    2 ++
 3 files changed, 7 insertions(+), 5 deletions(-)

--- a/arch/riscv/include/asm/pgtable-64.h~riscv-mm-fix-two-page-table-check-related-issues
+++ a/arch/riscv/include/asm/pgtable-64.h
@@ -86,6 +86,11 @@ static inline int pud_leaf(pud_t pud)
 	return pud_present(pud) && (pud_val(pud) & _PAGE_LEAF);
 }
 
+static inline int pud_user(pud_t pud)
+{
+	return pud_val(pud) & _PAGE_USER;
+}
+
 static inline void set_pud(pud_t *pudp, pud_t pud)
 {
 	*pudp = pud;
--- a/arch/riscv/include/asm/pgtable.h~riscv-mm-fix-two-page-table-check-related-issues
+++ a/arch/riscv/include/asm/pgtable.h
@@ -634,11 +634,6 @@ static inline void set_pmd_at(struct mm_
 	return __set_pte_at(mm, addr, (pte_t *)pmdp, pmd_pte(pmd));
 }
 
-static inline int pud_user(pud_t pud)
-{
-	return pte_user(pud_pte(pud));
-}
-
 static inline void set_pud_at(struct mm_struct *mm, unsigned long addr,
 				pud_t *pudp, pud_t pud)
 {
--- a/include/asm-generic/pgtable-nopmd.h~riscv-mm-fix-two-page-table-check-related-issues
+++ a/include/asm-generic/pgtable-nopmd.h
@@ -30,6 +30,8 @@ typedef struct { pud_t pud; } pmd_t;
 static inline int pud_none(pud_t pud)		{ return 0; }
 static inline int pud_bad(pud_t pud)		{ return 0; }
 static inline int pud_present(pud_t pud)	{ return 1; }
+static inline int pud_user(pud_t pud)		{ return 0; }
+static inline int pud_leaf(pud_t pud)		{ return 0; }
 static inline void pud_clear(pud_t *pud)	{ }
 #define pmd_ERROR(pmd)				(pud_ERROR((pmd).pud))
 
_

Patches currently in -mm which might be from tongtiangen@huawei.com are

riscv-mm-fix-two-page-table-check-related-issues.patch
arm64-mm-fix-page-table-check-compile-error-for-config_pgtable_levels=2.patch


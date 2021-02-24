Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD999C433E6
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:08:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F0E064F09
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:08:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235374AbhBXUIR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:08:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:59602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235291AbhBXUH2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:07:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F29D64E6C;
        Wed, 24 Feb 2021 20:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197207;
        bh=ExvbAqaH3jEwzhaUnfNFLwu8yOToxp3gruKqvmvQXso=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Pa+TGNiTyxleaNzoer7qAKcCG+ZBTxGB673cHipDA7S0MFKkBuf/lEtNdiREylVmd
         WtA4FRWyjDmDYx0FjKnYV+kWpZSUWw+5/IiufYy3V5T9yz/M+XXD3FdUoRxsrS61Y8
         rOOaRRsx6Jqqe7J7/s0crY3arPe2a6g0XkSooOao=
Date:   Wed, 24 Feb 2021 12:06:46 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        dansilsby@gmail.com, kirill.shutemov@linux.intel.com,
        linux-mm@kvack.org, maobibo@loongson.cn, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, paulburton@kernel.org,
        ralf@linux-mips.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, tsbogend@alpha.franken.de
Subject:  [patch 112/173] MIPS: do not call flush_tlb_all when
 setting pmd entry
Message-ID: <20210224200646.TrJOnYm-B%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Bibo Mao <maobibo@loongson.cn>
Subject: MIPS: do not call flush_tlb_all when setting pmd entry

Function set_pmd_at is to set pmd entry, if tlb entry need to be flushed,
there exists pmdp_huge_clear_flush alike function before set_pmd_at is
called.  So it is not necessary to call flush_tlb_all in this function.

In these scenarios, tlb for the pmd range needs to be flushed:
1. privilege degrade such as wrprotect is set on the pmd entry
2. pmd entry is cleared
3. there is exception if set_pmd_at is issued by dup_mmap, since
flush_tlb_mm is called for parent process, it is not necessary
to flush tlb in function copy_huge_pmd.

Link: http://lkml.kernel.org/r/1592990792-1923-3-git-send-email-maobibo@loongson.cn
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Daniel Silsby <dansilsby@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Paul Burton <paulburton@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/pgtable-32.c |    1 -
 arch/mips/mm/pgtable-64.c |    1 -
 2 files changed, 2 deletions(-)

--- a/arch/mips/mm/pgtable-32.c~mips-do-not-call-flush_tlb_all-when-setting-pmd-entry
+++ a/arch/mips/mm/pgtable-32.c
@@ -45,7 +45,6 @@ void set_pmd_at(struct mm_struct *mm, un
 		pmd_t *pmdp, pmd_t pmd)
 {
 	*pmdp = pmd;
-	flush_tlb_all();
 }
 #endif /* defined(CONFIG_TRANSPARENT_HUGEPAGE) */
 
--- a/arch/mips/mm/pgtable-64.c~mips-do-not-call-flush_tlb_all-when-setting-pmd-entry
+++ a/arch/mips/mm/pgtable-64.c
@@ -100,7 +100,6 @@ void set_pmd_at(struct mm_struct *mm, un
 		pmd_t *pmdp, pmd_t pmd)
 {
 	*pmdp = pmd;
-	flush_tlb_all();
 }
 
 void __init pagetable_init(void)
_

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E27A4C43381
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:31:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1C7264F28
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:31:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234550AbhBYTav (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:30:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:36924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234592AbhBYT16 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:27:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98EA764F9C;
        Thu, 25 Feb 2021 19:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280593;
        bh=XF3C9kI76Y0qXXHMNK8e7iBwhnRWBzYbU2PaFfyxeGY=;
        h=Date:From:To:Subject:From;
        b=XCDoPgXVn3TK1Ze/e+sGPLM9XiLcUGHvOFl7vI54d3SgEQMhmbDZLfJYKPzGycCsP
         sUjaWxcxq/rmRpGrRZGfBXVnlQdQRlPGWM2qIBQYsnPSILwoxEfTABnDwg+PMT/28E
         +kdR0PDtEu8QniCWqjiXJKXOYBrzRd2M9oPcaF7g=
Date:   Thu, 25 Feb 2021 11:16:32 -0800
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, dansilsby@gmail.com,
        kirill.shutemov@linux.intel.com, maobibo@loongson.cn,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        paulburton@kernel.org, ralf@linux-mips.org, rppt@linux.ibm.com,
        tsbogend@alpha.franken.de
Subject:  [merged]
 mips-do-not-call-flush_tlb_all-when-setting-pmd-entry.patch removed from
 -mm tree
Message-ID: <20210225191632.cUPT6BGCL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MIPS: do not call flush_tlb_all when setting pmd entry
has been removed from the -mm tree.  Its filename was
     mips-do-not-call-flush_tlb_all-when-setting-pmd-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from maobibo@loongson.cn are



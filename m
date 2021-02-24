Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CB75C433E6
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:07:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34C3F64E60
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:07:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235269AbhBXUHr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:07:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:56140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235283AbhBXUG7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:06:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7510A64E24;
        Wed, 24 Feb 2021 20:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197204;
        bh=axrXK3Oqhx1hjzIewrX2nB/fM2JIWPXy9yjR0sOCWEk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=uy1GrTPOnHm+QhRD2/mV45xZHGV99B6bfz0icWb1IMOcwMk6Chbap4/PnJJXoWzNW
         oOC+xRExfTGg5WODWecGVV1gppmcettqENiJTLlpheDALHiv0FID03oShASIQj5CH6
         /KVg2Md6E7Ndwr/lsCKDQnNWTrTcrFfaSYYh57Zs=
Date:   Wed, 24 Feb 2021 12:06:42 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        dansilsby@gmail.com, kirill.shutemov@linux.intel.com,
        linux-mm@kvack.org, maobibo@loongson.cn, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, paulburton@kernel.org,
        ralf@linux-mips.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, tsbogend@alpha.franken.de
Subject:  [patch 111/173] mm/huge_memory.c: update tlb entry if pmd
 is changed
Message-ID: <20210224200642.rrDUZyoaP%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Bibo Mao <maobibo@loongson.cn>
Subject: mm/huge_memory.c: update tlb entry if pmd is changed

When set_pmd_at is called in function do_huge_pmd_anonymous_page, new tlb
entry can be added by software on MIPS platform.

Here add update_mmu_cache_pmd when pmd entry is set, and
update_mmu_cache_pmd is defined as empty excepts arc/mips platform.  This
patch has no negative effect on other platforms except arc/mips system.

Link: http://lkml.kernel.org/r/1592990792-1923-2-git-send-email-maobibo@loongson.cn
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

 mm/huge_memory.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/huge_memory.c~mm-huge_memoryc-update-tlb-entry-if-pmd-is-changed
+++ a/mm/huge_memory.c
@@ -636,6 +636,7 @@ static vm_fault_t __do_huge_pmd_anonymou
 		lru_cache_add_inactive_or_unevictable(page, vma);
 		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
 		set_pmd_at(vma->vm_mm, haddr, vmf->pmd, entry);
+		update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
 		add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 		mm_inc_nr_ptes(vma->vm_mm);
 		spin_unlock(vmf->ptl);
@@ -749,6 +750,7 @@ vm_fault_t do_huge_pmd_anonymous_page(st
 			} else {
 				set_huge_zero_page(pgtable, vma->vm_mm, vma,
 						   haddr, vmf->pmd, zero_page);
+				update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
 				spin_unlock(vmf->ptl);
 			}
 		} else {
_

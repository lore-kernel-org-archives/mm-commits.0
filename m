Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA319C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:28:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9140164F1A
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:28:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234147AbhBYT2G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:28:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:36914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234263AbhBYTZj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:25:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F59564F6B;
        Thu, 25 Feb 2021 19:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280493;
        bh=VCyB67CJCdoRTznS071OqxbDGfwRPb0kMqLMFLUFM7I=;
        h=Date:From:To:Subject:From;
        b=Bpwj4dPgRqfQOC3xpJ2lsKEr0CDeDTBl88aVdyK3YpDCfJ8RRnrift9F9S7FhA0Tc
         lMdbM0L9NHbkhD4avyhwgDSjtDVtjAdl2wt5TSvvfWr6OrizGdoMujc5kaIsPYv6m5
         1TE8qyiVQE5ysCAjzZOEklS6v5QsT4Mc81K2OkoA=
Date:   Thu, 25 Feb 2021 11:14:53 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-simplify-the-vm_bug_on-condition-in-pmdp_huge_clear_flush.patch removed
 from -mm tree
Message-ID: <20210225191453.PFD-Ln2Rh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/pgtable-generic.c: simplify the VM_BUG_ON condition in pmdp_huge_clear_flush()
has been removed from the -mm tree.  Its filename was
     mm-simplify-the-vm_bug_on-condition-in-pmdp_huge_clear_flush.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/pgtable-generic.c: simplify the VM_BUG_ON condition in pmdp_huge_clear_flush()

The condition (A && !C && !D) || !A is equivalent to !A || (A && !C && !D)
and can be further simplified to !A || (!C && !D).

Link: https://lkml.kernel.org/r/20210201114319.34720-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pgtable-generic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/pgtable-generic.c~mm-simplify-the-vm_bug_on-condition-in-pmdp_huge_clear_flush
+++ a/mm/pgtable-generic.c
@@ -135,8 +135,8 @@ pmd_t pmdp_huge_clear_flush(struct vm_ar
 {
 	pmd_t pmd;
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
-	VM_BUG_ON((pmd_present(*pmdp) && !pmd_trans_huge(*pmdp) &&
-			   !pmd_devmap(*pmdp)) || !pmd_present(*pmdp));
+	VM_BUG_ON(!pmd_present(*pmdp) || (!pmd_trans_huge(*pmdp) &&
+					  !pmd_devmap(*pmdp)));
 	pmd = pmdp_huge_get_and_clear(vma->vm_mm, address, pmdp);
 	flush_pmd_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
 	return pmd;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory_hotplug-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-mlock-stop-counting-mlocked-pages-when-none-vma-is-found.patch
mm-rmap-correct-some-obsolete-comments-of-anon_vma.patch
mm-rmap-remove-unneeded-semicolon-in-page_not_mapped.patch
mm-rmap-fix-obsolete-comment-in-__page_check_anon_rmap.patch
mm-rmap-use-page_not_mapped-in-try_to_unmap.patch
mm-rmap-correct-obsolete-comment-of-page_get_anon_vma.patch
mm-rmap-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch
mm-zsmallocc-use-page_private-to-access-page-private.patch


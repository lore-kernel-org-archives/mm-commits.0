Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 815B9C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:28:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FED464F46
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:28:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234314AbhBYT2K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:28:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:36916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234244AbhBYTZj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:25:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C1E564F77;
        Thu, 25 Feb 2021 19:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280496;
        bh=NXn4o36q63QP4v1iWcIFwYibPX6iM0P8rkZj9LVTOUE=;
        h=Date:From:To:Subject:From;
        b=K1nDrh0yps7qbFkjY6eSFk3/8Wk+ijKfhNK0TbpU4Knm7LdCoBSYc/8uMYLNHPL9t
         YCmtpJn87zZeIIpEvf7qwbWZlQc25Y67c7kg23NFLTgZ4qGO0t6hsDOsKoyvHE0F/M
         F443P+YjMrqkAs0PA4AqeSuE1uBxBCFKKRzedSX4=
Date:   Thu, 25 Feb 2021 11:14:56 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?mm-pgtable-genericc-optimize-the-vm=5Fbug=5Fon-condition-in?=
 =?US-ASCII?Q?-pmdp=5Fhuge=5Fclear=5Fflush.patch?= removed from -mm tree
Message-ID: <20210225191456.NvYQaWflc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/pgtable-generic.c: optimize the VM_BUG_ON condition in pmdp_huge_clear_flush()
has been removed from the -mm tree.  Its filename was
     mm-pgtable-genericc-optimize-the-vm_bug_on-condition-in-pmdp_huge_clear_flush.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/pgtable-generic.c: optimize the VM_BUG_ON condition in pmdp_huge_clear_flush()

The developer will have trouble figuring out why the BUG actually
triggered when there is a complex expression in the VM_BUG_ON.  Because we
can only identify the condition triggered BUG via line number provided by
VM_BUG_ON.  Optimize this by spliting such a complex expression into two
simple conditions.

Link: https://lkml.kernel.org/r/20210203084137.25522-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pgtable-generic.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/pgtable-generic.c~mm-pgtable-genericc-optimize-the-vm_bug_on-condition-in-pmdp_huge_clear_flush
+++ a/mm/pgtable-generic.c
@@ -135,8 +135,9 @@ pmd_t pmdp_huge_clear_flush(struct vm_ar
 {
 	pmd_t pmd;
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
-	VM_BUG_ON(!pmd_present(*pmdp) || (!pmd_trans_huge(*pmdp) &&
-					  !pmd_devmap(*pmdp)));
+	VM_BUG_ON(!pmd_present(*pmdp));
+	/* Below assumes pmd_present() is true */
+	VM_BUG_ON(!pmd_trans_huge(*pmdp) && !pmd_devmap(*pmdp));
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


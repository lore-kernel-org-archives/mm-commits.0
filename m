Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA0D1C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:28:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FF6164F1A
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:28:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233618AbhBYT2A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:28:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:36912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234250AbhBYTZj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:25:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C688264F76;
        Thu, 25 Feb 2021 19:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280491;
        bh=RgM+275n5guRpp+i1Ks+UcJjGh3IylDA2XloDWSbbSg=;
        h=Date:From:To:Subject:From;
        b=ohIe8Bo7zT+vEE+IeKE4bMQ+nzSgkNA4NXFI1YY1Nl3xqL+LLQ0iPxgy9SDtHm0eb
         w3CeCnExppQLcugXWamfUvQuvnBdTzEKAoZX3bcRCEZIbWbXLwSsJiOcqg7+1L3mee
         CmjPSz2uEV3EP5otPiQ8BAaaih5Aa7WQ1uU+wABE=
Date:   Thu, 25 Feb 2021 11:14:50 -0800
From:   akpm@linux-foundation.org
To:     ak@linux.intel.com, dave.hansen@intel.com, jpoimboe@redhat.com,
        linmiaohe@huawei.com, louhongxiang@huawei.com,
        mm-commits@vger.kernel.org, tglx@linutronix.de
Subject:  [merged]
 mm-fix-potential-pte_unmap_unlock-pte-error.patch removed from -mm tree
Message-ID: <20210225191450.gL0Qk3A_Z%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: fix potential pte_unmap_unlock pte error
has been removed from the -mm tree.  Its filename was
     mm-fix-potential-pte_unmap_unlock-pte-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory.c: fix potential pte_unmap_unlock pte error

Since commit 42e4089c7890 ("x86/speculation/l1tf: Disallow non privileged
high MMIO PROT_NONE mappings"), when the first pfn modify is not allowed,
we would break the loop with pte unchanged.  Then the wrong pte - 1 would
be passed to pte_unmap_unlock.

Andi said:

: While the fix is correct, I'm not sure if it actually is a real bug.  Is
: there any architecture that would do something else than unlocking the
: underlying page?  If it's just the underlying page then it should be
: always the same page, so no bug.

Link: https://lkml.kernel.org/r/20210109080118.20885-1-linmiaohe@huawei.com
Fixes: 42e4089c789 ("x86/speculation/l1tf: Disallow non privileged high MMIO PROT_NONE mappings")
Signed-off-by: Hongxiang Lou <louhongxiang@huawei.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memory.c~mm-fix-potential-pte_unmap_unlock-pte-error
+++ a/mm/memory.c
@@ -2177,11 +2177,11 @@ static int remap_pte_range(struct mm_str
 			unsigned long addr, unsigned long end,
 			unsigned long pfn, pgprot_t prot)
 {
-	pte_t *pte;
+	pte_t *pte, *mapped_pte;
 	spinlock_t *ptl;
 	int err = 0;
 
-	pte = pte_alloc_map_lock(mm, pmd, addr, &ptl);
+	mapped_pte = pte = pte_alloc_map_lock(mm, pmd, addr, &ptl);
 	if (!pte)
 		return -ENOMEM;
 	arch_enter_lazy_mmu_mode();
@@ -2195,7 +2195,7 @@ static int remap_pte_range(struct mm_str
 		pfn++;
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 	arch_leave_lazy_mmu_mode();
-	pte_unmap_unlock(pte - 1, ptl);
+	pte_unmap_unlock(mapped_pte, ptl);
 	return err;
 }
 
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


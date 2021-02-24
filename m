Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D71D3C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CA8864F2C
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbhBXUGh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:06:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:55524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235298AbhBXUFw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:05:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABA4A64F28;
        Wed, 24 Feb 2021 20:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197074;
        bh=ZMX7Cyocnd5Q+RWAIfyBqoozo9BNvXR0pWfWkaU5ECc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Q4uIjkespeCCnpFojjEr203EFyBUxFVSV+NOJRgkPQ8emcv2Tb5pYEbW33IJqI+xS
         NMvfm47pNoK8EeN7rOQer0wzdD0c9aLJv5efeke97RiluBIAo9txWtma2/ceIXinQQ
         aV8NiAUvPhBRaCKpmfBbSvuerJ44GkGXV3zkN/pQ=
Date:   Wed, 24 Feb 2021 12:04:33 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     ak@linux.intel.com, akpm@linux-foundation.org,
        dave.hansen@intel.com, jpoimboe@redhat.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, louhongxiang@huawei.com,
        mm-commits@vger.kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org
Subject:  [patch 077/173] mm/memory.c: fix potential
 pte_unmap_unlock pte error
Message-ID: <20210224200433.NUH3KlBjC%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

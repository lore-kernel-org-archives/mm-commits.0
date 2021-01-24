Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A06FFC433DB
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 02:02:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D45422CF6
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 02:02:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbhAXCBz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 23 Jan 2021 21:01:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:52834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726512AbhAXCBx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 23 Jan 2021 21:01:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E909229F0;
        Sun, 24 Jan 2021 02:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611453672;
        bh=xdke8uuIdwBUnY9nSy5774jSK10KmEqE3Sblmvvt9F0=;
        h=Date:From:To:Subject:From;
        b=QXa3DPAvlatPy/KWlWzUhXtfV6DMQQctJ5GR4tPXrVjBvytiegRTEtWGvfObObTs0
         nH0gtbf5V6lgkG1bt/+GnL4/0XmLe0JdOFOfSgLQl+/4hJ27/bO0sIKKMT3f4rqKBx
         pVR5oUn87oM6nm16shYHzFRhOd1kXqOCecHHrdkQ=
Date:   Sat, 23 Jan 2021 18:01:11 -0800
From:   akpm@linux-foundation.org
To:     ak@linux.intel.com, dave.hansen@intel.com, jpoimboe@redhat.com,
        linmiaohe@huawei.com, louhongxiang@huawei.com,
        mm-commits@vger.kernel.org, tglx@linutronix.de
Subject:  + mm-fix-potential-pte_unmap_unlock-pte-error.patch added
 to -mm tree
Message-ID: <20210124020111.FlylNXrqo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: fix potential pte_unmap_unlock pte error
has been added to the -mm tree.  Its filename is
     mm-fix-potential-pte_unmap_unlock-pte-error.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-potential-pte_unmap_unlock-pte-error.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-potential-pte_unmap_unlock-pte-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2165,11 +2165,11 @@ static int remap_pte_range(struct mm_str
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
@@ -2183,7 +2183,7 @@ static int remap_pte_range(struct mm_str
 		pfn++;
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 	arch_leave_lazy_mmu_mode();
-	pte_unmap_unlock(pte - 1, ptl);
+	pte_unmap_unlock(mapped_pte, ptl);
 	return err;
 }
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_owner-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-fix-potential-pte_unmap_unlock-pte-error.patch
mm-hugetlb-fix-potential-double-free-in-hugetlb_register_node-error-path.patch
mm-hugetlb-avoid-unnecessary-hugetlb_acct_memory-call.patch
mm-hugetlb-use-helper-huge_page_order-and-pages_per_huge_page.patch
mm-workingsetc-avoid-unnecessary-max_nodes-estimation-in-count_shadow_nodes.patch
z3fold-remove-unused-attribute-for-release_z3fold_page.patch
z3fold-simplify-the-zhdr-initialization-code-in-init_z3fold_page.patch
mm-compaction-remove-duplicated-vm_bug_on_page-pagelocked.patch
hugetlbfs-remove-useless-bug_oninode-in-hugetlbfs_setattr.patch
hugetlbfs-use-helper-macro-default_hstate-in-init_hugetlbfs_fs.patch
hugetlbfs-correct-obsolete-function-name-in-hugetlbfs_read_iter.patch
hugetlbfs-remove-meaningless-variable-avoid_reserve.patch
hugetlbfs-make-hugepage-size-conversion-more-readable.patch
mm-rmap-correct-some-obsolete-comments-of-anon_vma.patch
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch


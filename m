Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 928F9C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:33:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243895AbiCYBeb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357599AbiCYBdc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 891A147AD3
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC80460909
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53813C340ED;
        Fri, 25 Mar 2022 01:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171918;
        bh=ThL3gbrachtCoURsz+AMecW4q4q0FojNEsh2xs3Wk4g=;
        h=Date:To:From:Subject:From;
        b=U1hwU7F/b3zI6rTLbfKycrWV7i7slBN9MeX6ObO8vcz3ErYLQCfpmkUoBkF5Lr+0o
         rtEZBagYsJe4FsZmmmeRgQ84MFClQfWtAeiRVpHOaGKDJkPNIebQYaeILkPTJsVIpM
         3sqvt1zqyj34kFYmU0oX3BEDxKM/jl9rnYSx/rZg=
Date:   Thu, 24 Mar 2022 18:31:57 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        willy@infradead.org, song.bao.hua@hisilicon.com, osalvador@suse.de,
        mike.kravetz@oracle.com, mhocko@suse.com, fam.zheng@bytedance.com,
        duanxiongchun@bytedance.com, david@redhat.com, corbet@lwn.net,
        chenhuang5@huawei.com, bodeddub@amazon.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-sparsemem-use-page-table-lock-to-protect-kernel-pmd-operations.patch removed from -mm tree
Message-Id: <20220325013158.53813C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: sparsemem: use page table lock to protect kernel pmd operations
has been removed from the -mm tree.  Its filename was
     mm-sparsemem-use-page-table-lock-to-protect-kernel-pmd-operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: sparsemem: use page table lock to protect kernel pmd operations

The init_mm.page_table_lock is used to protect kernel page tables, we can
use it to serialize splitting vmemmap PMD mappings instead of mmap write
lock, which can increase the concurrency of vmemmap_remap_free().

Actually, It increase the concurrency between allocations of HugeTLB
pages.  But it is not the only benefit.  There are a lot of users of mmap
read lock of init_mm.  The mmap write lock is holding through
vmemmap_remap_free(), removing mmap write lock usage to make it does not
affect other users of mmap read lock.  It is not making anything worse and
always a win to move.

Now the kernel page table walker does not hold the page_table_lock when
walking pmd entries.  There may be consistency issue of a pmd entry,
because pmd entry might change from a huge pmd entry to a PTE page table. 
There is only one user of kernel page table walker, namely ptdump.  The
ptdump already considers the consistency, which use a local variable to
cache the value of pmd entry.  But we also need to update ->action to
ACTION_CONTINUE to make sure the walker does not walk every pte entry
again when concurrent thread has split the huge pmd.

Link: https://lkml.kernel.org/r/20211101031651.75851-4-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Barry Song <song.bao.hua@hisilicon.com>
Cc: Bodeddula Balasubramaniam <bodeddub@amazon.com>
Cc: Chen Huang <chenhuang5@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ptdump.c         |   16 ++++++++++----
 mm/sparse-vmemmap.c |   47 +++++++++++++++++++++++++++---------------
 2 files changed, 43 insertions(+), 20 deletions(-)

--- a/mm/ptdump.c~mm-sparsemem-use-page-table-lock-to-protect-kernel-pmd-operations
+++ a/mm/ptdump.c
@@ -40,8 +40,10 @@ static int ptdump_pgd_entry(pgd_t *pgd,
 	if (st->effective_prot)
 		st->effective_prot(st, 0, pgd_val(val));
 
-	if (pgd_leaf(val))
+	if (pgd_leaf(val)) {
 		st->note_page(st, addr, 0, pgd_val(val));
+		walk->action = ACTION_CONTINUE;
+	}
 
 	return 0;
 }
@@ -61,8 +63,10 @@ static int ptdump_p4d_entry(p4d_t *p4d,
 	if (st->effective_prot)
 		st->effective_prot(st, 1, p4d_val(val));
 
-	if (p4d_leaf(val))
+	if (p4d_leaf(val)) {
 		st->note_page(st, addr, 1, p4d_val(val));
+		walk->action = ACTION_CONTINUE;
+	}
 
 	return 0;
 }
@@ -82,8 +86,10 @@ static int ptdump_pud_entry(pud_t *pud,
 	if (st->effective_prot)
 		st->effective_prot(st, 2, pud_val(val));
 
-	if (pud_leaf(val))
+	if (pud_leaf(val)) {
 		st->note_page(st, addr, 2, pud_val(val));
+		walk->action = ACTION_CONTINUE;
+	}
 
 	return 0;
 }
@@ -101,8 +107,10 @@ static int ptdump_pmd_entry(pmd_t *pmd,
 
 	if (st->effective_prot)
 		st->effective_prot(st, 3, pmd_val(val));
-	if (pmd_leaf(val))
+	if (pmd_leaf(val)) {
 		st->note_page(st, addr, 3, pmd_val(val));
+		walk->action = ACTION_CONTINUE;
+	}
 
 	return 0;
 }
--- a/mm/sparse-vmemmap.c~mm-sparsemem-use-page-table-lock-to-protect-kernel-pmd-operations
+++ a/mm/sparse-vmemmap.c
@@ -53,8 +53,7 @@ struct vmemmap_remap_walk {
 	struct list_head *vmemmap_pages;
 };
 
-static int split_vmemmap_huge_pmd(pmd_t *pmd, unsigned long start,
-				  struct vmemmap_remap_walk *walk)
+static int __split_vmemmap_huge_pmd(pmd_t *pmd, unsigned long start)
 {
 	pmd_t __pmd;
 	int i;
@@ -76,15 +75,34 @@ static int split_vmemmap_huge_pmd(pmd_t
 		set_pte_at(&init_mm, addr, pte, entry);
 	}
 
-	/* Make pte visible before pmd. See comment in pmd_install(). */
-	smp_wmb();
-	pmd_populate_kernel(&init_mm, pmd, pgtable);
-
-	flush_tlb_kernel_range(start, start + PMD_SIZE);
+	spin_lock(&init_mm.page_table_lock);
+	if (likely(pmd_leaf(*pmd))) {
+		/* Make pte visible before pmd. See comment in pmd_install(). */
+		smp_wmb();
+		pmd_populate_kernel(&init_mm, pmd, pgtable);
+		flush_tlb_kernel_range(start, start + PMD_SIZE);
+	} else {
+		pte_free_kernel(&init_mm, pgtable);
+	}
+	spin_unlock(&init_mm.page_table_lock);
 
 	return 0;
 }
 
+static int split_vmemmap_huge_pmd(pmd_t *pmd, unsigned long start)
+{
+	int leaf;
+
+	spin_lock(&init_mm.page_table_lock);
+	leaf = pmd_leaf(*pmd);
+	spin_unlock(&init_mm.page_table_lock);
+
+	if (!leaf)
+		return 0;
+
+	return __split_vmemmap_huge_pmd(pmd, start);
+}
+
 static void vmemmap_pte_range(pmd_t *pmd, unsigned long addr,
 			      unsigned long end,
 			      struct vmemmap_remap_walk *walk)
@@ -121,13 +139,12 @@ static int vmemmap_pmd_range(pud_t *pud,
 
 	pmd = pmd_offset(pud, addr);
 	do {
-		if (pmd_leaf(*pmd)) {
-			int ret;
+		int ret;
+
+		ret = split_vmemmap_huge_pmd(pmd, addr & PMD_MASK);
+		if (ret)
+			return ret;
 
-			ret = split_vmemmap_huge_pmd(pmd, addr & PMD_MASK, walk);
-			if (ret)
-				return ret;
-		}
 		next = pmd_addr_end(addr, end);
 		vmemmap_pte_range(pmd, addr, next, walk);
 	} while (pmd++, addr = next, addr != end);
@@ -321,10 +338,8 @@ int vmemmap_remap_free(unsigned long sta
 	 */
 	BUG_ON(start - reuse != PAGE_SIZE);
 
-	mmap_write_lock(&init_mm);
+	mmap_read_lock(&init_mm);
 	ret = vmemmap_remap_range(reuse, end, &walk);
-	mmap_write_downgrade(&init_mm);
-
 	if (ret && walk.nr_walked) {
 		end = reuse + walk.nr_walked * PAGE_SIZE;
 		/*
_

Patches currently in -mm which might be from songmuchun@bytedance.com are



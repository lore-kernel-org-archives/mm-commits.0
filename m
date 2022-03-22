Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA934C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:45:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbiCVVrD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236369AbiCVVqo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:46:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE775F8E8
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:45:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B09C6104C
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC35C340EE;
        Tue, 22 Mar 2022 21:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985506;
        bh=0kwVp1uCVNM1slEZwqSgpEq9T2hfQzOGDOCOgOTuyLo=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=RlALM8E+W1qsx2BH17YhyxMquSfH+KVsC+RJ3tMVNykvNYWWI827HAWsd1M9fAj9u
         3gr/ePy7kV+UmVmvtjJmVXaPFXFUbnpTIcw22QbMR+BjC8Ub3UZYJyr1hA8ld0jslg
         tHr8hxdqVEG8XeaUS42yMGeRM5aLpLf/vE6OYbZM=
Date:   Tue, 22 Mar 2022 14:45:06 -0700
To:     zhengqi.arch@bytedance.com, willy@infradead.org,
        song.bao.hua@hisilicon.com, osalvador@suse.de,
        mike.kravetz@oracle.com, mhocko@suse.com, fam.zheng@bytedance.com,
        duanxiongchun@bytedance.com, david@redhat.com, corbet@lwn.net,
        chenhuang5@huawei.com, bodeddub@amazon.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 130/227] mm: sparsemem: use page table lock to protect kernel pmd operations
Message-Id: <20220322214506.CDC35C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

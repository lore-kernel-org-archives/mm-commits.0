Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5FD4C04A6A
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:03:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236901AbjHKXDH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235787AbjHKXB1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:01:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06EDD3C26
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:00:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AE4466B5A
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:00:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9897C433C7;
        Fri, 11 Aug 2023 23:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794845;
        bh=q3mc6zzh9RsRF4/W+zvbDWiagQV57em04fgwFb22AJQ=;
        h=Date:To:From:Subject:From;
        b=1RaA007SQQHxFMmPKJD8E8DstKWroOW0Y2tM+bx9slwvAoqE2/05YJ7C394AN8iiI
         haD1BlIKg9vP+euKtFOfRq+okfKkyhwyaN0J/8ce5ZpJ7HIBKNdRC7zPiYXXyD9Uaj
         Wr876pDXukjLwUEvXoNu4JQcJjyQgsqVjzf3VWfc=
Date:   Fri, 11 Aug 2023 16:00:44 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com,
        zhengqi.arch@bytedance.com, zackr@vmware.com, yuzhao@google.com,
        ying.huang@intel.com, willy@infradead.org, will@kernel.org,
        vishal.moola@gmail.com, vbabka@suse.cz,
        thomas.hellstrom@linux.intel.com, surenb@google.com,
        steven.price@arm.com, song@kernel.org, sj@kernel.org,
        shy828301@gmail.com, rppt@kernel.org, rcampbell@nvidia.com,
        peterz@infradead.org, peterx@redhat.com, pasha.tatashin@soleen.com,
        naoya.horiguchi@nec.com, mpe@ellerman.id.au, minchan@kernel.org,
        mike.kravetz@oracle.com, mgorman@techsingularity.net,
        lstoakes@gmail.com, linux@armlinux.org.uk, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, jgg@ziepe.ca, jannh@google.com,
        ira.weiny@intel.com, imbrenda@linux.ibm.com, hch@infradead.org,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, david@redhat.com,
        davem@davemloft.net, christophe.leroy@csgroup.eu,
        borntraeger@linux.ibm.com, axelrasmussen@google.com,
        apopple@nvidia.com, anshuman.khandual@arm.com,
        aneesh.kumar@linux.ibm.com, agordeev@linux.ibm.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pgtable-notes-on-pte_offset_map.patch removed from -mm tree
Message-Id: <20230811230044.E9897C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/pgtable: notes on pte_offset_map[_lock]()
has been removed from the -mm tree.  Its filename was
     mm-pgtable-notes-on-pte_offset_map.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/pgtable: notes on pte_offset_map[_lock]()
Date: Tue, 11 Jul 2023 21:46:23 -0700 (PDT)

Add a block of comments on pte_offset_map_lock(), pte_offset_map() and
pte_offset_map_nolock() to mm/pgtable-generic.c, to help explain them.

Link: https://lkml.kernel.org/r/b791c3b0-25c6-a263-d785-d564344eb644@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huang, Ying <ying.huang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Steven Price <steven.price@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zack Rusin <zackr@vmware.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pgtable-generic.c |   44 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

--- a/mm/pgtable-generic.c~mm-pgtable-notes-on-pte_offset_map
+++ a/mm/pgtable-generic.c
@@ -315,6 +315,50 @@ pte_t *pte_offset_map_nolock(struct mm_s
 	return pte;
 }
 
+/*
+ * pte_offset_map_lock(mm, pmd, addr, ptlp), and its internal implementation
+ * __pte_offset_map_lock() below, is usually called with the pmd pointer for
+ * addr, reached by walking down the mm's pgd, p4d, pud for addr: either while
+ * holding mmap_lock or vma lock for read or for write; or in truncate or rmap
+ * context, while holding file's i_mmap_lock or anon_vma lock for read (or for
+ * write). In a few cases, it may be used with pmd pointing to a pmd_t already
+ * copied to or constructed on the stack.
+ *
+ * When successful, it returns the pte pointer for addr, with its page table
+ * kmapped if necessary (when CONFIG_HIGHPTE), and locked against concurrent
+ * modification by software, with a pointer to that spinlock in ptlp (in some
+ * configs mm->page_table_lock, in SPLIT_PTLOCK configs a spinlock in table's
+ * struct page).  pte_unmap_unlock(pte, ptl) to unlock and unmap afterwards.
+ *
+ * But it is unsuccessful, returning NULL with *ptlp unchanged, if there is no
+ * page table at *pmd: if, for example, the page table has just been removed,
+ * or replaced by the huge pmd of a THP.  (When successful, *pmd is rechecked
+ * after acquiring the ptlock, and retried internally if it changed: so that a
+ * page table can be safely removed or replaced by THP while holding its lock.)
+ *
+ * pte_offset_map(pmd, addr), and its internal helper __pte_offset_map() above,
+ * just returns the pte pointer for addr, its page table kmapped if necessary;
+ * or NULL if there is no page table at *pmd.  It does not attempt to lock the
+ * page table, so cannot normally be used when the page table is to be updated,
+ * or when entries read must be stable.  But it does take rcu_read_lock(): so
+ * that even when page table is racily removed, it remains a valid though empty
+ * and disconnected table.  Until pte_unmap(pte) unmaps and rcu_read_unlock()s
+ * afterwards.
+ *
+ * pte_offset_map_nolock(mm, pmd, addr, ptlp), above, is like pte_offset_map();
+ * but when successful, it also outputs a pointer to the spinlock in ptlp - as
+ * pte_offset_map_lock() does, but in this case without locking it.  This helps
+ * the caller to avoid a later pte_lockptr(mm, *pmd), which might by that time
+ * act on a changed *pmd: pte_offset_map_nolock() provides the correct spinlock
+ * pointer for the page table that it returns.  In principle, the caller should
+ * recheck *pmd once the lock is taken; in practice, no callsite needs that -
+ * either the mmap_lock for write, or pte_same() check on contents, is enough.
+ *
+ * Note that free_pgtables(), used after unmapping detached vmas, or when
+ * exiting the whole mm, does not take page table lock before freeing a page
+ * table, and may not use RCU at all: "outsiders" like khugepaged should avoid
+ * pte_offset_map() and co once the vma is detached from mm or mm_users is zero.
+ */
 pte_t *__pte_offset_map_lock(struct mm_struct *mm, pmd_t *pmd,
 			     unsigned long addr, spinlock_t **ptlp)
 {
_

Patches currently in -mm which might be from hughd@google.com are



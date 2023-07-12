Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A59E5EB64DD
	for <mm-commits@archiver.kernel.org>; Wed, 12 Jul 2023 17:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbjGLR6O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Jul 2023 13:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232334AbjGLR6L (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2023 13:58:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 843CE19BA
        for <mm-commits@vger.kernel.org>; Wed, 12 Jul 2023 10:58:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0ADAF618A8
        for <mm-commits@vger.kernel.org>; Wed, 12 Jul 2023 17:58:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5522BC433C9;
        Wed, 12 Jul 2023 17:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689184688;
        bh=RzTWp9XyvHbFCwZgT4xc4/dxjF3tqdrLU/Y4pcC66fU=;
        h=Date:To:From:Subject:From;
        b=qDSJe0XxZfwBbX44Gxcdt0uXpOtgCZf6zdMOD1so8KVj147+WGZvqTa0L57QKHPhW
         AgqRba7hId53o2EQ/gKSDfG83iDoVjU6EWoxL1tojPKiidbWriW9opY+neWiTH5ImZ
         CUYVYclfsUZyc5WXD2eWfJdqvV6se08zpyBq0uww=
Date:   Wed, 12 Jul 2023 10:58:07 -0700
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
Subject: + mm-pgtable-add-pae-safety-to-__pte_offset_map.patch added to mm-unstable branch
Message-Id: <20230712175808.5522BC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/pgtable: add PAE safety to __pte_offset_map()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pgtable-add-pae-safety-to-__pte_offset_map.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pgtable-add-pae-safety-to-__pte_offset_map.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/pgtable: add PAE safety to __pte_offset_map()
Date: Tue, 11 Jul 2023 21:32:05 -0700 (PDT)

There is a faint risk that __pte_offset_map(), on a 32-bit architecture
with a 64-bit pmd_t e.g.  x86-32 with CONFIG_X86_PAE=y, would succeed on a
pmdval assembled from a pmd_low and a pmd_high which never belonged
together: their combination not pointing to a page table at all, perhaps
not even a valid pfn.  pmdp_get_lockless() is not enough to prevent that.

Guard against that (on such configs) by local_irq_save() blocking TLB
flush between present updates, as linux/pgtable.h suggests.  It's only
needed around the pmdp_get_lockless() in __pte_offset_map(): a race when
__pte_offset_map_lock() repeats the pmdp_get_lockless() after getting the
lock, would just send it back to __pte_offset_map() again.

Complement this pmdp_get_lockless_start() and pmdp_get_lockless_end(),
used only locally in __pte_offset_map(), with a pmdp_get_lockless_sync()
synonym for tlb_remove_table_sync_one(): to send the necessary interrupt
at the right moment on those configs which do not already send it.

CONFIG_GUP_GET_PXX_LOW_HIGH is enabled when required by mips, sh and x86. 
It is not enabled by arm-32 CONFIG_ARM_LPAE: my understanding is that Will
Deacon's 2020 enhancements to READ_ONCE() are sufficient for arm.  It is
not enabled by arc, but its pmd_t is 32-bit even when pte_t 64-bit.

Limit the IRQ disablement to CONFIG_HIGHPTE?  Perhaps, but would need a
little more work, to retry if pmd_low good for page table, but pmd_high
non-zero from THP (and that might be making x86-specific assumptions).

Link: https://lkml.kernel.org/r/3adcd8f-9191-2df1-d7ea-c4877698aad@google.com
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

 include/linux/pgtable.h |    4 ++++
 mm/pgtable-generic.c    |   29 +++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

--- a/include/linux/pgtable.h~mm-pgtable-add-pae-safety-to-__pte_offset_map
+++ a/include/linux/pgtable.h
@@ -390,6 +390,7 @@ static inline pmd_t pmdp_get_lockless(pm
 	return pmd;
 }
 #define pmdp_get_lockless pmdp_get_lockless
+#define pmdp_get_lockless_sync() tlb_remove_table_sync_one()
 #endif /* CONFIG_PGTABLE_LEVELS > 2 */
 #endif /* CONFIG_GUP_GET_PXX_LOW_HIGH */
 
@@ -408,6 +409,9 @@ static inline pmd_t pmdp_get_lockless(pm
 {
 	return pmdp_get(pmdp);
 }
+static inline void pmdp_get_lockless_sync(void)
+{
+}
 #endif
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
--- a/mm/pgtable-generic.c~mm-pgtable-add-pae-safety-to-__pte_offset_map
+++ a/mm/pgtable-generic.c
@@ -232,12 +232,41 @@ pmd_t pmdp_collapse_flush(struct vm_area
 #endif
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
+#if defined(CONFIG_GUP_GET_PXX_LOW_HIGH) && \
+	(defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RCU))
+/*
+ * See the comment above ptep_get_lockless() in include/linux/pgtable.h:
+ * the barriers in pmdp_get_lockless() cannot guarantee that the value in
+ * pmd_high actually belongs with the value in pmd_low; but holding interrupts
+ * off blocks the TLB flush between present updates, which guarantees that a
+ * successful __pte_offset_map() points to a page from matched halves.
+ */
+static unsigned long pmdp_get_lockless_start(void)
+{
+	unsigned long irqflags;
+
+	local_irq_save(irqflags);
+	return irqflags;
+}
+static void pmdp_get_lockless_end(unsigned long irqflags)
+{
+	local_irq_restore(irqflags);
+}
+#else
+static unsigned long pmdp_get_lockless_start(void) { return 0; }
+static void pmdp_get_lockless_end(unsigned long irqflags) { }
+#endif
+
 pte_t *__pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
 {
+	unsigned long irqflags;
 	pmd_t pmdval;
 
 	rcu_read_lock();
+	irqflags = pmdp_get_lockless_start();
 	pmdval = pmdp_get_lockless(pmd);
+	pmdp_get_lockless_end(irqflags);
+
 	if (pmdvalp)
 		*pmdvalp = pmdval;
 	if (unlikely(pmd_none(pmdval) || is_pmd_migration_entry(pmdval)))
_

Patches currently in -mm which might be from hughd@google.com are

mm-userfaultfd-add-new-uffdio_poison-ioctl-fix.patch
mm-pgtable-add-rcu_read_lock-and-rcu_read_unlocks.patch
mm-pgtable-add-pae-safety-to-__pte_offset_map.patch
arm-adjust_pte-use-pte_offset_map_nolock.patch
powerpc-assert_pte_locked-use-pte_offset_map_nolock.patch
powerpc-add-pte_free_defer-for-pgtables-sharing-page.patch
sparc-add-pte_free_defer-for-pte_t-pgtable_t.patch
s390-add-pte_free_defer-for-pgtables-sharing-page.patch
mm-pgtable-add-pte_free_defer-for-pgtable-as-page.patch
mm-khugepaged-retract_page_tables-without-mmap-or-vma-lock.patch
mm-khugepaged-collapse_pte_mapped_thp-with-mmap_read_lock.patch
mm-khugepaged-delete-khugepaged_collapse_pte_mapped_thps.patch
mm-delete-mmap_write_trylock-and-vma_try_start_write.patch
mm-pgtable-notes-on-pte_offset_map.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8279C43460
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:33:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC471613E2
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:33:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbhEEBeN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:34:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231936AbhEEBeK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:34:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DA54613E3;
        Wed,  5 May 2021 01:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178394;
        bh=yDd1uJPXh8zhV54/KrgyCp3P3UTQnHHyvNfwjYbDKoE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vNCEvjPaSpFrFMLESlZAtGewTr39sDcHJORieaagcS8T94NN1c62KPGAxFkE6bVqR
         sYyoJCgzcRjzrBwC1w5nPRh3bKKlxd+OaYG4f8A1WzqYI2s++1lgzEwIhJ3K0oLIXW
         2hIWMk183jxTLr/A0ktnO6fEILBiSwYx5gH8sUbs=
Date:   Tue, 04 May 2021 18:33:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, adobriyan@gmail.com,
        akpm@linux-foundation.org, almasrymina@google.com,
        anshuman.khandual@arm.com, axelrasmussen@google.com,
        cannonmatthews@google.com, catalin.marinas@arm.com,
        chinwen.chang@mediatek.com, dgilbert@redhat.com, jannh@google.com,
        jglisse@redhat.com, kirill@shutemov.name, linux-mm@kvack.org,
        lokeshgidra@google.com, mike.kravetz@oracle.com, mingo@redhat.com,
        mkoutny@suse.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        npiggin@gmail.com, oupton@google.com, peterx@redhat.com,
        rientjes@google.com, rostedt@goodmis.org, rppt@linux.vnet.ibm.com,
        ruprecht@google.com, shawn@anastas.io, shli@fb.com,
        steven.price@arm.com, torvalds@linux-foundation.org,
        vbabka@suse.cz, viro@zeniv.linux.org.uk, walken@google.com,
        willy@infradead.org, ying.huang@intel.com
Subject:  [patch 009/143] hugetlb/userfaultfd: unshare all pmds for
 hugetlbfs when register wp
Message-ID: <20210505013313.EgbNEdWln%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Peter Xu <peterx@redhat.com>
Subject: hugetlb/userfaultfd: unshare all pmds for hugetlbfs when register wp

Huge pmd sharing for hugetlbfs is racy with userfaultfd-wp because
userfaultfd-wp is always based on pgtable entries, so they cannot be
shared.

Walk the hugetlb range and unshare all such mappings if there is, right
before UFFDIO_REGISTER will succeed and return to userspace.

This will pair with want_pmd_share() in hugetlb code so that huge pmd
sharing is completely disabled for userfaultfd-wp registered range.

Link: https://lkml.kernel.org/r/20210218231206.15524-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Adam Ruprecht <ruprecht@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Cannon Matthews <cannonmatthews@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Michal Koutn" <mkoutny@suse.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oliver Upton <oupton@google.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Shawn Anastasio <shawn@anastas.io>
Cc: Steven Price <steven.price@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c        |    4 ++
 include/linux/hugetlb.h |    3 ++
 mm/hugetlb.c            |   51 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+)

--- a/fs/userfaultfd.c~hugetlb-userfaultfd-unshare-all-pmds-for-hugetlbfs-when-register-wp
+++ a/fs/userfaultfd.c
@@ -15,6 +15,7 @@
 #include <linux/sched/signal.h>
 #include <linux/sched/mm.h>
 #include <linux/mm.h>
+#include <linux/mmu_notifier.h>
 #include <linux/poll.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
@@ -1449,6 +1450,9 @@ static int userfaultfd_register(struct u
 		vma->vm_flags = new_flags;
 		vma->vm_userfaultfd_ctx.ctx = ctx;
 
+		if (is_vm_hugetlb_page(vma) && uffd_disable_huge_pmd_share(vma))
+			hugetlb_unshare_all_pmds(vma);
+
 	skip:
 		prev = vma;
 		start = vma->vm_end;
--- a/include/linux/hugetlb.h~hugetlb-userfaultfd-unshare-all-pmds-for-hugetlbfs-when-register-wp
+++ a/include/linux/hugetlb.h
@@ -188,6 +188,7 @@ unsigned long hugetlb_change_protection(
 		unsigned long address, unsigned long end, pgprot_t newprot);
 
 bool is_hugetlb_entry_migration(pte_t pte);
+void hugetlb_unshare_all_pmds(struct vm_area_struct *vma);
 
 #else /* !CONFIG_HUGETLB_PAGE */
 
@@ -369,6 +370,8 @@ static inline vm_fault_t hugetlb_fault(s
 	return 0;
 }
 
+static inline void hugetlb_unshare_all_pmds(struct vm_area_struct *vma) { }
+
 #endif /* !CONFIG_HUGETLB_PAGE */
 /*
  * hugepages at page global directory. If arch support
--- a/mm/hugetlb.c~hugetlb-userfaultfd-unshare-all-pmds-for-hugetlbfs-when-register-wp
+++ a/mm/hugetlb.c
@@ -5691,6 +5691,57 @@ void move_hugetlb_state(struct page *old
 	}
 }
 
+/*
+ * This function will unconditionally remove all the shared pmd pgtable entries
+ * within the specific vma for a hugetlbfs memory range.
+ */
+void hugetlb_unshare_all_pmds(struct vm_area_struct *vma)
+{
+	struct hstate *h = hstate_vma(vma);
+	unsigned long sz = huge_page_size(h);
+	struct mm_struct *mm = vma->vm_mm;
+	struct mmu_notifier_range range;
+	unsigned long address, start, end;
+	spinlock_t *ptl;
+	pte_t *ptep;
+
+	if (!(vma->vm_flags & VM_MAYSHARE))
+		return;
+
+	start = ALIGN(vma->vm_start, PUD_SIZE);
+	end = ALIGN_DOWN(vma->vm_end, PUD_SIZE);
+
+	if (start >= end)
+		return;
+
+	/*
+	 * No need to call adjust_range_if_pmd_sharing_possible(), because
+	 * we have already done the PUD_SIZE alignment.
+	 */
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, mm,
+				start, end);
+	mmu_notifier_invalidate_range_start(&range);
+	i_mmap_lock_write(vma->vm_file->f_mapping);
+	for (address = start; address < end; address += PUD_SIZE) {
+		unsigned long tmp = address;
+
+		ptep = huge_pte_offset(mm, address, sz);
+		if (!ptep)
+			continue;
+		ptl = huge_pte_lock(h, mm, ptep);
+		/* We don't want 'address' to be changed */
+		huge_pmd_unshare(mm, vma, &tmp, ptep);
+		spin_unlock(ptl);
+	}
+	flush_hugetlb_tlb_range(vma, start, end);
+	i_mmap_unlock_write(vma->vm_file->f_mapping);
+	/*
+	 * No need to call mmu_notifier_invalidate_range(), see
+	 * Documentation/vm/mmu_notifier.rst.
+	 */
+	mmu_notifier_invalidate_range_end(&range);
+}
+
 #ifdef CONFIG_CMA
 static bool cma_reserve_called __initdata;
 
_

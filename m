Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3018DC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:21:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383678AbiEMTVZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383761AbiEMTVD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:21:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBFE61659B
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:20:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B0D462247
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8426EC34100;
        Fri, 13 May 2022 19:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469656;
        bh=VQKxxN9WdiFMSnBGZYoGmChVuuq2swWZL5aMcrv1rk0=;
        h=Date:To:From:Subject:From;
        b=JcuggzW1asWUGyeAeAFNkl+12ysAwV4N9W+DD6+BaA5A9gGxoeih7N5fvWZo+B1tX
         OXeyVD5awQ0oMep5GO+R9jJJPNB8t+faDWliJ7eWXDQRtZdA088in8b6i5ux27Yf6K
         YirNw6MvNYLANNTPlfu3KkEFtYQSpTZZNVEcWorg=
Date:   Fri, 13 May 2022 12:20:55 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, kirill@shutemov.name, jglisse@redhat.com,
        hughd@google.com, david@redhat.com, axelrasmussen@google.com,
        apopple@nvidia.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-allow-uffd-wr-protect-none-pte-for-file-backed-mem.patch removed from -mm tree
Message-Id: <20220513192056.8426EC34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/shmem: allow uffd wr-protect none pte for file-backed mem
has been removed from the -mm tree.  Its filename was
     mm-shmem-allow-uffd-wr-protect-none-pte-for-file-backed-mem.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/shmem: allow uffd wr-protect none pte for file-backed mem

File-backed memory differs from anonymous memory in that even if the pte
is missing, the data could still resides either in the file or in
page/swap cache.  So when wr-protect a pte, we need to consider none ptes
too.

We do that by installing the uffd-wp pte markers when necessary.  So when
there's a future write to the pte, the fault handler will go the special
path to first fault-in the page as read-only, then report to userfaultfd
server with the wr-protect message.

On the other hand, when unprotecting a page, it's also possible that the
pte got unmapped but replaced by the special uffd-wp marker.  Then we'll
need to be able to recover from a uffd-wp pte marker into a none pte, so
that the next access to the page will fault in correctly as usual when
accessed the next time.

Special care needs to be taken throughout the change_protection_range()
process.  Since now we allow user to wr-protect a none pte, we need to be
able to pre-populate the page table entries if we see (!anonymous &&
MM_CP_UFFD_WP) requests, otherwise change_protection_range() will always
skip when the pgtable entry does not exist.

For example, the pgtable can be missing for a whole chunk of 2M pmd, but
the page cache can exist for the 2M range.  When we want to wr-protect one
4K page within the 2M pmd range, we need to pre-populate the pgtable and
install the pte marker showing that we want to get a message and block the
thread when the page cache of that 4K page is written.  Without
pre-populating the pmd, change_protection() will simply skip that whole
pmd.

Note that this patch only covers the small pages (pte level) but not
covering any of the transparent huge pages yet.  That will be done later,
and this patch will be a preparation for it too.

Link: https://lkml.kernel.org/r/20220405014850.14352-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |   64 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 62 insertions(+), 2 deletions(-)

--- a/mm/mprotect.c~mm-shmem-allow-uffd-wr-protect-none-pte-for-file-backed-mem
+++ a/mm/mprotect.c
@@ -30,6 +30,7 @@
 #include <linux/mm_inline.h>
 #include <linux/pgtable.h>
 #include <linux/sched/sysctl.h>
+#include <linux/userfaultfd_k.h>
 #include <asm/cacheflush.h>
 #include <asm/mmu_context.h>
 #include <asm/tlbflush.h>
@@ -193,8 +194,16 @@ static unsigned long change_pte_range(st
 					newpte = pte_swp_mksoft_dirty(newpte);
 				if (pte_swp_uffd_wp(oldpte))
 					newpte = pte_swp_mkuffd_wp(newpte);
-			} else if (is_pte_marker_entry(entry)) {
-				/* Skip it, the same as none pte */
+			} else if (pte_marker_entry_uffd_wp(entry)) {
+				/*
+				 * If this is uffd-wp pte marker and we'd like
+				 * to unprotect it, drop it; the next page
+				 * fault will trigger without uffd trapping.
+				 */
+				if (uffd_wp_resolve) {
+					pte_clear(vma->vm_mm, addr, pte);
+					pages++;
+				}
 				continue;
 			} else {
 				newpte = oldpte;
@@ -209,6 +218,20 @@ static unsigned long change_pte_range(st
 				set_pte_at(vma->vm_mm, addr, pte, newpte);
 				pages++;
 			}
+		} else {
+			/* It must be an none page, or what else?.. */
+			WARN_ON_ONCE(!pte_none(oldpte));
+			if (unlikely(uffd_wp && !vma_is_anonymous(vma))) {
+				/*
+				 * For file-backed mem, we need to be able to
+				 * wr-protect a none pte, because even if the
+				 * pte is none, the page/swap cache could
+				 * exist.  Doing that by install a marker.
+				 */
+				set_pte_at(vma->vm_mm, addr, pte,
+					   make_pte_marker(PTE_MARKER_UFFD_WP));
+				pages++;
+			}
 		}
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 	arch_leave_lazy_mmu_mode();
@@ -242,6 +265,39 @@ static inline int pmd_none_or_clear_bad_
 	return 0;
 }
 
+/* Return true if we're uffd wr-protecting file-backed memory, or false */
+static inline bool
+uffd_wp_protect_file(struct vm_area_struct *vma, unsigned long cp_flags)
+{
+	return (cp_flags & MM_CP_UFFD_WP) && !vma_is_anonymous(vma);
+}
+
+/*
+ * If wr-protecting the range for file-backed, populate pgtable for the case
+ * when pgtable is empty but page cache exists.  When {pte|pmd|...}_alloc()
+ * failed it means no memory, we don't have a better option but stop.
+ */
+#define  change_pmd_prepare(vma, pmd, cp_flags)				\
+	do {								\
+		if (unlikely(uffd_wp_protect_file(vma, cp_flags))) {	\
+			if (WARN_ON_ONCE(pte_alloc(vma->vm_mm, pmd)))	\
+				break;					\
+		}							\
+	} while (0)
+/*
+ * This is the general pud/p4d/pgd version of change_pmd_prepare(). We need to
+ * have separate change_pmd_prepare() because pte_alloc() returns 0 on success,
+ * while {pmd|pud|p4d}_alloc() returns the valid pointer on success.
+ */
+#define  change_prepare(vma, high, low, addr, cp_flags)			\
+	do {								\
+		if (unlikely(uffd_wp_protect_file(vma, cp_flags))) {	\
+			low##_t *p = low##_alloc(vma->vm_mm, high, addr); \
+			if (WARN_ON_ONCE(p == NULL))			\
+				break;					\
+		}							\
+	} while (0)
+
 static inline unsigned long change_pmd_range(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, pud_t *pud, unsigned long addr,
 		unsigned long end, pgprot_t newprot, unsigned long cp_flags)
@@ -260,6 +316,7 @@ static inline unsigned long change_pmd_r
 
 		next = pmd_addr_end(addr, end);
 
+		change_pmd_prepare(vma, pmd, cp_flags);
 		/*
 		 * Automatic NUMA balancing walks the tables with mmap_lock
 		 * held for read. It's possible a parallel update to occur
@@ -329,6 +386,7 @@ static inline unsigned long change_pud_r
 	pud = pud_offset(p4d, addr);
 	do {
 		next = pud_addr_end(addr, end);
+		change_prepare(vma, pud, pmd, addr, cp_flags);
 		if (pud_none_or_clear_bad(pud))
 			continue;
 		pages += change_pmd_range(tlb, vma, pud, addr, next, newprot,
@@ -349,6 +407,7 @@ static inline unsigned long change_p4d_r
 	p4d = p4d_offset(pgd, addr);
 	do {
 		next = p4d_addr_end(addr, end);
+		change_prepare(vma, p4d, pud, addr, cp_flags);
 		if (p4d_none_or_clear_bad(p4d))
 			continue;
 		pages += change_pud_range(tlb, vma, p4d, addr, next, newprot,
@@ -372,6 +431,7 @@ static unsigned long change_protection_r
 	tlb_start_vma(tlb, vma);
 	do {
 		next = pgd_addr_end(addr, end);
+		change_prepare(vma, pgd, p4d, addr, cp_flags);
 		if (pgd_none_or_clear_bad(pgd))
 			continue;
 		pages += change_p4d_range(tlb, vma, pgd, addr, next, newprot,
_

Patches currently in -mm which might be from peterx@redhat.com are



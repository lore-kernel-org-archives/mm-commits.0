Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC76AC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:21:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383456AbiEMTVy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383722AbiEMTVC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:21:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1BC11A2B
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:20:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BE3962252
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:20:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D13DC34116;
        Fri, 13 May 2022 19:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469655;
        bh=0rCuMRRmk3rEnfm+A2oo3hM6GJpJpWfgRqULB/edr9E=;
        h=Date:To:From:Subject:From;
        b=PqGnFUA2BUAWg4ZhgrCtLExeztmEfCTOwk80pUI4u5forDs1L9GXuzUwEuNg8Rz4g
         seX24wj9qUWe+PhXD0r/xqElTFMYmqzpUMvc8AOBG6ewbDKT8SqsRJaF8GgVamZL2t
         Mz3qpJnG4SFEdBjJTIV+QjueOptpRYNyhctejea8=
Date:   Fri, 13 May 2022 12:20:54 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, kirill@shutemov.name, jglisse@redhat.com,
        hughd@google.com, david@redhat.com, axelrasmussen@google.com,
        apopple@nvidia.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-persist-uffd-wp-bit-across-zapping-for-file-backed.patch removed from -mm tree
Message-Id: <20220513192055.5D13DC34116@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/shmem: persist uffd-wp bit across zapping for file-backed
has been removed from the -mm tree.  Its filename was
     mm-shmem-persist-uffd-wp-bit-across-zapping-for-file-backed.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/shmem: persist uffd-wp bit across zapping for file-backed

File-backed memory is prone to being unmapped at any time.  It means all
information in the pte will be dropped, including the uffd-wp flag.

To persist the uffd-wp flag, we'll use the pte markers.  This patch
teaches the zap code to understand uffd-wp and know when to keep or drop
the uffd-wp bit.

Add a new flag ZAP_FLAG_DROP_MARKER and set it in zap_details when we
don't want to persist such an information, for example, when destroying
the whole vma, or punching a hole in a shmem file.  For the rest cases we
should never drop the uffd-wp bit, or the wr-protect information will get
lost.

The new ZAP_FLAG_DROP_MARKER needs to be put into mm.h rather than
memory.c because it'll be further referenced in hugetlb files later.

Link: https://lkml.kernel.org/r/20220405014847.14295-1-peterx@redhat.com
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

 include/linux/mm.h        |   10 +++++++
 include/linux/mm_inline.h |   43 +++++++++++++++++++++++++++++++
 mm/memory.c               |   49 +++++++++++++++++++++++++++++++++---
 mm/rmap.c                 |    8 +++++
 4 files changed, 107 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h~mm-shmem-persist-uffd-wp-bit-across-zapping-for-file-backed
+++ a/include/linux/mm.h
@@ -3428,4 +3428,14 @@ madvise_set_anon_name(struct mm_struct *
 }
 #endif
 
+typedef unsigned int __bitwise zap_flags_t;
+
+/*
+ * Whether to drop the pte markers, for example, the uffd-wp information for
+ * file-backed memory.  This should only be specified when we will completely
+ * drop the page in the mm, either by truncation or unmapping of the vma.  By
+ * default, the flag is not set.
+ */
+#define  ZAP_FLAG_DROP_MARKER        ((__force zap_flags_t) BIT(0))
+
 #endif /* _LINUX_MM_H */
--- a/include/linux/mm_inline.h~mm-shmem-persist-uffd-wp-bit-across-zapping-for-file-backed
+++ a/include/linux/mm_inline.h
@@ -6,6 +6,8 @@
 #include <linux/huge_mm.h>
 #include <linux/swap.h>
 #include <linux/string.h>
+#include <linux/userfaultfd_k.h>
+#include <linux/swapops.h>
 
 /**
  * folio_is_file_lru - Should the folio be on a file LRU or anon LRU?
@@ -316,5 +318,46 @@ static inline bool mm_tlb_flush_nested(s
 	return atomic_read(&mm->tlb_flush_pending) > 1;
 }
 
+/*
+ * If this pte is wr-protected by uffd-wp in any form, arm the special pte to
+ * replace a none pte.  NOTE!  This should only be called when *pte is already
+ * cleared so we will never accidentally replace something valuable.  Meanwhile
+ * none pte also means we are not demoting the pte so tlb flushed is not needed.
+ * E.g., when pte cleared the caller should have taken care of the tlb flush.
+ *
+ * Must be called with pgtable lock held so that no thread will see the none
+ * pte, and if they see it, they'll fault and serialize at the pgtable lock.
+ *
+ * This function is a no-op if PTE_MARKER_UFFD_WP is not enabled.
+ */
+static inline void
+pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
+			      pte_t *pte, pte_t pteval)
+{
+#ifdef CONFIG_PTE_MARKER_UFFD_WP
+	bool arm_uffd_pte = false;
+
+	/* The current status of the pte should be "cleared" before calling */
+	WARN_ON_ONCE(!pte_none(*pte));
+
+	if (vma_is_anonymous(vma) || !userfaultfd_wp(vma))
+		return;
+
+	/* A uffd-wp wr-protected normal pte */
+	if (unlikely(pte_present(pteval) && pte_uffd_wp(pteval)))
+		arm_uffd_pte = true;
+
+	/*
+	 * A uffd-wp wr-protected swap pte.  Note: this should even cover an
+	 * existing pte marker with uffd-wp bit set.
+	 */
+	if (unlikely(pte_swp_uffd_wp_any(pteval)))
+		arm_uffd_pte = true;
+
+	if (unlikely(arm_uffd_pte))
+		set_pte_at(vma->vm_mm, addr, pte,
+			   make_pte_marker(PTE_MARKER_UFFD_WP));
+#endif
+}
 
 #endif
--- a/mm/memory.c~mm-shmem-persist-uffd-wp-bit-across-zapping-for-file-backed
+++ a/mm/memory.c
@@ -74,6 +74,7 @@
 #include <linux/perf_event.h>
 #include <linux/ptrace.h>
 #include <linux/vmalloc.h>
+#include <linux/mm_inline.h>
 
 #include <trace/events/kmem.h>
 
@@ -1306,6 +1307,7 @@ copy_page_range(struct vm_area_struct *d
 struct zap_details {
 	struct folio *single_folio;	/* Locked folio to be unmapped */
 	bool even_cows;			/* Zap COWed private pages too? */
+	zap_flags_t zap_flags;		/* Extra flags for zapping */
 };
 
 /* Whether we should zap all COWed (private) pages too */
@@ -1334,6 +1336,29 @@ static inline bool should_zap_page(struc
 	return !PageAnon(page);
 }
 
+static inline bool zap_drop_file_uffd_wp(struct zap_details *details)
+{
+	if (!details)
+		return false;
+
+	return details->zap_flags & ZAP_FLAG_DROP_MARKER;
+}
+
+/*
+ * This function makes sure that we'll replace the none pte with an uffd-wp
+ * swap special pte marker when necessary. Must be with the pgtable lock held.
+ */
+static inline void
+zap_install_uffd_wp_if_needed(struct vm_area_struct *vma,
+			      unsigned long addr, pte_t *pte,
+			      struct zap_details *details, pte_t pteval)
+{
+	if (zap_drop_file_uffd_wp(details))
+		return;
+
+	pte_install_uffd_wp_if_needed(vma, addr, pte, pteval);
+}
+
 static unsigned long zap_pte_range(struct mmu_gather *tlb,
 				struct vm_area_struct *vma, pmd_t *pmd,
 				unsigned long addr, unsigned long end,
@@ -1371,6 +1396,8 @@ again:
 			ptent = ptep_get_and_clear_full(mm, addr, pte,
 							tlb->fullmm);
 			tlb_remove_tlb_entry(tlb, pte, addr);
+			zap_install_uffd_wp_if_needed(vma, addr, pte, details,
+						      ptent);
 			if (unlikely(!page))
 				continue;
 
@@ -1401,6 +1428,13 @@ again:
 			page = pfn_swap_entry_to_page(entry);
 			if (unlikely(!should_zap_page(details, page)))
 				continue;
+			/*
+			 * Both device private/exclusive mappings should only
+			 * work with anonymous page so far, so we don't need to
+			 * consider uffd-wp bit when zap. For more information,
+			 * see zap_install_uffd_wp_if_needed().
+			 */
+			WARN_ON_ONCE(!vma_is_anonymous(vma));
 			rss[mm_counter(page)]--;
 			if (is_device_private_entry(entry))
 				page_remove_rmap(page, vma, false);
@@ -1417,8 +1451,10 @@ again:
 			if (!should_zap_page(details, page))
 				continue;
 			rss[mm_counter(page)]--;
-		} else if (is_pte_marker_entry(entry)) {
-			/* By default, simply drop all pte markers when zap */
+		} else if (pte_marker_entry_uffd_wp(entry)) {
+			/* Only drop the uffd-wp marker if explicitly requested */
+			if (!zap_drop_file_uffd_wp(details))
+				continue;
 		} else if (is_hwpoison_entry(entry)) {
 			if (!should_zap_cows(details))
 				continue;
@@ -1427,6 +1463,7 @@ again:
 			WARN_ON_ONCE(1);
 		}
 		pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
+		zap_install_uffd_wp_if_needed(vma, addr, pte, details, ptent);
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 
 	add_mm_rss_vec(mm, rss);
@@ -1637,12 +1674,17 @@ void unmap_vmas(struct mmu_gather *tlb,
 		unsigned long end_addr)
 {
 	struct mmu_notifier_range range;
+	struct zap_details details = {
+		.zap_flags = ZAP_FLAG_DROP_MARKER,
+		/* Careful - we need to zap private pages too! */
+		.even_cows = true,
+	};
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, vma->vm_mm,
 				start_addr, end_addr);
 	mmu_notifier_invalidate_range_start(&range);
 	for ( ; vma && vma->vm_start < end_addr; vma = vma->vm_next)
-		unmap_single_vma(tlb, vma, start_addr, end_addr, NULL);
+		unmap_single_vma(tlb, vma, start_addr, end_addr, &details);
 	mmu_notifier_invalidate_range_end(&range);
 }
 
@@ -3438,6 +3480,7 @@ void unmap_mapping_folio(struct folio *f
 
 	details.even_cows = false;
 	details.single_folio = folio;
+	details.zap_flags = ZAP_FLAG_DROP_MARKER;
 
 	i_mmap_lock_read(mapping);
 	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root)))
--- a/mm/rmap.c~mm-shmem-persist-uffd-wp-bit-across-zapping-for-file-backed
+++ a/mm/rmap.c
@@ -73,6 +73,7 @@
 #include <linux/page_idle.h>
 #include <linux/memremap.h>
 #include <linux/userfaultfd_k.h>
+#include <linux/mm_inline.h>
 
 #include <asm/tlbflush.h>
 
@@ -1585,6 +1586,13 @@ static bool try_to_unmap_one(struct foli
 			pteval = ptep_clear_flush(vma, address, pvmw.pte);
 		}
 
+		/*
+		 * Now the pte is cleared. If this pte was uffd-wp armed,
+		 * we may want to replace a none pte with a marker pte if
+		 * it's file-backed, so we don't lose the tracking info.
+		 */
+		pte_install_uffd_wp_if_needed(vma, address, pvmw.pte, pteval);
+
 		/* Set the dirty flag on the folio now the pte is gone. */
 		if (pte_dirty(pteval))
 			folio_mark_dirty(folio);
_

Patches currently in -mm which might be from peterx@redhat.com are



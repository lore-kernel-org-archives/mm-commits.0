Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C8ADCDB48A
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 15:46:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbjJRPqE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 11:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235351AbjJRPhd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 11:37:33 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C354418B
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 08:37:30 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633EBC433C8;
        Wed, 18 Oct 2023 15:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697643450;
        bh=unTtd2ETFies2/vdHVFwJ+JvR77eVtPBZnKufnxTcPo=;
        h=Date:To:From:Subject:From;
        b=xmyTnkFehFSQ2UTVjp3mBR9R4KeNG/qaYBQVWDJgtGKmxzo/Po8irK+FDTw0fpIdm
         90W5crZET/GNpv07owTiVbLWrjUjoPTSdMf9FcytVbpz4K7MXfnYWX+/FZ2/kFAoCb
         p7IAbBbhk8UOmT+YpKNaNKaK5tJb+is5O9fmQHp0=
Date:   Wed, 18 Oct 2023 08:37:29 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, vincent.guittot@linaro.org,
        peterz@infradead.org, mingo@redhat.com, juri.lelli@redhat.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-wp_page_reuse-and-finish_mkwrite_fault-to-take-a-folio.patch added to mm-unstable branch
Message-Id: <20231018153730.633EBC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert wp_page_reuse() and finish_mkwrite_fault() to take a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-wp_page_reuse-and-finish_mkwrite_fault-to-take-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-wp_page_reuse-and-finish_mkwrite_fault-to-take-a-folio.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: convert wp_page_reuse() and finish_mkwrite_fault() to take a folio
Date: Wed, 18 Oct 2023 22:08:04 +0800

Saves one compound_head() call, also in preparation for
page_cpupid_xchg_last() conversion.

Link: https://lkml.kernel.org/r/20231018140806.2783514-18-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/mm/memory.c~mm-convert-wp_page_reuse-and-finish_mkwrite_fault-to-take-a-folio
+++ a/mm/memory.c
@@ -3018,7 +3018,7 @@ static vm_fault_t fault_dirty_shared_pag
  * case, all we need to do here is to mark the page as writable and update
  * any related book-keeping.
  */
-static inline void wp_page_reuse(struct vm_fault *vmf)
+static inline void wp_page_reuse(struct vm_fault *vmf, struct folio *folio)
 	__releases(vmf->ptl)
 {
 	struct vm_area_struct *vma = vmf->vma;
@@ -3026,7 +3026,7 @@ static inline void wp_page_reuse(struct
 	pte_t entry;
 
 	VM_BUG_ON(!(vmf->flags & FAULT_FLAG_WRITE));
-	VM_BUG_ON(page && PageAnon(page) && !PageAnonExclusive(page));
+	VM_BUG_ON(folio && folio_test_anon(folio) && !PageAnonExclusive(page));
 
 	/*
 	 * Clear the pages cpupid information as the existing
@@ -3261,6 +3261,7 @@ out:
  *			  writeable once the page is prepared
  *
  * @vmf: structure describing the fault
+ * @folio: the folio of vmf->page
  *
  * This function handles all that is needed to finish a write page fault in a
  * shared mapping due to PTE being read-only once the mapped page is prepared.
@@ -3272,7 +3273,7 @@ out:
  * Return: %0 on success, %VM_FAULT_NOPAGE when PTE got changed before
  * we acquired PTE lock.
  */
-static vm_fault_t finish_mkwrite_fault(struct vm_fault *vmf)
+static vm_fault_t finish_mkwrite_fault(struct vm_fault *vmf, struct folio *folio)
 {
 	WARN_ON_ONCE(!(vmf->vma->vm_flags & VM_SHARED));
 	vmf->pte = pte_offset_map_lock(vmf->vma->vm_mm, vmf->pmd, vmf->address,
@@ -3288,7 +3289,7 @@ static vm_fault_t finish_mkwrite_fault(s
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 		return VM_FAULT_NOPAGE;
 	}
-	wp_page_reuse(vmf);
+	wp_page_reuse(vmf, folio);
 	return 0;
 }
 
@@ -3312,9 +3313,9 @@ static vm_fault_t wp_pfn_shared(struct v
 		ret = vma->vm_ops->pfn_mkwrite(vmf);
 		if (ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE))
 			return ret;
-		return finish_mkwrite_fault(vmf);
+		return finish_mkwrite_fault(vmf, NULL);
 	}
-	wp_page_reuse(vmf);
+	wp_page_reuse(vmf, NULL);
 	return 0;
 }
 
@@ -3342,14 +3343,14 @@ static vm_fault_t wp_page_shared(struct
 			folio_put(folio);
 			return tmp;
 		}
-		tmp = finish_mkwrite_fault(vmf);
+		tmp = finish_mkwrite_fault(vmf, folio);
 		if (unlikely(tmp & (VM_FAULT_ERROR | VM_FAULT_NOPAGE))) {
 			folio_unlock(folio);
 			folio_put(folio);
 			return tmp;
 		}
 	} else {
-		wp_page_reuse(vmf);
+		wp_page_reuse(vmf, folio);
 		folio_lock(folio);
 	}
 	ret |= fault_dirty_shared_page(vmf);
@@ -3494,7 +3495,7 @@ static vm_fault_t do_wp_page(struct vm_f
 			pte_unmap_unlock(vmf->pte, vmf->ptl);
 			return 0;
 		}
-		wp_page_reuse(vmf);
+		wp_page_reuse(vmf, folio);
 		return 0;
 	}
 	/*
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm_types-add-virtual-and-_last_cpupid-into-struct-folio.patch
mm-add-folio_last_cpupid.patch
mm-memory-use-folio_last_cpupid-in-do_numa_page.patch
mm-huge_memory-use-folio_last_cpupid-in-do_huge_pmd_numa_page.patch
mm-huge_memory-use-folio_last_cpupid-in-__split_huge_page_tail.patch
mm-remove-page_cpupid_last.patch
mm-add-folio_xchg_access_time.patch
sched-fair-use-folio_xchg_access_time-in-numa_hint_fault_latency.patch
mm-mprotect-use-a-folio-in-change_pte_range.patch
mm-huge_memory-use-a-folio-in-change_huge_pmd.patch
mm-remove-xchg_page_access_time.patch
mm-add-folio_xchg_last_cpupid.patch
sched-fair-use-folio_xchg_last_cpupid-in-should_numa_migrate_memory.patch
mm-migrate-use-folio_xchg_last_cpupid-in-folio_migrate_flags.patch
mm-huge_memory-use-folio_xchg_last_cpupid-in-__split_huge_page_tail.patch
mm-make-finish_mkwrite_fault-static.patch
mm-convert-wp_page_reuse-and-finish_mkwrite_fault-to-take-a-folio.patch
mm-use-folio_xchg_last_cpupid-in-wp_page_reuse.patch
mm-remove-page_cpupid_xchg_last.patch


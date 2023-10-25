Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FB96C27C46
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbjJYXth (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbjJYXsu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:50 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BAF93
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4B0C433CD;
        Wed, 25 Oct 2023 23:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277728;
        bh=3FloTzTsOW+J+ds4XT0NRCLO/MdJpvo3goeP4PTI+8o=;
        h=Date:To:From:Subject:From;
        b=oUW9ByzUFPzr22dRliWSVjP7uB72phKTMo7n7OWu3Gq2WT5QDFP9RSHbzB6Wc60Zp
         1w32DahrzUoQwldq606bXFqgQp4a8tssy5nCtWuSfK2F+fBQ04xOskNOfVx0Jc2Eau
         Z+Nf7RcPEsfZ67QIsygdovC/d2XhApMmkuiC05Yk=
Date:   Wed, 25 Oct 2023 16:48:47 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, vincent.guittot@linaro.org,
        peterz@infradead.org, mingo@redhat.com, juri.lelli@redhat.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-wp_page_reuse-and-finish_mkwrite_fault-to-take-a-folio.patch removed from -mm tree
Message-Id: <20231025234848.3F4B0C433CD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: convert wp_page_reuse() and finish_mkwrite_fault() to take a folio
has been removed from the -mm tree.  Its filename was
     mm-convert-wp_page_reuse-and-finish_mkwrite_fault-to-take-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3015,7 +3015,7 @@ static vm_fault_t fault_dirty_shared_pag
  * case, all we need to do here is to mark the page as writable and update
  * any related book-keeping.
  */
-static inline void wp_page_reuse(struct vm_fault *vmf)
+static inline void wp_page_reuse(struct vm_fault *vmf, struct folio *folio)
 	__releases(vmf->ptl)
 {
 	struct vm_area_struct *vma = vmf->vma;
@@ -3023,7 +3023,7 @@ static inline void wp_page_reuse(struct
 	pte_t entry;
 
 	VM_BUG_ON(!(vmf->flags & FAULT_FLAG_WRITE));
-	VM_BUG_ON(page && PageAnon(page) && !PageAnonExclusive(page));
+	VM_BUG_ON(folio && folio_test_anon(folio) && !PageAnonExclusive(page));
 
 	/*
 	 * Clear the pages cpupid information as the existing
@@ -3258,6 +3258,7 @@ out:
  *			  writeable once the page is prepared
  *
  * @vmf: structure describing the fault
+ * @folio: the folio of vmf->page
  *
  * This function handles all that is needed to finish a write page fault in a
  * shared mapping due to PTE being read-only once the mapped page is prepared.
@@ -3269,7 +3270,7 @@ out:
  * Return: %0 on success, %VM_FAULT_NOPAGE when PTE got changed before
  * we acquired PTE lock.
  */
-static vm_fault_t finish_mkwrite_fault(struct vm_fault *vmf)
+static vm_fault_t finish_mkwrite_fault(struct vm_fault *vmf, struct folio *folio)
 {
 	WARN_ON_ONCE(!(vmf->vma->vm_flags & VM_SHARED));
 	vmf->pte = pte_offset_map_lock(vmf->vma->vm_mm, vmf->pmd, vmf->address,
@@ -3285,7 +3286,7 @@ static vm_fault_t finish_mkwrite_fault(s
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 		return VM_FAULT_NOPAGE;
 	}
-	wp_page_reuse(vmf);
+	wp_page_reuse(vmf, folio);
 	return 0;
 }
 
@@ -3309,9 +3310,9 @@ static vm_fault_t wp_pfn_shared(struct v
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
 
@@ -3339,14 +3340,14 @@ static vm_fault_t wp_page_shared(struct
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
@@ -3491,7 +3492,7 @@ static vm_fault_t do_wp_page(struct vm_f
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



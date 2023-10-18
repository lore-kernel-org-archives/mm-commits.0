Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87B18CDB485
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 15:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbjJRPqF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 11:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232415AbjJRPhe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 11:37:34 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A754D116
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 08:37:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 427B4C433C8;
        Wed, 18 Oct 2023 15:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697643452;
        bh=Ix5t3j8xZMy0le7aEynerwcTWlCzb/Z6m6Li+PG0sjE=;
        h=Date:To:From:Subject:From;
        b=h0rkntxfHmX2OYia8PYuiZRM9ydL74GZu14JvFMi4C6Ww1pnfLD59qdc1m7Ip23xM
         E/i+C4hFh+MZpJ0vE+jD8/rE224qdw1mMUG0+gO+lPPBwydLxN+kBPvHSfii5wndbI
         YN9RyOjdCjKlgfgHMU9bwSvuCE/QfGbT7k78dc7Q=
Date:   Wed, 18 Oct 2023 08:37:31 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, vincent.guittot@linaro.org,
        peterz@infradead.org, mingo@redhat.com, juri.lelli@redhat.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-folio_xchg_last_cpupid-in-wp_page_reuse.patch added to mm-unstable branch
Message-Id: <20231018153732.427B4C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use folio_xchg_last_cpupid() in wp_page_reuse()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-folio_xchg_last_cpupid-in-wp_page_reuse.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-folio_xchg_last_cpupid-in-wp_page_reuse.patch

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
Subject: mm: use folio_xchg_last_cpupid() in wp_page_reuse()
Date: Wed, 18 Oct 2023 22:08:05 +0800

Convert to use folio_xchg_last_cpupid() in wp_page_reuse(), and remove
page variable. Since now only normal and PMD-mapped page is handled by
numa balancing, it's enough to only update the entire folio's last cpupid.

Link: https://lkml.kernel.org/r/20231018140806.2783514-19-wangkefeng.wang@huawei.com
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

--- a/mm/memory.c~mm-use-folio_xchg_last_cpupid-in-wp_page_reuse
+++ a/mm/memory.c
@@ -3022,19 +3022,20 @@ static inline void wp_page_reuse(struct
 	__releases(vmf->ptl)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	struct page *page = vmf->page;
 	pte_t entry;
 
 	VM_BUG_ON(!(vmf->flags & FAULT_FLAG_WRITE));
-	VM_BUG_ON(folio && folio_test_anon(folio) && !PageAnonExclusive(page));
 
-	/*
-	 * Clear the pages cpupid information as the existing
-	 * information potentially belongs to a now completely
-	 * unrelated process.
-	 */
-	if (page)
-		page_cpupid_xchg_last(page, (1 << LAST_CPUPID_SHIFT) - 1);
+	if (folio) {
+		VM_BUG_ON(folio_test_anon(folio) &&
+			  !PageAnonExclusive(vmf->page));
+		/*
+		 * Clear the folio's cpupid information as the existing
+		 * information potentially belongs to a now completely
+		 * unrelated process.
+		 */
+		folio_xchg_last_cpupid(folio, (1 << LAST_CPUPID_SHIFT) - 1);
+	}
 
 	flush_cache_page(vma, vmf->address, pte_pfn(vmf->orig_pte));
 	entry = pte_mkyoung(vmf->orig_pte);
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


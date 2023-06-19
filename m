Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0CABEB64DB
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:23:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjFSXXD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjFSXVv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:21:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA971702
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:21:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1C1C60FB9
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:21:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1F4C433C8;
        Mon, 19 Jun 2023 23:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216894;
        bh=+9pz3QmcK8YXf8LcminaVnnoKihDn8RGRs9mD09kOKA=;
        h=Date:To:From:Subject:From;
        b=knfTME8DdH8rTIjiOCAnG/4dfU7bAvtNbpx4pBLYapb0gYZCPzEQiVAYOXtFtQBWR
         ZZHhsrUP+gf2mP0Qg+lPQHLx73YDoQHHxhDwhqdvuq8Zw7SbchwrafSaTXM8afDbpv
         W5/th0oe2oMN3bJgQZBUqRFesrtMmj3G3V9tPYYc=
Date:   Mon, 19 Jun 2023 16:21:33 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        zackr@vmware.com, yuzhao@google.com, ying.huang@intel.com,
        willy@infradead.org, will@kernel.org,
        thomas.hellstrom@linux.intel.com, surenb@google.com,
        steven.price@arm.com, song@kernel.org, sj@kernel.org,
        shy828301@gmail.com, ryan.roberts@arm.com, rppt@kernel.org,
        rcampbell@nvidia.com, peterz@infradead.org, peterx@redhat.com,
        pasha.tatashin@soleen.com, naoya.horiguchi@nec.com,
        minchan@kernel.org, mike.kravetz@oracle.com,
        mgorman@techsingularity.net, lstoakes@gmail.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jgg@ziepe.ca, ira.weiny@intel.com, hch@infradead.org,
        david@redhat.com, christophe.leroy@csgroup.eu,
        axelrasmussen@google.com, apopple@nvidia.com,
        anshuman.khandual@arm.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_vma_mapped-reformat-map_pte-with-less-indentation.patch removed from -mm tree
Message-Id: <20230619232134.0F1F4C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_vma_mapped: reformat map_pte() with less indentation
has been removed from the -mm tree.  Its filename was
     mm-page_vma_mapped-reformat-map_pte-with-less-indentation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/page_vma_mapped: reformat map_pte() with less indentation
Date: Thu, 8 Jun 2023 18:14:12 -0700 (PDT)

No functional change here, but adjust the format of map_pte() so that the
following commit will be easier to read: separate out the PVMW_SYNC case
first, and remove two levels of indentation from the ZONE_DEVICE case.

Link: https://lkml.kernel.org/r/bf723f59-e3fc-6839-1cc3-c0631ee248bc@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Steven Price <steven.price@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zack Rusin <zackr@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |   65 +++++++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 31 deletions(-)

--- a/mm/page_vma_mapped.c~mm-page_vma_mapped-reformat-map_pte-with-less-indentation
+++ a/mm/page_vma_mapped.c
@@ -15,38 +15,41 @@ static inline bool not_found(struct page
 
 static bool map_pte(struct page_vma_mapped_walk *pvmw)
 {
-	pvmw->pte = pte_offset_map(pvmw->pmd, pvmw->address);
-	if (!(pvmw->flags & PVMW_SYNC)) {
-		if (pvmw->flags & PVMW_MIGRATION) {
-			if (!is_swap_pte(*pvmw->pte))
-				return false;
-		} else {
-			/*
-			 * We get here when we are trying to unmap a private
-			 * device page from the process address space. Such
-			 * page is not CPU accessible and thus is mapped as
-			 * a special swap entry, nonetheless it still does
-			 * count as a valid regular mapping for the page (and
-			 * is accounted as such in page maps count).
-			 *
-			 * So handle this special case as if it was a normal
-			 * page mapping ie lock CPU page table and returns
-			 * true.
-			 *
-			 * For more details on device private memory see HMM
-			 * (include/linux/hmm.h or mm/hmm.c).
-			 */
-			if (is_swap_pte(*pvmw->pte)) {
-				swp_entry_t entry;
+	if (pvmw->flags & PVMW_SYNC) {
+		/* Use the stricter lookup */
+		pvmw->pte = pte_offset_map_lock(pvmw->vma->vm_mm, pvmw->pmd,
+						pvmw->address, &pvmw->ptl);
+		return true;
+	}
 
-				/* Handle un-addressable ZONE_DEVICE memory */
-				entry = pte_to_swp_entry(*pvmw->pte);
-				if (!is_device_private_entry(entry) &&
-				    !is_device_exclusive_entry(entry))
-					return false;
-			} else if (!pte_present(*pvmw->pte))
-				return false;
-		}
+	pvmw->pte = pte_offset_map(pvmw->pmd, pvmw->address);
+	if (pvmw->flags & PVMW_MIGRATION) {
+		if (!is_swap_pte(*pvmw->pte))
+			return false;
+	} else if (is_swap_pte(*pvmw->pte)) {
+		swp_entry_t entry;
+		/*
+		 * Handle un-addressable ZONE_DEVICE memory.
+		 *
+		 * We get here when we are trying to unmap a private
+		 * device page from the process address space. Such
+		 * page is not CPU accessible and thus is mapped as
+		 * a special swap entry, nonetheless it still does
+		 * count as a valid regular mapping for the page
+		 * (and is accounted as such in page maps count).
+		 *
+		 * So handle this special case as if it was a normal
+		 * page mapping ie lock CPU page table and return true.
+		 *
+		 * For more details on device private memory see HMM
+		 * (include/linux/hmm.h or mm/hmm.c).
+		 */
+		entry = pte_to_swp_entry(*pvmw->pte);
+		if (!is_device_private_entry(entry) &&
+		    !is_device_exclusive_entry(entry))
+			return false;
+	} else if (!pte_present(*pvmw->pte)) {
+		return false;
 	}
 	pvmw->ptl = pte_lockptr(pvmw->vma->vm_mm, pvmw->pmd);
 	spin_lock(pvmw->ptl);
_

Patches currently in -mm which might be from hughd@google.com are



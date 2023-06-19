Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7376EB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:23:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjFSXXK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbjFSXVw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:21:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E563FA
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:21:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB9AB60F79
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:21:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2724CC433C0;
        Mon, 19 Jun 2023 23:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216905;
        bh=SPkr9Pq0+M9bkZ6bqRJSmFF+Kz7smjGItldZG7xBRo8=;
        h=Date:To:From:Subject:From;
        b=xtaYYhCTBKzOu284Rb7yyDRz8OfxHnBfzUiu6LI3uzProgbBujpiDvWTnmK0r5ygo
         m99jKGfxNMJRGe1LG1azA/A8MjVH9+xBlXlnkjV+9cFHyDtXhKpc4/OiQiCdMseuFt
         4e7uBgycOsaQXQ8ZlboFHYPHU1W8urlF2TB0amYI=
Date:   Mon, 19 Jun 2023 16:21:44 -0700
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
Subject: [merged mm-stable] mm-userfaultfd-allow-pte_offset_map_lock-to-fail.patch removed from -mm tree
Message-Id: <20230619232145.2724CC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/userfaultfd: allow pte_offset_map_lock() to fail
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-allow-pte_offset_map_lock-to-fail.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/userfaultfd: allow pte_offset_map_lock() to fail
Date: Thu, 8 Jun 2023 18:26:04 -0700 (PDT)

mfill_atomic_install_pte() and mfill_atomic_pte_zeropage() treat failed
pte_offset_map_lock() as -EAGAIN, which mfill_atomic() already returns to
user for a similar race.

Link: https://lkml.kernel.org/r/50cf3930-1bfa-4de9-a079-3da47b7ce17b@google.com
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

 mm/userfaultfd.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/userfaultfd.c~mm-userfaultfd-allow-pte_offset_map_lock-to-fail
+++ a/mm/userfaultfd.c
@@ -76,7 +76,10 @@ int mfill_atomic_install_pte(pmd_t *dst_
 	if (flags & MFILL_ATOMIC_WP)
 		_dst_pte = pte_mkuffd_wp(_dst_pte);
 
+	ret = -EAGAIN;
 	dst_pte = pte_offset_map_lock(dst_mm, dst_pmd, dst_addr, &ptl);
+	if (!dst_pte)
+		goto out;
 
 	if (vma_is_shmem(dst_vma)) {
 		/* serialize against truncate with the page table lock */
@@ -121,6 +124,7 @@ int mfill_atomic_install_pte(pmd_t *dst_
 	ret = 0;
 out_unlock:
 	pte_unmap_unlock(dst_pte, ptl);
+out:
 	return ret;
 }
 
@@ -212,7 +216,10 @@ static int mfill_atomic_pte_zeropage(pmd
 
 	_dst_pte = pte_mkspecial(pfn_pte(my_zero_pfn(dst_addr),
 					 dst_vma->vm_page_prot));
+	ret = -EAGAIN;
 	dst_pte = pte_offset_map_lock(dst_vma->vm_mm, dst_pmd, dst_addr, &ptl);
+	if (!dst_pte)
+		goto out;
 	if (dst_vma->vm_file) {
 		/* the shmem MAP_PRIVATE case requires checking the i_size */
 		inode = dst_vma->vm_file->f_inode;
@@ -231,6 +238,7 @@ static int mfill_atomic_pte_zeropage(pmd
 	ret = 0;
 out_unlock:
 	pte_unmap_unlock(dst_pte, ptl);
+out:
 	return ret;
 }
 
_

Patches currently in -mm which might be from hughd@google.com are



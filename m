Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78F44C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:02:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234926AbjHKXC0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbjHKXA4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:00:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824623A98
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:00:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18EC6677A0
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:00:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643DBC433C8;
        Fri, 11 Aug 2023 23:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794828;
        bh=NX3+DrFtastKa3I7uEYg+2aSwZLJbj1udO9sptOYXZg=;
        h=Date:To:From:Subject:From;
        b=XR/eWE9fjNwTRiZZ64KScNADeeyOiAhdW1275311g7KYx/AF5QUmTF7vyBM0ZIAk8
         L5O42JRDkaB81SqqZvAEeeveqs/sfp1vU0m/87MPb880jNqdHETxdhXXnP3VpKSChb
         tsvkbIHqRcmtNGDJpWBDQmSd/hIFIaIWlO3bPitE=
Date:   Fri, 11 Aug 2023 16:00:27 -0700
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
Subject: [merged mm-stable] powerpc-assert_pte_locked-use-pte_offset_map_nolock.patch removed from -mm tree
Message-Id: <20230811230028.643DBC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: powerpc: assert_pte_locked() use pte_offset_map_nolock()
has been removed from the -mm tree.  Its filename was
     powerpc-assert_pte_locked-use-pte_offset_map_nolock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: powerpc: assert_pte_locked() use pte_offset_map_nolock()
Date: Tue, 11 Jul 2023 21:34:25 -0700 (PDT)

Instead of pte_lockptr(), use the recently added pte_offset_map_nolock()
in assert_pte_locked().  BUG if pte_offset_map_nolock() fails.

This mod might cause new crashes: which either expose my ignorance, or
indicate issues to be fixed, or limit the usage of assert_pte_locked().

[hughd@google.com: assert_pte_locked() still needs the pmd_none() check]
  Link: https://lkml.kernel.org/r/c73d1543-532c-3da2-8cf2-a95363a14116@google.com
Link: https://lkml.kernel.org/r/e8d56c95-c132-a82e-5f5f-7bb1b738b057@google.com
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

 arch/powerpc/mm/pgtable.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/powerpc/mm/pgtable.c~powerpc-assert_pte_locked-use-pte_offset_map_nolock
+++ a/arch/powerpc/mm/pgtable.c
@@ -311,6 +311,8 @@ void assert_pte_locked(struct mm_struct
 	p4d_t *p4d;
 	pud_t *pud;
 	pmd_t *pmd;
+	pte_t *pte;
+	spinlock_t *ptl;
 
 	if (mm == &init_mm)
 		return;
@@ -329,8 +331,10 @@ void assert_pte_locked(struct mm_struct
 	 */
 	if (pmd_none(*pmd))
 		return;
-	BUG_ON(!pmd_present(*pmd));
-	assert_spin_locked(pte_lockptr(mm, pmd));
+	pte = pte_offset_map_nolock(mm, pmd, addr, &ptl);
+	BUG_ON(!pte);
+	assert_spin_locked(ptl);
+	pte_unmap(pte);
 }
 #endif /* CONFIG_DEBUG_VM */
 
_

Patches currently in -mm which might be from hughd@google.com are



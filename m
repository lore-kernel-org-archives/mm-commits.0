Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48FDDC04A6A
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:02:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234317AbjHKXCC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237043AbjHKXAg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:00:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C33693C0E
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:00:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51CC066DF9
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3250C433C7;
        Fri, 11 Aug 2023 23:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794823;
        bh=yCVRlRhCLsXtuQY69hqsI711d2GeGfgTMyYXBAkVNwg=;
        h=Date:To:From:Subject:From;
        b=oiHWIsD/aSF3lT5vJLCcURds1ytAB+DXcmvxPsbufzRxkIpmM9H+e1gDCsW6156RQ
         eHYitPfiP0LwONWD0W/F93ovMRYmhha3rqD2cB1y0og0XF8FXaPGFIYEDqpEOBy2ov
         nxp4LeBCgvWaH3Kn5zR5imcOt5s8+et3Pm38FnQM=
Date:   Fri, 11 Aug 2023 16:00:23 -0700
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
Subject: [merged mm-stable] mm-pgtable-add-rcu_read_lock-and-rcu_read_unlocks.patch removed from -mm tree
Message-Id: <20230811230023.A3250C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/pgtable: add rcu_read_lock() and rcu_read_unlock()s
has been removed from the -mm tree.  Its filename was
     mm-pgtable-add-rcu_read_lock-and-rcu_read_unlocks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/pgtable: add rcu_read_lock() and rcu_read_unlock()s
Date: Tue, 11 Jul 2023 21:30:40 -0700 (PDT)

Patch series "mm: free retracted page table by RCU", v3.

Some mmap_lock avoidance i.e.  latency reduction.  Initially just for the
case of collapsing shmem or file pages to THPs: the usefulness of
MADV_COLLAPSE on shmem is being limited by that mmap_write_lock it
currently requires.

Likely to be relied upon later in other contexts e.g.  freeing of empty
page tables (but that's not work I'm doing).  mmap_write_lock avoidance
when collapsing to anon THPs?  Perhaps, but again that's not work I've
done: a quick attempt was not as easy as the shmem/file case.

These changes (though of course not these exact patches) have been in
Google's data centre kernel for three years now: we do rely upon them.


This patch (of 13):

Before putting them to use (several commits later), add rcu_read_lock() to
pte_offset_map(), and rcu_read_unlock() to pte_unmap().  Make this a
separate commit, since it risks exposing imbalances: prior commits have
fixed all the known imbalances, but we may find some have been missed.

Link: https://lkml.kernel.org/r/7cd843a9-aa80-14f-5eb2-33427363c20@google.com
Link: https://lkml.kernel.org/r/d3b01da5-2a6-833c-6681-67a3e024a16f@google.com
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

 include/linux/pgtable.h |    4 ++--
 mm/pgtable-generic.c    |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/pgtable.h~mm-pgtable-add-rcu_read_lock-and-rcu_read_unlocks
+++ a/include/linux/pgtable.h
@@ -99,7 +99,7 @@ static inline pte_t *pte_offset_kernel(p
 	((pte_t *)kmap_local_page(pmd_page(*(pmd))) + pte_index((address)))
 #define pte_unmap(pte)	do {	\
 	kunmap_local((pte));	\
-	/* rcu_read_unlock() to be added later */	\
+	rcu_read_unlock();	\
 } while (0)
 #else
 static inline pte_t *__pte_map(pmd_t *pmd, unsigned long address)
@@ -108,7 +108,7 @@ static inline pte_t *__pte_map(pmd_t *pm
 }
 static inline void pte_unmap(pte_t *pte)
 {
-	/* rcu_read_unlock() to be added later */
+	rcu_read_unlock();
 }
 #endif
 
--- a/mm/pgtable-generic.c~mm-pgtable-add-rcu_read_lock-and-rcu_read_unlocks
+++ a/mm/pgtable-generic.c
@@ -236,7 +236,7 @@ pte_t *__pte_offset_map(pmd_t *pmd, unsi
 {
 	pmd_t pmdval;
 
-	/* rcu_read_lock() to be added later */
+	rcu_read_lock();
 	pmdval = pmdp_get_lockless(pmd);
 	if (pmdvalp)
 		*pmdvalp = pmdval;
@@ -250,7 +250,7 @@ pte_t *__pte_offset_map(pmd_t *pmd, unsi
 	}
 	return __pte_map(&pmdval, addr);
 nomap:
-	/* rcu_read_unlock() to be added later */
+	rcu_read_unlock();
 	return NULL;
 }
 
_

Patches currently in -mm which might be from hughd@google.com are



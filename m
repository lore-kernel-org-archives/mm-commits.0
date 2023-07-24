Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8285C00528
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 16:47:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjGXQrq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 12:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjGXQro (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 12:47:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9A8E65
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 09:47:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CF216129A
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 16:47:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9874FC433C7;
        Mon, 24 Jul 2023 16:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690217262;
        bh=aL5uTs2N9ioEkbg8PYuxHRB9hvy/zhiYucbvsT5K8fo=;
        h=Date:To:From:Subject:From;
        b=El94A6DEZWMsWVuQmn+kwniCuSiyEdKFAaaxxo/5oo6CRtmOsDkCgwqkqAu2PVLLW
         B3BASASNVdzebIvNNMkyoxYGrUjzDMNZ1yMziIDS0OJzY5gBgUn6E1707BEdejRqCM
         10BUn+N3lomLt5zFOyXI153UWYhpgsdp15+jjOhc=
Date:   Mon, 24 Jul 2023 09:47:42 -0700
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
Subject: + mm-khugepaged-delete-khugepaged_collapse_pte_mapped_thps-fix.patch added to mm-unstable branch
Message-Id: <20230724164742.9874FC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: delete khugepaged_collapse_pte_mapped_thps(): fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-delete-khugepaged_collapse_pte_mapped_thps-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-delete-khugepaged_collapse_pte_mapped_thps-fix.patch

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
From: Hugh Dickins <hughd@google.com>
Subject: mm/khugepaged: delete khugepaged_collapse_pte_mapped_thps(): fix
Date: Sun, 23 Jul 2023 15:35:07 -0700 (PDT)

Though not yet detected by syzbot, this commit was making the same mistake
with mmap_locked as the previous commit: fix that.

Link: https://lkml.kernel.org/r/bfc6cab2-497f-32bf-dd5-98dc1987e4a9@google.com
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

 mm/khugepaged.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-delete-khugepaged_collapse_pte_mapped_thps-fix
+++ a/mm/khugepaged.c
@@ -2380,19 +2380,17 @@ skip:
 				mmap_locked = false;
 				*result = hpage_collapse_scan_file(mm,
 					khugepaged_scan.address, file, pgoff, cc);
+				fput(file);
 				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
 					mmap_read_lock(mm);
-					mmap_locked = true;
-					if (hpage_collapse_test_exit(mm)) {
-						fput(file);
+					if (hpage_collapse_test_exit(mm))
 						goto breakouterloop;
-					}
 					*result = collapse_pte_mapped_thp(mm,
 						khugepaged_scan.address, false);
 					if (*result == SCAN_PMD_MAPPED)
 						*result = SCAN_SUCCEED;
+					mmap_read_unlock(mm);
 				}
-				fput(file);
 			} else {
 				*result = hpage_collapse_scan_pmd(mm, vma,
 					khugepaged_scan.address, &mmap_locked, cc);
_

Patches currently in -mm which might be from hughd@google.com are

tmpfs-fix-documentation-of-noswap-and-huge-mount-options.patch
shmem-minor-fixes-to-splice-read-implementation.patch
mm-pagewalk-fix-efi_pgt_dump-of-espfix-area.patch
mm-userfaultfd-add-new-uffdio_poison-ioctl-fix.patch
mm-pgtable-add-rcu_read_lock-and-rcu_read_unlocks.patch
mm-pgtable-add-pae-safety-to-__pte_offset_map.patch
arm-adjust_pte-use-pte_offset_map_nolock.patch
powerpc-assert_pte_locked-use-pte_offset_map_nolock.patch
powerpc-assert_pte_locked-use-pte_offset_map_nolock-fix.patch
powerpc-add-pte_free_defer-for-pgtables-sharing-page.patch
sparc-add-pte_free_defer-for-pte_t-pgtable_t.patch
s390-add-pte_free_defer-for-pgtables-sharing-page.patch
s390-add-pte_free_defer-for-pgtables-sharing-page-fix.patch
mm-pgtable-add-pte_free_defer-for-pgtable-as-page.patch
mm-khugepaged-retract_page_tables-without-mmap-or-vma-lock.patch
mm-khugepaged-collapse_pte_mapped_thp-with-mmap_read_lock.patch
mm-khugepaged-collapse_pte_mapped_thp-with-mmap_read_lock-fix.patch
mm-khugepaged-delete-khugepaged_collapse_pte_mapped_thps.patch
mm-khugepaged-delete-khugepaged_collapse_pte_mapped_thps-fix.patch
mm-delete-mmap_write_trylock-and-vma_try_start_write.patch
mm-pgtable-notes-on-pte_offset_map.patch


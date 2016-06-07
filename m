From: akpm@linux-foundation.org
Subject: +
 page-flags-relax-policy-for-pg_mappedtodisk-and-pg_reclaim.patch added to
 -mm tree
Date: Tue, 07 Jun 2016 14:04:21 -0700
Message-ID: <575736d5.tI/nMTGStlctVLTR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39492 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422628AbcFGVEW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2016 17:04:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, andreslc@google.com, aneesh.kumar@linux.vnet.ibm.com, cl@gentwo.org, dave.hansen@intel.com, hughd@google.com, jmarchan@redhat.com, n-horiguchi@ah.jp.nec.com, peterz@infradead.org, quning@gmail.com, sasha.levin@oracle.com, vbabka@suse.cz, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: page-flags: relax policy for PG_mappedtodisk and PG_reclaim
has been added to the -mm tree.  Its filename is
     page-flags-relax-policy-for-pg_mappedtodisk-and-pg_reclaim.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/page-flags-relax-policy-for-pg_mappedtodisk-and-pg_reclaim.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/page-flags-relax-policy-for-pg_mappedtodisk-and-pg_reclaim.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: page-flags: relax policy for PG_mappedtodisk and PG_reclaim

These flags are in use for file THP.

Link: http://lkml.kernel.org/r/1465297246-98985-18-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Ning Qu <quning@gmail.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/page-flags.h~page-flags-relax-policy-for-pg_mappedtodisk-and-pg_reclaim include/linux/page-flags.h
--- a/include/linux/page-flags.h~page-flags-relax-policy-for-pg_mappedtodisk-and-pg_reclaim
+++ a/include/linux/page-flags.h
@@ -295,11 +295,11 @@ PAGEFLAG(OwnerPriv1, owner_priv_1, PF_AN
  */
 TESTPAGEFLAG(Writeback, writeback, PF_NO_COMPOUND)
 	TESTSCFLAG(Writeback, writeback, PF_NO_COMPOUND)
-PAGEFLAG(MappedToDisk, mappedtodisk, PF_NO_COMPOUND)
+PAGEFLAG(MappedToDisk, mappedtodisk, PF_NO_TAIL)
 
 /* PG_readahead is only used for reads; PG_reclaim is only for writes */
-PAGEFLAG(Reclaim, reclaim, PF_NO_COMPOUND)
-	TESTCLEARFLAG(Reclaim, reclaim, PF_NO_COMPOUND)
+PAGEFLAG(Reclaim, reclaim, PF_NO_TAIL)
+	TESTCLEARFLAG(Reclaim, reclaim, PF_NO_TAIL)
 PAGEFLAG(Readahead, reclaim, PF_NO_COMPOUND)
 	TESTCLEARFLAG(Readahead, reclaim, PF_NO_COMPOUND)
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix.patch
thp-mlock-update-unevictable-lrutxt.patch
mm-do-not-pass-mm_struct-into-handle_mm_fault.patch
mm-introduce-fault_env.patch
mm-postpone-page-table-allocation-until-we-have-page-to-map.patch
rmap-support-file-thp.patch
mm-introduce-do_set_pmd.patch
thp-vmstats-add-counters-for-huge-file-pages.patch
thp-support-file-pages-in-zap_huge_pmd.patch
thp-handle-file-pages-in-split_huge_pmd.patch
thp-handle-file-cow-faults.patch
thp-skip-file-huge-pmd-on-copy_huge_pmd.patch
thp-prepare-change_huge_pmd-for-file-thp.patch
thp-run-vma_adjust_trans_huge-outside-i_mmap_rwsem.patch
thp-file-pages-support-for-split_huge_page.patch
thp-mlock-do-not-mlock-pte-mapped-file-huge-pages.patch
vmscan-split-file-huge-pages-before-paging-them-out.patch
page-flags-relax-policy-for-pg_mappedtodisk-and-pg_reclaim.patch
radix-tree-implement-radix_tree_maybe_preload_order.patch
filemap-prepare-find-and-delete-operations-for-huge-pages.patch
truncate-handle-file-thp.patch
mm-rmap-account-shmem-thp-pages.patch
shmem-prepare-huge=-mount-option-and-sysfs-knob.patch
shmem-add-huge-pages-support.patch
shmem-thp-respect-madv_nohugepage-for-file-mappings.patch
thp-extract-khugepaged-from-mm-huge_memoryc.patch
khugepaged-move-up_readmmap_sem-out-of-khugepaged_alloc_page.patch
shmem-make-shmem_inode_info-lock-irq-safe.patch
khugepaged-add-support-of-collapse-for-tmpfs-shmem-pages.patch
thp-introduce-config_transparent_huge_pagecache.patch
shmem-split-huge-pages-beyond-i_size-under-memory-pressure.patch
thp-update-documentation-vm-transhugefilesystems-proctxt.patch
a.patch


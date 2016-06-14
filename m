From: akpm@linux-foundation.org
Subject: +
 revert-mm-disable-fault-around-on-emulated-access-bit-architecture.patch
 added to -mm tree
Date: Tue, 14 Jun 2016 13:41:57 -0700
Message-ID: <57606c15.ExmmARYO9LX8f48i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54093 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbcFNUl6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jun 2016 16:41:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, dave.hansen@linux.intel.com, mgorman@suse.de, mhocko@suse.com, minchan@kernel.org, riel@redhat.com, torvalds@linux-foundation.org, vinmenon@codeaurora.org, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "mm: disable fault around on emulated access bit architecture"
has been added to the -mm tree.  Its filename is
     revert-mm-disable-fault-around-on-emulated-access-bit-architecture.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-mm-disable-fault-around-on-emulated-access-bit-architecture.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-mm-disable-fault-around-on-emulated-access-bit-architecture.patch

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
Subject: Revert "mm: disable fault around on emulated access bit architecture"

This reverts commit d0834a6c2c5b0c76cfb806bd7dba6556d8b4edbb.

After revert of 5c0a85fad949 ("mm: make faultaround produce old ptes")
faultaround doesn't have dependencies on hardware accessed bit, so let's
revert this one too.

Link: http://lkml.kernel.org/r/1465893750-44080-3-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN mm/memory.c~revert-mm-disable-fault-around-on-emulated-access-bit-architecture mm/memory.c
--- a/mm/memory.c~revert-mm-disable-fault-around-on-emulated-access-bit-architecture
+++ a/mm/memory.c
@@ -2898,16 +2898,8 @@ void do_set_pte(struct vm_area_struct *v
 	update_mmu_cache(vma, address, pte);
 }
 
-/*
- * If architecture emulates "accessed" or "young" bit without HW support,
- * there is no much gain with fault_around.
- */
 static unsigned long fault_around_bytes __read_mostly =
-#ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
-	PAGE_SIZE;
-#else
 	rounddown_pow_of_two(65536);
-#endif
 
 #ifdef CONFIG_DEBUG_FS
 static int fault_around_bytes_get(void *data, u64 *val)
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

revert-mm-make-faultaround-produce-old-ptes.patch
revert-mm-disable-fault-around-on-emulated-access-bit-architecture.patch
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


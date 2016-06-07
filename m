From: akpm@linux-foundation.org
Subject: + thp-mlock-update-unevictable-lrutxt.patch added to -mm tree
Date: Tue, 07 Jun 2016 14:03:40 -0700
Message-ID: <575736ac.B5+GfClqDiCuwWr7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39286 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932666AbcFGVDm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2016 17:03:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, andreslc@google.com, aneesh.kumar@linux.vnet.ibm.com, cl@gentwo.org, dave.hansen@intel.com, hughd@google.com, jmarchan@redhat.com, n-horiguchi@ah.jp.nec.com, peterz@infradead.org, quning@gmail.com, sasha.levin@oracle.com, vbabka@suse.cz, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: thp, mlock: update unevictable-lru.txt
has been added to the -mm tree.  Its filename is
     thp-mlock-update-unevictable-lrutxt.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-mlock-update-unevictable-lrutxt.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-mlock-update-unevictable-lrutxt.patch

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
Subject: thp, mlock: update unevictable-lru.txt

THP-enabled tmpfs/shmem using compound pages.


This patch (of 32):

Add description of THP handling into unevictable-lru.txt.

Link: http://lkml.kernel.org/r/1465297246-98985-2-git-send-email-kirill.shutemov@linux.intel.com
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

 Documentation/vm/unevictable-lru.txt |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff -puN Documentation/vm/unevictable-lru.txt~thp-mlock-update-unevictable-lrutxt Documentation/vm/unevictable-lru.txt
--- a/Documentation/vm/unevictable-lru.txt~thp-mlock-update-unevictable-lrutxt
+++ a/Documentation/vm/unevictable-lru.txt
@@ -461,6 +461,27 @@ unevictable LRU is enabled, the work of
 the page migration code and the same work flow as described in MIGRATING
 MLOCKED PAGES will apply.
 
+MLOCKING TRANSPARENT HUGE PAGES
+-------------------------------
+
+A transparent huge page is represented by a single entry on an LRU list.
+Therefore, we can only make unevictable an entire compound page, not
+individual subpages.
+
+If a user tries to mlock() part of a huge page, we want the rest of the
+page to be reclaimable.
+
+We cannot just split the page on partial mlock() as split_huge_page() can
+fail and new intermittent failure mode for the syscall is undesirable.
+
+We handle this by keeping PTE-mapped huge pages on normal LRU lists: the
+PMD on border of VM_LOCKED VMA will be split into PTE table.
+
+This way the huge page is accessible for vmscan. Under memory pressure the
+page will be split, subpages which belong to VM_LOCKED VMAs will be moved
+to unevictable LRU and the rest can be reclaimed.
+
+See also comment in follow_trans_huge_pmd().
 
 mmap(MAP_LOCKED) SYSTEM CALL HANDLING
 -------------------------------------
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


From: akpm@linux-foundation.org
Subject: + thp-update-documentation-vm-transhugefilesystems-proctxt.patch
 added to -mm tree
Date: Tue, 07 Jun 2016 14:05:05 -0700
Message-ID: <57573701.lBLu30iZ4P/wHXaG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39686 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161158AbcFGVFH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2016 17:05:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, andreslc@google.com, aneesh.kumar@linux.vnet.ibm.com, cl@gentwo.org, dave.hansen@intel.com, hughd@google.com, jmarchan@redhat.com, n-horiguchi@ah.jp.nec.com, peterz@infradead.org, quning@gmail.com, sasha.levin@oracle.com, vbabka@suse.cz, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: update Documentation/{vm/transhuge,filesystems/proc}.txt
has been added to the -mm tree.  Its filename is
     thp-update-documentation-vm-transhugefilesystems-proctxt.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-update-documentation-vm-transhugefilesystems-proctxt.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-update-documentation-vm-transhugefilesystems-proctxt.patch

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
Subject: thp: update Documentation/{vm/transhuge,filesystems/proc}.txt

Add info about tmpfs/shmem with huge pages.

Link: http://lkml.kernel.org/r/1465297246-98985-33-git-send-email-kirill.shutemov@linux.intel.com
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

 Documentation/filesystems/proc.txt |    9 +
 Documentation/vm/transhuge.txt     |  130 +++++++++++++++++++--------
 2 files changed, 102 insertions(+), 37 deletions(-)

diff -puN Documentation/filesystems/proc.txt~thp-update-documentation-vm-transhugefilesystems-proctxt Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~thp-update-documentation-vm-transhugefilesystems-proctxt
+++ a/Documentation/filesystems/proc.txt
@@ -436,6 +436,7 @@ Private_Dirty:         0 kB
 Referenced:          892 kB
 Anonymous:             0 kB
 AnonHugePages:         0 kB
+ShmemPmdMapped:        0 kB
 Shared_Hugetlb:        0 kB
 Private_Hugetlb:       0 kB
 Swap:                  0 kB
@@ -464,6 +465,8 @@ accessed.
 a mapping associated with a file may contain anonymous pages: when MAP_PRIVATE
 and a page is modified, the file page is replaced by a private anonymous copy.
 "AnonHugePages" shows the ammount of memory backed by transparent hugepage.
+"ShmemPmdMapped" shows the ammount of shared (shmem/tmpfs) memory backed by
+huge pages.
 "Shared_Hugetlb" and "Private_Hugetlb" show the ammounts of memory backed by
 hugetlbfs page which is *not* counted in "RSS" or "PSS" field for historical
 reasons. And these are not included in {Shared,Private}_{Clean,Dirty} field.
@@ -868,6 +871,9 @@ VmallocTotal:   112216 kB
 VmallocUsed:       428 kB
 VmallocChunk:   111088 kB
 AnonHugePages:   49152 kB
+ShmemHugePages:      0 kB
+ShmemPmdMapped:      0 kB
+
 
     MemTotal: Total usable ram (i.e. physical ram minus a few reserved
               bits and the kernel binary code)
@@ -912,6 +918,9 @@ MemAvailable: An estimate of how much me
 AnonHugePages: Non-file backed huge pages mapped into userspace page tables
       Mapped: files which have been mmaped, such as libraries
        Shmem: Total memory used by shared memory (shmem) and tmpfs
+ShmemHugePages: Memory used by shared memory (shmem) and tmpfs allocated
+              with huge pages
+ShmemPmdMapped: Shared memory mapped into userspace with huge pages
         Slab: in-kernel data structures cache
 SReclaimable: Part of Slab, that might be reclaimed, such as caches
   SUnreclaim: Part of Slab, that cannot be reclaimed on memory pressure
diff -puN Documentation/vm/transhuge.txt~thp-update-documentation-vm-transhugefilesystems-proctxt Documentation/vm/transhuge.txt
--- a/Documentation/vm/transhuge.txt~thp-update-documentation-vm-transhugefilesystems-proctxt
+++ a/Documentation/vm/transhuge.txt
@@ -9,8 +9,8 @@ using huge pages for the backing of virt
 that supports the automatic promotion and demotion of page sizes and
 without the shortcomings of hugetlbfs.
 
-Currently it only works for anonymous memory mappings but in the
-future it can expand over the pagecache layer starting with tmpfs.
+Currently it only works for anonymous memory mappings and tmpfs/shmem.
+But in the future it can expand to other filesystems.
 
 The reason applications are running faster is because of two
 factors. The first factor is almost completely irrelevant and it's not
@@ -57,10 +57,6 @@ miss is going to run faster.
   feature that applies to all dynamic high order allocations in the
   kernel)
 
-- this initial support only offers the feature in the anonymous memory
-  regions but it'd be ideal to move it to tmpfs and the pagecache
-  later
-
 Transparent Hugepage Support maximizes the usefulness of free memory
 if compared to the reservation approach of hugetlbfs by allowing all
 unused memory to be used as cache or other movable (or even unmovable
@@ -94,21 +90,21 @@ madvise(MADV_HUGEPAGE) on their critical
 
 == sysfs ==
 
-Transparent Hugepage Support can be entirely disabled (mostly for
-debugging purposes) or only enabled inside MADV_HUGEPAGE regions (to
-avoid the risk of consuming more memory resources) or enabled system
-wide. This can be achieved with one of:
+Transparent Hugepage Support for anonymous memory can be entirely disabled
+(mostly for debugging purposes) or only enabled inside MADV_HUGEPAGE
+regions (to avoid the risk of consuming more memory resources) or enabled
+system wide. This can be achieved with one of:
 
 echo always >/sys/kernel/mm/transparent_hugepage/enabled
 echo madvise >/sys/kernel/mm/transparent_hugepage/enabled
 echo never >/sys/kernel/mm/transparent_hugepage/enabled
 
 It's also possible to limit defrag efforts in the VM to generate
-hugepages in case they're not immediately free to madvise regions or
-to never try to defrag memory and simply fallback to regular pages
-unless hugepages are immediately available. Clearly if we spend CPU
-time to defrag memory, we would expect to gain even more by the fact
-we use hugepages later instead of regular pages. This isn't always
+anonymous hugepages in case they're not immediately free to madvise
+regions or to never try to defrag memory and simply fallback to regular
+pages unless hugepages are immediately available. Clearly if we spend CPU
+time to defrag memory, we would expect to gain even more by the fact we
+use hugepages later instead of regular pages. This isn't always
 guaranteed, but it may be more likely in case the allocation is for a
 MADV_HUGEPAGE region.
 
@@ -133,9 +129,9 @@ that are have used madvise(MADV_HUGEPAGE
 
 "never" should be self-explanatory.
 
-By default kernel tries to use huge zero page on read page fault.
-It's possible to disable huge zero page by writing 0 or enable it
-back by writing 1:
+By default kernel tries to use huge zero page on read page fault to
+anonymous mapping. It's possible to disable huge zero page by writing 0
+or enable it back by writing 1:
 
 echo 0 >/sys/kernel/mm/transparent_hugepage/use_zero_page
 echo 1 >/sys/kernel/mm/transparent_hugepage/use_zero_page
@@ -204,21 +200,67 @@ Support by passing the parameter "transp
 "transparent_hugepage=madvise" or "transparent_hugepage=never"
 (without "") to the kernel command line.
 
+== Hugepages in tmpfs/shmem ==
+
+You can control hugepage allocation policy in tmpfs with mount option
+"huge=". It can have following values:
+
+  - "always":
+    Attempt to allocate huge pages every time we need a new page;
+
+  - "never":
+    Do not allocate huge pages;
+
+  - "within_size":
+    Only allocate huge page if it will be fully within i_size.
+    Also respect fadvise()/madvise() hints;
+
+  - "advise:
+    Only allocate huge pages if requested with fadvise()/madvise();
+
+The default policy is "never".
+
+"mount -o remount,huge= /mountpoint" works fine after mount: remounting
+huge=never will not attempt to break up huge pages at all, just stop more
+from being allocated.
+
+There's also sysfs knob to control hugepage allocation policy for internal
+shmem mount: /sys/kernel/mm/transparent_hugepage/shmem_enabled. The mount
+is used for SysV SHM, memfds, shared anonymous mmaps (of /dev/zero or
+MAP_ANONYMOUS), GPU drivers' DRM objects, Ashmem.
+
+In addition to policies listed above, shmem_enabled allows two further
+values:
+
+  - "deny":
+    For use in emergencies, to force the huge option off from
+    all mounts;
+  - "force":
+    Force the huge option on for all - very useful for testing;
+
 == Need of application restart ==
 
-The transparent_hugepage/enabled values only affect future
-behavior. So to make them effective you need to restart any
-application that could have been using hugepages. This also applies to
-the regions registered in khugepaged.
+The transparent_hugepage/enabled values and tmpfs mount option only affect
+future behavior. So to make them effective you need to restart any
+application that could have been using hugepages. This also applies to the
+regions registered in khugepaged.
 
 == Monitoring usage ==
 
-The number of transparent huge pages currently used by the system is
-available by reading the AnonHugePages field in /proc/meminfo. To
-identify what applications are using transparent huge pages, it is
-necessary to read /proc/PID/smaps and count the AnonHugePages fields
-for each mapping. Note that reading the smaps file is expensive and
-reading it frequently will incur overhead.
+The number of anonymous transparent huge pages currently used by the
+system is available by reading the AnonHugePages field in /proc/meminfo.
+To identify what applications are using anonymous transparent huge pages,
+it is necessary to read /proc/PID/smaps and count the AnonHugePages fields
+for each mapping.
+
+The number of file transparent huge pages mapped to userspace is available
+by reading ShmemPmdMapped and ShmemHugePages fields in /proc/meminfo.
+To identify what applications are mapping file  transparent huge pages, it
+is necessary to read /proc/PID/smaps and count the FileHugeMapped fields
+for each mapping.
+
+Note that reading the smaps file is expensive and reading it
+frequently will incur overhead.
 
 There are a number of counters in /proc/vmstat that may be used to
 monitor how successfully the system is providing huge pages for use.
@@ -238,6 +280,12 @@ thp_collapse_alloc_failed is incremented
 	of pages that should be collapsed into one huge page but failed
 	the allocation.
 
+thp_file_alloc is incremented every time a file huge page is successfully
+i	allocated.
+
+thp_file_mapped is incremented every time a file huge page is mapped into
+	user address space.
+
 thp_split_page is incremented every time a huge page is split into base
 	pages. This can happen for a variety of reasons but a common
 	reason is that a huge page is old and is being reclaimed.
@@ -403,19 +451,27 @@ pages:
     on relevant sub-page of the compound page.
 
   - map/unmap of the whole compound page accounted in compound_mapcount
-    (stored in first tail page).
-
-PageDoubleMap() indicates that ->_mapcount in all subpages is offset up by one.
-This additional reference is required to get race-free detection of unmap of
-subpages when we have them mapped with both PMDs and PTEs.
+    (stored in first tail page). For file huge pages, we also increment
+    ->_mapcount of all sub-pages in order to have race-free detection of
+    last unmap of subpages.
+
+PageDoubleMap() indicates that the page is *possibly* mapped with PTEs.
+
+For anonymous pages PageDoubleMap() also indicates ->_mapcount in all
+subpages is offset up by one. This additional reference is required to
+get race-free detection of unmap of subpages when we have them mapped with
+both PMDs and PTEs.
 
 This is optimization required to lower overhead of per-subpage mapcount
 tracking. The alternative is alter ->_mapcount in all subpages on each
 map/unmap of the whole compound page.
 
-We set PG_double_map when a PMD of the page got split for the first time,
-but still have PMD mapping. The additional references go away with last
-compound_mapcount.
+For anonymous pages, we set PG_double_map when a PMD of the page got split
+for the first time, but still have PMD mapping. The additional references
+go away with last compound_mapcount.
+
+File pages get PG_double_map set on first map of the page with PTE and
+goes away when the page gets evicted from page cache.
 
 split_huge_page internally has to distribute the refcounts in the head
 page to the tail pages before clearing all PG_head/tail bits from the page
@@ -427,7 +483,7 @@ sum of mapcount of all sub-pages plus on
 have reference for head page).
 
 split_huge_page uses migration entries to stabilize page->_refcount and
-page->_mapcount.
+page->_mapcount of anonymous pages. File pages just got unmapped.
 
 We safe against physical memory scanners too: the only legitimate way
 scanner can get reference to a page is get_page_unless_zero().
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


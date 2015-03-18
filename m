From: akpm@linux-foundation.org
Subject: +
 hugetlbfs-add-minimum-size-tracking-fields-to-subpool-structure-fix.patch
 added to -mm tree
Date: Wed, 18 Mar 2015 14:44:29 -0700
Message-ID: <5509f1bd.2NmlWjQfH1aWxvga%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38928 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965043AbbCRVoa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Mar 2015 17:44:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andi@firstfloor.org, aneesh.kumar@linux.vnet.ibm.com, dave@stgolabs.net, iamjoonsoo.kim@lge.com, mike.kravetz@oracle.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs-add-minimum-size-tracking-fields-to-subpool-structure-fix
has been added to the -mm tree.  Its filename is
     hugetlbfs-add-minimum-size-tracking-fields-to-subpool-structure-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlbfs-add-minimum-size-tracking-fields-to-subpool-structure-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlbfs-add-minimum-size-tracking-fields-to-subpool-structure-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hugetlbfs-add-minimum-size-tracking-fields-to-subpool-structure-fix

clean up hugepage_subpool definition, use kzalloc()

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    6 ++++--
 mm/hugetlb.c            |    6 +-----
 2 files changed, 5 insertions(+), 7 deletions(-)

diff -puN include/linux/hugetlb.h~hugetlbfs-add-minimum-size-tracking-fields-to-subpool-structure-fix include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlbfs-add-minimum-size-tracking-fields-to-subpool-structure-fix
+++ a/include/linux/hugetlb.h
@@ -22,9 +22,11 @@ struct mmu_gather;
 struct hugepage_subpool {
 	spinlock_t lock;
 	long count;
-	long max_hpages, used_hpages;
+	long max_hpagesl
+	long used_hpages;
 	struct hstate *hstate;
-	long min_hpages, rsv_hpages;
+	long min_hpages;
+	long rsv_hpages;
 };
 
 struct resv_map {
diff -puN mm/hugetlb.c~hugetlbfs-add-minimum-size-tracking-fields-to-subpool-structure-fix mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlbfs-add-minimum-size-tracking-fields-to-subpool-structure-fix
+++ a/mm/hugetlb.c
@@ -77,17 +77,13 @@ struct hugepage_subpool *hugepage_new_su
 {
 	struct hugepage_subpool *spool;
 
-	spool = kmalloc(sizeof(*spool), GFP_KERNEL);
+	spool = kzalloc(sizeof(*spool), GFP_KERNEL);
 	if (!spool)
 		return NULL;
 
 	spin_lock_init(&spool->lock);
 	spool->count = 1;
 	spool->max_hpages = nr_blocks;
-	spool->used_hpages = 0;
-	spool->hstate = NULL;
-	spool->min_hpages = 0;
-	spool->rsv_hpages = 0;
 
 	return spool;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
drivers-rtc-rtc-mrst-fix-suspend-resume-fix.patch
mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention.patch
mm.patch
mm-cma-release-trigger-checkpatch-fixes.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch
mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch
mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes.patch
mm-change-vunmap-to-tear-down-huge-kva-mappings-fix.patch
mm-mempool-do-not-allow-atomic-resizing-checkpatch-fixes.patch
hugetlbfs-add-minimum-size-tracking-fields-to-subpool-structure-fix.patch
hugetlbfs-add-minimum-size-accounting-to-subpools-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-introduce-automatic-device_id-generation-fix.patch
zsmalloc-support-compaction-fix.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch
lib-find__bit-reimplementation-fix.patch
checkpatch-match-more-world-writable-permissions-fix.patch
binfmt_misc-simplify-entry_status-fix.patch
rtc-add-abracon-abx80x-driver-fix.patch
fs-fat-remove-unnecessary-includes-fix.patch
kconfig-use-macros-which-are-already-defined-fix.patch
linux-next.patch
linux-next-rejects.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix.patch
tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch


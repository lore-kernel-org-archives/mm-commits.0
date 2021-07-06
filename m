Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74401C07E9C
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:19:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58F0261C7F
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:19:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231792AbhGFTWK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:22:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231438AbhGFTWK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:22:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC29F6192B;
        Tue,  6 Jul 2021 19:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599171;
        bh=LnWpZcbpt2UovFg44tITB35wWkIR/lngm1HKNPxXxHc=;
        h=Date:From:To:Subject:From;
        b=Bc+Zv+aYInLK/y5OVf2jI3vfKjZfPB6l+253Y97zhuueeb5QfKyWj/znAWFoOYDCg
         JnRMBlIPu/uwK4shH0gsFnMrDdTeJJAhzsDkWn5D6hbpCjgSD9qosYotFm5RCcdXcB
         Yja3teRMlMeTxILMkqBzGOZftpJKerXhLcZocXM8=
Date:   Tue, 06 Jul 2021 12:19:30 -0700
From:   akpm@linux-foundation.org
To:     borntraeger@de.ibm.com, gerald.schaefer@linux.ibm.com,
        gor@linux.ibm.com, hca@linux.ibm.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        ying.huang@intel.com, ziy@nvidia.com
Subject:  [merged] mm-memory-add-orig_pmd-to-struct-vm_fault.patch
 removed from -mm tree
Message-ID: <20210706191930.nQiGS3-C8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory: add orig_pmd to struct vm_fault
has been removed from the -mm tree.  Its filename was
     mm-memory-add-orig_pmd-to-struct-vm_fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: memory: add orig_pmd to struct vm_fault

Pach series "mm: thp: use generic THP migration for NUMA hinting fault", v3.

When the THP NUMA fault support was added THP migration was not supported
yet.  So the ad hoc THP migration was implemented in NUMA fault handling. 
Since v4.14 THP migration has been supported so it doesn't make too much
sense to still keep another THP migration implementation rather than using
the generic migration code.  It is definitely a maintenance burden to keep
two THP migration implementation for different code paths and it is more
error prone.  Using the generic THP migration implementation allows us
remove the duplicate code and some hacks needed by the old ad hoc
implementation.

A quick grep shows x86_64, PowerPC (book3s), ARM64 ans S390 support both
THP and NUMA balancing.  The most of them support THP migration except for
S390.  Zi Yan tried to add THP migration support for S390 before but it
was not accepted due to the design of S390 PMD.  For the discussion,
please see: https://lkml.org/lkml/2018/4/27/953.

Per the discussion with Gerald Schaefer in v1 it is acceptible to skip
huge PMD for S390 for now.

I saw there were some hacks about gup from git history, but I didn't
figure out if they have been removed or not since I just found FOLL_NUMA
code in the current gup implementation and they seems useful.

Patch #1 ~ #2 are preparation patches.
Patch #3 is the real meat.
Patch #4 ~ #6 keep consistent counters and behaviors with before.
Patch #7 skips change huge PMD to prot_none if thp migration is not supported.


Test
----
Did some tests to measure the latency of do_huge_pmd_numa_page.  The test
VM has 80 vcpus and 64G memory.  The test would create 2 processes to
consume 128G memory together which would incur memory pressure to cause
THP splits.  And it also creates 80 processes to hog cpu, and the memory
consumer processes are bound to different nodes periodically in order to
increase NUMA faults.

The below test script is used:

echo 3 > /proc/sys/vm/drop_caches

# Run stress-ng for 24 hours
./stress-ng/stress-ng --vm 2 --vm-bytes 64G --timeout 24h &
PID=$!

./stress-ng/stress-ng --cpu $NR_CPUS --timeout 24h &

# Wait for vm stressors forked
sleep 5

PID_1=`pgrep -P $PID | awk 'NR == 1'`
PID_2=`pgrep -P $PID | awk 'NR == 2'`

JOB1=`pgrep -P $PID_1`
JOB2=`pgrep -P $PID_2`

# Bind load jobs to different nodes periodically to force generate
# cross node memory access
while [ -d "/proc/$PID" ]
do
        taskset -apc 8 $JOB1
        taskset -apc 8 $JOB2
        sleep 300
        taskset -apc 58 $JOB1
        taskset -apc 58 $JOB2
        sleep 300
done

With the above test the histogram of latency of do_huge_pmd_numa_page is
as shown below.  Since the number of do_huge_pmd_numa_page varies
drastically for each run (should be due to scheduler), so I converted the
raw number to percentage.

                             patched               base
@us[stress-ng]:
[0]                          3.57%                 0.16%
[1]                          55.68%                18.36%
[2, 4)                       10.46%                40.44%
[4, 8)                       7.26%                 17.82%
[8, 16)                      21.12%                13.41%
[16, 32)                     1.06%                 4.27%
[32, 64)                     0.56%                 4.07%
[64, 128)                    0.16%                 0.35%
[128, 256)                   < 0.1%                < 0.1%
[256, 512)                   < 0.1%                < 0.1%
[512, 1K)                    < 0.1%                < 0.1%
[1K, 2K)                     < 0.1%                < 0.1%
[2K, 4K)                     < 0.1%                < 0.1%
[4K, 8K)                     < 0.1%                < 0.1%
[8K, 16K)                    < 0.1%                < 0.1%
[16K, 32K)                   < 0.1%                < 0.1%
[32K, 64K)                   < 0.1%                < 0.1%

Per the result, patched kernel is even slightly better than the base
kernel.  I think this is because the lock contention against THP split is
less than base kernel due to the refactor.

To exclude the affect from THP split, I also did test w/o memory pressure.
No obvious regression is spotted.  The below is the test result *w/o*
memory pressure.

                           patched                  base
@us[stress-ng]:
[0]                        7.97%                   18.4%
[1]                        69.63%                  58.24%
[2, 4)                     4.18%                   2.63%
[4, 8)                     0.22%                   0.17%
[8, 16)                    1.03%                   0.92%
[16, 32)                   0.14%                   < 0.1%
[32, 64)                   < 0.1%                  < 0.1%
[64, 128)                  < 0.1%                  < 0.1%
[128, 256)                 < 0.1%                  < 0.1%
[256, 512)                 0.45%                   1.19%
[512, 1K)                  15.45%                  17.27%
[1K, 2K)                   < 0.1%                  < 0.1%
[2K, 4K)                   < 0.1%                  < 0.1%
[4K, 8K)                   < 0.1%                  < 0.1%
[8K, 16K)                  0.86%                   0.88%
[16K, 32K)                 < 0.1%                  0.15%
[32K, 64K)                 < 0.1%                  < 0.1%
[64K, 128K)                < 0.1%                  < 0.1%
[128K, 256K)               < 0.1%                  < 0.1%

The series also survived a series of tests that exercise NUMA balancing
migrations by Mel.


This patch (of 7):

Add orig_pmd to struct vm_fault so the "orig_pmd" parameter used by huge
page fault could be removed, just like its PTE counterpart does.

Link: https://lkml.kernel.org/r/20210518200801.7413-1-shy828301@gmail.com
Link: https://lkml.kernel.org/r/20210518200801.7413-2-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    9 ++++-----
 include/linux/mm.h      |    7 ++++++-
 mm/huge_memory.c        |    9 ++++++---
 mm/memory.c             |   26 +++++++++++++-------------
 4 files changed, 29 insertions(+), 22 deletions(-)

--- a/include/linux/huge_mm.h~mm-memory-add-orig_pmd-to-struct-vm_fault
+++ a/include/linux/huge_mm.h
@@ -11,7 +11,7 @@ vm_fault_t do_huge_pmd_anonymous_page(st
 int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		  pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
 		  struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma);
-void huge_pmd_set_accessed(struct vm_fault *vmf, pmd_t orig_pmd);
+void huge_pmd_set_accessed(struct vm_fault *vmf);
 int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		  pud_t *dst_pud, pud_t *src_pud, unsigned long addr,
 		  struct vm_area_struct *vma);
@@ -24,7 +24,7 @@ static inline void huge_pud_set_accessed
 }
 #endif
 
-vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf, pmd_t orig_pmd);
+vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf);
 struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
 				   unsigned long addr, pmd_t *pmd,
 				   unsigned int flags);
@@ -288,7 +288,7 @@ struct page *follow_devmap_pmd(struct vm
 struct page *follow_devmap_pud(struct vm_area_struct *vma, unsigned long addr,
 		pud_t *pud, int flags, struct dev_pagemap **pgmap);
 
-vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf, pmd_t orig_pmd);
+vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf);
 
 extern struct page *huge_zero_page;
 extern unsigned long huge_zero_pfn;
@@ -441,8 +441,7 @@ static inline spinlock_t *pud_trans_huge
 	return NULL;
 }
 
-static inline vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf,
-		pmd_t orig_pmd)
+static inline vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
 {
 	return 0;
 }
--- a/include/linux/mm.h~mm-memory-add-orig_pmd-to-struct-vm_fault
+++ a/include/linux/mm.h
@@ -550,7 +550,12 @@ struct vm_fault {
 	pud_t *pud;			/* Pointer to pud entry matching
 					 * the 'address'
 					 */
-	pte_t orig_pte;			/* Value of PTE at the time of fault */
+	union {
+		pte_t orig_pte;		/* Value of PTE at the time of fault */
+		pmd_t orig_pmd;		/* Value of PMD at the time of fault,
+					 * used by PMD fault only.
+					 */
+	};
 
 	struct page *cow_page;		/* Page handler may use for COW fault */
 	struct page *page;		/* ->fault handlers should return a
--- a/mm/huge_memory.c~mm-memory-add-orig_pmd-to-struct-vm_fault
+++ a/mm/huge_memory.c
@@ -1257,11 +1257,12 @@ unlock:
 }
 #endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 
-void huge_pmd_set_accessed(struct vm_fault *vmf, pmd_t orig_pmd)
+void huge_pmd_set_accessed(struct vm_fault *vmf)
 {
 	pmd_t entry;
 	unsigned long haddr;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
+	pmd_t orig_pmd = vmf->orig_pmd;
 
 	vmf->ptl = pmd_lock(vmf->vma->vm_mm, vmf->pmd);
 	if (unlikely(!pmd_same(*vmf->pmd, orig_pmd)))
@@ -1278,11 +1279,12 @@ unlock:
 	spin_unlock(vmf->ptl);
 }
 
-vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf, pmd_t orig_pmd)
+vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct page *page;
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
+	pmd_t orig_pmd = vmf->orig_pmd;
 
 	vmf->ptl = pmd_lockptr(vma->vm_mm, vmf->pmd);
 	VM_BUG_ON_VMA(!vma->anon_vma, vma);
@@ -1418,9 +1420,10 @@ out:
 }
 
 /* NUMA hinting page fault entry point for trans huge pmds */
-vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf, pmd_t pmd)
+vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
+	pmd_t pmd = vmf->orig_pmd;
 	struct anon_vma *anon_vma = NULL;
 	struct page *page;
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
--- a/mm/memory.c~mm-memory-add-orig_pmd-to-struct-vm_fault
+++ a/mm/memory.c
@@ -4298,12 +4298,12 @@ static inline vm_fault_t create_huge_pmd
 }
 
 /* `inline' is required to avoid gcc 4.1.2 build error */
-static inline vm_fault_t wp_huge_pmd(struct vm_fault *vmf, pmd_t orig_pmd)
+static inline vm_fault_t wp_huge_pmd(struct vm_fault *vmf)
 {
 	if (vma_is_anonymous(vmf->vma)) {
-		if (userfaultfd_huge_pmd_wp(vmf->vma, orig_pmd))
+		if (userfaultfd_huge_pmd_wp(vmf->vma, vmf->orig_pmd))
 			return handle_userfault(vmf, VM_UFFD_WP);
-		return do_huge_pmd_wp_page(vmf, orig_pmd);
+		return do_huge_pmd_wp_page(vmf);
 	}
 	if (vmf->vma->vm_ops->huge_fault) {
 		vm_fault_t ret = vmf->vma->vm_ops->huge_fault(vmf, PE_SIZE_PMD);
@@ -4530,26 +4530,26 @@ retry_pud:
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
 	} else {
-		pmd_t orig_pmd = *vmf.pmd;
+		vmf.orig_pmd = *vmf.pmd;
 
 		barrier();
-		if (unlikely(is_swap_pmd(orig_pmd))) {
+		if (unlikely(is_swap_pmd(vmf.orig_pmd))) {
 			VM_BUG_ON(thp_migration_supported() &&
-					  !is_pmd_migration_entry(orig_pmd));
-			if (is_pmd_migration_entry(orig_pmd))
+					  !is_pmd_migration_entry(vmf.orig_pmd));
+			if (is_pmd_migration_entry(vmf.orig_pmd))
 				pmd_migration_entry_wait(mm, vmf.pmd);
 			return 0;
 		}
-		if (pmd_trans_huge(orig_pmd) || pmd_devmap(orig_pmd)) {
-			if (pmd_protnone(orig_pmd) && vma_is_accessible(vma))
-				return do_huge_pmd_numa_page(&vmf, orig_pmd);
+		if (pmd_trans_huge(vmf.orig_pmd) || pmd_devmap(vmf.orig_pmd)) {
+			if (pmd_protnone(vmf.orig_pmd) && vma_is_accessible(vma))
+				return do_huge_pmd_numa_page(&vmf);
 
-			if (dirty && !pmd_write(orig_pmd)) {
-				ret = wp_huge_pmd(&vmf, orig_pmd);
+			if (dirty && !pmd_write(vmf.orig_pmd)) {
+				ret = wp_huge_pmd(&vmf);
 				if (!(ret & VM_FAULT_FALLBACK))
 					return ret;
 			} else {
-				huge_pmd_set_accessed(&vmf, orig_pmd);
+				huge_pmd_set_accessed(&vmf);
 				return 0;
 			}
 		}
_

Patches currently in -mm which might be from shy828301@gmail.com are



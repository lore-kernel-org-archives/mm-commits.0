Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69C2BECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:28:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiILD2W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiILD2H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:28:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D2B1CFE8
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:28:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1359361164
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:28:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61406C433D7;
        Mon, 12 Sep 2022 03:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953284;
        bh=8f5ljzoTm7+ulDs72LME+Z66YDOxQQEnlK47RFewziQ=;
        h=Date:To:From:Subject:From;
        b=MdBn0H8kjc0Yjt7JQnr5IGstiW4OVyMxMEcJRqACPUm0xlluJrM7Ooj/+9zyTcWX6
         e4QXQecIQRnGJVTa9Yg2x+uBQ8px6bfbqeO4aBQzkvvM4Os12bH97Y2xUqkq/fCFOV
         pO5MP8kOBhQ//MCsJ87gv3ws8lryoVxcoiLwIwLc=
Date:   Sun, 11 Sep 2022 20:28:03 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        vbabka@suse.cz, tsbogend@alpha.franken.de, songliubraving@fb.com,
        sj@kernel.org, shy828301@gmail.com, rongwei.wang@linux.alibaba.com,
        rientjes@google.com, peterx@redhat.com, pasha.tatashin@soleen.com,
        minchan@kernel.org, mhocko@suse.com, mattst88@gmail.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jrdr.linux@gmail.com, jcmvbkbc@gmail.com,
        James.Bottomley@HansenPartnership.com, ink@jurassic.park.msu.ru,
        hughd@google.com, deller@gmx.de, david@redhat.com,
        dan.carpenter@oracle.com, ckennelly@google.com, chris@zankel.net,
        axelrasmussen@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        arnd@arndb.de, alex.shi@linux.alibaba.com, aarcange@redhat.com,
        zokeefe@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-thp-add-flag-to-enforce-sysfs-thp-in-hugepage_vma_check.patch removed from -mm tree
Message-Id: <20220912032804.61406C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/thp: add flag to enforce sysfs THP in hugepage_vma_check()
has been removed from the -mm tree.  Its filename was
     mm-thp-add-flag-to-enforce-sysfs-thp-in-hugepage_vma_check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: mm/thp: add flag to enforce sysfs THP in hugepage_vma_check()
Date: Wed, 6 Jul 2022 16:59:25 -0700

MADV_COLLAPSE is not coupled to the kernel-oriented sysfs THP settings[1].

hugepage_vma_check() is the authority on determining if a VMA is eligible
for THP allocation/collapse, and currently enforces the sysfs THP
settings.  Add a flag to disable these checks.  For now, only apply this
arg to anon and file, which use /sys/kernel/transparent_hugepage/enabled. 
We can expand this to shmem, which uses
/sys/kernel/transparent_hugepage/shmem_enabled, later.

Use this flag in collapse_pte_mapped_thp() where previously the VMA flags
passed to hugepage_vma_check() were OR'd with VM_HUGEPAGE to elide the
VM_HUGEPAGE check in "madvise" THP mode.  Prior to "mm: khugepaged: check
THP flag in hugepage_vma_check()", this check also didn't check "never"
THP mode.  As such, this restores the previous behavior of
collapse_pte_mapped_thp() where sysfs THP settings are ignored.  See
comment in code for justification why this is OK.

[1] https://lore.kernel.org/linux-mm/CAAa6QmQxay1_=Pmt8oCX2-Va18t44FV-Vs-WsQt_6+qBks4nZA@mail.gmail.com/

Link: https://lkml.kernel.org/r/20220706235936.2197195-8-zokeefe@google.com
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Kennelly <ckennelly@google.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Souptick Joarder (HPE)" <jrdr.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c      |    2 +-
 include/linux/huge_mm.h |    9 ++++-----
 mm/huge_memory.c        |   14 ++++++--------
 mm/khugepaged.c         |   25 ++++++++++++++-----------
 mm/memory.c             |    4 ++--
 5 files changed, 27 insertions(+), 27 deletions(-)

--- a/fs/proc/task_mmu.c~mm-thp-add-flag-to-enforce-sysfs-thp-in-hugepage_vma_check
+++ a/fs/proc/task_mmu.c
@@ -864,7 +864,7 @@ static int show_smap(struct seq_file *m,
 	__show_smap(m, &mss, false);
 
 	seq_printf(m, "THPeligible:    %d\n",
-		   hugepage_vma_check(vma, vma->vm_flags, true, false));
+		   hugepage_vma_check(vma, vma->vm_flags, true, false, true));
 
 	if (arch_pkeys_enabled())
 		seq_printf(m, "ProtectionKey:  %8u\n", vma_pkey(vma));
--- a/include/linux/huge_mm.h~mm-thp-add-flag-to-enforce-sysfs-thp-in-hugepage_vma_check
+++ a/include/linux/huge_mm.h
@@ -168,9 +168,8 @@ static inline bool file_thp_enabled(stru
 	       !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
 }
 
-bool hugepage_vma_check(struct vm_area_struct *vma,
-			unsigned long vm_flags,
-			bool smaps, bool in_pf);
+bool hugepage_vma_check(struct vm_area_struct *vma, unsigned long vm_flags,
+			bool smaps, bool in_pf, bool enforce_sysfs);
 
 #define transparent_hugepage_use_zero_page()				\
 	(transparent_hugepage_flags &					\
@@ -321,8 +320,8 @@ static inline bool transhuge_vma_suitabl
 }
 
 static inline bool hugepage_vma_check(struct vm_area_struct *vma,
-				       unsigned long vm_flags,
-				       bool smaps, bool in_pf)
+				      unsigned long vm_flags, bool smaps,
+				      bool in_pf, bool enforce_sysfs)
 {
 	return false;
 }
--- a/mm/huge_memory.c~mm-thp-add-flag-to-enforce-sysfs-thp-in-hugepage_vma_check
+++ a/mm/huge_memory.c
@@ -70,9 +70,8 @@ static atomic_t huge_zero_refcount;
 struct page *huge_zero_page __read_mostly;
 unsigned long huge_zero_pfn __read_mostly = ~0UL;
 
-bool hugepage_vma_check(struct vm_area_struct *vma,
-			unsigned long vm_flags,
-			bool smaps, bool in_pf)
+bool hugepage_vma_check(struct vm_area_struct *vma, unsigned long vm_flags,
+			bool smaps, bool in_pf, bool enforce_sysfs)
 {
 	if (!vma->vm_mm)		/* vdso */
 		return false;
@@ -121,11 +120,10 @@ bool hugepage_vma_check(struct vm_area_s
 	if (!in_pf && shmem_file(vma->vm_file))
 		return shmem_huge_enabled(vma);
 
-	if (!hugepage_flags_enabled())
-		return false;
-
-	/* THP settings require madvise. */
-	if (!(vm_flags & VM_HUGEPAGE) && !hugepage_flags_always())
+	/* Enforce sysfs THP requirements as necessary */
+	if (enforce_sysfs &&
+	    (!hugepage_flags_enabled() || (!(vm_flags & VM_HUGEPAGE) &&
+					   !hugepage_flags_always())))
 		return false;
 
 	/* Only regular file is valid */
--- a/mm/khugepaged.c~mm-thp-add-flag-to-enforce-sysfs-thp-in-hugepage_vma_check
+++ a/mm/khugepaged.c
@@ -478,7 +478,7 @@ void khugepaged_enter_vma(struct vm_area
 {
 	if (!test_bit(MMF_VM_HUGEPAGE, &vma->vm_mm->flags) &&
 	    hugepage_flags_enabled()) {
-		if (hugepage_vma_check(vma, vm_flags, false, false))
+		if (hugepage_vma_check(vma, vm_flags, false, false, true))
 			__khugepaged_enter(vma->vm_mm);
 	}
 }
@@ -848,7 +848,8 @@ static bool khugepaged_alloc_page(struct
  */
 
 static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
-		struct vm_area_struct **vmap)
+				   struct vm_area_struct **vmap,
+				   struct collapse_control *cc)
 {
 	struct vm_area_struct *vma;
 
@@ -861,7 +862,8 @@ static int hugepage_vma_revalidate(struc
 
 	if (!transhuge_vma_suitable(vma, address))
 		return SCAN_ADDRESS_RANGE;
-	if (!hugepage_vma_check(vma, vma->vm_flags, false, false))
+	if (!hugepage_vma_check(vma, vma->vm_flags, false, false,
+				cc->is_khugepaged))
 		return SCAN_VMA_CHECK;
 	/*
 	 * Anon VMA expected, the address may be unmapped then
@@ -980,7 +982,7 @@ static int collapse_huge_page(struct mm_
 		goto out_nolock;
 
 	mmap_read_lock(mm);
-	result = hugepage_vma_revalidate(mm, address, &vma);
+	result = hugepage_vma_revalidate(mm, address, &vma, cc);
 	if (result != SCAN_SUCCEED) {
 		mmap_read_unlock(mm);
 		goto out_nolock;
@@ -1012,7 +1014,7 @@ static int collapse_huge_page(struct mm_
 	 * handled by the anon_vma lock + PG_lock.
 	 */
 	mmap_write_lock(mm);
-	result = hugepage_vma_revalidate(mm, address, &vma);
+	result = hugepage_vma_revalidate(mm, address, &vma, cc);
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
 	/* check if the pmd is still valid */
@@ -1360,12 +1362,13 @@ void collapse_pte_mapped_thp(struct mm_s
 		return;
 
 	/*
-	 * This vm_flags may not have VM_HUGEPAGE if the page was not
-	 * collapsed by this mm. But we can still collapse if the page is
-	 * the valid THP. Add extra VM_HUGEPAGE so hugepage_vma_check()
-	 * will not fail the vma for missing VM_HUGEPAGE
+	 * If we are here, we've succeeded in replacing all the native pages
+	 * in the page cache with a single hugepage. If a mm were to fault-in
+	 * this memory (mapped by a suitably aligned VMA), we'd get the hugepage
+	 * and map it by a PMD, regardless of sysfs THP settings. As such, let's
+	 * analogously elide sysfs THP settings here.
 	 */
-	if (!hugepage_vma_check(vma, vma->vm_flags | VM_HUGEPAGE, false, false))
+	if (!hugepage_vma_check(vma, vma->vm_flags, false, false, false))
 		return;
 
 	/* Keep pmd pgtable for uffd-wp; see comment in retract_page_tables() */
@@ -2048,7 +2051,7 @@ static unsigned int khugepaged_scan_mm_s
 			progress++;
 			break;
 		}
-		if (!hugepage_vma_check(vma, vma->vm_flags, false, false)) {
+		if (!hugepage_vma_check(vma, vma->vm_flags, false, false, true)) {
 skip:
 			progress++;
 			continue;
--- a/mm/memory.c~mm-thp-add-flag-to-enforce-sysfs-thp-in-hugepage_vma_check
+++ a/mm/memory.c
@@ -4985,7 +4985,7 @@ static vm_fault_t __handle_mm_fault(stru
 		return VM_FAULT_OOM;
 retry_pud:
 	if (pud_none(*vmf.pud) &&
-	    hugepage_vma_check(vma, vm_flags, false, true)) {
+	    hugepage_vma_check(vma, vm_flags, false, true, true)) {
 		ret = create_huge_pud(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
@@ -5019,7 +5019,7 @@ retry_pud:
 		goto retry_pud;
 
 	if (pmd_none(*vmf.pmd) &&
-	    hugepage_vma_check(vma, vm_flags, false, true)) {
+	    hugepage_vma_check(vma, vm_flags, false, true, true)) {
 		ret = create_huge_pmd(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
_

Patches currently in -mm which might be from zokeefe@google.com are

mm-shmem-add-flag-to-enforce-shmem-thp-in-hugepage_vma_check.patch
mm-khugepaged-attempt-to-map-file-shmem-backed-pte-mapped-thps-by-pmds.patch
mm-madvise-add-file-and-shmem-support-to-madv_collapse.patch
mm-khugepaged-add-tracepoint-to-hpage_collapse_scan_file.patch
selftests-vm-dedup-thp-helpers.patch
selftests-vm-modularize-thp-collapse-memory-operations.patch
selftests-vm-add-thp-collapse-file-and-tmpfs-testing.patch
selftests-vm-add-thp-collapse-shmem-testing.patch
selftests-vm-add-file-shmem-madv_collapse-selftest-for-cleared-pmd.patch
selftests-vm-add-selftest-for-madv_collapse-of-uffd-minor-memory.patch


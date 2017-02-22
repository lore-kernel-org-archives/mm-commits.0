From: akpm@linux-foundation.org
Subject: [patch 138/142] oom-reaper: use madvise_dontneed() logic to
 decide if unmap the VMA
Date: Wed, 22 Feb 2017 15:46:39 -0800
Message-ID: <58ae22df.e4QebUUfOjA7v3Nu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49792 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934239AbdBVXql (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:46:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, peterz@infradead.org, riel@redhat.com

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: oom-reaper: use madvise_dontneed() logic to decide if unmap the VMA

Logic on whether we can reap pages from the VMA should match what we have
in madvise_dontneed().  In particular, we should skip, VM_PFNMAP VMAs, but
we don't now.

Let's just extract condition on which we can shoot down pagesi from a VMA
with MADV_DONTNEED into separate function and use it in both places.

Link: http://lkml.kernel.org/r/20170118122429.43661-4-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    5 +++++
 mm/madvise.c  |    4 +++-
 mm/oom_kill.c |    9 +--------
 3 files changed, 9 insertions(+), 9 deletions(-)

diff -puN mm/internal.h~oom-reaper-use-madvise_dontneed-logic-to-decide-if-unmap-the-vma mm/internal.h
--- a/mm/internal.h~oom-reaper-use-madvise_dontneed-logic-to-decide-if-unmap-the-vma
+++ a/mm/internal.h
@@ -43,6 +43,11 @@ int do_swap_page(struct vm_fault *vmf);
 void free_pgtables(struct mmu_gather *tlb, struct vm_area_struct *start_vma,
 		unsigned long floor, unsigned long ceiling);
 
+static inline bool can_madv_dontneed_vma(struct vm_area_struct *vma)
+{
+	return !(vma->vm_flags & (VM_LOCKED|VM_HUGETLB|VM_PFNMAP));
+}
+
 void unmap_page_range(struct mmu_gather *tlb,
 			     struct vm_area_struct *vma,
 			     unsigned long addr, unsigned long end,
diff -puN mm/madvise.c~oom-reaper-use-madvise_dontneed-logic-to-decide-if-unmap-the-vma mm/madvise.c
--- a/mm/madvise.c~oom-reaper-use-madvise_dontneed-logic-to-decide-if-unmap-the-vma
+++ a/mm/madvise.c
@@ -25,6 +25,8 @@
 
 #include <asm/tlb.h>
 
+#include "internal.h"
+
 /*
  * Any behaviour which results in changes to the vma->vm_flags needs to
  * take mmap_sem for writing. Others, which simply traverse vmas, need
@@ -474,7 +476,7 @@ static long madvise_dontneed(struct vm_a
 			     unsigned long start, unsigned long end)
 {
 	*prev = vma;
-	if (vma->vm_flags & (VM_LOCKED|VM_HUGETLB|VM_PFNMAP))
+	if (!can_madv_dontneed_vma(vma))
 		return -EINVAL;
 
 	madvise_userfault_dontneed(vma, prev, start, end);
diff -puN mm/oom_kill.c~oom-reaper-use-madvise_dontneed-logic-to-decide-if-unmap-the-vma mm/oom_kill.c
--- a/mm/oom_kill.c~oom-reaper-use-madvise_dontneed-logic-to-decide-if-unmap-the-vma
+++ a/mm/oom_kill.c
@@ -508,14 +508,7 @@ static bool __oom_reap_task_mm(struct ta
 
 	tlb_gather_mmu(&tlb, mm, 0, -1);
 	for (vma = mm->mmap ; vma; vma = vma->vm_next) {
-		if (is_vm_hugetlb_page(vma))
-			continue;

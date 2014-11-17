From: akpm@linux-foundation.org
Subject: + mm-fix-huge-zero-page-accounting-in-smaps-report-fix-2.patch
 added to -mm tree
Date: Mon, 17 Nov 2014 13:36:11 -0800
Message-ID: <546a6a4b.KXle2499R/uQ3MaP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51346 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbaKQVgM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Nov 2014 16:36:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-huge-zero-page-accounting-in-smaps-report-fix-2
has been added to the -mm tree.  Its filename is
     mm-fix-huge-zero-page-accounting-in-smaps-report-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-huge-zero-page-accounting-in-smaps-report-fix-2.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-huge-zero-page-accounting-in-smaps-report-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: mm-fix-huge-zero-page-accounting-in-smaps-report-fix-2

fs/proc/task_mmu.c:474 smaps_account() warn: should 'size << 12' be a 64 bit type?

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-fix-huge-zero-page-accounting-in-smaps-report-fix-2 fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-fix-huge-zero-page-accounting-in-smaps-report-fix-2
+++ a/fs/proc/task_mmu.c
@@ -465,17 +465,16 @@ static void smaps_account(struct mem_siz
 			mss->shared_dirty += size;
 		else
 			mss->shared_clean += size;
-		mss->pss += (size << PSS_SHIFT) / mapcount;
+               mss->pss += ((u64)size << PSS_SHIFT) / mapcount;
 	} else {
 		if (dirty || PageDirty(page))
 			mss->private_dirty += size;
 		else
 			mss->private_clean += size;
-		mss->pss += (size << PSS_SHIFT);
+               mss->pss += (u64)size << PSS_SHIFT;
 	}
 }
 
-
 static void smaps_pte_entry(pte_t *pte, unsigned long addr,
 		struct mm_walk *walk)
 {
_

Patches currently in -mm which might be from kirill@shutemov.name are

mm-verify-compound-order-when-freeing-a-page.patch
thp-do-not-mark-zero-page-pmd-write-protected-explicitly.patch
mm-fix-huge-zero-page-accounting-in-smaps-report.patch
mm-fix-huge-zero-page-accounting-in-smaps-report-fix.patch
mm-fix-huge-zero-page-accounting-in-smaps-report-fix-2.patch
mm-embed-the-memcg-pointer-directly-into-struct-page.patch
mm-embed-the-memcg-pointer-directly-into-struct-page-fix.patch
mm-page_cgroup-rename-file-to-mm-swap_cgroupc.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix-2.patch
mmfs-introduce-helpers-around-the-i_mmap_mutex.patch
mm-use-new-helper-functions-around-the-i_mmap_mutex.patch
mm-convert-i_mmap_mutex-to-rwsem.patch
mm-rmap-share-the-i_mmap_rwsem.patch
uprobes-share-the-i_mmap_rwsem.patch
mm-xip-share-the-i_mmap_rwsem.patch
mm-memory-failure-share-the-i_mmap_rwsem.patch
mm-nommu-share-the-i_mmap_rwsem.patch
mm-memoryc-share-the-i_mmap_rwsem.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch


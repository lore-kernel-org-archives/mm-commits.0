From: akpm@linux-foundation.org
Subject: [merged] mm-proc-add-workaround-for-old-compilers.patch removed
 from -mm tree
Date: Thu, 21 Jan 2016 14:58:28 -0800
Message-ID: <56a16294.wf7eZoqpjj4XrQz8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33767 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbcAUW63 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 17:58:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, geert@linux-m68k.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_mmu.c: add workaround for old compilers
has been removed from the -mm tree.  Its filename was
     mm-proc-add-workaround-for-old-compilers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: fs/proc/task_mmu.c: add workaround for old compilers

For THP=n, HPAGE_PMD_NR in smaps_account() expands to BUILD_BUG().  That's
fine since this codepath is eliminated by modern compilers.

But older compilers have not that efficient dead code elimination.  It
causes problem at least with gcc 4.1.2 on m68k:

   fs/built-in.o: In function `smaps_account':
   task_mmu.c:(.text+0x4f8fa): undefined reference to `__compiletime_assert_471'

Let's replace HPAGE_PMD_NR with 1 << compound_order(page).

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~mm-proc-add-workaround-for-old-compilers fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-proc-add-workaround-for-old-compilers
+++ a/fs/proc/task_mmu.c
@@ -468,7 +468,7 @@ struct mem_size_stats {
 static void smaps_account(struct mem_size_stats *mss, struct page *page,
 		bool compound, bool young, bool dirty)
 {
-	int i, nr = compound ? HPAGE_PMD_NR : 1;
+	int i, nr = compound ? 1 << compound_order(page) : 1;
 	unsigned long size = nr * PAGE_SIZE;
 
 	if (PageAnon(page))
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-change-pmd_trans_huge_lock-interface-to-return-ptl.patch
mlocked-pages-statistics-shows-bogus-value.patch
thp-make-split_queue-per-node.patch
thp-change-deferred_split_count-to-return-number-of-thp-in-queue.patch
thp-limit-number-of-object-to-scan-on-deferred_split_scan.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch


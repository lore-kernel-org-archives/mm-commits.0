From: akpm@linux-foundation.org
Subject: [merged]
 mm-avoid-unnecessary-atomic-operations-during-end_page_writeback.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 12:52:53 -0700
Message-ID: <5390ca95.LjAF6rvg5SIR1GoO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56507 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbaFETwy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:52:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mgorman@suse.de

Subject: [merged] mm-avoid-unnecessary-atomic-operations-during-end_page_writeback.patch removed from -mm tree
To: mgorman@suse.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:52:53 -0700


The patch titled
     Subject: mm: avoid unnecessary atomic operations during end_page_writeback()
has been removed from the -mm tree.  Its filename was
     mm-avoid-unnecessary-atomic-operations-during-end_page_writeback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: avoid unnecessary atomic operations during end_page_writeback()

If a page is marked for immediate reclaim then it is moved to the tail of
the LRU list.  This occurs when the system is under enough memory pressure
for pages under writeback to reach the end of the LRU but we test for this
using atomic operations on every writeback.  This patch uses an optimistic
non-atomic test first.  It'll miss some pages in rare cases but the
consequences are not severe enough to warrant such a penalty.

While the function does not dominate profiles during a simple dd test the
cost of it is reduced.

73048     0.7428  vmlinux-3.15.0-rc5-mmotm-20140513 end_page_writeback
23740     0.2409  vmlinux-3.15.0-rc5-lessatomic     end_page_writeback

Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN mm/filemap.c~mm-avoid-unnecessary-atomic-operations-during-end_page_writeback mm/filemap.c
--- a/mm/filemap.c~mm-avoid-unnecessary-atomic-operations-during-end_page_writeback
+++ a/mm/filemap.c
@@ -753,8 +753,17 @@ EXPORT_SYMBOL(unlock_page);
  */
 void end_page_writeback(struct page *page)
 {
-	if (TestClearPageReclaim(page))
+	/*
+	 * TestClearPageReclaim could be used here but it is an atomic
+	 * operation and overkill in this particular case. Failing to
+	 * shuffle a page marked for immediate reclaim is too mild to
+	 * justify taking an atomic operation penalty at the end of
+	 * ever page writeback.
+	 */
+	if (PageReclaim(page)) {
+		ClearPageReclaim(page);
 		rotate_reclaimable_page(page);
+	}
 
 	if (!test_clear_page_writeback(page))
 		BUG();
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-v5.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
linux-next.patch


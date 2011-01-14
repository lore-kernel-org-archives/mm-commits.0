From: akpm@linux-foundation.org
Subject: [merged] thp-enable-direct-defrag.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:48:03 -0800
Message-ID: <201101142250.p0EMorA0005448@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54905 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752926Ab1ANWvF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:51:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     thp: enable direct defrag
has been removed from the -mm tree.  Its filename was
     thp-enable-direct-defrag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: enable direct defrag
From: Andrea Arcangeli <aarcange@redhat.com>

With memory compaction in, and lumpy-reclaim disabled, it seems safe
enough to defrag memory during the (synchronous) transparent hugepage page
faults (TRANSPARENT_HUGEPAGE_DEFRAG_FLAG) and not only during khugepaged
(async) hugepage allocations that was already enabled even before memory
compaction was in (TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG).

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/huge_memory.c~thp-enable-direct-defrag mm/huge_memory.c
--- a/mm/huge_memory.c~thp-enable-direct-defrag
+++ a/mm/huge_memory.c
@@ -28,6 +28,7 @@
  */
 unsigned long transparent_hugepage_flags __read_mostly =
 	(1<<TRANSPARENT_HUGEPAGE_FLAG)|
+	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_FLAG)|
 	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG);
 
 /* default scan 8*512 pte (or vmas) every 30 second */
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch


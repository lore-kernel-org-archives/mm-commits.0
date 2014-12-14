From: akpm@linux-foundation.org
Subject: [merged]
 mm-fadvise-document-the-fadvisefadv_dontneed-behaviour-for-partial-pages.patch removed from -mm tree
Date: Sat, 13 Dec 2014 20:08:24 -0800
Message-ID: <548d0d38.7kBw9SEycCQ/ZU0Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbaLNEIQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:08:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, mtk.manpages@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fadvise: document the fadvise(FADV_DONTNEED) behaviour for partial pages
has been removed from the -mm tree.  Its filename was
     mm-fadvise-document-the-fadvisefadv_dontneed-behaviour-for-partial-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: fadvise: document the fadvise(FADV_DONTNEED) behaviour for partial pages

A random seek IO benchmark appeared to regress because of a change to
readahead but the real problem was the benchmark.  To ensure the IO
request accesssed disk, it used fadvise(FADV_DONTNEED) on a block boundary
(512K) but the hint is ignored by the kernel.  This is correct but not
necessarily obvious behaviour.  As much as I dislike comment patches, the
explanation for this behaviour predates current git history.  Clarify why
it behaves like this in case someone "fixes" fadvise or readahead for the
wrong reasons.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fadvise.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/fadvise.c~mm-fadvise-document-the-fadvisefadv_dontneed-behaviour-for-partial-pages mm/fadvise.c
--- a/mm/fadvise.c~mm-fadvise-document-the-fadvisefadv_dontneed-behaviour-for-partial-pages
+++ a/mm/fadvise.c
@@ -117,7 +117,11 @@ SYSCALL_DEFINE4(fadvise64_64, int, fd, l
 			__filemap_fdatawrite_range(mapping, offset, endbyte,
 						   WB_SYNC_NONE);
 
-		/* First and last FULL page! */
+		/*
+		 * First and last FULL page! Partial pages are deliberately
+		 * preserved on the expectation that it is better to preserve
+		 * needed memory than to discard unneeded memory.
+		 */
 		start_index = (offset+(PAGE_CACHE_SIZE-1)) >> PAGE_CACHE_SHIFT;
 		end_index = (endbyte >> PAGE_CACHE_SHIFT);
 
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation-fix.patch


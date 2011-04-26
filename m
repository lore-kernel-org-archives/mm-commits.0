From: akpm@linux-foundation.org
Subject: + readahead-return-early-when-readahead-is-disabled.patch added to -mm tree
Date: Tue, 26 Apr 2011 14:03:42 -0700
Message-ID: <201104262103.p3QL3g7T019024@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754071Ab1DZVDo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Apr 2011 17:03:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, ak@linux.intel.com, tim.c.chen@intel.com


The patch titled
     readahead: return early when readahead is disabled
has been added to the -mm tree.  Its filename is
     readahead-return-early-when-readahead-is-disabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: readahead: return early when readahead is disabled
From: Wu Fengguang <fengguang.wu@intel.com>

Reduce readahead overheads by returning early in do_sync_mmap_readahead().

tmpfs has ra_pages=0 and it can page fault really fast (not constraint by
IO if not swapping).

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Tested-by: Tim Chen <tim.c.chen@intel.com>
Reported-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/filemap.c~readahead-return-early-when-readahead-is-disabled mm/filemap.c
--- a/mm/filemap.c~readahead-return-early-when-readahead-is-disabled
+++ a/mm/filemap.c
@@ -1567,6 +1567,8 @@ static void do_sync_mmap_readahead(struc
 	/* If we don't want any read-ahead, don't bother */
 	if (VM_RandomReadHint(vma))
 		return;
+	if (!ra->ra_pages)
+		return;
 
 	if (VM_SequentialReadHint(vma) ||
 			offset - 1 == (ra->prev_pos >> PAGE_CACHE_SHIFT)) {
@@ -1589,12 +1591,10 @@ static void do_sync_mmap_readahead(struc
 	 * mmap read-around
 	 */
 	ra_pages = max_sane_readahead(ra->ra_pages);
-	if (ra_pages) {
-		ra->start = max_t(long, 0, offset - ra_pages/2);
-		ra->size = ra_pages;
-		ra->async_size = 0;
-		ra_submit(ra, mapping, file);
-	}
+	ra->start = max_t(long, 0, offset - ra_pages / 2);
+	ra->size = ra_pages;
+	ra->async_size = 0;
+	ra_submit(ra, mapping, file);
 }
 
 /*
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

mm-per-node-vmstat-show-proper-vmstats.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
writeback-pass-writeback_control-down-to-move_expired_inodes.patch
writeback-introduce-writeback_controlinodes_cleaned.patch
writeback-try-more-writeback-as-long-as-something-was-written.patch
writeback-the-kupdate-expire-timestamp-should-be-a-moving-target.patch
writeback-sync-expired-inodes-first-in-background-writeback.patch
writeback-sync-expired-inodes-first-in-background-writeback-fix.patch
writeback-refill-b_io-iff-empty.patch
readahead-readahead-page-allocations-are-ok-to-fail.patch
readahead-return-early-when-readahead-is-disabled.patch
readahead-reduce-unnecessary-mmap_miss-increases.patch
readahead-trigger-mmap-sequential-readahead-on-pg_readahead.patch


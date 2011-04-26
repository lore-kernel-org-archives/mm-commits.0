From: akpm@linux-foundation.org
Subject: + readahead-trigger-mmap-sequential-readahead-on-pg_readahead.patch added to -mm tree
Date: Tue, 26 Apr 2011 14:03:46 -0700
Message-ID: <201104262103.p3QL3kxR019052@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57443 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754071Ab1DZVDs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Apr 2011 17:03:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, ak@linux.intel.com, tim.c.chen@intel.com


The patch titled
     readahead: trigger mmap sequential readahead on PG_readahead
has been added to the -mm tree.  Its filename is
     readahead-trigger-mmap-sequential-readahead-on-pg_readahead.patch

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
Subject: readahead: trigger mmap sequential readahead on PG_readahead
From: Wu Fengguang <fengguang.wu@intel.com>

Previously the mmap sequential readahead is triggered by updating
ra->prev_pos on each page fault and compare it with current page offset.

In the mosbench exim benchmark which does multi-threaded page faults on
shared struct file, the ra->mmap_miss and ra->prev_pos updates are found
to cause excessive cache line bouncing on tmpfs, which actually disabled
readahead totally (shmem_backing_dev_info.ra_pages == 0).

So remove the ra->prev_pos recording, and instead tag PG_readahead to
trigger the possible sequential readahead.  It's not only more simple, but
also will work more reliably on concurrent reads on shared struct file.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Tested-by: Tim Chen <tim.c.chen@intel.com>
Reported-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/filemap.c~readahead-trigger-mmap-sequential-readahead-on-pg_readahead mm/filemap.c
--- a/mm/filemap.c~readahead-trigger-mmap-sequential-readahead-on-pg_readahead
+++ a/mm/filemap.c
@@ -1570,8 +1570,7 @@ static void do_sync_mmap_readahead(struc
 	if (!ra->ra_pages)
 		return;
 
-	if (VM_SequentialReadHint(vma) ||
-			offset - 1 == (ra->prev_pos >> PAGE_CACHE_SHIFT)) {
+	if (VM_SequentialReadHint(vma)) {
 		page_cache_sync_readahead(mapping, ra, file, offset,
 					  ra->ra_pages);
 		return;
@@ -1594,7 +1593,7 @@ static void do_sync_mmap_readahead(struc
 	ra_pages = max_sane_readahead(ra->ra_pages);
 	ra->start = max_t(long, 0, offset - ra_pages / 2);
 	ra->size = ra_pages;
-	ra->async_size = 0;
+	ra->async_size = ra_pages / 4;
 	ra_submit(ra, mapping, file);
 }
 
@@ -1700,7 +1699,6 @@ retry_find:
 		return VM_FAULT_SIGBUS;
 	}
 
-	ra->prev_pos = (loff_t)offset << PAGE_CACHE_SHIFT;
 	vmf->page = page;
 	return ret | VM_FAULT_LOCKED;
 
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


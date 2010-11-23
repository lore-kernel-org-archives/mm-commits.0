From: akpm@linux-foundation.org
Subject: + mm-clear-pageerror-bit-in-msync-fsync.patch added to -mm tree
Date: Mon, 22 Nov 2010 16:49:42 -0800
Message-ID: <201011230049.oAN0ng2s018706@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46885 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932424Ab0KWAu3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Nov 2010 19:50:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, jack@suse.cz, jlayton@redhat.com, tytso@mit.edu, vaurora@redhat.com


The patch titled
     mm: clear PageError bit in msync & fsync
has been added to the -mm tree.  Its filename is
     mm-clear-pageerror-bit-in-msync-fsync.patch

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
Subject: mm: clear PageError bit in msync & fsync
From: Rik van Riel <riel@redhat.com>

Temporary IO failures, eg.  due to loss of both multipath paths, can
permanently leave the PageError bit set on a page, resulting in msync or
fsync returning -EIO over and over again, even if IO is now getting to the
disk correctly.

We already clear the AS_ENOSPC and AS_IO bits in mapping->flags in the
filemap_fdatawait_range function.  Also clearing the PageError bit on the
page allows subsequent msync or fsync calls on this file to return without
an error, if the subsequent IO succeeds.

Unfortunately data written out in the msync or fsync call that returned
-EIO can still get lost, because the page dirty bit appears to not get
restored on IO error.  However, the alternative could be potentially all
of memory filling up with uncleanable dirty pages, hanging the system, so
there is no nice choice here...

Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Valerie Aurora <vaurora@redhat.com>
Acked-by: Jeff Layton <jlayton@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 +-
 mm/filemap.c               |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/page-flags.h~mm-clear-pageerror-bit-in-msync-fsync include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-clear-pageerror-bit-in-msync-fsync
+++ a/include/linux/page-flags.h
@@ -198,7 +198,7 @@ static inline int __TestClearPage##uname
 struct page;	/* forward declaration */
 
 TESTPAGEFLAG(Locked, locked) TESTSETFLAG(Locked, locked)
-PAGEFLAG(Error, error)
+PAGEFLAG(Error, error) TESTCLEARFLAG(Error, error)
 PAGEFLAG(Referenced, referenced) TESTCLEARFLAG(Referenced, referenced)
 PAGEFLAG(Dirty, dirty) TESTSCFLAG(Dirty, dirty) __CLEARPAGEFLAG(Dirty, dirty)
 PAGEFLAG(LRU, lru) __CLEARPAGEFLAG(LRU, lru)
diff -puN mm/filemap.c~mm-clear-pageerror-bit-in-msync-fsync mm/filemap.c
--- a/mm/filemap.c~mm-clear-pageerror-bit-in-msync-fsync
+++ a/mm/filemap.c
@@ -307,7 +307,7 @@ int filemap_fdatawait_range(struct addre
 				continue;
 
 			wait_on_page_writeback(page);
-			if (PageError(page))
+			if (TestClearPageError(page))
 				ret = -EIO;
 		}
 		pagevec_release(&pvec);
_

Patches currently in -mm which might be from riel@redhat.com are

linux-next.patch
writeback-io-less-balance_dirty_pages.patch
writeback-consolidate-variable-names-in-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages-fix.patch
writeback-prevent-duplicate-balance_dirty_pages_ratelimited-calls.patch
writeback-account-per-bdi-accumulated-written-pages.patch
writeback-bdi-write-bandwidth-estimation.patch
writeback-bdi-write-bandwidth-estimation-fix.patch
writeback-show-bdi-write-bandwidth-in-debugfs.patch
writeback-quit-throttling-when-bdi-dirty-pages-dropped-low.patch
writeback-reduce-per-bdi-dirty-threshold-ramp-up-time.patch
writeback-make-reasonable-gap-between-the-dirty-background-thresholds.patch
writeback-scale-down-max-throttle-bandwidth-on-concurrent-dirtiers.patch
writeback-add-trace-event-for-balance_dirty_pages.patch
writeback-make-nr_to_write-a-per-file-limit.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
mm-compaction-add-trace-events-for-memory-compaction-activity.patch
mm-vmscan-convert-lumpy_mode-into-a-bitmask.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path.patch
mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync.patch
mm-compaction-perform-a-faster-migration-scan-when-migrating-asynchronously.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode.patch
mm-deactivate-invalidated-pages.patch
mm-deactivate-invalidated-pages-fix.patch
oom-allow-a-non-cap_sys_resource-proces-to-oom_score_adj-down.patch
mm-clear-pageerror-bit-in-msync-fsync.patch


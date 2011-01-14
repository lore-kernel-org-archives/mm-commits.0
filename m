From: akpm@linux-foundation.org
Subject: [merged] mm-clear-pageerror-bit-in-msync-fsync.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:45:14 -0800
Message-ID: <201101142248.p0EMm4LM005083@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39038 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752912Ab1ANWsQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:48:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, jack@suse.cz, jlayton@redhat.com, tytso@mit.edu, vaurora@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: clear PageError bit in msync & fsync
has been removed from the -mm tree.  Its filename was
     mm-clear-pageerror-bit-in-msync-fsync.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -298,7 +298,7 @@ int filemap_fdatawait_range(struct addre
 				continue;
 
 			wait_on_page_writeback(page);
-			if (PageError(page))
+			if (TestClearPageError(page))
 				ret = -EIO;
 		}
 		pagevec_release(&pvec);
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
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
mm-deactivate-invalidated-pages.patch
mm-deactivate-invalidated-pages-fix.patch


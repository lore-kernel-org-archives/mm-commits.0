From: akpm@linux-foundation.org
Subject: - mm-write_cache_pages-integrity-fix.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:11:35 -0800
Message-ID: <200901072211.n07MBZuG011890@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754118AbZAGWLo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:11:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, chris.mason@oracle.com, david@fromorbit.com, mm-commits@vger.kernel.org


The patch titled
     mm: write_cache_pages integrity fix
has been removed from the -mm tree.  Its filename was
     mm-write_cache_pages-integrity-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: write_cache_pages integrity fix
From: Nick Piggin <npiggin@suse.de>

In write_cache_pages, nr_to_write is heeded even for data-integrity syncs,
so the function will return success after writing out nr_to_write pages,
even if that was not sufficient to guarantee data integrity.

The callers tend to set it to values that could break data interity
semantics easily in practice.  For example, nr_to_write can be set to
mapping->nr_pages * 2, however if a file has a single, dirty page, then
fsync is called, subsequent pages might be concurrently added and dirtied,
then write_cache_pages might writeout two of these newly dirty pages,
while not writing out the old page that should have been written out.

Fix this by ignoring nr_to_write if it is a data integrity sync.

This is a data integrity bug.

The reason this has been done in the past is to avoid stalling sync
operations behind page dirtiers.

 "If a file has one dirty page at offset 1000000000000000 then someone
  does an fsync() and someone else gets in first and starts madly writing
  pages at offset 0, we want to write that page at 1000000000000000. 
  Somehow."

What we do today is return success after an arbitrary amount of pages are
written, whether or not we have provided the data-integrity semantics that
the caller has asked for.  Even this doesn't actually fix all stall cases
completely: in the above situation, if the file has a huge number of pages
in pagecache (but not dirty), then mapping->nrpages is going to be huge,
even if pages are being dirtied.

This change does indeed make the possibility of long stalls lager, and
that's not a good thing, but lying about data integrity is even worse.  We
have to either perform the sync, or return -ELINUXISLAME so at least the
caller knows what has happened.

There are subsequent competing approaches in the works to solve the stall
problems properly, without compromising data integrity.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c        |    2 +-
 mm/page-writeback.c |    6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN mm/filemap.c~mm-write_cache_pages-integrity-fix mm/filemap.c
--- a/mm/filemap.c~mm-write_cache_pages-integrity-fix
+++ a/mm/filemap.c
@@ -210,7 +210,7 @@ int __filemap_fdatawrite_range(struct ad
 	int ret;
 	struct writeback_control wbc = {
 		.sync_mode = sync_mode,
-		.nr_to_write = mapping->nrpages * 2,
+		.nr_to_write = LONG_MAX,
 		.range_start = start,
 		.range_end = end,
 	};
diff -puN mm/page-writeback.c~mm-write_cache_pages-integrity-fix mm/page-writeback.c
--- a/mm/page-writeback.c~mm-write_cache_pages-integrity-fix
+++ a/mm/page-writeback.c
@@ -963,8 +963,10 @@ retry:
 				}
  			}
 
-			if (--nr_to_write <= 0)
-				done = 1;
+			if (wbc->sync_mode == WB_SYNC_NONE) {
+				if (--wbc->nr_to_write <= 0)
+					done = 1;
+			}
 			if (wbc->nonblocking && bdi_write_congested(bdi)) {
 				wbc->encountered_congestion = 1;
 				done = 1;
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
radix-tree-gang-set-if-tagged-operation.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch


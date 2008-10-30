From: akpm@linux-foundation.org
Subject: + mm-write_cache_pages-integrity-fix.patch added to -mm tree
Date: Thu, 30 Oct 2008 16:14:36 -0700
Message-ID: <200810302314.m9UNEagZ027523@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754387AbYJ3XPQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 19:15:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, chris.mason@oracle.com, david@fromorbit.com, jowens@hp.com


The patch titled
     mm: write_cache_pages integrity fix
has been added to the -mm tree.  Its filename is
     mm-write_cache_pages-integrity-fix.patch

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
Cc: jim owens <jowens@hp.com>
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

mm-increase-the-default-mlock-limit-from-32k-to-64k.patch
fs-remove-prepare_write-commit_write.patch
linux-next.patch
mm-dont-mark_page_accessed-in-fault-path.patch
mm-invoke-oom-killer-from-page-fault.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-cyclic-fix.patch
mm-write_cache_pages-cyclic-fix-fix.patch
mm-write_cache_pages-early-loop-termination.patch
mm-write_cache_pages-writepage-error-fix.patch
mm-write_cache_pages-integrity-fix.patch
mm-write_cache_pages-cleanups.patch
mm-write_cache_pages-optimise-page-cleaning.patch
mm-write_cache_pages-terminate-quickly.patch
mm-write_cache_pages-more-terminate-quickly.patch
mm-do_sync_mapping_range-integrity-fix.patch
reiser4.patch


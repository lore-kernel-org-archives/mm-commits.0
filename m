From: akpm@linux-foundation.org
Subject: - knfsd-stop-nfsd-writes-from-being-broken-into-lots-of-little-writes-to-filesystem.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:16:30 -0800
Message-ID: <200702170716.l1H7GU6r021707@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51146 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946503AbXBQHQn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:16:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, nickpiggin@yahoo.com.au, norman.r.weathers@conocophillips.com, vs@namesys.com, mm-commits@vger.kernel.org


The patch titled
     knfsd: stop NFSD writes from being broken into lots of little writes to filesystem
has been removed from the -mm tree.  Its filename was
     knfsd-stop-nfsd-writes-from-being-broken-into-lots-of-little-writes-to-filesystem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: stop NFSD writes from being broken into lots of little writes to filesystem
From: NeilBrown <neilb@suse.de>

When NFSD receives a write request, the data is typically in a number of
1448 byte segments and writev is used to collect them together.

Unfortunately, generic_file_buffered_write passes these to the filesystem
one at a time, so an e.g.  32K over-write becomes a series of partial-page
writes to each page, causing the filesystem to have to pre-read those pages
- wasted effort.

generic_file_buffered_write handles one segment of the vector at a time as
it has to pre-fault in each segment to avoid deadlocks.  When writing from
kernel-space (and nfsd does) this is not an issue, so
generic_file_buffered_write does not need to break and iovec from nfsd into
little pieces.

This patch avoids the splitting when  get_fs is KERNEL_DS as it is
from NFSd.

This issue was introduced by commit 6527c2bdf1f833cc18e8f42bd97973d583e4aa83

Acked-by: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Norman Weathers <norman.r.weathers@conocophillips.com>
Cc: Vladimir V. Saveliev <vs@namesys.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff -puN mm/filemap.c~knfsd-stop-nfsd-writes-from-being-broken-into-lots-of-little-writes-to-filesystem mm/filemap.c
--- a/mm/filemap.c~knfsd-stop-nfsd-writes-from-being-broken-into-lots-of-little-writes-to-filesystem
+++ a/mm/filemap.c
@@ -2079,21 +2079,27 @@ generic_file_buffered_write(struct kiocb
 		/* Limit the size of the copy to the caller's write size */
 		bytes = min(bytes, count);
 
-		/*
-		 * Limit the size of the copy to that of the current segment,
-		 * because fault_in_pages_readable() doesn't know how to walk
-		 * segments.
+		/* We only need to worry about prefaulting when writes are from
+		 * user-space.  NFSd uses vfs_writev with several non-aligned
+		 * segments in the vector, and limiting to one segment a time is
+		 * a noticeable performance for re-write
 		 */
-		bytes = min(bytes, cur_iov->iov_len - iov_base);
-
-		/*
-		 * Bring in the user page that we will copy from _first_.
-		 * Otherwise there's a nasty deadlock on copying from the
-		 * same page as we're writing to, without it being marked
-		 * up-to-date.
-		 */
-		fault_in_pages_readable(buf, bytes);
+		if (!segment_eq(get_fs(), KERNEL_DS)) {
+			/*
+			 * Limit the size of the copy to that of the current
+			 * segment, because fault_in_pages_readable() doesn't
+			 * know how to walk segments.
+			 */
+			bytes = min(bytes, cur_iov->iov_len - iov_base);
 
+			/*
+			 * Bring in the user page that we will copy from
+			 * _first_.  Otherwise there's a nasty deadlock on
+			 * copying from the same page as we're writing to,
+			 * without it being marked up-to-date.
+			 */
+			fault_in_pages_readable(buf, bytes);
+		}
 		page = __grab_cache_page(mapping,index,&cached_page,&lru_pvec);
 		if (!page) {
 			status = -ENOMEM;
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
fix-build-errors-if-bitop-functions-are-do-while-macros.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
replace-highest_possible_node_id-with-nr_node_ids.patch
convert-highest_possible_processor_id-to-nr_cpu_ids.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
lockdep-annotate-blkpg_del_partition.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch

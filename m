From: akpm@linux-foundation.org
Subject: + readahead-record-mmap-read-around-states-in-file_ra_state.patch added to -mm tree
Date: Fri, 10 Apr 2009 16:40:30 -0700
Message-ID: <200904102340.n3ANeUVF021809@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751259AbZDJXn4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 19:43:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, npiggin@suse.de, torvalds@linux-foundation.org, wfg@mail.ustc.edu.cn, yinghan@google.com


The patch titled
     readahead: record mmap read-around states in file_ra_state
has been added to the -mm tree.  Its filename is
     readahead-record-mmap-read-around-states-in-file_ra_state.patch

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
Subject: readahead: record mmap read-around states in file_ra_state
From: Wu Fengguang <fengguang.wu@intel.com>

Mmap read-around now shares the same code style and data structure with
readahead code.

This also removes do_page_cache_readahead().  Its last user, mmap
read-around, has been changed to call ra_submit().

The no-readahead-if-congested logic is dumped by the way.  Users will be
pretty sensitive about the slow loading of executables.  So it's
unfavorable to disabled mmap read-around on a congested queue.

Cc: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    5 +++--
 mm/filemap.c       |   12 +++++++-----
 mm/readahead.c     |   23 ++---------------------
 3 files changed, 12 insertions(+), 28 deletions(-)

diff -puN include/linux/mm.h~readahead-record-mmap-read-around-states-in-file_ra_state include/linux/mm.h
--- a/include/linux/mm.h~readahead-record-mmap-read-around-states-in-file_ra_state
+++ a/include/linux/mm.h
@@ -1181,8 +1181,6 @@ void task_dirty_inc(struct task_struct *
 #define VM_MAX_READAHEAD	128	/* kbytes */
 #define VM_MIN_READAHEAD	16	/* kbytes (includes current page) */
 
-int do_page_cache_readahead(struct address_space *mapping, struct file *filp,
-			pgoff_t offset, unsigned long nr_to_read);
 int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
 			pgoff_t offset, unsigned long nr_to_read);
 
@@ -1200,6 +1198,9 @@ void page_cache_async_readahead(struct a
 				unsigned long size);
 
 unsigned long max_sane_readahead(unsigned long nr);
+unsigned long ra_submit(struct file_ra_state *ra,
+		        struct address_space *mapping,
+			struct file *filp);
 
 /* Do stack extension */
 extern int expand_stack(struct vm_area_struct *vma, unsigned long address);
diff -puN mm/filemap.c~readahead-record-mmap-read-around-states-in-file_ra_state mm/filemap.c
--- a/mm/filemap.c~readahead-record-mmap-read-around-states-in-file_ra_state
+++ a/mm/filemap.c
@@ -1487,13 +1487,15 @@ static void do_sync_mmap_readahead(struc
 	if (ra->mmap_miss > MMAP_LOTSAMISS)
 		return;
 
+	/*
+	 * mmap read-around
+	 */
 	ra_pages = max_sane_readahead(ra->ra_pages);
 	if (ra_pages) {
-		pgoff_t start = 0;
-
-		if (offset > ra_pages / 2)
-			start = offset - ra_pages / 2;
-		do_page_cache_readahead(mapping, file, start, ra_pages);
+		ra->start = max_t(long, 0, offset - ra_pages/2);
+		ra->size = ra_pages;
+		ra->async_size = 0;
+		ra_submit(ra, mapping, file);
 	}
 }
 
diff -puN mm/readahead.c~readahead-record-mmap-read-around-states-in-file_ra_state mm/readahead.c
--- a/mm/readahead.c~readahead-record-mmap-read-around-states-in-file_ra_state
+++ a/mm/readahead.c
@@ -133,15 +133,12 @@ out:
 }
 
 /*
- * do_page_cache_readahead actually reads a chunk of disk.  It allocates all
+ * __do_page_cache_readahead() actually reads a chunk of disk.  It allocates all
  * the pages first, then submits them all for I/O. This avoids the very bad
  * behaviour which would occur if page allocations are causing VM writeback.
  * We really don't want to intermingle reads and writes like that.
  *
  * Returns the number of pages requested, or the maximum amount of I/O allowed.
- *
- * do_page_cache_readahead() returns -1 if it encountered request queue
- * congestion.
  */
 static int
 __do_page_cache_readahead(struct address_space *mapping, struct file *filp,
@@ -232,22 +229,6 @@ int force_page_cache_readahead(struct ad
 }
 
 /*
- * This version skips the IO if the queue is read-congested, and will tell the
- * block layer to abandon the readahead if request allocation would block.
- *
- * force_page_cache_readahead() will ignore queue congestion and will block on
- * request queues.
- */
-int do_page_cache_readahead(struct address_space *mapping, struct file *filp,
-			pgoff_t offset, unsigned long nr_to_read)
-{
-	if (bdi_read_congested(mapping->backing_dev_info))
-		return -1;
-
-	return __do_page_cache_readahead(mapping, filp, offset, nr_to_read, 0);
-}
-
-/*
  * Given a desired number of PAGE_CACHE_SIZE readahead pages, return a
  * sensible upper limit.
  */
@@ -260,7 +241,7 @@ unsigned long max_sane_readahead(unsigne
 /*
  * Submit IO for the read-ahead request in file_ra_state.
  */
-static unsigned long ra_submit(struct file_ra_state *ra,
+unsigned long ra_submit(struct file_ra_state *ra,
 		       struct address_space *mapping, struct file *filp)
 {
 	int actual;
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
readahead-make-mmap_miss-an-unsigned-int.patch
readahead-move-max_sane_readahead-calls-into-force_page_cache_readahead.patch
readahead-apply-max_sane_readahead-limit-in-ondemand_readahead.patch
readahead-remove-one-unnecessary-radix-tree-lookup.patch
readahead-increase-interleaved-readahead-size.patch
readahead-remove-sync-async-readahead-call-dependency.patch
readahead-clean-up-and-simplify-the-code-for-filemap-page-fault-readahead.patch
readahead-sequential-mmap-readahead.patch
readahead-enforce-full-readahead-size-on-async-mmap-readahead.patch
readahead-record-mmap-read-around-states-in-file_ra_state.patch


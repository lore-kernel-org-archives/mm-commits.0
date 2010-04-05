From: akpm@linux-foundation.org
Subject: + ntfs-use-add_to_page_cache_lru.patch added to -mm tree
Date: Mon, 05 Apr 2010 14:49:08 -0700
Message-ID: <201004052149.o35Ln9nL011063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43572 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756434Ab0DEVtq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Apr 2010 17:49:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, aia21@cantab.net, nickpiggin@yahoo.com.au


The patch titled
     ntfs: use add_to_page_cache_lru()
has been added to the -mm tree.  Its filename is
     ntfs-use-add_to_page_cache_lru.patch

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
Subject: ntfs: use add_to_page_cache_lru()
From: Minchan Kim <minchan.kim@gmail.com>

Quote from Nick piggin's about btrfs patch
- http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg04472.html.

"add_to_page_cache_lru is exported, so it should be used. Benefits over
using a private pagevec: neater code, 128 bytes fewer stack used, percpu
lru ordering is preserved, and finally don't need to flush pagevec
before returning so batching may be shared with other LRU insertions."

Let's use it instead of private pagevec in ntfs, too.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Anton Altaparmakov <aia21@cantab.net>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/file.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff -puN fs/ntfs/file.c~ntfs-use-add_to_page_cache_lru fs/ntfs/file.c
--- a/fs/ntfs/file.c~ntfs-use-add_to_page_cache_lru
+++ a/fs/ntfs/file.c
@@ -399,18 +399,13 @@ static inline void ntfs_fault_in_pages_r
  * Obtain @nr_pages locked page cache pages from the mapping @mapping and
  * starting at index @index.
  *
- * If a page is newly created, increment its refcount and add it to the
- * caller's lru-buffering pagevec @lru_pvec.
- *
- * This is the same as mm/filemap.c::__grab_cache_page(), except that @nr_pages
- * are obtained at once instead of just one page and that 0 is returned on
- * success and -errno on error.
+ * If a page is newly created, add it to lru list
  *
  * Note, the page locks are obtained in ascending page index order.
  */
 static inline int __ntfs_grab_cache_pages(struct address_space *mapping,
 		pgoff_t index, const unsigned nr_pages, struct page **pages,
-		struct page **cached_page, struct pagevec *lru_pvec)
+		struct page **cached_page)
 {
 	int err, nr;
 
@@ -426,7 +421,7 @@ static inline int __ntfs_grab_cache_page
 					goto err_out;
 				}
 			}
-			err = add_to_page_cache(*cached_page, mapping, index,
+			err = add_to_page_cache_lru(*cached_page, mapping, index,
 					GFP_KERNEL);
 			if (unlikely(err)) {
 				if (err == -EEXIST)
@@ -434,9 +429,6 @@ static inline int __ntfs_grab_cache_page
 				goto err_out;
 			}
 			pages[nr] = *cached_page;
-			page_cache_get(*cached_page);
-			if (unlikely(!pagevec_add(lru_pvec, *cached_page)))
-				__pagevec_lru_add_file(lru_pvec);
 			*cached_page = NULL;
 		}
 		index++;
@@ -1796,7 +1788,6 @@ static ssize_t ntfs_file_buffered_write(
 	ssize_t status, written;
 	unsigned nr_pages;
 	int err;
-	struct pagevec lru_pvec;
 
 	ntfs_debug("Entering for i_ino 0x%lx, attribute type 0x%x, "
 			"pos 0x%llx, count 0x%lx.",
@@ -1908,7 +1899,6 @@ static ssize_t ntfs_file_buffered_write(
 			}
 		}
 	}
-	pagevec_init(&lru_pvec, 0);
 	written = 0;
 	/*
 	 * If the write starts beyond the initialized size, extend it up to the
@@ -2007,7 +1997,7 @@ static ssize_t ntfs_file_buffered_write(
 			ntfs_fault_in_pages_readable_iovec(iov, iov_ofs, bytes);
 		/* Get and lock @do_pages starting at index @start_idx. */
 		status = __ntfs_grab_cache_pages(mapping, start_idx, do_pages,
-				pages, &cached_page, &lru_pvec);
+				pages, &cached_page);
 		if (unlikely(status))
 			break;
 		/*
@@ -2072,7 +2062,6 @@ err_out:
 	*ppos = pos;
 	if (cached_page)
 		page_cache_release(cached_page);
-	pagevec_lru_add_file(&lru_pvec);
 	ntfs_debug("Done.  Returning %s (written 0x%lx, status %li).",
 			written ? "written" : "status", (unsigned long)written,
 			(long)status);
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

rmap-fix-anon_vma_fork-memory-leak.patch
exit-fix-oops-in-sync_mm_rss.patch
exit-fix-oops-in-sync_mm_rss-fix.patch
mm-revert-vmscan-get_scan_ratio-cleanup.patch
ntfs-clean-up-ntfs_attr_extend_initialized.patch
ntfs-use-add_to_page_cache_lru.patch
shmem-remove-redundant-code.patch
mm-remove-return-value-of-putback_lru_pages.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
oom-select-task-from-tasklist-for-mempolicy-ooms.patch
oom-remove-special-handling-for-pagefault-ooms.patch
oom-badness-heuristic-rewrite.patch
oom-deprecate-oom_adj-tunable.patch
oom-replace-sysctls-with-quick-mode.patch
oom-avoid-oom-killer-for-lowmem-allocations.patch
oom-remove-unnecessary-code-and-cleanup.patch
oom-default-to-killing-current-for-pagefault-ooms.patch
oom-avoid-race-for-oom-killed-tasks-detaching-mm-prior-to-exit.patch


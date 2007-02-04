From: akpm@linux-foundation.org
Subject: - mm-fix-pagecache-write-deadlocks-mm-pagecache-write-deadlocks-efault-fix.patch removed from -mm tree
Date: Sun, 04 Feb 2007 01:08:00 -0800
Message-ID: <200702040908.l14980Z7026142@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34083 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246AbXBDJIL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 4 Feb 2007 04:08:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, pbadari@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     mm: pagecache write deadlocks EFAULT fix
has been removed from the -mm tree.  Its filename was
     mm-fix-pagecache-write-deadlocks-mm-pagecache-write-deadlocks-efault-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: mm: pagecache write deadlocks EFAULT fix
From: Nick Piggin <npiggin@suse.de>

Fix buffered writes to handle -EFAULT properly.

Also, pass 'seglen' rather than 'bytes' to fault_in_pages_readable in the
DEBUG_VM case, which matches !DEBUG_VM and is the correct thing to do.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-by: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/pagemap.h |    5 +++--
 mm/filemap.c            |   12 ++++++++++--
 2 files changed, 13 insertions(+), 4 deletions(-)

diff -puN include/linux/pagemap.h~mm-fix-pagecache-write-deadlocks-mm-pagecache-write-deadlocks-efault-fix include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-fix-pagecache-write-deadlocks-mm-pagecache-write-deadlocks-efault-fix
+++ a/include/linux/pagemap.h
@@ -217,7 +217,7 @@ static inline int fault_in_pages_writeab
 	return ret;
 }
 
-static inline void fault_in_pages_readable(const char __user *uaddr, int size)
+static inline int fault_in_pages_readable(const char __user *uaddr, int size)
 {
 	volatile char c;
 	int ret;
@@ -228,8 +228,9 @@ static inline void fault_in_pages_readab
 
 		if (((unsigned long)uaddr & PAGE_MASK) !=
 				((unsigned long)end & PAGE_MASK))
-		 	__get_user(c, end);
+		 	ret = __get_user(c, end);
 	}
+	return ret;
 }
 
 #endif /* _LINUX_PAGEMAP_H */
diff -puN mm/filemap.c~mm-fix-pagecache-write-deadlocks-mm-pagecache-write-deadlocks-efault-fix mm/filemap.c
--- a/mm/filemap.c~mm-fix-pagecache-write-deadlocks-mm-pagecache-write-deadlocks-efault-fix
+++ a/mm/filemap.c
@@ -2110,8 +2110,14 @@ retry_noprogress:
 		 * Bring in the user page that we will copy from _first_, this
 		 * minimises the chance we have to break into the slowpath
 		 * below.
+		 *
+		 * Must check for -EFAULT here, because an unhandled pagefault
+		 * from the atomic copy below may not actually be due to an
+		 * unmapped user region.
 		 */
-		fault_in_pages_readable(buf, seglen);
+		status = fault_in_pages_readable(buf, seglen);
+		if (unlikely(status))
+			break;
 #endif
 
 		page = __grab_cache_page(mapping,index,&cached_page,&lru_pvec);
@@ -2202,7 +2208,9 @@ retry_noprogress:
 			}
 		} else {
 #ifdef CONFIG_DEBUG_VM
-			fault_in_pages_readable(buf, bytes);
+			status = fault_in_pages_readable(buf, seglen);
+			if (unlikely(status))
+				break;
 #endif
 			/*
 			 * OK, we took a fault without making progress. Fall
_

Patches currently in -mm which might be from npiggin@suse.de are

mm-only-mm-debug-write-deadlocks.patch
mm-fix-pagecache-write-deadlocks.patch
mm-fix-pagecache-write-deadlocks-mm-pagecache-write-deadlocks-efault-fix.patch
mm-fix-pagecache-write-deadlocks-zerolength-fix.patch
mm-fix-pagecache-write-deadlocks-stale-holes-fix.patch
fs-prepare_write-fixes.patch
fs-prepare_write-fixes-fuse-fix.patch
fs-prepare_write-fixes-jffs-fix.patch
fs-prepare_write-fixes-fat-fix.patch
fs-fix-cont-vs-deadlock-patches.patch
git-block.patch
buffer-memorder-fix.patch
sched-avoid-div-in-rebalance_tick.patch
fs-libfs-buffered-write-leak-fix.patch
mm-revert-generic_file_buffered_write-handle-zero-length-iovec-segments.patch
mm-revert-generic_file_buffered_write-deadlock-on-vectored-write.patch
mm-generic_file_buffered_write-cleanup.patch
mm-debug-write-deadlocks.patch
mm-be-sure-to-trim-blocks.patch
mm-cleanup-pagecache-insertion-operations.patch
mm-generic_file_buffered_write-iovec-cleanup.patch

From: akpm@linux-foundation.org
Subject: - mm-fix-pagecache-write-deadlocks-zerolength-fix.patch removed from -mm tree
Date: Sun, 04 Feb 2007 01:08:08 -0800
Message-ID: <200702040908.l14988j7026151@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34084 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247AbXBDJIL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 4 Feb 2007 04:08:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: pagecache write deadlocks zerolength fix
has been removed from the -mm tree.  Its filename was
     mm-fix-pagecache-write-deadlocks-zerolength-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: mm: pagecache write deadlocks zerolength fix
From: Nick Piggin <npiggin@suse.de>

writev with a zero-length segment is a noop, and we shouldn't return EFAULT.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/pagemap.h |    6 ++++++
 1 files changed, 6 insertions(+)

diff -puN include/linux/pagemap.h~mm-fix-pagecache-write-deadlocks-zerolength-fix include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-fix-pagecache-write-deadlocks-zerolength-fix
+++ a/include/linux/pagemap.h
@@ -198,6 +198,9 @@ static inline int fault_in_pages_writeab
 {
 	int ret;
 
+	if (unlikely(size == 0))
+		return 0;
+
 	/*
 	 * Writing zeroes into userspace here is OK, because we know that if
 	 * the zero gets there, we'll be overwriting it.
@@ -222,6 +225,9 @@ static inline int fault_in_pages_readabl
 	volatile char c;
 	int ret;
 
+	if (unlikely(size == 0))
+		return 0;
+
 	ret = __get_user(c, uaddr);
 	if (ret == 0) {
 		const char __user *end = uaddr + size - 1;
_

Patches currently in -mm which might be from npiggin@suse.de are

mm-only-mm-debug-write-deadlocks.patch
mm-fix-pagecache-write-deadlocks.patch
mm-fix-pagecache-write-deadlocks-zerolength-fix.patch
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

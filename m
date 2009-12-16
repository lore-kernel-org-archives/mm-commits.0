From: akpm@linux-foundation.org
Subject: [folded] direct-io-cleanup-blockdev_direct_io-locking-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 15 Dec 2009 16:38:06 -0800
Message-ID: <200912160038.nBG0c680023866@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56616 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761450AbZLPAid (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 19:38:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     direct-io-cleanup-blockdev_direct_io-locking-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     direct-io-cleanup-blockdev_direct_io-locking-checkpatch-fixes.patch

This patch was dropped because it was folded into direct-io-cleanup-blockdev_direct_io-locking.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: direct-io-cleanup-blockdev_direct_io-locking-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: space prohibited before that close parenthesis ')'
#252: FILE: fs/direct-io.c:1212:
+			if (end > isize )

total: 1 errors, 0 warnings, 338 lines checked

./patches/direct-io-cleanup-blockdev_direct_io-locking.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/direct-io.c~direct-io-cleanup-blockdev_direct_io-locking-checkpatch-fixes fs/direct-io.c
--- a/fs/direct-io.c~direct-io-cleanup-blockdev_direct_io-locking-checkpatch-fixes
+++ a/fs/direct-io.c
@@ -1209,7 +1209,7 @@ __blockdev_direct_IO(int rw, struct kioc
 	if (dio->flags & DIO_LOCKING) {
 		if (unlikely((rw & WRITE) && retval < 0)) {
 			loff_t isize = i_size_read(inode);
-			if (end > isize )
+			if (end > isize)
 				vmtruncate(inode, isize);
 		}
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect.patch
ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock.patch
memcg-coalesce-charging-via-percpu-storage.patch
memcg-code-cleanrm-unused-variable-in-mem_cgroup_resize_limit.patch
ipc-remove-unreachable-code-in-semc.patch
fs-cache-avoid-maybe-used-uninitialised-warning-on-variable.patch
aio-dont-zero-out-the-pages-array-inside-struct-dio.patch
direct-io-cleanup-blockdev_direct_io-locking.patch
direct-io-cleanup-blockdev_direct_io-locking-checkpatch-fixes.patch


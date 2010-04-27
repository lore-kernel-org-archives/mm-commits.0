From: akpm@linux-foundation.org
Subject: [folded] vfs-o_-bit-numbers-uniqueness-check-fix.patch removed from -mm tree
Date: Tue, 27 Apr 2010 11:41:04 -0700
Message-ID: <201004271908.o3RJ8TOq014257@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754300Ab0D0TIw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Apr 2010 15:08:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, adilger@sun.com, mm-commits@vger.kernel.org


The patch titled
     vfs: O_* bit numbers uniqueness check fix
has been removed from the -mm tree.  Its filename was
     vfs-o_-bit-numbers-uniqueness-check-fix.patch

This patch was dropped because it was folded into vfs-o_-bit-numbers-uniqueness-check.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: O_* bit numbers uniqueness check fix
From: Wu Fengguang <fengguang.wu@intel.com>

Follow the comment by Andreas:

It's non-obvious why there are 18 flags listed here, but the hweight is
only 17?  Presumably this is because O_RDONLY has value 0, but that should
at least be listed in a comment, or the test could be written more
explicitly, like:

	BUILD_BUG_ON(18 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andreas Dilger <adilger@sun.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fcntl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/fcntl.c~vfs-o_-bit-numbers-uniqueness-check-fix fs/fcntl.c
--- a/fs/fcntl.c~vfs-o_-bit-numbers-uniqueness-check-fix
+++ a/fs/fcntl.c
@@ -742,7 +742,7 @@ EXPORT_SYMBOL(kill_fasync);
 static int __init fcntl_init(void)
 {
 	/* please add new bits here to ensure allocation uniqueness */
-	BUILD_BUG_ON(17 != HWEIGHT32(
+	BUILD_BUG_ON(18 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
 		O_RDONLY	| O_WRONLY	| O_RDWR	|
 		O_CREAT		| O_EXCL	| O_NOCTTY	|
 		O_TRUNC		| O_APPEND	| O_NONBLOCK	|
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
vfs-o_-bit-numbers-uniqueness-check.patch
vfs-o_-bit-numbers-uniqueness-check-fix.patch
vfs-o_-bit-numbers-uniqueness-check-fix-2.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
vmscan-prevent-get_scan_ratio-rounding-errors.patch
readaheadc-fix-comment.patch
fs-writeback-check-sync-bit-earlier-in-inode_wait_for_writeback.patch
vfs-add-super-operation-writeback_inodes.patch


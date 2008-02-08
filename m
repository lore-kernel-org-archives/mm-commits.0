From: akpm@linux-foundation.org
Subject: - write_inode_now-avoid-unnecessary-synchronous-write.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:16:41 -0800
Message-ID: <200802082016.m18KGMAw010709@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60863 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751626AbYBHUrM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:47:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: efault@gmx.de, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     write_inode_now(): avoid unnecessary synchronous write
has been removed from the -mm tree.  Its filename was
     write_inode_now-avoid-unnecessary-synchronous-write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: write_inode_now(): avoid unnecessary synchronous write
From: Mike Galbraith <efault@gmx.de>

We shouldn't use WB_SYNC_ALL if the caller is asking for asynchronous
treatment.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/fs-writeback.c~write_inode_now-avoid-unnecessary-synchronous-write fs/fs-writeback.c
--- a/fs/fs-writeback.c~write_inode_now-avoid-unnecessary-synchronous-write
+++ a/fs/fs-writeback.c
@@ -655,7 +655,7 @@ int write_inode_now(struct inode *inode,
 	int ret;
 	struct writeback_control wbc = {
 		.nr_to_write = LONG_MAX,
-		.sync_mode = WB_SYNC_ALL,
+		.sync_mode = sync ? WB_SYNC_ALL : WB_SYNC_NONE,
 		.range_start = 0,
 		.range_end = LLONG_MAX,
 	};
_

Patches currently in -mm which might be from efault@gmx.de are

origin.patch

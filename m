From: akpm@linux-foundation.org
Subject: + write_inode_now-avoid-unnecessary-synchronous-write.patch added to -mm tree
Date: Thu, 10 Jan 2008 16:42:04 -0800
Message-ID: <200801110042.m0B0g5Ds018082@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41556 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753563AbYAKAmM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 19:42:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: efault@gmx.de, jack@suse.cz


The patch titled
     write_inode_now(): avoid unnecessary synchronous write
has been added to the -mm tree.  Its filename is
     write_inode_now-avoid-unnecessary-synchronous-write.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -643,7 +643,7 @@ int write_inode_now(struct inode *inode,
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

git-sched.patch
git-x86.patch
write_inode_now-avoid-unnecessary-synchronous-write.patch
udf-avoid-unnecessary-synchronous-writes.patch

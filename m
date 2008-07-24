From: akpm@linux-foundation.org
Subject: - sync_file_range_write-may-and-will-block-document-that.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:22:46 -0700
Message-ID: <200807242322.m6ONMk5w010594@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55200 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753160AbYGXXWu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:22:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@suse.cz, mm-commits@vger.kernel.org


The patch titled
     SYNC_FILE_RANGE_WRITE may and will block. Document that.
has been removed from the -mm tree.  Its filename was
     sync_file_range_write-may-and-will-block-document-that.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: SYNC_FILE_RANGE_WRITE may and will block. Document that.
From: Pavel Machek <pavel@suse.cz>

[akpm@linux-foundation.org: fix comment text]
Signed-off-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sync.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/sync.c~sync_file_range_write-may-and-will-block-document-that fs/sync.c
--- a/fs/sync.c~sync_file_range_write-may-and-will-block-document-that
+++ a/fs/sync.c
@@ -139,7 +139,8 @@ asmlinkage long sys_fdatasync(unsigned i
  * before performing the write.
  *
  * SYNC_FILE_RANGE_WRITE: initiate writeout of all those dirty pages in the
- * range which are not presently under writeback.
+ * range which are not presently under writeback. Note that this may block for
+ * significant periods due to exhaustion of disk request structures.
  *
  * SYNC_FILE_RANGE_WAIT_AFTER: wait upon writeout of all pages in the range
  * after performing the write.
_

Patches currently in -mm which might be from pavel@suse.cz are

origin.patch
linux-next.patch


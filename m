From: akpm@linux-foundation.org
Subject: - ext3-truncate-block-allocated-on-a-failed-ext3_write_begin.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:36:04 -0700
Message-ID: <200810202036.m9KKa4j7011293@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47824 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754150AbYJTUrF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:47:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     ext3: truncate block allocated on a failed ext3_write_begin
has been removed from the -mm tree.  Its filename was
     ext3-truncate-block-allocated-on-a-failed-ext3_write_begin.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: truncate block allocated on a failed ext3_write_begin
From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

For blocksize < pagesize we need to remove blocks that got allocated in
block_write_begin() if we fail with ENOSPC for later blocks. 
block_write_begin() internally does this if it allocated page locally. 
This makes sure we don't have blocks outside inode.i_size during ENOSPC.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/inode.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN fs/ext3/inode.c~ext3-truncate-block-allocated-on-a-failed-ext3_write_begin fs/ext3/inode.c
--- a/fs/ext3/inode.c~ext3-truncate-block-allocated-on-a-failed-ext3_write_begin
+++ a/fs/ext3/inode.c
@@ -1186,6 +1186,13 @@ write_begin_failed:
 		ext3_journal_stop(handle);
 		unlock_page(page);
 		page_cache_release(page);
+		/*
+		 * block_write_begin may have instantiated a few blocks
+		 * outside i_size.  Trim these off again. Don't need
+		 * i_size_read because we hold i_mutex.
+		 */
+		if (pos + len > inode->i_size)
+			vmtruncate(inode, inode->i_size);
 	}
 	if (ret == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

origin.patch


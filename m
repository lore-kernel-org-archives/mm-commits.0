From: akpm@linux-foundation.org
Subject: + ext3-truncate-block-allocated-on-a-failed-ext3_write_begin.patch added to -mm tree
Date: Wed, 17 Sep 2008 12:30:37 -0700
Message-ID: <200809171930.m8HJUbC1026849@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34957 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752769AbYIQTbb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Sep 2008 15:31:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, tytso@mit.edu


The patch titled
     ext3: truncate block allocated on a failed ext3_write_begin
has been added to the -mm tree.  Its filename is
     ext3-truncate-block-allocated-on-a-failed-ext3_write_begin.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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
@@ -1178,6 +1178,13 @@ write_begin_failed:
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

ext3-truncate-block-allocated-on-a-failed-ext3_write_begin.patch


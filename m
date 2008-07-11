From: akpm@linux-foundation.org
Subject: + reiserfs-discard-prealloc-in-reiserfs_delete_inode.patch added to -mm tree
Date: Fri, 11 Jul 2008 14:50:55 -0700
Message-ID: <200807112150.m6BLotiu006514@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46982 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754972AbYGKVvK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 17:51:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeffm@suse.com, stable@kernel.org


The patch titled
     reiserfs: discard prealloc in reiserfs_delete_inode
has been added to the -mm tree.  Its filename is
     reiserfs-discard-prealloc-in-reiserfs_delete_inode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiserfs: discard prealloc in reiserfs_delete_inode
From: Jeff Mahoney <jeffm@suse.com>

With the removal of struct file from the xattr code, reiserfs_file_release()
isn't used anymore, so the prealloc isn't discarded.  This causes hangs later
down the line.

This patch adds it to reiserfs_delete_inode.  In most cases it will be a no-op
due to it already having been called, but will avoid hangs with xattrs.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/reiserfs/inode.c~reiserfs-discard-prealloc-in-reiserfs_delete_inode fs/reiserfs/inode.c
--- a/fs/reiserfs/inode.c~reiserfs-discard-prealloc-in-reiserfs_delete_inode
+++ a/fs/reiserfs/inode.c
@@ -45,6 +45,8 @@ void reiserfs_delete_inode(struct inode 
 			goto out;
 		reiserfs_update_inode_transaction(inode);
 
+		reiserfs_discard_prealloc(&th, inode);
+
 		err = reiserfs_delete_object(&th, inode);
 
 		/* Do quota update inside a transaction for journaled quotas. We must do that
_

Patches currently in -mm which might be from jeffm@suse.com are

reiserfs-discard-prealloc-in-reiserfs_delete_inode.patch
reiserfs-convert-j_lock-to-mutex.patch
reiserfs-convert-j_flush_sem-to-mutex.patch
reiserfs-convert-j_commit_lock-to-mutex.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch


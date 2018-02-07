From: akpm@linux-foundation.org
Subject: [merged] vfs-remove-might_sleep-from-clear_inode.patch
 removed from -mm tree
Date: Wed, 07 Feb 2018 11:59:26 -0800
Message-ID: <20180207195926.8Yw0RwA1V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60326 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754411AbeBGT71 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:59:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gthelen@google.com, hannes@cmpxchg.org, jack@suse.cz, mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: vfs: remove might_sleep() from clear_inode()
has been removed from the -mm tree.  Its filename was
     vfs-remove-might_sleep-from-clear_inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: vfs: remove might_sleep() from clear_inode()

7994e6f72543 ("vfs: Move waiting for inode writeback from end_writeback()
to evict_inode()") removed inode_sync_wait() from end_writeback() and
commit dbd5768f87ff ("vfs: Rename end_writeback() to clear_inode()")
renamed end_writeback() to clear_inode().  After these patches there is no
sleeping operation in clear_inode().  So, remove might_sleep() from it.

Link: http://lkml.kernel.org/r/20171108004354.40308-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Greg Thelen <gthelen@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/inode.c~vfs-remove-might_sleep-from-clear_inode fs/inode.c
--- a/fs/inode.c~vfs-remove-might_sleep-from-clear_inode
+++ a/fs/inode.c
@@ -498,7 +498,6 @@ EXPORT_SYMBOL(__remove_inode_hash);
 
 void clear_inode(struct inode *inode)
 {
-	might_sleep();
 	/*
 	 * We have to cycle tree_lock here because reclaim can be still in the
 	 * process of removing the last page (in __delete_from_page_cache())
_

Patches currently in -mm which might be from shakeelb@google.com are

mm-mlock-vmscan-no-more-skipping-pagevecs.patch


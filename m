From: akpm@linux-foundation.org
Subject: [patch 085/114] vfs: remove might_sleep() from
 clear_inode()
Date: Tue, 06 Feb 2018 15:40:59 -0800
Message-ID: <20180206234059.32tLhj8_2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55656 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932106AbeBFXlB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:41:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gthelen@google.com, hannes@cmpxchg.org, jack@suse.cz, mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk

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

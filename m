From: akpm@linux-foundation.org
Subject: - vfs-fix-lock-inversion-in-drop_pagecache_sb.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:41:20 -0700
Message-ID: <200804300541.m3U5fKYd029047@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57533 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760158AbYD3GMP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, dgc@sgi.com, wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     vfs: fix lock inversion in drop_pagecache_sb()
has been removed from the -mm tree.  Its filename was
     vfs-fix-lock-inversion-in-drop_pagecache_sb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: fix lock inversion in drop_pagecache_sb()
From: Jan Kara <jack@suse.cz>

Fix longstanding lock inversion in drop_pagecache_sb by dropping inode_lock
before calling __invalidate_mapping_pages().  We just have to make sure inode
won't go away from under us by keeping reference to it and putting the
reference only after we have safely resumed the scan of the inode list.  A bit
tricky but not too bad...

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: David Chinner <dgc@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/drop_caches.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN fs/drop_caches.c~vfs-fix-lock-inversion-in-drop_pagecache_sb fs/drop_caches.c
--- a/fs/drop_caches.c~vfs-fix-lock-inversion-in-drop_pagecache_sb
+++ a/fs/drop_caches.c
@@ -14,15 +14,21 @@ int sysctl_drop_caches;
 
 static void drop_pagecache_sb(struct super_block *sb)
 {
-	struct inode *inode;
+	struct inode *inode, *toput_inode = NULL;
 
 	spin_lock(&inode_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		if (inode->i_state & (I_FREEING|I_WILL_FREE))
 			continue;
+		__iget(inode);
+		spin_unlock(&inode_lock);
 		__invalidate_mapping_pages(inode->i_mapping, 0, -1, true);
+		iput(toput_inode);
+		toput_inode = inode;
+		spin_lock(&inode_lock);
 	}
 	spin_unlock(&inode_lock);
+	iput(toput_inode);
 }
 
 static void drop_pagecache(void)
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
isofs-fix-access-to-unallocated-memory-when-reading-corrupted-filesystem.patch
ext4-fix-mount-messages-when-quota-disabled.patch
quota-le_add_cpu-conversion.patch


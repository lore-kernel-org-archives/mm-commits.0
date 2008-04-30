From: akpm@linux-foundation.org
Subject: - vfs-skip-inodes-without-pages-to-free-in-drop_pagecache_sb.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:41:23 -0700
Message-ID: <200804300541.m3U5fNV2029050@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756285AbYD3GJP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:09:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     vfs: skip inodes without pages to free in drop_pagecache_sb()
has been removed from the -mm tree.  Its filename was
     vfs-skip-inodes-without-pages-to-free-in-drop_pagecache_sb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: skip inodes without pages to free in drop_pagecache_sb()
From: Jan Kara <jack@suse.cz>

Many inodes have no pagecache, so we can avoid lots of lock-takings.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/drop_caches.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/drop_caches.c~vfs-skip-inodes-without-pages-to-free-in-drop_pagecache_sb fs/drop_caches.c
--- a/fs/drop_caches.c~vfs-skip-inodes-without-pages-to-free-in-drop_pagecache_sb
+++ a/fs/drop_caches.c
@@ -20,6 +20,8 @@ static void drop_pagecache_sb(struct sup
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		if (inode->i_state & (I_FREEING|I_WILL_FREE))
 			continue;
+		if (inode->i_mapping->nrpages == 0)
+			continue;
 		__iget(inode);
 		spin_unlock(&inode_lock);
 		__invalidate_mapping_pages(inode->i_mapping, 0, -1, true);
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
isofs-fix-access-to-unallocated-memory-when-reading-corrupted-filesystem.patch
ext4-fix-mount-messages-when-quota-disabled.patch
quota-le_add_cpu-conversion.patch


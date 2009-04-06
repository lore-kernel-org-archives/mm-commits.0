From: akpm@linux-foundation.org
Subject: [merged] vfs-skip-i_clear-state-inodes.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:32:20 -0700
Message-ID: <200904061932.n36JWK0W010665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757487AbZDFTgl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:36:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, jack@suse.cz, m.mizuma@jp.fujitsu.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     vfs: skip I_CLEAR state inodes
has been removed from the -mm tree.  Its filename was
     vfs-skip-i_clear-state-inodes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: skip I_CLEAR state inodes
From: Wu Fengguang <fengguang.wu@intel.com>

clear_inode() will switch inode state from I_FREEING to I_CLEAR, and do so
_outside_ of inode_lock.  So any I_FREEING testing is incomplete without a
coupled testing of I_CLEAR.

So add I_CLEAR tests to drop_pagecache_sb(), generic_sync_sb_inodes() and
add_dquot_ref().

Masayoshi MIZUMA discovered the bug in drop_pagecache_sb() and Jan Kara
reminds fixing the other two cases.

Masayoshi MIZUMA has a nice panic flow:

=====================================================================
            [process A]               |        [process B]
 |                                    |
 |    prune_icache()                  | drop_pagecache()
 |      spin_lock(&inode_lock)        |   drop_pagecache_sb()
 |      inode->i_state |= I_FREEING;  |       |
 |      spin_unlock(&inode_lock)      |       V
 |          |                         |     spin_lock(&inode_lock)
 |          V                         |         |
 |      dispose_list()                |         |
 |        list_del()                  |         |
 |        clear_inode()               |         |
 |          inode->i_state = I_CLEAR  |         |
 |            |                       |         V
 |            |                       |      if (inode->i_state & (I_FREEING|I_WILL_FREE))
 |            |                       |              continue;           <==== NOT MATCH
 |            |                       |
 |            |                       | (DANGER from here on! Accessing disposing inode!)
 |            |                       |
 |            |                       |      __iget()
 |            |                       |        list_move() <===== PANIC on poisoned list !!
 V            V                       |
(time)
=====================================================================

Reported-by: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/drop_caches.c  |    2 +-
 fs/fs-writeback.c |    3 ++-
 fs/quota/dquot.c  |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/drop_caches.c~vfs-skip-i_clear-state-inodes fs/drop_caches.c
--- a/fs/drop_caches.c~vfs-skip-i_clear-state-inodes
+++ a/fs/drop_caches.c
@@ -18,7 +18,7 @@ static void drop_pagecache_sb(struct sup
 
 	spin_lock(&inode_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
-		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
+		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW))
 			continue;
 		if (inode->i_mapping->nrpages == 0)
 			continue;
diff -puN fs/fs-writeback.c~vfs-skip-i_clear-state-inodes fs/fs-writeback.c
--- a/fs/fs-writeback.c~vfs-skip-i_clear-state-inodes
+++ a/fs/fs-writeback.c
@@ -538,7 +538,8 @@ void generic_sync_sb_inodes(struct super
 		list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 			struct address_space *mapping;
 
-			if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
+			if (inode->i_state &
+					(I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW))
 				continue;
 			mapping = inode->i_mapping;
 			if (mapping->nrpages == 0)
diff -puN fs/quota/dquot.c~vfs-skip-i_clear-state-inodes fs/quota/dquot.c
--- a/fs/quota/dquot.c~vfs-skip-i_clear-state-inodes
+++ a/fs/quota/dquot.c
@@ -823,7 +823,7 @@ static void add_dquot_ref(struct super_b
 
 	spin_lock(&inode_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
-		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
+		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW))
 			continue;
 		if (!atomic_read(&inode->i_writecount))
 			continue;
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch


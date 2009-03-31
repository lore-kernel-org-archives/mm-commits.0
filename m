From: akpm@linux-foundation.org
Subject: + vfs-skip-i_clear-state-inodes.patch added to -mm tree
Date: Tue, 31 Mar 2009 16:44:35 -0700
Message-ID: <200903312344.n2VNiZAl012993@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755612AbZCaXs5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Mar 2009 19:48:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, jack@suse.cz, m.mizuma@jp.fujitsu.com, stable@kernel.org


The patch titled
     vfs: skip I_CLEAR state inodes
has been added to the -mm tree.  Its filename is
     vfs-skip-i_clear-state-inodes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
ramfs-add-support-for-mode=-mount-option.patch
writeback-guard-against-jiffies-wraparound-on-inode-dirtied_when-checks.patch
vfs-skip-i_clear-state-inodes.patch
linux-next.patch


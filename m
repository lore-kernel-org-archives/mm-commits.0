From: akpm@linux-foundation.org
Subject: + vfs-fix-lock-inversion-in-drop_pagecache_sb.patch added to -mm tree
Date: Tue, 25 Mar 2008 15:22:20 -0700
Message-ID: <200803252222.m2PMMKss016533@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753782AbYCYWW4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Mar 2008 18:22:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, dgc@sgi.com, wfg@mail.ustc.edu.cn


The patch titled
     vfs: fix lock inversion in drop_pagecache_sb()
has been added to the -mm tree.  Its filename is
     vfs-fix-lock-inversion-in-drop_pagecache_sb.patch

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
 
 void drop_pagecache(void)
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
git-udf.patch
git-ocfs2.patch
quota-do-not-allow-setting-of-quota-limits-to-too-high-values.patch
quota-remove-superfluous-dquot_off-in-fs-namespacec.patch
quota-various-style-cleanups.patch
quota-various-style-cleanups-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-reiserfs-make-reiserfs-handle-quotaon-on-remount.patch
ext3-fdatasync-should-skip-metadata-writeout-when-overwriting.patch
quota-le_add_cpu-conversion.patch
vfs-fix-lock-inversion-in-drop_pagecache_sb.patch


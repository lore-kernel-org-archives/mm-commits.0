From: akpm@linux-foundation.org
Subject: + vfs-skip-inodes-without-pages-to-free-in-drop_pagecache_sb.patch added to -mm tree
Date: Thu, 27 Mar 2008 01:27:56 -0700
Message-ID: <200803270827.m2R8Ruag025665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53326 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750818AbYC0I2g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Mar 2008 04:28:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, wfg@mail.ustc.edu.cn


The patch titled
     vfs: skip inodes without pages to free in drop_pagecache_sb()
has been added to the -mm tree.  Its filename is
     vfs-skip-inodes-without-pages-to-free-in-drop_pagecache_sb.patch

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

git-udf.patch
git-ocfs2.patch
vfs-fix-lock-inversion-in-drop_pagecache_sb.patch
vfs-skip-inodes-without-pages-to-free-in-drop_pagecache_sb.patch
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


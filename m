From: akpm@linux-foundation.org
Subject: [wrecked] vfs-fs_may_remount_ro-turn-unnecessary-check-into-a-warn_on.patch removed from -mm tree
Date: Fri, 18 Mar 2011 11:41:50 -0700
Message-ID: <201103181844.p2IIiWp8004653@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756523Ab1CRSof (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Mar 2011 14:44:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     vfs: fs_may_remount_ro: turn unnecessary check into a WARN_ON
has been removed from the -mm tree.  Its filename was
     vfs-fs_may_remount_ro-turn-unnecessary-check-into-a-warn_on.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: fs_may_remount_ro: turn unnecessary check into a WARN_ON
From: Miklos Szeredi <mszeredi@suse.cz>

Now a successful sb_prepare_remount_readonly() should ensure that no
writable files remain for this superblock.  So turn this check into a
WARN_ON.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file_table.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN fs/file_table.c~vfs-fs_may_remount_ro-turn-unnecessary-check-into-a-warn_on fs/file_table.c
--- a/fs/file_table.c~vfs-fs_may_remount_ro-turn-unnecessary-check-into-a-warn_on
+++ a/fs/file_table.c
@@ -439,8 +439,11 @@ int fs_may_remount_ro(struct super_block
 		if (inode->i_nlink == 0)
 			goto too_bad;
 
-		/* Writeable file? */
-		if (S_ISREG(inode->i_mode) && (file->f_mode & FMODE_WRITE))
+		/*
+		 * Writable file?
+		 * Should be caught by sb_prepare_remount_readonly().
+		 */
+		if (WARN_ON(S_ISREG(inode->i_mode) && (file->f_mode & FMODE_WRITE)))
 			goto too_bad;
 	} while_file_list_for_each_entry;
 	lg_global_unlock(files_lglock);
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
linux-next.patch
mm-add-replace_page_cache_page-function.patch
mm-add-replace_page_cache_page-function-add-freepage-hook.patch


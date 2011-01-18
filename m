From: akpm@linux-foundation.org
Subject: + vfs-fs_may_remount_ro-turn-unnecessary-check-into-a-warn_on.patch added to -mm tree
Date: Tue, 18 Jan 2011 15:10:09 -0800
Message-ID: <201101182310.p0INA9Zn011263@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52645 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751701Ab1ARXLF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Jan 2011 18:11:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     vfs: fs_may_remount_ro: turn unnecessary check into a WARN_ON
has been added to the -mm tree.  Its filename is
     vfs-fs_may_remount_ro-turn-unnecessary-check-into-a-warn_on.patch

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
@@ -436,8 +436,11 @@ int fs_may_remount_ro(struct super_block
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
vfs-ignore-error-on-forced-remount.patch
vfs-keep-list-of-mounts-for-each-superblock.patch
vfs-protect-remounting-superblock-read-only.patch
vfs-fs_may_remount_ro-turn-unnecessary-check-into-a-warn_on.patch


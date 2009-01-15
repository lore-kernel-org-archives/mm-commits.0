From: akpm@linux-foundation.org
Subject: - ext2-update-also-inode-on-disk-when-dir-is-is_dirsync-fix.patch removed from -mm tree
Date: Thu, 15 Jan 2009 12:11:23 -0800
Message-ID: <200901152011.n0FKBO2Y019653@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932783AbZAOUL5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jan 2009 15:11:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jack@suse.cz, pavel@suse.cz, mm-commits@vger.kernel.org


The patch titled
     ext2-update-also-inode-on-disk-when-dir-is-is_dirsync-fix
has been removed from the -mm tree.  Its filename was
     ext2-update-also-inode-on-disk-when-dir-is-is_dirsync-fix.patch

This patch was dropped because it was folded into ext2-update-also-inode-on-disk-when-dir-is-is_dirsync.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext2-update-also-inode-on-disk-when-dir-is-is_dirsync-fix
From: Andrew Morton <akpm@linux-foundation.org>

still sync the data page

Cc: Jan Kara <jack@suse.cz>
Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/dir.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN fs/ext2/dir.c~ext2-update-also-inode-on-disk-when-dir-is-is_dirsync-fix fs/ext2/dir.c
--- a/fs/ext2/dir.c~ext2-update-also-inode-on-disk-when-dir-is-is_dirsync-fix
+++ a/fs/ext2/dir.c
@@ -94,10 +94,14 @@ static int ext2_commit_chunk(struct page
 		i_size_write(dir, pos+len);
 		mark_inode_dirty(dir);
 	}
-	unlock_page(page);
 
-	if (IS_DIRSYNC(dir))
-		err = ext2_sync_inode(dir);
+	if (IS_DIRSYNC(dir)) {
+		err = write_one_page(page, 1);
+		if (!err)
+			err = ext2_sync_inode(dir);
+	} else {
+		unlock_page(page);
+	}
 
 	return err;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
alpha-fix-vmalloc-breakage.patch
revert-mm-vmalloc-use-mutex-for-purge.patch
lib-idrc-use-kmem_cache_zalloc-for-the-idr_layer-cache.patch
hp_accel-do-not-call-acpi-from-invalid-context.patch
ext2-update-also-inode-on-disk-when-dir-is-is_dirsync.patch
ext2-update-also-inode-on-disk-when-dir-is-is_dirsync-fix.patch


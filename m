From: akpm@linux-foundation.org
Subject: - vfs-add-explanation-of-i_dirty_datasync-bit.patch removed from -mm tree
Date: Thu, 14 Feb 2008 19:16:32 -0500
Message-ID: <200802150719.m1F7JsKX025744@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35765 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763093AbYBOHUi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 02:20:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, joern@logfs.org, mm-commits@vger.kernel.org


The patch titled
     vfs: add explanation of I_DIRTY_DATASYNC bit
has been removed from the -mm tree.  Its filename was
     vfs-add-explanation-of-i_dirty_datasync-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: add explanation of I_DIRTY_DATASYNC bit
From: Jan Kara <jack@suse.cz>

Add explanation of I_DIRTY_DATASYNC bit.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Joern Engel <joern@logfs.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN include/linux/fs.h~vfs-add-explanation-of-i_dirty_datasync-bit include/linux/fs.h
--- a/include/linux/fs.h~vfs-add-explanation-of-i_dirty_datasync-bit
+++ a/include/linux/fs.h
@@ -1284,8 +1284,10 @@ struct super_operations {
  *
  * I_DIRTY_SYNC		Inode is dirty, but doesn't have to be written on
  *			fdatasync().  i_atime is the usual cause.
- * I_DIRTY_DATASYNC	Inode is dirty and must be written on fdatasync(), f.e.
- *			because i_size changed.
+ * I_DIRTY_DATASYNC	Data-related inode changes pending. We keep track of
+ *			these changes separately from I_DIRTY_SYNC so that we
+ *			don't have to write inode on fdatasync() when only
+ *			mtime has changed in it.
  * I_DIRTY_PAGES	Inode has dirty pages.  Inode itself may be clean.
  * I_NEW		get_new_inode() sets i_state to I_LOCK|I_NEW.  Both
  *			are cleared by unlock_new_inode(), called from iget().
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
ext3-fdatasync-should-skip-metadata-writeout-when-overwriting.patch
ext4-fdatasync-should-skip-metadata-writeout-when-overwriting.patch
quota-le_add_cpu-conversion.patch

From: akpm@linux-foundation.org
Subject: + vfs-add-explanation-of-i_dirty_datasync-bit.patch added to -mm tree
Date: Thu, 14 Feb 2008 14:38:04 -0800
Message-ID: <200802142238.m1EMc40I006655@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60868 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757807AbYBNWiv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 17:38:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, joern@logfs.org


The patch titled
     vfs: add explanation of I_DIRTY_DATASYNC bit
has been added to the -mm tree.  Its filename is
     vfs-add-explanation-of-i_dirty_datasync-bit.patch

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

udf-fix-directory-offset-handling.patch
udf-fix-udf_add_free_space.patch
vfs-add-explanation-of-i_dirty_datasync-bit.patch
ext3-fdatasync-should-skip-metadata-writeout-when-overwriting.patch
ext4-fdatasync-should-skip-metadata-writeout-when-overwriting.patch
quota-le_add_cpu-conversion.patch

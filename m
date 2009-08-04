From: akpm@linux-foundation.org
Subject: + vfs-mnt_want_write_file-fix-special-file-handling.patch added to -mm tree
Date: Tue, 04 Aug 2009 12:24:25 -0700
Message-ID: <200908041924.n74JOPNE010824@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51636 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932928AbZHDTY2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2009 15:24:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp, dave@linux.vnet.ibm.com, nickpiggin@yahoo.com.au, viro@zeniv.linux.org.uk


The patch titled
     vfs: mnt_want_write_file(): fix special file handling
has been added to the -mm tree.  Its filename is
     vfs-mnt_want_write_file-fix-special-file-handling.patch

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
Subject: vfs: mnt_want_write_file(): fix special file handling
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

I suspect that mnt_want_write_file() may have wrong assumption.  I think
mnt_want_write_file() is assuming it increments ->mnt_writers if
(file->f_mode & FMODE_WRITE).  But, if it's special_file(), it is false?

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/namespace.c~vfs-mnt_want_write_file-fix-special-file-handling fs/namespace.c
--- a/fs/namespace.c~vfs-mnt_want_write_file-fix-special-file-handling
+++ a/fs/namespace.c
@@ -316,7 +316,8 @@ EXPORT_SYMBOL_GPL(mnt_clone_write);
  */
 int mnt_want_write_file(struct file *file)
 {
-	if (!(file->f_mode & FMODE_WRITE))
+	struct inode *inode = file->f_dentry->d_inode;
+	if (!(file->f_mode & FMODE_WRITE) || special_file(inode->i_mode))
 		return mnt_want_write(file->f_path.mnt);
 	else
 		return mnt_clone_write(file->f_path.mnt);
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

linux-next.patch
time-add-function-to-convert-between-calendar-time-and-broken-down-time-for-universal-use.patch
fatfs-use-common-time_to_tm-in-fat_time_unix2fat.patch
vfs-mnt_want_write_file-fix-special-file-handling.patch


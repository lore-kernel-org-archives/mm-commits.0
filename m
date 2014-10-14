From: akpm@linux-foundation.org
Subject: + fs-affs-filec-forward-declaration-clean-up.patch added to -mm
 tree
Date: Tue, 14 Oct 2014 13:18:08 -0700
Message-ID: <543d8500.nNylWGgL8E/F0/LT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45357 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470AbaJNUSI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 16:18:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs/file.c: forward declaration clean-up
has been added to the -mm tree.  Its filename is
     fs-affs-filec-forward-declaration-clean-up.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-affs-filec-forward-declaration-clean-up.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-affs-filec-forward-declaration-clean-up.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs/file.c: forward declaration clean-up

-Move file_operations to avoid forward declarations.

-Remove unused declarations.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/file.c |   38 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff -puN fs/affs/file.c~fs-affs-filec-forward-declaration-clean-up fs/affs/file.c
--- a/fs/affs/file.c~fs-affs-filec-forward-declaration-clean-up
+++ a/fs/affs/file.c
@@ -18,29 +18,7 @@
 #error PAGE_SIZE must be at least 4096
 #endif
 
-static int affs_grow_extcache(struct inode *inode, u32 lc_idx);
-static struct buffer_head *affs_alloc_extblock(struct inode *inode, struct buffer_head *bh, u32 ext);
-static inline struct buffer_head *affs_get_extblock(struct inode *inode, u32 ext);
 static struct buffer_head *affs_get_extblock_slow(struct inode *inode, u32 ext);
-static int affs_file_open(struct inode *inode, struct file *filp);
-static int affs_file_release(struct inode *inode, struct file *filp);
-
-const struct file_operations affs_file_operations = {
-	.llseek		= generic_file_llseek,
-	.read		= new_sync_read,
-	.read_iter	= generic_file_read_iter,
-	.write		= new_sync_write,
-	.write_iter	= generic_file_write_iter,
-	.mmap		= generic_file_mmap,
-	.open		= affs_file_open,
-	.release	= affs_file_release,
-	.fsync		= affs_file_fsync,
-	.splice_read	= generic_file_splice_read,
-};
-
-const struct inode_operations affs_file_inode_operations = {
-	.setattr	= affs_notify_change,
-};
 
 static int
 affs_file_open(struct inode *inode, struct file *filp)
@@ -961,3 +939,19 @@ int affs_file_fsync(struct file *filp, l
 	mutex_unlock(&inode->i_mutex);
 	return ret;
 }
+const struct file_operations affs_file_operations = {
+	.llseek		= generic_file_llseek,
+	.read		= new_sync_read,
+	.read_iter	= generic_file_read_iter,
+	.write		= new_sync_write,
+	.write_iter	= generic_file_write_iter,
+	.mmap		= generic_file_mmap,
+	.open		= affs_file_open,
+	.release	= affs_file_release,
+	.fsync		= affs_file_fsync,
+	.splice_read	= generic_file_splice_read,
+};
+
+const struct inode_operations affs_file_inode_operations = {
+	.setattr	= affs_notify_change,
+};
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-affs-filec-forward-declaration-clean-up.patch
fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf.patch
linux-next.patch


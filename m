From: akpm@linux-foundation.org
Subject: - keep-track-of-mnt_writer-state-of-struct-file-fix-warn_on.patch removed from -mm tree
Date: Wed, 06 Feb 2008 12:37:52 -0800
Message-ID: <200802062037.m16Kbqwe029164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34442 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756393AbYBFUiG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 15:38:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, m.kozlowski@tuxland.pl, mm-commits@vger.kernel.org


The patch titled
     r-o-bind-mounts: fix WARN_ON
has been removed from the -mm tree.  Its filename was
     keep-track-of-mnt_writer-state-of-struct-file-fix-warn_on.patch

This patch was dropped because it was folded into keep-track-of-mnt_writer-state-of-struct-file.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: r-o-bind-mounts: fix WARN_ON
From: Dave Hansen <haveblue@us.ibm.com>

On Tue, 2008-01-22 at 13:02 -0800, Andrew Morton wrote:
> > On Tue, 22 Jan 2008 21:30:23 +0100 Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:
> > Hello,
> >
> > Issuing "sysrq-s sysrq-u" sequence causes these warnings on sparc64:
> >
> > ------------[ cut here ]------------
> > WARNING: at fs/file_table.c:49 __fput+0x1a8/0x1e0()
> > Modules linked in: sg sr_mod cdrom
> > Call Trace:
> >  [00000000004c9ac8] __fput+0x1b0/0x1e0
> >  [00000000004c6978] filp_close+0x60/0x80
> >  [00000000004c6a18] sys_close+0x80/0xe0
> >  [00000000004062d4] linux_sparc_syscall32+0x3c/0x40
> >  [0000000000012f1c] 0x12f24
> > ---[ end trace 6dbe14ff8ec57744 ]---
> > ------------[ cut here ]------------
...
> That's
>
>         WARN_ON(f->f_mnt_write_state == FILE_MNT_WRITE_TAKEN);

The emergency remount code forcibly removes FMODE_WRITE from filps.  The r/o
bind mount code notices that this was done without a proper mnt_drop_write()
and properly gives a warning.

This patch does a mnt_drop_write() and also notes in the filp that this was
done to suppress any warning that would have otherwise been triggered.

I also wonder if inode->i_writecount is made inconsistent by the emergency
remount code.  I guess it is, but the damage is limited to a single inode
instead of being visible more globally like the mnt write count.  Probably not
really worth fixing.

BTW, this wasn't just a sparc thing.  I triggered it in about 3 seconds on a
plain old x86 machine.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff -puN fs/super.c~keep-track-of-mnt_writer-state-of-struct-file-fix-warn_on fs/super.c
--- a/fs/super.c~keep-track-of-mnt_writer-state-of-struct-file-fix-warn_on
+++ a/fs/super.c
@@ -37,6 +37,7 @@
 #include <linux/idr.h>
 #include <linux/kobject.h>
 #include <linux/mutex.h>
+#include <linux/file.h>
 #include <asm/uaccess.h>
 
 
@@ -566,10 +567,26 @@ static void mark_files_ro(struct super_b
 {
 	struct file *f;
 
+retry:
 	file_list_lock();
 	list_for_each_entry(f, &sb->s_files, f_u.fu_list) {
-		if (S_ISREG(f->f_path.dentry->d_inode->i_mode) && file_count(f))
-			f->f_mode &= ~FMODE_WRITE;
+		struct vfsmount mnt;
+		if (!S_ISREG(f->f_path.dentry->d_inode->i_mode))
+		       continue;
+		if (!file_count(f))
+			continue;
+		if (!(f->f_mode & FMODE_WRITE))
+			continue;
+		f->f_mode &= ~FMODE_WRITE;
+		f->f_mnt_write_state |= FILE_MNT_WRITE_RELEASED;
+		mnt = f->f_path.mnt;
+		file_list_unlock();
+		/*
+		 * This can sleep, so we can't hold
+		 * the file_list_lock() spinlock.
+		 */
+		mnt_drop_write(mnt);
+		goto retry;
 	}
 	file_list_unlock();
 }
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

origin.patch
enable-hotplug-memory-remove-for-ppc64.patch
add-arch-specific-walk_memory_remove-for-ppc64.patch
reiserfs-eliminate-private-use-of-struct-file-in-xattr.patch
do-namei_flags-calculation-inside-open_namei.patch
make-open_namei-return-a-filp.patch
kill-do_filp_open.patch
kill-filp_open.patch
rename-open_namei-to-open_pathname.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-do_rmdir-elevate-write-count.patch
r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir.patch
r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers.patch
r-o-bind-mounts-elevate-mount-count-for-extended-attributes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-file_update_time.patch
r-o-bind-mounts-elevate-write-count-for-link-and-symlink-calls.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls.patch
r-o-bind-mounts-elevate-write-count-opened-files.patch
r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch
r-o-bind-mounts-elevate-writer-count-for-chown-and-friends.patch
r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate.patch
r-o-bind-mounts-make-access-use-mnt-check.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
keep-track-of-mnt_writer-state-of-struct-file.patch
keep-track-of-mnt_writer-state-of-struct-file-fix-warn_on.patch
keep-track-of-mnt_writer-state-of-struct-file-fix-warn_on-fix.patch
create-file_drop_write_access-helper.patch
fix-up-new-filp-allocators.patch
use-struct-path-in-struct-svc_export-nfsd-fix-wrong-mnt_writer-count-in-rename.patch
reiser4.patch
page-owner-tracking-leak-detector.patch

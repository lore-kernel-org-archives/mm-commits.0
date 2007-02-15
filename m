From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-fix-mounth-vs-fsh-include-quagmire.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:32:45 -0800
Message-ID: <200702150832.l1F8Wj2u024573@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39794 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965283AbXBOIoS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:44:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hansendc@us.ibm.com, haveblue@us.ibm.com, hch@lst.de, miklos@szeredi.hu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: fix mount.h vs fs.h include quagmire
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-fix-mounth-vs-fsh-include-quagmire.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: r/o bind mounts: fix mount.h vs fs.h include quagmire
From: Dave Hansen <hansendc@us.ibm.com>

I attempted to check the sb->s_flags (declared in fs.h)) variable in mount.h,
by including fs.h, but it blew up on me very quickly.

fs.h references current, which requires sched.h.  sched.h references mounts,
so it includes mount.h.  Circular include dependency fun.  Well, it appears
that fs.h is no stranger to these kinds of problems because it has #includes
spread out in quite a few places.

So, move the sched.h include in fs.h down to just before it is needed, waaaaay
after the 'struct superblock' definition that we need.  Do the same for
mount.h so that we can get at current from fs.h.

If there's a better way to solve this, I'm all ears.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    3 ++-
 linux/sched.h      |    0 
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/fs.h~r-o-bind-mounts-fix-mounth-vs-fsh-include-quagmire include/linux/fs.h
--- a/include/linux/fs.h~r-o-bind-mounts-fix-mounth-vs-fsh-include-quagmire
+++ a/include/linux/fs.h
@@ -280,7 +280,6 @@ extern int dir_notify_enable;
 #include <linux/prio_tree.h>
 #include <linux/init.h>
 #include <linux/pid.h>
-#include <linux/sched.h>
 #include <linux/mutex.h>
 
 #include <asm/atomic.h>
@@ -967,6 +966,8 @@ enum {
 #define vfs_check_frozen(sb, level) \
 	wait_event((sb)->s_wait_unfrozen, ((sb)->s_frozen < (level)))
 
+#include <linux/sched.h>
+
 #define get_fs_excl() atomic_inc(&current->fs_excl)
 #define put_fs_excl() atomic_dec(&current->fs_excl)
 #define has_fs_excl() atomic_read(&current->fs_excl)
diff -puN include/linux/sched.h~r-o-bind-mounts-fix-mounth-vs-fsh-include-quagmire include/linux/sched.h
_

Patches currently in -mm which might be from hansendc@us.ibm.com are

r-o-bind-mounts-fix-mounth-vs-fsh-include-quagmire.patch
r-o-bind-mounts-r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-ext3-remove-extra-is_rdonly-check.patch
r-o-bind-mounts-ext4-remove-extra-is_rdonly-check.patch
r-o-bind-mounts-r-o-bind-mounts-elevate-write-count-for-some-ioctls.patch
r-o-bind-mounts-elevate-writer-count-for-chown-and-friends.patch
r-o-bind-mounts-make-access-use-mnt-check.patch
r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-for-link-and-symlink-calls.patch
r-o-bind-mounts-elevate-mount-count-for-extended-attributes.patch
r-o-bind-mounts-elevate-write-count-for-file_update_time.patch
r-o-bind-mounts-mount_is_safe-add-comment.patch
r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime.patch
r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch
r-o-bind-mounts-elevate-write-count-files-are-opened.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-sb.patch
r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers.patch
r-o-bind-mounts-do_rmdir-elevate-write-count.patch
r-o-bind-mounts-elevate-writer-count-for-custom-struct_file.patch
r-o-bind-mounts-remove-is_rdonly-from-permission.patch
r-o-bind-mounts-reiser4-remove-is_rdonly-checks.patch

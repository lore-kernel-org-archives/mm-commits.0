From: akpm@linux-foundation.org
Subject: + initmpfs-use-initramfs-if-rootfstype=-or-root=-specified.patch
 added to -mm tree
Date: Fri, 19 Jul 2013 12:57:54 -0700
Message-ID: <51e99a42.AyGibh0ztLt/cIJV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50809 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab3GST5z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Jul 2013 15:57:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, swarren@nvidia.com, sam@ravnborg.org, rusty@rustcorp.com.au, jlayton@redhat.com, jim.cromie@gmail.com, hpa@zytor.com, gregkh@linuxfoundation.org, ebiederm@xmission.com, axboe@kernel.dk, rob@landley.net

Subject: + initmpfs-use-initramfs-if-rootfstype=-or-root=-specified.patch added to -mm tree
To: rob@landley.net,axboe@kernel.dk,ebiederm@xmission.com,gregkh@linuxfoundation.org,hpa@zytor.com,jim.cromie@gmail.com,jlayton@redhat.com,rusty@rustcorp.com.au,sam@ravnborg.org,swarren@nvidia.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Fri, 19 Jul 2013 12:57:54 -0700


The patch titled
     Subject: initmpfs: use initramfs if rootfstype= or root= specified
has been added to the -mm tree.  Its filename is
     initmpfs-use-initramfs-if-rootfstype=-or-root=-specified.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/initmpfs-use-initramfs-if-rootfstype=-or-root=-specified.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/initmpfs-use-initramfs-if-rootfstype=-or-root=-specified.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rob Landley <rob@landley.net>
Subject: initmpfs: use initramfs if rootfstype= or root= specified

Command line option rootfstype=ramfs to obtain old initramfs behavior, and
use ramfs instead of tmpfs for stub when root= defined (for cosmetic
reasons).

Signed-off-by: Rob Landley <rob@landley.net>
Cc: Jeff Layton <jlayton@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jim Cromie <jim.cromie@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN init/do_mounts.c~initmpfs-use-initramfs-if-rootfstype=-or-root=-specified init/do_mounts.c
--- a/init/do_mounts.c~initmpfs-use-initramfs-if-rootfstype=-or-root=-specified
+++ a/init/do_mounts.c
@@ -591,16 +591,20 @@ out:
 	sys_chroot(".");
 }
 
+static bool is_tmpfs;
 static struct dentry *rootfs_mount(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data)
 {
 	static unsigned long once;
+	void *fill = ramfs_fill_super;
 
 	if (test_and_set_bit(0, &once))
 		return ERR_PTR(-ENODEV);
 
-	return mount_nodev(fs_type, flags, data,
-		IS_ENABLED(CONFIG_TMPFS) ? shmem_fill_super : ramfs_fill_super);
+	if (IS_ENABLED(CONFIG_TMPFS) && is_tmpfs)
+		fill = shmem_fill_super;
+
+	return mount_nodev(fs_type, flags, data, fill);
 }
 
 static struct file_system_type rootfs_fs_type = {
@@ -616,9 +620,12 @@ int __init init_rootfs(void)
 	if (err)
 		return err;
 
-	if (IS_ENABLED(CONFIG_TMPFS))
+	if (IS_ENABLED(CONFIG_TMPFS) && !saved_root_name[0] &&
+		(!root_fs_names || strstr(root_fs_names, "tmpfs")))
+	{
 		err = shmem_init();
-	else
+		is_tmpfs = true;
+	} else
 		err = init_ramfs_fs();
 
 	if (err)
_

Patches currently in -mm which might be from rob@landley.net are

x86-make-mem=-option-to-work-for-efi-platform.patch
initmpfs-replace-ms_nouser-in-initramfs.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-move-rootfs-code-from-fs-ramfs-to-init.patch
initmpfs-make-rootfs-use-tmpfs-when-config_tmpfs-enabled.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified.patch


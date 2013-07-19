From: akpm@linux-foundation.org
Subject: + initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs.patch
 added to -mm tree
Date: Fri, 19 Jul 2013 12:57:48 -0700
Message-ID: <51e99a3c.8CTYtu+3ClZ1VPOS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50763 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab3GST5t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Jul 2013 15:57:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, swarren@nvidia.com, sam@ravnborg.org, rusty@rustcorp.com.au, jlayton@redhat.com, jim.cromie@gmail.com, hpa@zytor.com, gregkh@linuxfoundation.org, ebiederm@xmission.com, axboe@kernel.dk, rob@landley.net

Subject: + initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs.patch added to -mm tree
To: rob@landley.net,axboe@kernel.dk,ebiederm@xmission.com,gregkh@linuxfoundation.org,hpa@zytor.com,jim.cromie@gmail.com,jlayton@redhat.com,rusty@rustcorp.com.au,sam@ravnborg.org,swarren@nvidia.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Fri, 19 Jul 2013 12:57:48 -0700


The patch titled
     Subject: initmpfs: move bdi setup from init_rootfs to init_ramfs
has been added to the -mm tree.  Its filename is
     initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs.patch

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
Subject: initmpfs: move bdi setup from init_rootfs to init_ramfs

Even though ramfs hasn't got a backing device, commit e0bf68ddec4f ("mm:
bdi init hooks") added one anyway, and put the initialization in
init_rootfs() since that's the first user, leaving it out of init_ramfs()
to avoid duplication.

But initmpfs uses init_tmpfs() instead, so move the init into the
filesystem's init function, add a "once" guard to prevent duplicate
initialization, and call the filesystem init from rootfs init.

This goes part of the way to allowing ramfs to be built as a module.

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

 fs/ramfs/inode.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff -puN fs/ramfs/inode.c~initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs fs/ramfs/inode.c
--- a/fs/ramfs/inode.c~initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs
+++ a/fs/ramfs/inode.c
@@ -275,21 +275,34 @@ static struct file_system_type rootfs_fs
 
 static int __init init_ramfs_fs(void)
 {
-	return register_filesystem(&ramfs_fs_type);
+	static unsigned long once;
+	int err;
+
+	if (test_and_set_bit(1, &once))
+		return 0;
+
+	err = bdi_init(&ramfs_backing_dev_info);
+	if (err)
+		return err;
+
+	err = register_filesystem(&ramfs_fs_type);
+	if (err)
+		bdi_destroy(&ramfs_backing_dev_info);
+
+	return err;
 }
 module_init(init_ramfs_fs)
 
 int __init init_rootfs(void)
 {
-	int err;
+	int err = register_filesystem(&rootfs_fs_type);
 
-	err = bdi_init(&ramfs_backing_dev_info);
 	if (err)
 		return err;
 
-	err = register_filesystem(&rootfs_fs_type);
+	err = init_ramfs_fs();
 	if (err)
-		bdi_destroy(&ramfs_backing_dev_info);
+		unregister_filesystem(&rootfs_fs_type);
 
 	return err;
 }
_

Patches currently in -mm which might be from rob@landley.net are

x86-make-mem=-option-to-work-for-efi-platform.patch
initmpfs-replace-ms_nouser-in-initramfs.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-move-rootfs-code-from-fs-ramfs-to-init.patch
initmpfs-make-rootfs-use-tmpfs-when-config_tmpfs-enabled.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified.patch


From: akpm@linux-foundation.org
Subject: + initmpfs-make-rootfs-use-tmpfs-when-config_tmpfs-enabled.patch
 added to -mm tree
Date: Fri, 19 Jul 2013 12:57:52 -0700
Message-ID: <51e99a40.7ollEKvyE97yFimz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50800 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab3GST5x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Jul 2013 15:57:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, swarren@nvidia.com, sam@ravnborg.org, rusty@rustcorp.com.au, jlayton@redhat.com, jim.cromie@gmail.com, hpa@zytor.com, gregkh@linuxfoundation.org, ebiederm@xmission.com, axboe@kernel.dk, rob@landley.net

Subject: + initmpfs-make-rootfs-use-tmpfs-when-config_tmpfs-enabled.patch added to -mm tree
To: rob@landley.net,axboe@kernel.dk,ebiederm@xmission.com,gregkh@linuxfoundation.org,hpa@zytor.com,jim.cromie@gmail.com,jlayton@redhat.com,rusty@rustcorp.com.au,sam@ravnborg.org,swarren@nvidia.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Fri, 19 Jul 2013 12:57:52 -0700


The patch titled
     Subject: initmpfs: make rootfs use tmpfs when CONFIG_TMPFS enabled
has been added to the -mm tree.  Its filename is
     initmpfs-make-rootfs-use-tmpfs-when-config_tmpfs-enabled.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/initmpfs-make-rootfs-use-tmpfs-when-config_tmpfs-enabled.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/initmpfs-make-rootfs-use-tmpfs-when-config_tmpfs-enabled.patch

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
Subject: initmpfs: make rootfs use tmpfs when CONFIG_TMPFS enabled

Conditionally call the appropriate fs_init function and fill_super
functions.  Add a use once guard to shmem_init() to simply succeed on a
second call.

(Note that IS_ENABLED() is a compile time constant so dead code
elimination removes unused function calls when CONFIG_TMPFS is disabled.)

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

 init/do_mounts.c |   10 ++++++++--
 mm/shmem.c       |    4 ++++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff -puN init/do_mounts.c~initmpfs-make-rootfs-use-tmpfs-when-config_tmpfs-enabled init/do_mounts.c
--- a/init/do_mounts.c~initmpfs-make-rootfs-use-tmpfs-when-config_tmpfs-enabled
+++ a/init/do_mounts.c
@@ -27,6 +27,7 @@
 #include <linux/fs_struct.h>
 #include <linux/slab.h>
 #include <linux/ramfs.h>
+#include <linux/shmem_fs.h>
 
 #include <linux/nfs_fs.h>
 #include <linux/nfs_fs_sb.h>
@@ -598,7 +599,8 @@ static struct dentry *rootfs_mount(struc
 	if (test_and_set_bit(0, &once))
 		return ERR_PTR(-ENODEV);
 
-	return mount_nodev(fs_type, flags, data, ramfs_fill_super);
+	return mount_nodev(fs_type, flags, data,
+		IS_ENABLED(CONFIG_TMPFS) ? shmem_fill_super : ramfs_fill_super);
 }
 
 static struct file_system_type rootfs_fs_type = {
@@ -614,7 +616,11 @@ int __init init_rootfs(void)
 	if (err)
 		return err;
 
-	err = init_ramfs_fs();
+	if (IS_ENABLED(CONFIG_TMPFS))
+		err = shmem_init();
+	else
+		err = init_ramfs_fs();
+
 	if (err)
 		unregister_filesystem(&rootfs_fs_type);
 
diff -puN mm/shmem.c~initmpfs-make-rootfs-use-tmpfs-when-config_tmpfs-enabled mm/shmem.c
--- a/mm/shmem.c~initmpfs-make-rootfs-use-tmpfs-when-config_tmpfs-enabled
+++ a/mm/shmem.c
@@ -2817,6 +2817,10 @@ int __init shmem_init(void)
 {
 	int error;
 
+	/* If rootfs called this, don't re-init */
+	if (shmem_inode_cachep)
+		return 0;
+
 	error = bdi_init(&shmem_backing_dev_info);
 	if (error)
 		goto out4;
_

Patches currently in -mm which might be from rob@landley.net are

x86-make-mem=-option-to-work-for-efi-platform.patch
initmpfs-replace-ms_nouser-in-initramfs.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-move-rootfs-code-from-fs-ramfs-to-init.patch
initmpfs-make-rootfs-use-tmpfs-when-config_tmpfs-enabled.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified.patch


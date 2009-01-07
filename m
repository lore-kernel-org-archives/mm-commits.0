From: akpm@linux-foundation.org
Subject: - block-do_mounts-add-device-info-to-mount-message.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:15:14 -0800
Message-ID: <200901072215.n07MFEl9015071@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58705 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761948AbZAGWPa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:15:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cus@fazekas.hu, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     do_mounts: add device info to mount message
has been removed from the -mm tree.  Its filename was
     block-do_mounts-add-device-info-to-mount-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: do_mounts: add device info to mount message
From: Marton Balint <cus@fazekas.hu>

In the past, I used the root=...  command line parameter to specify the
root filesystem to the kernel.  Now it seems that specifying it is not
necessary.  The kernel detects the root filesystem even if the kernel
command line is empty.  My root fs is on a raid1 device by the way, and I
am not using initrd for the boot process.

If the kernel detects the root filesystem somehow, I think it should print
out the result of this detection, otherwise I will not know which device
has the root filesystem.  Or is there an easy way to get this information
on a running system?  I had a quick look at the /proc and /sys
filesystems, but haven't found anything useful there.

Signed-off-by: Marton Balint <cus@fazekas.hu>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN init/do_mounts.c~block-do_mounts-add-device-info-to-mount-message init/do_mounts.c
--- a/init/do_mounts.c~block-do_mounts-add-device-info-to-mount-message
+++ a/init/do_mounts.c
@@ -220,10 +220,10 @@ static int __init do_mount_root(char *na
 
 	sys_chdir("/root");
 	ROOT_DEV = current->fs->pwd.mnt->mnt_sb->s_dev;
-	printk("VFS: Mounted root (%s filesystem)%s.\n",
+	printk("VFS: Mounted root (%s filesystem)%s on device %u:%u.\n",
 	       current->fs->pwd.mnt->mnt_sb->s_type->name,
 	       current->fs->pwd.mnt->mnt_sb->s_flags & MS_RDONLY ?
-	       " readonly" : "");
+	       " readonly" : "", MAJOR(ROOT_DEV), MINOR(ROOT_DEV));
 	return 0;
 }
 
_

Patches currently in -mm which might be from cus@fazekas.hu are

origin.patch


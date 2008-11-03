From: akpm@linux-foundation.org
Subject: + block-do_mounts-add-device-info-to-mount-message.patch added to -mm tree
Date: Mon, 03 Nov 2008 12:09:44 -0800
Message-ID: <200811032009.mA3K9i6m006750@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754043AbYKCUKE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Nov 2008 15:10:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cus@fazekas.hu, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     do_mounts: add device info to mount message
has been added to the -mm tree.  Its filename is
     block-do_mounts-add-device-info-to-mount-message.patch

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

block-do_mounts-add-device-info-to-mount-message.patch


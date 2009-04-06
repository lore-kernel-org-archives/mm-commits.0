From: akpm@linux-foundation.org
Subject: [merged] initramfs-prevent-initramfs-printk-message-being-split-by-messages-from-other-code.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:33:23 -0700
Message-ID: <200904061933.n36JXNmm011074@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753403AbZDFTfL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:35:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: skitching@apache.org, mm-commits@vger.kernel.org


The patch titled
     initramfs: prevent initramfs printk message being split by messages from other code.
has been removed from the -mm tree.  Its filename was
     initramfs-prevent-initramfs-printk-message-being-split-by-messages-from-other-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: initramfs: prevent initramfs printk message being split by messages from other code.
From: Simon Kitching <skitching@apache.org>

initramfs uses printk without a linefeed, then does some work, then uses
printk to finish the message off.  However if some other code does a
printk in between, then the messages get mixed together.  Better for each
message to be an independent line...

Example of problem that this fixes:

    checking if image is initramfs...<7>Switched to high resolution mode on CPU 1
    Switched to high resolution mode on CPU 0
    it is

Signed-off-by: Simon Kitching <skitching@apache.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN init/initramfs.c~initramfs-prevent-initramfs-printk-message-being-split-by-messages-from-other-code init/initramfs.c
--- a/init/initramfs.c~initramfs-prevent-initramfs-printk-message-being-split-by-messages-from-other-code
+++ a/init/initramfs.c
@@ -571,11 +571,11 @@ static int __init populate_rootfs(void)
 	if (initrd_start) {
 #ifdef CONFIG_BLK_DEV_RAM
 		int fd;
-		printk(KERN_INFO "checking if image is initramfs...");
+		printk(KERN_INFO "checking if image is initramfs...\n");
 		err = unpack_to_rootfs((char *)initrd_start,
 			initrd_end - initrd_start);
 		if (!err) {
-			printk(" it is\n");
+			printk(KERN_INFO "rootfs image is initramfs; unpacking...\n");
 			free_initrd();
 			return 0;
 		} else {
@@ -583,7 +583,8 @@ static int __init populate_rootfs(void)
 			unpack_to_rootfs(__initramfs_start,
 				 __initramfs_end - __initramfs_start);
 		}
-		printk("it isn't (%s); looks like an initrd\n", err);
+		printk(KERN_INFO "rootfs image is not initramfs (%s)"
+				"; looks like an initrd\n", err);
 		fd = sys_open("/initrd.image", O_WRONLY|O_CREAT, 0700);
 		if (fd >= 0) {
 			sys_write(fd, (char *)initrd_start,
_

Patches currently in -mm which might be from skitching@apache.org are

origin.patch


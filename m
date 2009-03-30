From: akpm@linux-foundation.org
Subject: + initramfs-prevent-initramfs-printk-message-being-split-by-messages-from-other-code.patch added to -mm tree
Date: Mon, 30 Mar 2009 15:05:37 -0700
Message-ID: <200903302205.n2UM5cAN001225@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757823AbZC3WHV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 18:07:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: skitching@apache.org


The patch titled
     initramfs: prevent initramfs printk message being split by messages from other code.
has been added to the -mm tree.  Its filename is
     initramfs-prevent-initramfs-printk-message-being-split-by-messages-from-other-code.patch

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

initramfs-prevent-initramfs-printk-message-being-split-by-messages-from-other-code.patch


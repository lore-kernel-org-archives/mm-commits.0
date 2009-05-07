From: akpm@linux-foundation.org
Subject: [merged] initramfs-clean-up-messages-related-to-initramfs-unpacking.patch removed from -mm tree
Date: Thu, 07 May 2009 12:16:27 -0700
Message-ID: <200905071916.n47JGRGH020362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752427AbZEGTTV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 May 2009 15:19:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.piel@tremplin-utc.net, hpa@zytor.com, mm-commits@vger.kernel.org


The patch titled
     initramfs: clean up messages related to initramfs unpacking
has been removed from the -mm tree.  Its filename was
     initramfs-clean-up-messages-related-to-initramfs-unpacking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: initramfs: clean up messages related to initramfs unpacking
From: Eric Piel <eric.piel@tremplin-utc.net>

With the removal of duplicate unpack_to_rootfs() (commit
df52092f3c97788592ef72501a43fb7ac6a3cfe0) the messages displayed do not
actually correspond to what the kernel is doing.  In addition, depending
if ramdisks are supported or not, the messages are not at all the same.

So keep the messages more in sync with what is really doing the kernel,
and only display a second message in case of failure.  This also ensure
that the printk message cannot be split by other printk's.

Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff -puN init/initramfs.c~initramfs-clean-up-messages-related-to-initramfs-unpacking init/initramfs.c
--- a/init/initramfs.c~initramfs-clean-up-messages-related-to-initramfs-unpacking
+++ a/init/initramfs.c
@@ -574,11 +574,10 @@ static int __init populate_rootfs(void)
 	if (initrd_start) {
 #ifdef CONFIG_BLK_DEV_RAM
 		int fd;
-		printk(KERN_INFO "checking if image is initramfs...\n");
+		printk(KERN_INFO "Trying to unpack rootfs image as initramfs...\n");
 		err = unpack_to_rootfs((char *)initrd_start,
 			initrd_end - initrd_start);
 		if (!err) {
-			printk(KERN_INFO "rootfs image is initramfs; unpacking...\n");
 			free_initrd();
 			return 0;
 		} else {
@@ -596,15 +595,11 @@ static int __init populate_rootfs(void)
 			free_initrd();
 		}
 #else
-		printk(KERN_INFO "Unpacking initramfs...");
+		printk(KERN_INFO "Unpacking initramfs...\n");
 		err = unpack_to_rootfs((char *)initrd_start,
 			initrd_end - initrd_start);
-		if (err) {
-			printk(" failed!\n");
-			printk(KERN_EMERG "%s\n", err);
-		} else {
-			printk(" done\n");
-		}
+		if (err)
+			printk(KERN_EMERG "Initramfs unpacking failed: %s\n", err);
 		free_initrd();
 #endif
 	}
_

Patches currently in -mm which might be from eric.piel@tremplin-utc.net are

origin.patch


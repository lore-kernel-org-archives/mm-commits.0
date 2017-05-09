From: akpm@linux-foundation.org
Subject: [merged]
 initramfs-provide-a-way-to-ignore-image-provided-by-bootloader.patch
 removed from -mm tree
Date: Tue, 09 May 2017 11:02:14 -0700
Message-ID: <20170509180214.9oghZiONO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34598 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753940AbdEISCP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:02:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.thompson@linaro.org, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: initramfs: provide a way to ignore image provided by bootloader
has been removed from the -mm tree.  Its filename was
     initramfs-provide-a-way-to-ignore-image-provided-by-bootloader.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Thompson <daniel.thompson@linaro.org>
Subject: initramfs: provide a way to ignore image provided by bootloader

Many "embedded" architectures provide CMDLINE_FORCE to allow the kernel to
override the command line provided by an inflexible bootloader.  However
there is currrently no way for the kernel to override the initramfs image
provided by the bootloader meaning there are still ways for bootloaders to
make things difficult for us.

Fix this by introducing INITRAMFS_FORCE which can prevent the kernel from
loading the bootloader supplied image.

We use CMDLINE_FORCE (and its friend CMDLINE_EXTEND) to imply that the
system has an inflexible bootloader.  This allow us to avoid presenting
this config option to users of systems where inflexible bootloaders aren't
usually a problem.

Link: http://lkml.kernel.org/r/20170217121940.30126-1-daniel.thompson@linaro.org
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |    2 +-
 usr/Kconfig      |   10 ++++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff -puN init/initramfs.c~initramfs-provide-a-way-to-ignore-image-provided-by-bootloader init/initramfs.c
--- a/init/initramfs.c~initramfs-provide-a-way-to-ignore-image-provided-by-bootloader
+++ a/init/initramfs.c
@@ -613,7 +613,7 @@ static int __init populate_rootfs(void)
 	if (err)
 		panic("%s", err); /* Failed to decompress INTERNAL initramfs */
 	/* If available load the bootloader supplied initrd */
-	if (initrd_start) {
+	if (initrd_start && !IS_ENABLED(CONFIG_INITRAMFS_FORCE)) {
 #ifdef CONFIG_BLK_DEV_RAM
 		int fd;
 		printk(KERN_INFO "Trying to unpack rootfs image as initramfs...\n");
diff -puN usr/Kconfig~initramfs-provide-a-way-to-ignore-image-provided-by-bootloader usr/Kconfig
--- a/usr/Kconfig~initramfs-provide-a-way-to-ignore-image-provided-by-bootloader
+++ a/usr/Kconfig
@@ -21,6 +21,16 @@ config INITRAMFS_SOURCE
 
 	  If you are not sure, leave it blank.
 
+config INITRAMFS_FORCE
+	bool "Ignore the initramfs passed by the bootloader"
+	depends on CMDLINE_EXTEND || CMDLINE_FORCE
+	help
+	  This option causes the kernel to ignore the initramfs image
+	  (or initrd image) passed to it by the bootloader. This is
+	  analogous to CMDLINE_FORCE, which is found on some architectures,
+	  and is useful if you cannot or don't want to change the image
+	  your bootloader passes to the kernel.
+
 config INITRAMFS_ROOT_UID
 	int "User ID to map to 0 (user root)"
 	depends on INITRAMFS_SOURCE!=""
_

Patches currently in -mm which might be from daniel.thompson@linaro.org are



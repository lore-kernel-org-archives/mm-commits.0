From: akpm@linux-foundation.org
Subject: +
 initramfs-provide-a-way-to-ignore-image-provided-by-bootloader.patch added
 to -mm tree
Date: Fri, 03 Mar 2017 16:25:05 -0800
Message-ID: <58ba0961.1aoXpfhzjcb+1Fzz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45428 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752105AbdCDAfz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2017 19:35:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.thompson@linaro.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: initramfs: provide a way to ignore image provided by bootloader
has been added to the -mm tree.  Its filename is
     initramfs-provide-a-way-to-ignore-image-provided-by-bootloader.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/initramfs-provide-a-way-to-ignore-image-provided-by-bootloader.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/initramfs-provide-a-way-to-ignore-image-provided-by-bootloader.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -611,7 +611,7 @@ static int __init populate_rootfs(void)
 	char *err = unpack_to_rootfs(__initramfs_start, __initramfs_size);
 	if (err)
 		panic("%s", err); /* Failed to decompress INTERNAL initramfs */
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

initramfs-provide-a-way-to-ignore-image-provided-by-bootloader.patch


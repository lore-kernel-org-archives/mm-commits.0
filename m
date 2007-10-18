From: akpm@linux-foundation.org
Subject: - remove-final-traces-of-long-deprecated-ramdisk-kernel.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:59:34 -0700
Message-ID: <200710180659.l9I6xYDU030994@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37791 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757597AbXJRG7p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 02:59:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Remove final traces of long-deprecated "ramdisk" kernel parm
has been removed from the -mm tree.  Its filename was
     remove-final-traces-of-long-deprecated-ramdisk-kernel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove final traces of long-deprecated "ramdisk" kernel parm
From: "Robert P. J. Day" <rpjday@mindspring.com>

Since the "ramdisk" kernel parameter has been officially deprecated
since at least 2.6.18, might as well finally get rid of it.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt   |    4 ----
 Documentation/m68k/kernel-options.txt |    4 ++--
 Documentation/ramdisk.txt             |    7 -------
 drivers/block/rd.c                    |    7 +------
 4 files changed, 3 insertions(+), 19 deletions(-)

diff -puN Documentation/kernel-parameters.txt~remove-final-traces-of-long-deprecated-ramdisk-kernel Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~remove-final-traces-of-long-deprecated-ramdisk-kernel
+++ a/Documentation/kernel-parameters.txt
@@ -1473,14 +1473,10 @@ and is between 256 and 4096 characters. 
 	raid=		[HW,RAID]
 			See Documentation/md.txt.
 
-	ramdisk=	[RAM] Sizes of RAM disks in kilobytes [deprecated]
-			See Documentation/ramdisk.txt.
-
 	ramdisk_blocksize=	[RAM]
 			See Documentation/ramdisk.txt.
 
 	ramdisk_size=	[RAM] Sizes of RAM disks in kilobytes
-			New name for the ramdisk parameter.
 			See Documentation/ramdisk.txt.
 
 	rcu.blimit=	[KNL,BOOT] Set maximum number of finished
diff -puN Documentation/m68k/kernel-options.txt~remove-final-traces-of-long-deprecated-ramdisk-kernel Documentation/m68k/kernel-options.txt
--- a/Documentation/m68k/kernel-options.txt~remove-final-traces-of-long-deprecated-ramdisk-kernel
+++ a/Documentation/m68k/kernel-options.txt
@@ -192,10 +192,10 @@ Devices possible for Atari:
            seconds.
 
 
-2.6) ramdisk=
+2.6) ramdisk_size=
 -------------
 
-Syntax: ramdisk=<size>
+Syntax: ramdisk_size=<size>
 
   This option instructs the kernel to set up a ramdisk of the given
 size in KBytes. Do not use this option if the ramdisk contents are
diff -puN Documentation/ramdisk.txt~remove-final-traces-of-long-deprecated-ramdisk-kernel Documentation/ramdisk.txt
--- a/Documentation/ramdisk.txt~remove-final-traces-of-long-deprecated-ramdisk-kernel
+++ a/Documentation/ramdisk.txt
@@ -31,13 +31,6 @@ To use RAM disk support with your system
 directory.  RAM disks are all major number 1, and start with minor number 0
 for /dev/ram0, etc.  If used, modern kernels use /dev/ram0 for an initrd.
 
-The old "ramdisk=<ram_size>" has been changed to "ramdisk_size=<ram_size>" to
-make it clearer.  The original "ramdisk=<ram_size>" has been kept around for
-compatibility reasons, but it may be removed in the future.
-There are also config symbols (in the Block drivers config menu) for these
-variables:  BLK_DEV_RAM_SIZE defaults to 4096 and BLK_DEV_RAM_BLOCKSIZE
-defaults to 1024.
-
 The new RAM disk also has the ability to load compressed RAM disk images,
 allowing one to squeeze more programs onto an average installation or
 rescue floppy disk.
diff -puN drivers/block/rd.c~remove-final-traces-of-long-deprecated-ramdisk-kernel drivers/block/rd.c
--- a/drivers/block/rd.c~remove-final-traces-of-long-deprecated-ramdisk-kernel
+++ a/drivers/block/rd.c
@@ -504,17 +504,12 @@ static int __init ramdisk_size(char *str
 	rd_size = simple_strtol(str,NULL,0);
 	return 1;
 }
-static int __init ramdisk_size2(char *str)	/* kludge */
-{
-	return ramdisk_size(str);
-}
 static int __init ramdisk_blocksize(char *str)
 {
 	rd_blocksize = simple_strtol(str,NULL,0);
 	return 1;
 }
-__setup("ramdisk=", ramdisk_size);
-__setup("ramdisk_size=", ramdisk_size2);
+__setup("ramdisk_size=", ramdisk_size);
 __setup("ramdisk_blocksize=", ramdisk_blocksize);
 #endif
 
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-kvm.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch

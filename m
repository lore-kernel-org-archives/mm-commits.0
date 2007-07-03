From: akpm@linux-foundation.org
Subject: + remove-the-last-few-umsdos-leftovers.patch added to -mm tree
Date: Tue, 03 Jul 2007 13:01:13 -0700
Message-ID: <200707032001.l63K1DeY012458@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32839 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756600AbXGCUBa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2007 16:01:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com, hpa@zytor.com


The patch titled
     Remove the last few UMSDOS leftovers
has been added to the -mm tree.  Its filename is
     remove-the-last-few-umsdos-leftovers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove the last few UMSDOS leftovers
From: Jesper Juhl <jesper.juhl@gmail.com>

The UMSDOS filesystem was removed back in 2.6.11, but some tiny bits stuck
around.  This patch removes the few remaining leftovers.  The only things
left behind after this are the entries in the CREDITS file and the ioctl
number in Documentation/ioctl-number.txt as documentation.

This third (hopefully final) version of the patch doesn't edit the
arch/um/config.release file, since Jeff Dike pointed out to me that it
should die completely, and asked me to remove it from my patch as he'll
send in a seperate patch removing the file completely.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ioctl-number.txt |    2 +-
 arch/arm26/defconfig           |    1 -
 arch/cris/arch-v10/defconfig   |    1 -
 include/linux/ncp_fs.h         |    2 --
 4 files changed, 1 insertion(+), 5 deletions(-)

diff -puN Documentation/ioctl-number.txt~remove-the-last-few-umsdos-leftovers Documentation/ioctl-number.txt
--- a/Documentation/ioctl-number.txt~remove-the-last-few-umsdos-leftovers
+++ a/Documentation/ioctl-number.txt
@@ -67,7 +67,7 @@ Code	Seq#	Include File		Comments
 0x00	00-1F	linux/wavefront.h	conflict!
 0x02	all	linux/fd.h
 0x03	all	linux/hdreg.h
-0x04	all	linux/umsdos_fs.h
+0x04	D2-DC	linux/umsdos_fs.h	Dead since 2.6.11, but don't reuse these.
 0x06	all	linux/lp.h
 0x09	all	linux/md.h
 0x12	all	linux/fs.h
diff -puN arch/arm26/defconfig~remove-the-last-few-umsdos-leftovers arch/arm26/defconfig
--- a/arch/arm26/defconfig~remove-the-last-few-umsdos-leftovers
+++ a/arch/arm26/defconfig
@@ -248,7 +248,6 @@ CONFIG_I2C_CHARDEV=y
 # CONFIG_JBD_DEBUG is not set
 # CONFIG_FAT_FS is not set
 # CONFIG_MSDOS_FS is not set
-# CONFIG_UMSDOS_FS is not set
 # CONFIG_VFAT_FS is not set
 # CONFIG_EFS_FS is not set
 # CONFIG_JFFS_FS is not set
diff -puN arch/cris/arch-v10/defconfig~remove-the-last-few-umsdos-leftovers arch/cris/arch-v10/defconfig
--- a/arch/cris/arch-v10/defconfig~remove-the-last-few-umsdos-leftovers
+++ a/arch/cris/arch-v10/defconfig
@@ -429,7 +429,6 @@ CONFIG_NET_ETHERNET=y
 # CONFIG_BFS_FS is not set
 # CONFIG_FAT_FS is not set
 # CONFIG_MSDOS_FS is not set
-# CONFIG_UMSDOS_FS is not set
 # CONFIG_VFAT_FS is not set
 # CONFIG_EFS_FS is not set
 # CONFIG_JFFS_FS is not set
diff -puN include/linux/ncp_fs.h~remove-the-last-few-umsdos-leftovers include/linux/ncp_fs.h
--- a/include/linux/ncp_fs.h~remove-the-last-few-umsdos-leftovers
+++ a/include/linux/ncp_fs.h
@@ -148,8 +148,6 @@ struct ncp_nls_ioctl
 #include <linux/ncp_fs_i.h>
 #include <linux/ncp_fs_sb.h>
 
-/* undef because public define in umsdos_fs.h (ncp_fs.h isn't public) */
-#undef PRINTK
 /* define because it is easy to change PRINTK to {*}PRINTK */
 #define PRINTK(format, args...) printk(KERN_DEBUG format , ## args)
 
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

remove-unneeded-test-of-task-in-dump_trace.patch
git-xfs.patch
submitchecklist-update-fix-spelling-error.patch
add-missing-files-and-dirs-to-00-index-in-documentation.patch
remove-the-last-few-umsdos-leftovers.patch

From: akpm@linux-foundation.org
Subject: + export-ufs_fsh-to-userspace.patch added to -mm tree
Date: Thu, 08 Feb 2007 23:51:04 -0800
Message-ID: <200702090751.l197p4kP007669@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33926 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946185AbXBIHvR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 02:51:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, dushistov@mail.ru


The patch titled
     export ufs_fs.h to userspace
has been added to the -mm tree.  Its filename is
     export-ufs_fsh-to-userspace.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: export ufs_fs.h to userspace
From: Mike Frysinger <vapier@gentoo.org>

Was ufs_fs.h purposefully not exported to userspace or did it just slip
through the cracks ?  assuming the latter scenario, the attached patch touches
up the relationship between ufs_fs.h and its sub headers (like ufs_fs_sb.h) so
that we can export it ...  the silo bootloader takes advantage of this header
for example.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/Kbuild      |    1 +
 include/linux/ufs_fs.h    |    4 +++-
 include/linux/ufs_fs_sb.h |    1 -
 3 files changed, 4 insertions(+), 2 deletions(-)

diff -puN include/linux/Kbuild~export-ufs_fsh-to-userspace include/linux/Kbuild
--- a/include/linux/Kbuild~export-ufs_fsh-to-userspace
+++ a/include/linux/Kbuild
@@ -323,6 +323,7 @@ unifdef-y += tty.h
 unifdef-y += types.h
 unifdef-y += udf_fs_i.h
 unifdef-y += udp.h
+unifdef-y += ufs_fs.h
 unifdef-y += uinput.h
 unifdef-y += uio.h
 unifdef-y += unistd.h
diff -puN include/linux/ufs_fs.h~export-ufs_fsh-to-userspace include/linux/ufs_fs.h
--- a/include/linux/ufs_fs.h~export-ufs_fsh-to-userspace
+++ a/include/linux/ufs_fs.h
@@ -45,8 +45,10 @@ typedef __u32 __bitwise __fs32;
 typedef __u16 __bitwise __fs16;
 #endif
 
+#ifdef __KERNEL__
 #include <linux/ufs_fs_i.h>
 #include <linux/ufs_fs_sb.h>
+#endif
 
 #define UFS_BBLOCK 0
 #define UFS_BBSIZE 8192
@@ -303,7 +305,7 @@ typedef __u16 __bitwise __fs16;
 #define UFS_MAXMNTLEN 512
 #define UFS2_MAXMNTLEN 468
 #define UFS2_MAXVOLLEN 32
-/* #define UFS_MAXCSBUFS 31 */
+#define UFS_MAXCSBUFS 31
 #define UFS_LINK_MAX 32000
 /*
 #define	UFS2_NOCSPTRS	((128 / sizeof(void *)) - 4)
diff -puN include/linux/ufs_fs_sb.h~export-ufs_fsh-to-userspace include/linux/ufs_fs_sb.h
--- a/include/linux/ufs_fs_sb.h~export-ufs_fsh-to-userspace
+++ a/include/linux/ufs_fs_sb.h
@@ -21,7 +21,6 @@
 struct ufs_sb_private_info;
 struct ufs_cg_private_info;
 struct ufs_csum;
-#define UFS_MAXCSBUFS 31
 
 struct ufs_sb_info {
 	struct ufs_sb_private_info * s_uspi;	
_

Patches currently in -mm which might be from vapier@gentoo.org are

search-a-little-harder-for-mkimage.patch
new-toplevel-target-headers_check_all.patch
use-__u64-rather-than-u64-in-parisc-statfs-structs.patch
use-__u32-rather-than-u32-in-userspace-ioctls-in-usbdevice_fsh.patch
m68k-dont-include-asm-m68k-pageh-in-asm-m68k-userh.patch
some-rtc-documentation-updates.patch
export-ufs_fsh-to-userspace.patch

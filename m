From: akpm@linux-foundation.org
Subject: - unexport-asm-elfh.patch removed from -mm tree
Date: Wed, 07 Nov 2007 14:30:12 -0800
Message-ID: <200711072230.lA7MUEJP031216@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36563 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754898AbXKGWay (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Nov 2007 17:30:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.shutemov@gmail.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Unexport asm/elf.h
has been removed from the -mm tree.  Its filename was
     unexport-asm-elfh.patch

This patch was dropped because it missed powerpc (at least)

------------------------------------------------------
Subject: Unexport asm/elf.h
From: "Kirill A. Shutemov" <k.shutemov@gmail.com>

Do not export asm/elf.h during make headers_install.

Signed-off-by: Kirill A. Shutemov <k.shutemov@gmail.com>
Reviewed-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/Kbuild.asm |    3 ---
 include/linux/Kbuild           |    2 +-
 include/linux/elf.h            |    2 ++
 include/linux/elfcore.h        |    2 ++
 4 files changed, 5 insertions(+), 4 deletions(-)

diff -puN include/asm-generic/Kbuild.asm~unexport-asm-elfh include/asm-generic/Kbuild.asm
--- a/include/asm-generic/Kbuild.asm~unexport-asm-elfh
+++ a/include/asm-generic/Kbuild.asm
@@ -28,6 +28,3 @@ unifdef-y += termios.h
 unifdef-y += types.h
 unifdef-y += unistd.h
 unifdef-y += user.h
-
-# These probably shouldn't be exported
-unifdef-y += elf.h
diff -puN include/linux/Kbuild~unexport-asm-elfh include/linux/Kbuild
--- a/include/linux/Kbuild~unexport-asm-elfh
+++ a/include/linux/Kbuild
@@ -58,7 +58,6 @@ header-y += dqblk_v2.h
 header-y += dqblk_xfs.h
 header-y += efs_fs_sb.h
 header-y += elf-fdpic.h
-header-y += elf.h
 header-y += elf-em.h
 header-y += fadvise.h
 header-y += fd.h
@@ -189,6 +188,7 @@ unifdef-y += dccp.h
 unifdef-y += dirent.h
 unifdef-y += dlm.h
 unifdef-y += edd.h
+unifdef-y += elf.h
 unifdef-y += elfcore.h
 unifdef-y += errno.h
 unifdef-y += errqueue.h
diff -puN include/linux/elf.h~unexport-asm-elfh include/linux/elf.h
--- a/include/linux/elf.h~unexport-asm-elfh
+++ a/include/linux/elf.h
@@ -3,7 +3,9 @@
 
 #include <linux/types.h>
 #include <linux/elf-em.h>
+#ifdef __KERNEL__
 #include <asm/elf.h>
+#endif
 
 struct file;
 
diff -puN include/linux/elfcore.h~unexport-asm-elfh include/linux/elfcore.h
--- a/include/linux/elfcore.h~unexport-asm-elfh
+++ a/include/linux/elfcore.h
@@ -14,7 +14,9 @@ struct elf_siginfo
 	int	si_errno;			/* errno */
 };
 
+#ifdef __KERNEL__
 #include <asm/elf.h>
+#endif
 
 #ifndef __KERNEL__
 typedef elf_greg_t greg_t;
_

Patches currently in -mm which might be from k.shutemov@gmail.com are

unexport-asm-elfh.patch
unexport-asm-userh-and-linux-userh.patch
cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed.patch

From: akpm@linux-foundation.org
Subject: - unexport-asm-userh-and-linux-userh.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:08:23 -0800
Message-ID: <200802080808.m18884xw014617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47465 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762006AbYBHIVp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:21:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.shutemov@gmail.com, dwmw2@infradead.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Unexport asm/user.h and linux/user.h
has been removed from the -mm tree.  Its filename was
     unexport-asm-userh-and-linux-userh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Unexport asm/user.h and linux/user.h
From: "Kirill A. Shutemov" <k.shutemov@gmail.com>

Do not export asm/user.h and linux/user.h during make headers_install.

Signed-off-by: Kirill A. Shutemov <k.shutemov@gmail.com>
Reviewed-by: David Woodhouse <dwmw2@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/Kbuild.asm |    1 -
 include/asm-x86/Kbuild         |    2 --
 include/linux/Kbuild           |    1 -
 include/linux/elfcore.h        |    2 ++
 4 files changed, 2 insertions(+), 4 deletions(-)

diff -puN include/asm-generic/Kbuild.asm~unexport-asm-userh-and-linux-userh include/asm-generic/Kbuild.asm
--- a/include/asm-generic/Kbuild.asm~unexport-asm-userh-and-linux-userh
+++ a/include/asm-generic/Kbuild.asm
@@ -27,7 +27,6 @@ unifdef-y += termbits.h
 unifdef-y += termios.h
 unifdef-y += types.h
 unifdef-y += unistd.h
-unifdef-y += user.h
 
 # These probably shouldn't be exported
 unifdef-y += elf.h
diff -puN include/asm-x86/Kbuild~unexport-asm-userh-and-linux-userh include/asm-x86/Kbuild
--- a/include/asm-x86/Kbuild~unexport-asm-userh-and-linux-userh
+++ a/include/asm-x86/Kbuild
@@ -22,7 +22,5 @@ unifdef-y += posix_types_64.h
 unifdef-y += ptrace.h
 unifdef-y += unistd_32.h
 unifdef-y += unistd_64.h
-unifdef-y += user_32.h
-unifdef-y += user_64.h
 unifdef-y += vm86.h
 unifdef-y += vsyscall.h
diff -puN include/linux/Kbuild~unexport-asm-userh-and-linux-userh include/linux/Kbuild
--- a/include/linux/Kbuild~unexport-asm-userh-and-linux-userh
+++ a/include/linux/Kbuild
@@ -344,7 +344,6 @@ unifdef-y += uinput.h
 unifdef-y += uio.h
 unifdef-y += unistd.h
 unifdef-y += usbdevice_fs.h
-unifdef-y += user.h
 unifdef-y += utsname.h
 unifdef-y += videodev2.h
 unifdef-y += videodev.h
diff -puN include/linux/elfcore.h~unexport-asm-userh-and-linux-userh include/linux/elfcore.h
--- a/include/linux/elfcore.h~unexport-asm-userh-and-linux-userh
+++ a/include/linux/elfcore.h
@@ -4,7 +4,9 @@
 #include <linux/types.h>
 #include <linux/signal.h>
 #include <linux/time.h>
+#ifdef __KERNEL__
 #include <linux/user.h>
+#endif
 #include <linux/ptrace.h>
 
 struct elf_siginfo
_

Patches currently in -mm which might be from k.shutemov@gmail.com are

origin.patch

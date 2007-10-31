From: akpm@linux-foundation.org
Subject: + unexport-asm-userh-and-linux-userh.patch added to -mm tree
Date: Wed, 31 Oct 2007 13:23:18 -0700
Message-ID: <200710312023.l9VKNI7F025819@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52769 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754333AbXJaUY2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Oct 2007 16:24:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: k.shutemov@gmail.com, dwmw2@infradead.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de


The patch titled
     Unexport asm/user.h and linux/user.h
has been added to the -mm tree.  Its filename is
     unexport-asm-userh-and-linux-userh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Unexport asm/user.h and linux/user.h
From: "Kirill A. Shutemov" <k.shutemov@gmail.com>

Do not export asm/user.h and linux/user.h during make headers_install.

Signed-off-by: Kirill A. Shutemov <k.shutemov@gmail.com>
Reviewed-by: David Woodhouse <dwmw2@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
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
@@ -27,4 +27,3 @@ unifdef-y += termbits.h
 unifdef-y += termios.h
 unifdef-y += types.h
 unifdef-y += unistd.h
-unifdef-y += user.h
diff -puN include/asm-x86/Kbuild~unexport-asm-userh-and-linux-userh include/asm-x86/Kbuild
--- a/include/asm-x86/Kbuild~unexport-asm-userh-and-linux-userh
+++ a/include/asm-x86/Kbuild
@@ -21,7 +21,5 @@ unifdef-y += posix_types_64.h
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
@@ -341,7 +341,6 @@ unifdef-y += uinput.h
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

unexport-asm-pageh.patch
unexport-asm-elfh.patch
unexport-asm-userh-and-linux-userh.patch
cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed.patch

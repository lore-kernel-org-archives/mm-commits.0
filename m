From: akpm@linux-foundation.org
Subject: - unexport-asm-pageh.patch removed from -mm tree
Date: Wed, 07 Nov 2007 13:55:44 -0800
Message-ID: <200711072155.lA7Ltjm2029798@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50425 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756427AbXKGV4v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Nov 2007 16:56:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.shutemov@gmail.com, dhowells@redhat.com, dwmw2@infradead.org, heiko.carstens@de.ibm.com, hpa@zytor.com, mingo@redhat.com, schwidefsky@de.ibm.com, tglx@linutronix.de, mm-commits@vger


The patch titled
     Unexport asm/page.h
has been removed from the -mm tree.  Its filename was
     unexport-asm-pageh.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: Unexport asm/page.h
From: "Kirill A. Shutemov" <k.shutemov@gmail.com>

Do not export asm/page.h during make headers_install.  This removes PAGE_SIZE
from userspace headers.

Signed-off-by: Kirill A. Shutemov <k.shutemov@gmail.com>
Reviewed-by: David Woodhouse <dwmw2@infradead.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-frv/Kbuild         |    1 -
 include/asm-generic/Kbuild.asm |    1 -
 include/asm-s390/kexec.h       |    2 ++
 include/asm-x86/Kbuild         |    2 --
 include/linux/Kbuild           |    2 +-
 include/linux/a.out.h          |    8 ++++++++
 include/linux/shm.h            |    8 ++++++++
 7 files changed, 19 insertions(+), 5 deletions(-)

diff -puN include/asm-frv/Kbuild~unexport-asm-pageh include/asm-frv/Kbuild
--- a/include/asm-frv/Kbuild~unexport-asm-pageh
+++ a/include/asm-frv/Kbuild
@@ -4,4 +4,3 @@ header-y += registers.h
 
 unifdef-y += termios.h
 unifdef-y += ptrace.h
-unifdef-y += page.h
diff -puN include/asm-generic/Kbuild.asm~unexport-asm-pageh include/asm-generic/Kbuild.asm
--- a/include/asm-generic/Kbuild.asm~unexport-asm-pageh
+++ a/include/asm-generic/Kbuild.asm
@@ -31,4 +31,3 @@ unifdef-y += user.h
 
 # These probably shouldn't be exported
 unifdef-y += elf.h
-unifdef-y += page.h
diff -puN include/asm-s390/kexec.h~unexport-asm-pageh include/asm-s390/kexec.h
--- a/include/asm-s390/kexec.h~unexport-asm-pageh
+++ a/include/asm-s390/kexec.h
@@ -10,7 +10,9 @@
 #ifndef _S390_KEXEC_H
 #define _S390_KEXEC_H
 
+#ifdef __KERNEL__
 #include <asm/page.h>
+#endif
 #include <asm/processor.h>
 /*
  * KEXEC_SOURCE_MEMORY_LIMIT maximum page get_free_page can return.
diff -puN include/asm-x86/Kbuild~unexport-asm-pageh include/asm-x86/Kbuild
--- a/include/asm-x86/Kbuild~unexport-asm-pageh
+++ a/include/asm-x86/Kbuild
@@ -16,8 +16,6 @@ unifdef-y += ist.h
 unifdef-y += mce.h
 unifdef-y += msr.h
 unifdef-y += mtrr.h
-unifdef-y += page_32.h
-unifdef-y += page_64.h
 unifdef-y += posix_types_32.h
 unifdef-y += posix_types_64.h
 unifdef-y += ptrace.h
diff -puN include/linux/Kbuild~unexport-asm-pageh include/linux/Kbuild
--- a/include/linux/Kbuild~unexport-asm-pageh
+++ a/include/linux/Kbuild
@@ -17,7 +17,6 @@ header-y += usb/
 
 header-y += affs_hardblocks.h
 header-y += aio_abi.h
-header-y += a.out.h
 header-y += arcfb.h
 header-y += atmapi.h
 header-y += atmbr2684.h
@@ -165,6 +164,7 @@ unifdef-y += acct.h
 unifdef-y += adb.h
 unifdef-y += adfs_fs.h
 unifdef-y += agpgart.h
+unifdef-y += a.out.h
 unifdef-y += apm_bios.h
 unifdef-y += atalk.h
 unifdef-y += atmarp.h
diff -puN include/linux/a.out.h~unexport-asm-pageh include/linux/a.out.h
--- a/include/linux/a.out.h~unexport-asm-pageh
+++ a/include/linux/a.out.h
@@ -130,12 +130,20 @@ enum machine_type {
 #endif
 
 #ifdef linux
+#ifdef __KERNEL__
 #include <asm/page.h>
+#else
+#include <unistd.h>
+#endif
 #if defined(__i386__) || defined(__mc68000__)
 #define SEGMENT_SIZE	1024
 #else
 #ifndef SEGMENT_SIZE
+#ifdef __KERNEL__
 #define SEGMENT_SIZE	PAGE_SIZE
+#else
+#define SEGMENT_SIZE   getpagesize()
+#endif
 #endif
 #endif
 #endif
diff -puN include/linux/shm.h~unexport-asm-pageh include/linux/shm.h
--- a/include/linux/shm.h~unexport-asm-pageh
+++ a/include/linux/shm.h
@@ -3,7 +3,11 @@
 
 #include <linux/ipc.h>
 #include <linux/errno.h>
+#ifdef __KERNEL__
 #include <asm/page.h>
+#else
+#include <unistd.h>
+#endif
 
 /*
  * SHMMAX, SHMMNI and SHMALL are upper limits are defaults which can
@@ -13,7 +17,11 @@
 #define SHMMAX 0x2000000		 /* max shared seg size (bytes) */
 #define SHMMIN 1			 /* min shared seg size (bytes) */
 #define SHMMNI 4096			 /* max num of segs system wide */
+#ifdef __KERNEL__
 #define SHMALL (SHMMAX/PAGE_SIZE*(SHMMNI/16)) /* max shm system wide (pages) */
+#else
+#define SHMALL (SHMMAX/getpagesize()*(SHMMNI/16))
+#endif
 #define SHMSEG SHMMNI			 /* max shared segs per process */
 
 #ifdef __KERNEL__
_

Patches currently in -mm which might be from k.shutemov@gmail.com are

unexport-asm-pageh.patch
unexport-asm-elfh.patch
unexport-asm-userh-and-linux-userh.patch
cleanup-asm-elfpageuserh-ifdef-__kernel__-is-no-longer-needed.patch

From: akpm@linux-foundation.org
Subject: - centralize-checking-for-an-acceptable-version-of-gcc.patch removed from -mm tree
Date: Tue, 12 Jun 2007 15:20:29 -0700
Message-ID: <200706122224.l5CMOBlW022599@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50527 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752146AbXFLWYa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 18:24:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, mm-commits@vger.kernel.org


The patch titled
     Centralize checking for an acceptable version of gcc
has been removed from the -mm tree.  Its filename was
     centralize-checking-for-an-acceptable-version-of-gcc.patch

This patch was dropped because it hurts

------------------------------------------------------
Subject: Centralize checking for an acceptable version of gcc
From: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler.h |   14 +++++++++++---
 init/main.c              |   18 ------------------
 2 files changed, 11 insertions(+), 21 deletions(-)

diff -puN include/linux/compiler.h~centralize-checking-for-an-acceptable-version-of-gcc include/linux/compiler.h
--- a/include/linux/compiler.h~centralize-checking-for-an-acceptable-version-of-gcc
+++ a/include/linux/compiler.h
@@ -36,12 +36,20 @@ extern void __chk_io_ptr(const void __io
 
 #ifdef __KERNEL__
 
-#if __GNUC__ >= 4
+/*
+ *  Start with some sanity checking on the version of gcc.
+ */
+
+#if (__GNUC__ < 3) || (__GNUC__ == 3 && __GNUC_MINOR__ < 2)
+# error Sorry, your GCC is too old. It builds incorrect kernels.
+#elif __GNUC__ == 4 && __GNUC_MINOR__ == 1 && __GNUC_PATCHLEVEL__ == 0
+# warning gcc-4.1.0 is known to miscompile the kernel.  A different compiler version is recommended.
+#elif __GNUC__ == 4
 # include <linux/compiler-gcc4.h>
-#elif __GNUC__ == 3 && __GNUC_MINOR__ >= 2
+#elif __GNUC__ == 3
 # include <linux/compiler-gcc3.h>
 #else
-# error Sorry, your compiler is too old/not recognized.
+# error Sorry, your compiler is not recognized.
 #endif
 
 /* Intel compiler defines __GNUC__. So we will overwrite implementations
diff -puN init/main.c~centralize-checking-for-an-acceptable-version-of-gcc init/main.c
--- a/init/main.c~centralize-checking-for-an-acceptable-version-of-gcc
+++ a/init/main.c
@@ -5,7 +5,6 @@
  *
  *  GK 2/5/95  -  Changed to support mounting root fs via NFS
  *  Added initrd & change_root: Werner Almesberger & Hans Lermen, Feb '96
- *  Moan early if gcc is old, avoiding bogus kernels - Paul Gortmaker, May '96
  *  Simplified starting of init:  Michael A. Griffith <grif@acm.org> 
  */
 
@@ -66,23 +65,6 @@
 #include <asm/smp.h>
 #endif
 
-/*
- * This is one of the first .c files built. Error out early if we have compiler
- * trouble.
- *
- * Versions of gcc older than that listed below may actually compile and link
- * okay, but the end product can have subtle run time bugs.  To avoid associated
- * bogus bug reports, we flatly refuse to compile with a gcc that is known to be
- * too old from the very beginning.
- */
-#if (__GNUC__ < 3) || (__GNUC__ == 3 && __GNUC_MINOR__ < 2)
-#error Sorry, your GCC is too old. It builds incorrect kernels.
-#endif
-
-#if __GNUC__ == 4 && __GNUC_MINOR__ == 1 && __GNUC_PATCHLEVEL__ == 0
-#warning gcc-4.1.0 is known to miscompile the kernel.  A different compiler version is recommended.
-#endif
-
 static int kernel_init(void *);
 
 extern void init_IRQ(void);
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
ppc-remove-dead-code-for-preventing-pread-and-pwrite-calls.patch
viotape-use-designated-initializers-for-fops-member.patch
git-dvb.patch
git-ieee1394.patch
input-delete-useless-reference-to-dead-module_parm-macro.patch
git-kbuild.patch
git-kvm.patch
bluetooth-remove-the-redundant-non-seekable-llseek-method.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-s390.patch
git-scsi-misc.patch
remove-dead-references-to-module_parm-macro.patch
git-watchdog.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
cris-replace-old-style-member-inits-with-designated-inits.patch
remove-unnecessary-includes-of-spinlockh-under-include-linux.patch
drop-an-empty-isicomh-from-being-exported-to-user-space.patch
remove-apparently-useless-commented-apm_get_battery_status.patch
cobalt-remove-all-references-to-cobalt-nvram.patch
centralize-checking-for-an-acceptable-version-of-gcc.patch

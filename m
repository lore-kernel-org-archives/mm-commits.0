From: akpm@linux-foundation.org
Subject: [merged] powerpc-kexec-enable-kexec_file_load-syscall.patch
 removed from -mm tree
Date: Fri, 02 Dec 2016 15:45:46 -0800
Message-ID: <584207aa.1x4Pvg40m+vs6+Vw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59072 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753264AbcLBXpe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2016 18:45:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bauerman@linux.vnet.ibm.com, benh@kernel.crashing.org, bhe@redhat.com, bsingharora@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, hpa@zytor.com, mingo@redhat.com, mpe@ellerman.id.au, paulus@samba.org, sfr@canb.auug.org.au, sklar@linux.vnet.ibm.com, stewart@linux.vnet.ibm.com, tglx@linutronix.de, vgoyal@redhat.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/kexec: enable kexec_file_load() syscall
has been removed from the -mm tree.  Its filename was
     powerpc-kexec-enable-kexec_file_load-syscall.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: powerpc/kexec: enable kexec_file_load() syscall

Define the Kconfig symbol so that the kexec_file_load() code can be
built, and wire up the syscall so that it can be called.

Link: http://lkml.kernel.org/r/1480423554-6411-8-git-send-email-mpe@ellerman.id.au
Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Josh Sklar <sklar@linux.vnet.ibm.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stewart Smith <stewart@linux.vnet.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig                   |   13 +++++++++++++
 arch/powerpc/include/asm/systbl.h      |    1 +
 arch/powerpc/include/asm/unistd.h      |    2 +-
 arch/powerpc/include/uapi/asm/unistd.h |    1 +
 4 files changed, 16 insertions(+), 1 deletion(-)

diff -puN arch/powerpc/Kconfig~powerpc-kexec-enable-kexec_file_load-syscall arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~powerpc-kexec-enable-kexec_file_load-syscall
+++ a/arch/powerpc/Kconfig
@@ -466,6 +466,19 @@ config KEXEC
 	  interface is strongly in flux, so no good recommendation can be
 	  made.
 
+config KEXEC_FILE
+	bool "kexec file based system call"
+	select KEXEC_CORE
+	select BUILD_BIN2C
+	depends on PPC64
+	depends on CRYPTO=y
+	depends on CRYPTO_SHA256=y
+	help
+	  This is a new version of the kexec system call. This call is
+	  file based and takes in file descriptors as system call arguments
+	  for kernel and initramfs as opposed to a list of segments as is the
+	  case for the older kexec call.
+
 config RELOCATABLE
 	bool "Build a relocatable kernel"
 	depends on (PPC64 && !COMPILE_TEST) || (FLATMEM && (44x || FSL_BOOKE))
diff -puN arch/powerpc/include/asm/systbl.h~powerpc-kexec-enable-kexec_file_load-syscall arch/powerpc/include/asm/systbl.h
--- a/arch/powerpc/include/asm/systbl.h~powerpc-kexec-enable-kexec_file_load-syscall
+++ a/arch/powerpc/include/asm/systbl.h
@@ -386,3 +386,4 @@ SYSCALL(mlock2)
 SYSCALL(copy_file_range)
 COMPAT_SYS_SPU(preadv2)
 COMPAT_SYS_SPU(pwritev2)
+SYSCALL(kexec_file_load)
diff -puN arch/powerpc/include/asm/unistd.h~powerpc-kexec-enable-kexec_file_load-syscall arch/powerpc/include/asm/unistd.h
--- a/arch/powerpc/include/asm/unistd.h~powerpc-kexec-enable-kexec_file_load-syscall
+++ a/arch/powerpc/include/asm/unistd.h
@@ -12,7 +12,7 @@
 #include <uapi/asm/unistd.h>
 
 
-#define NR_syscalls		382
+#define NR_syscalls		383
 
 #define __NR__exit __NR_exit
 
diff -puN arch/powerpc/include/uapi/asm/unistd.h~powerpc-kexec-enable-kexec_file_load-syscall arch/powerpc/include/uapi/asm/unistd.h
--- a/arch/powerpc/include/uapi/asm/unistd.h~powerpc-kexec-enable-kexec_file_load-syscall
+++ a/arch/powerpc/include/uapi/asm/unistd.h
@@ -392,5 +392,6 @@
 #define __NR_copy_file_range	379
 #define __NR_preadv2		380
 #define __NR_pwritev2		381
+#define __NR_kexec_file_load	382
 
 #endif /* _UAPI_ASM_POWERPC_UNISTD_H_ */
_

Patches currently in -mm which might be from bauerman@linux.vnet.ibm.com are

powerpc-enable-config_kexec_file-in-powerpc-server-defconfigs.patch
powerpc-ima-get-the-kexec-buffer-passed-by-the-previous-kernel.patch
powerpc-ima-send-the-kexec-buffer-to-the-next-kernel.patch


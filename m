From: akpm@linux-foundation.org
Subject: [folded-merged]
 kexec-load-and-relocate-purgatory-at-kernel-load-time-fix.patch removed
 from -mm tree
Date: Fri, 08 Aug 2014 14:03:02 -0700
Message-ID: <53e53b06.BsQ1bMc+Br5wrnNZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:46390 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932648AbaHHVDD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2014 17:03:03 -0400
Received: by mail-yh0-f74.google.com with SMTP id 29so807862yhl.1
        for <mm-commits@vger.kernel.org>; Fri, 08 Aug 2014 14:03:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@redhat.com, bhe@redhat.com, bp@suse.de, chaowang@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, greg@kroah.com, hpa@zytor.com, luto@amacapital.net, mjg59@srcf.ucam.org, mtk.manpages@gmail.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec-load-and-relocate-purgatory-at-kernel-load-time-fix
has been removed from the -mm tree.  Its filename was
     kexec-load-and-relocate-purgatory-at-kernel-load-time-fix.patch

This patch was dropped because it was folded into kexec-load-and-relocate-purgatory-at-kernel-load-time.patch

------------------------------------------------------
From: Vivek Goyal <vgoyal@redhat.com>
Subject: kexec-load-and-relocate-purgatory-at-kernel-load-time-fix

Set CRYPTO=y and CRYPTO_SHA256=y for all arch supporting kexec.

Generic kexec implementation now makes use of crypto API to calculate the
sha256 digest of loaded kernel segments (for new syscall kexec_file_load()).

That means one need to enforce that CRYPTO and CRYPTO_SHA256 are built in
for kexec to compile and for new syscall to work.

I created this dependency for x86 but forgot to do for other arches
supporting kexec. And ran into compilation failure reports from kbuild
test robot.

   kernel/built-in.o: In function `sys_kexec_file_load':
   (.text+0x32314): undefined reference to `crypto_shash_final'
   kernel/built-in.o: In function `sys_kexec_file_load':
   (.text+0x32328): undefined reference to `crypto_shash_update'
   kernel/built-in.o: In function `sys_kexec_file_load':
>> (.text+0x32338): undefined reference to `crypto_alloc_shash'

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: WANG Chao <chaowang@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig     |    2 ++
 arch/ia64/Kconfig    |    2 ++
 arch/m68k/Kconfig    |    2 ++
 arch/mips/Kconfig    |    2 ++
 arch/powerpc/Kconfig |    2 ++
 arch/s390/Kconfig    |    2 ++
 arch/sh/Kconfig      |    2 ++
 arch/tile/Kconfig    |    2 ++
 8 files changed, 16 insertions(+)

diff -puN arch/arm/Kconfig~kexec-load-and-relocate-purgatory-at-kernel-load-time-fix arch/arm/Kconfig
--- a/arch/arm/Kconfig~kexec-load-and-relocate-purgatory-at-kernel-load-time-fix
+++ a/arch/arm/Kconfig
@@ -1983,6 +1983,8 @@ config XIP_PHYS_ADDR
 config KEXEC
 	bool "Kexec system call (EXPERIMENTAL)"
 	depends on (!SMP || PM_SLEEP_SMP)
+	select CRYPTO
+	select CRYPTO_SHA256
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
diff -puN arch/ia64/Kconfig~kexec-load-and-relocate-purgatory-at-kernel-load-time-fix arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~kexec-load-and-relocate-purgatory-at-kernel-load-time-fix
+++ a/arch/ia64/Kconfig
@@ -549,6 +549,8 @@ source "drivers/sn/Kconfig"
 config KEXEC
 	bool "kexec system call"
 	depends on !IA64_HP_SIM && (!SMP || HOTPLUG_CPU)
+	select CRYPTO
+	select CRYPTO_SHA256
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
diff -puN arch/m68k/Kconfig~kexec-load-and-relocate-purgatory-at-kernel-load-time-fix arch/m68k/Kconfig
--- a/arch/m68k/Kconfig~kexec-load-and-relocate-purgatory-at-kernel-load-time-fix
+++ a/arch/m68k/Kconfig
@@ -91,6 +91,8 @@ config MMU_SUN3
 config KEXEC
 	bool "kexec system call"
 	depends on M68KCLASSIC
+	select CRYPTO
+	select CRYPTO_SHA256
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
diff -puN arch/mips/Kconfig~kexec-load-and-relocate-purgatory-at-kernel-load-time-fix arch/mips/Kconfig
--- a/arch/mips/Kconfig~kexec-load-and-relocate-purgatory-at-kernel-load-time-fix
+++ a/arch/mips/Kconfig
@@ -2396,6 +2396,8 @@ source "kernel/Kconfig.preempt"
 
 config KEXEC
 	bool "Kexec system call"
+	select CRYPTO
+	select CRYPTO_SHA256
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
diff -puN arch/powerpc/Kconfig~kexec-load-and-relocate-purgatory-at-kernel-load-time-fix arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~kexec-load-and-relocate-purgatory-at-kernel-load-time-fix
+++ a/arch/powerpc/Kconfig
@@ -399,6 +399,8 @@ config PPC64_SUPPORTS_MEMORY_FAILURE
 config KEXEC
 	bool "kexec system call"
 	depends on (PPC_BOOK3S || FSL_BOOKE || (44x && !SMP))
+	select CRYPTO
+	select CRYPTO_SHA256
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
diff -puN arch/s390/Kconfig~kexec-load-and-relocate-purgatory-at-kernel-load-time-fix arch/s390/Kconfig
--- a/arch/s390/Kconfig~kexec-load-and-relocate-purgatory-at-kernel-load-time-fix
+++ a/arch/s390/Kconfig
@@ -48,6 +48,8 @@ config ARCH_SUPPORTS_DEBUG_PAGEALLOC
 
 config KEXEC
 	def_bool y
+	select CRYPTO
+	select CRYPTO_SHA256
 
 config AUDIT_ARCH
 	def_bool y
diff -puN arch/sh/Kconfig~kexec-load-and-relocate-purgatory-at-kernel-load-time-fix arch/sh/Kconfig
--- a/arch/sh/Kconfig~kexec-load-and-relocate-purgatory-at-kernel-load-time-fix
+++ a/arch/sh/Kconfig
@@ -595,6 +595,8 @@ source kernel/Kconfig.hz
 config KEXEC
 	bool "kexec system call (EXPERIMENTAL)"
 	depends on SUPERH32 && MMU
+	select CRYPTO
+	select CRYPTO_SHA256
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
diff -puN arch/tile/Kconfig~kexec-load-and-relocate-purgatory-at-kernel-load-time-fix arch/tile/Kconfig
--- a/arch/tile/Kconfig~kexec-load-and-relocate-purgatory-at-kernel-load-time-fix
+++ a/arch/tile/Kconfig
@@ -191,6 +191,8 @@ source "kernel/Kconfig.hz"
 
 config KEXEC
 	bool "kexec system call"
+	select CRYPTO
+	select CRYPTO_SHA256
 	---help---
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
_

Patches currently in -mm which might be from vgoyal@redhat.com are

origin.patch
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors.patch
bin2c-move-bin2c-in-scripts-basic.patch
kernel-build-bin2c-based-on-config-option-config_build_bin2c.patch
kexec-rename-unusebale_pages-to-unusable_pages.patch
kexec-move-segment-verification-code-in-a-separate-function.patch
kexec-use-common-function-for-kimage_normal_alloc-and-kimage_crash_alloc.patch
resource-provide-new-functions-to-walk-through-resources.patch
kexec-make-kexec_segment-user-buffer-pointer-a-union.patch
kexec-new-syscall-kexec_file_load-declaration.patch
kexec-implementation-of-new-syscall-kexec_file_load.patch
purgatory-sha256-provide-implementation-of-sha256-in-purgaotory-context.patch
purgatory-core-purgatory-functionality.patch
kexec-load-and-relocate-purgatory-at-kernel-load-time.patch
kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry.patch
kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry-fix.patch
kexec-support-for-kexec-on-panic-using-new-system-call.patch
kexec-support-for-kexec-on-panic-using-new-system-call-fix.patch
kexec-support-kexec-kdump-on-efi-systems.patch
kexec-support-kexec-kdump-on-efi-systems-fix.patch
kexec-verify-the-signature-of-signed-pe-bzimage.patch


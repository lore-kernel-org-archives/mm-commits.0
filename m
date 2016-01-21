From: akpm@linux-foundation.org
Subject: [merged] powerpc-enable-ubsan-support.patch removed from -mm tree
Date: Thu, 21 Jan 2016 15:28:23 -0800
Message-ID: <56a16997.aviAZ8KYgRm2NlQC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35980 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbcAUX21 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:28:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dja@axtens.net, andrew.donnellan@au1.ibm.com, aryabinin@virtuozzo.com, benh@kernel.crashing.org, mpe@ellerman.id.au, valentinrothberg@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: enable UBSAN support
has been removed from the -mm tree.  Its filename was
     powerpc-enable-ubsan-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Axtens <dja@axtens.net>
Subject: powerpc: enable UBSAN support

This hooks up UBSAN support for PowerPC.

So far it's found some interesting cases where we don't properly sanitise
input to shifts, including one in our futex handling.  Nothing critical,
but interesting and worth fixing.

[valentinrothberg@gmail.com: arch/powerpc/Kconfig: fix typo in select statement]
Signed-off-by: Daniel Axtens <dja@axtens.net>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Tested-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Valentin Rothberg <valentinrothberg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig                |    1 +
 arch/powerpc/kernel/Makefile        |    8 +++++++-
 arch/powerpc/kernel/vdso32/Makefile |    1 +
 arch/powerpc/kernel/vdso64/Makefile |    1 +
 arch/powerpc/xmon/Makefile          |    1 +
 5 files changed, 11 insertions(+), 1 deletion(-)

diff -puN arch/powerpc/Kconfig~powerpc-enable-ubsan-support arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~powerpc-enable-ubsan-support
+++ a/arch/powerpc/Kconfig
@@ -158,6 +158,7 @@ config PPC
 	select ARCH_HAS_DMA_SET_COHERENT_MASK
 	select ARCH_HAS_DEVMEM_IS_ALLOWED
 	select HAVE_ARCH_SECCOMP_FILTER
+	select ARCH_HAS_UBSAN_SANITIZE_ALL
 
 config GENERIC_CSUM
 	def_bool CPU_LITTLE_ENDIAN
diff -puN arch/powerpc/kernel/Makefile~powerpc-enable-ubsan-support arch/powerpc/kernel/Makefile
--- a/arch/powerpc/kernel/Makefile~powerpc-enable-ubsan-support
+++ a/arch/powerpc/kernel/Makefile
@@ -136,12 +136,18 @@ endif
 obj-$(CONFIG_EPAPR_PARAVIRT)	+= epapr_paravirt.o epapr_hcalls.o
 obj-$(CONFIG_KVM_GUEST)		+= kvm.o kvm_emul.o
 
-# Disable GCOV in odd or sensitive code
+# Disable GCOV & sanitizers in odd or sensitive code
 GCOV_PROFILE_prom_init.o := n
+UBSAN_SANITIZE_prom_init.o := n
 GCOV_PROFILE_ftrace.o := n
+UBSAN_SANITIZE_ftrace.o := n
 GCOV_PROFILE_machine_kexec_64.o := n
+UBSAN_SANITIZE_machine_kexec_64.o := n
 GCOV_PROFILE_machine_kexec_32.o := n
+UBSAN_SANITIZE_machine_kexec_32.o := n
 GCOV_PROFILE_kprobes.o := n
+UBSAN_SANITIZE_kprobes.o := n
+UBSAN_SANITIZE_vdso.o := n
 
 extra-$(CONFIG_PPC_FPU)		+= fpu.o
 extra-$(CONFIG_ALTIVEC)		+= vector.o
diff -puN arch/powerpc/kernel/vdso32/Makefile~powerpc-enable-ubsan-support arch/powerpc/kernel/vdso32/Makefile
--- a/arch/powerpc/kernel/vdso32/Makefile~powerpc-enable-ubsan-support
+++ a/arch/powerpc/kernel/vdso32/Makefile
@@ -15,6 +15,7 @@ targets := $(obj-vdso32) vdso32.so vdso3
 obj-vdso32 := $(addprefix $(obj)/, $(obj-vdso32))
 
 GCOV_PROFILE := n
+UBSAN_SANITIZE := n
 
 ccflags-y := -shared -fno-common -fno-builtin
 ccflags-y += -nostdlib -Wl,-soname=linux-vdso32.so.1 \
diff -puN arch/powerpc/kernel/vdso64/Makefile~powerpc-enable-ubsan-support arch/powerpc/kernel/vdso64/Makefile
--- a/arch/powerpc/kernel/vdso64/Makefile~powerpc-enable-ubsan-support
+++ a/arch/powerpc/kernel/vdso64/Makefile
@@ -8,6 +8,7 @@ targets := $(obj-vdso64) vdso64.so vdso6
 obj-vdso64 := $(addprefix $(obj)/, $(obj-vdso64))
 
 GCOV_PROFILE := n
+UBSAN_SANITIZE := n
 
 ccflags-y := -shared -fno-common -fno-builtin
 ccflags-y += -nostdlib -Wl,-soname=linux-vdso64.so.1 \
diff -puN arch/powerpc/xmon/Makefile~powerpc-enable-ubsan-support arch/powerpc/xmon/Makefile
--- a/arch/powerpc/xmon/Makefile~powerpc-enable-ubsan-support
+++ a/arch/powerpc/xmon/Makefile
@@ -3,6 +3,7 @@
 subdir-ccflags-$(CONFIG_PPC_WERROR) := -Werror
 
 GCOV_PROFILE := n
+UBSAN_SANITIZE := n
 
 ccflags-$(CONFIG_PPC64) := $(NO_MINIMAL_TOC)
 
_

Patches currently in -mm which might be from dja@axtens.net are



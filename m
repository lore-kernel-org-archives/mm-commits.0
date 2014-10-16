From: akpm@linux-foundation.org
Subject: + gcov-enable-gcov_profile_all-from-arch-kconfigs.patch added to
 -mm tree
Date: Thu, 16 Oct 2014 12:25:59 -0700
Message-ID: <54401bc7.DrtzisIvUqh5Bij5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48017 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbaJPT0A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Oct 2014 15:26:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riku.voipio@linaro.org, oberpar@linux.vnet.ibm.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: gcov: enable GCOV_PROFILE_ALL from ARCH Kconfigs
has been added to the -mm tree.  Its filename is
     gcov-enable-gcov_profile_all-from-arch-kconfigs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/gcov-enable-gcov_profile_all-from-arch-kconfigs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/gcov-enable-gcov_profile_all-from-arch-kconfigs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Riku Voipio <riku.voipio@linaro.org>
Subject: gcov: enable GCOV_PROFILE_ALL from ARCH Kconfigs

Following the suggestions from Andrew Morton and Stephen Rothwell,
Dont expand the ARCH list in kernel/gcov/Kconfig. Instead,
define a ARCH_HAS_GCOV_PROFILE_ALL bool which architectures
can enable.

set ARCH_HAS_GCOV_PROFILE_ALL on Architectures where it was
previously allowed + ARM64 which I tested.

Signed-off-by: Riku Voipio <riku.voipio@linaro.org>
Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig        |    1 +
 arch/arm64/Kconfig      |    1 +
 arch/microblaze/Kconfig |    1 +
 arch/powerpc/Kconfig    |    1 +
 arch/s390/Kconfig       |    1 +
 arch/sh/Kconfig         |    1 +
 arch/x86/Kconfig        |    1 +
 kernel/gcov/Kconfig     |    5 ++++-
 8 files changed, 11 insertions(+), 1 deletion(-)

diff -puN arch/arm/Kconfig~gcov-enable-gcov_profile_all-from-arch-kconfigs arch/arm/Kconfig
--- a/arch/arm/Kconfig~gcov-enable-gcov_profile_all-from-arch-kconfigs
+++ a/arch/arm/Kconfig
@@ -5,6 +5,7 @@ config ARM
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAVE_CUSTOM_GPIO_H
+	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_USE_BUILTIN_BSWAP
diff -puN arch/arm64/Kconfig~gcov-enable-gcov_profile_all-from-arch-kconfigs arch/arm64/Kconfig
--- a/arch/arm64/Kconfig~gcov-enable-gcov_profile_all-from-arch-kconfigs
+++ a/arch/arm64/Kconfig
@@ -1,6 +1,7 @@
 config ARM64
 	def_bool y
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
+	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_SG_CHAIN
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_USE_CMPXCHG_LOCKREF
diff -puN arch/microblaze/Kconfig~gcov-enable-gcov_profile_all-from-arch-kconfigs arch/microblaze/Kconfig
--- a/arch/microblaze/Kconfig~gcov-enable-gcov_profile_all-from-arch-kconfigs
+++ a/arch/microblaze/Kconfig
@@ -1,5 +1,6 @@
 config MICROBLAZE
 	def_bool y
+	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select ARCH_WANT_OPTIONAL_GPIOLIB
diff -puN arch/powerpc/Kconfig~gcov-enable-gcov_profile_all-from-arch-kconfigs arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~gcov-enable-gcov_profile_all-from-arch-kconfigs
+++ a/arch/powerpc/Kconfig
@@ -128,6 +128,7 @@ config PPC
 	select HAVE_BPF_JIT if PPC64
 	select HAVE_ARCH_JUMP_LABEL
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select ARCH_HAS_GCOV_PROFILE_ALL
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_CMOS_UPDATE
 	select GENERIC_TIME_VSYSCALL_OLD
diff -puN arch/s390/Kconfig~gcov-enable-gcov_profile_all-from-arch-kconfigs arch/s390/Kconfig
--- a/arch/s390/Kconfig~gcov-enable-gcov_profile_all-from-arch-kconfigs
+++ a/arch/s390/Kconfig
@@ -65,6 +65,7 @@ config S390
 	def_bool y
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
+	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select ARCH_INLINE_READ_LOCK
 	select ARCH_INLINE_READ_LOCK_BH
diff -puN arch/sh/Kconfig~gcov-enable-gcov_profile_all-from-arch-kconfigs arch/sh/Kconfig
--- a/arch/sh/Kconfig~gcov-enable-gcov_profile_all-from-arch-kconfigs
+++ a/arch/sh/Kconfig
@@ -16,6 +16,7 @@ config SUPERH
 	select HAVE_DEBUG_BUGVERBOSE
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if (GUSA_RB || CPU_SH4A)
+	select ARCH_HAS_GCOV_PROFILE_ALL
 	select PERF_USE_VMALLOC
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_KERNEL_GZIP
diff -puN arch/x86/Kconfig~gcov-enable-gcov_profile_all-from-arch-kconfigs arch/x86/Kconfig
--- a/arch/x86/Kconfig~gcov-enable-gcov_profile_all-from-arch-kconfigs
+++ a/arch/x86/Kconfig
@@ -24,6 +24,7 @@ config X86
 	select ARCH_MIGHT_HAVE_ACPI_PDC if ACPI
 	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
 	select ARCH_HAS_FAST_MULTIPLIER
+	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_MIGHT_HAVE_PC_SERIO
 	select HAVE_AOUT if X86_32
diff -puN kernel/gcov/Kconfig~gcov-enable-gcov_profile_all-from-arch-kconfigs kernel/gcov/Kconfig
--- a/kernel/gcov/Kconfig~gcov-enable-gcov_profile_all-from-arch-kconfigs
+++ a/kernel/gcov/Kconfig
@@ -32,10 +32,13 @@ config GCOV_KERNEL
 	Note that the debugfs filesystem has to be mounted to access
 	profiling data.
 
+config ARCH_HAS_GCOV_PROFILE_ALL
+	def_bool n
+
 config GCOV_PROFILE_ALL
 	bool "Profile entire Kernel"
 	depends on GCOV_KERNEL
-	depends on SUPERH || S390 || X86 || PPC || MICROBLAZE || ARM || ARM64
+	depends on ARCH_HAS_GCOV_PROFILE_ALL
 	default n
 	---help---
 	This options activates profiling for the entire kernel.
_

Patches currently in -mm which might be from riku.voipio@linaro.org are

origin.patch
gcov-add-arm64-to-gcov_profile_all.patch
gcov-enable-gcov_profile_all-from-arch-kconfigs.patch


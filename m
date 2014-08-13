From: akpm@linux-foundation.org
Subject: + kexec-remove-config_kexec-dependency-on-crypto.patch added to
 -mm tree
Date: Wed, 13 Aug 2014 13:35:26 -0700
Message-ID: <53ebcc0e.an2EFfK1c0qflNb6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:50340 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaHMUf1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Aug 2014 16:35:27 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so91141pde.5
        for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2014 13:35:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@redhat.com, ebiederm@xmission.com, hpa@zytor.com, sruffell@digium.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: remove CONFIG_KEXEC dependency on crypto
has been added to the -mm tree.  Its filename is
     kexec-remove-config_kexec-dependency-on-crypto.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-remove-config_kexec-dependency-on-crypto.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-remove-config_kexec-dependency-on-crypto.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vivek Goyal <vgoyal@redhat.com>
Subject: kexec: remove CONFIG_KEXEC dependency on crypto

New system call depends on crypto.  As it did not have a separate config
option, CONFIG_KEXEC was modified to select CRYPTO and CRYPTO_SHA256.

But now previous patch introduced a new config option for new syscall.  So
CONFIG_KEXEC does not require crypto.  Remove that dependency.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Shaun Ruffell <sruffell@digium.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig     |    2 --
 arch/ia64/Kconfig    |    2 --
 arch/m68k/Kconfig    |    2 --
 arch/mips/Kconfig    |    2 --
 arch/powerpc/Kconfig |    2 --
 arch/s390/Kconfig    |    2 --
 arch/sh/Kconfig      |    2 --
 arch/tile/Kconfig    |    2 --
 8 files changed, 16 deletions(-)

diff -puN arch/arm/Kconfig~kexec-remove-config_kexec-dependency-on-crypto arch/arm/Kconfig
--- a/arch/arm/Kconfig~kexec-remove-config_kexec-dependency-on-crypto
+++ a/arch/arm/Kconfig
@@ -1983,8 +1983,6 @@ config XIP_PHYS_ADDR
 config KEXEC
 	bool "Kexec system call (EXPERIMENTAL)"
 	depends on (!SMP || PM_SLEEP_SMP)
-	select CRYPTO
-	select CRYPTO_SHA256
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
diff -puN arch/ia64/Kconfig~kexec-remove-config_kexec-dependency-on-crypto arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~kexec-remove-config_kexec-dependency-on-crypto
+++ a/arch/ia64/Kconfig
@@ -549,8 +549,6 @@ source "drivers/sn/Kconfig"
 config KEXEC
 	bool "kexec system call"
 	depends on !IA64_HP_SIM && (!SMP || HOTPLUG_CPU)
-	select CRYPTO
-	select CRYPTO_SHA256
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
diff -puN arch/m68k/Kconfig~kexec-remove-config_kexec-dependency-on-crypto arch/m68k/Kconfig
--- a/arch/m68k/Kconfig~kexec-remove-config_kexec-dependency-on-crypto
+++ a/arch/m68k/Kconfig
@@ -91,8 +91,6 @@ config MMU_SUN3
 config KEXEC
 	bool "kexec system call"
 	depends on M68KCLASSIC
-	select CRYPTO
-	select CRYPTO_SHA256
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
diff -puN arch/mips/Kconfig~kexec-remove-config_kexec-dependency-on-crypto arch/mips/Kconfig
--- a/arch/mips/Kconfig~kexec-remove-config_kexec-dependency-on-crypto
+++ a/arch/mips/Kconfig
@@ -2396,8 +2396,6 @@ source "kernel/Kconfig.preempt"
 
 config KEXEC
 	bool "Kexec system call"
-	select CRYPTO
-	select CRYPTO_SHA256
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
diff -puN arch/powerpc/Kconfig~kexec-remove-config_kexec-dependency-on-crypto arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~kexec-remove-config_kexec-dependency-on-crypto
+++ a/arch/powerpc/Kconfig
@@ -399,8 +399,6 @@ config PPC64_SUPPORTS_MEMORY_FAILURE
 config KEXEC
 	bool "kexec system call"
 	depends on (PPC_BOOK3S || FSL_BOOKE || (44x && !SMP))
-	select CRYPTO
-	select CRYPTO_SHA256
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
diff -puN arch/s390/Kconfig~kexec-remove-config_kexec-dependency-on-crypto arch/s390/Kconfig
--- a/arch/s390/Kconfig~kexec-remove-config_kexec-dependency-on-crypto
+++ a/arch/s390/Kconfig
@@ -48,8 +48,6 @@ config ARCH_SUPPORTS_DEBUG_PAGEALLOC
 
 config KEXEC
 	def_bool y
-	select CRYPTO
-	select CRYPTO_SHA256
 
 config AUDIT_ARCH
 	def_bool y
diff -puN arch/sh/Kconfig~kexec-remove-config_kexec-dependency-on-crypto arch/sh/Kconfig
--- a/arch/sh/Kconfig~kexec-remove-config_kexec-dependency-on-crypto
+++ a/arch/sh/Kconfig
@@ -595,8 +595,6 @@ source kernel/Kconfig.hz
 config KEXEC
 	bool "kexec system call (EXPERIMENTAL)"
 	depends on SUPERH32 && MMU
-	select CRYPTO
-	select CRYPTO_SHA256
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
diff -puN arch/tile/Kconfig~kexec-remove-config_kexec-dependency-on-crypto arch/tile/Kconfig
--- a/arch/tile/Kconfig~kexec-remove-config_kexec-dependency-on-crypto
+++ a/arch/tile/Kconfig
@@ -191,8 +191,6 @@ source "kernel/Kconfig.hz"
 
 config KEXEC
 	bool "kexec system call"
-	select CRYPTO
-	select CRYPTO_SHA256
 	---help---
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
_

Patches currently in -mm which might be from vgoyal@redhat.com are

origin.patch
kernel-resourcec-fix-null-deref-with-no-iomem.patch
kexec-create-a-new-config-option-config_kexec_file-for-new-syscall.patch
kexec-remove-config_kexec-dependency-on-crypto.patch


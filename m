Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86C6AC25B45
	for <mm-commits@archiver.kernel.org>; Mon, 23 Oct 2023 18:06:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjJWSGq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Oct 2023 14:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjJWSGq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 23 Oct 2023 14:06:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D42B4
        for <mm-commits@vger.kernel.org>; Mon, 23 Oct 2023 11:06:44 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5357C433C8;
        Mon, 23 Oct 2023 18:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698084403;
        bh=v1Odccv2QEZsmGCrvQJyl8261mrs+gG7JD/9haNSKEM=;
        h=Date:To:From:Subject:From;
        b=PCBk6DA/S/W0UZZe1VPGEewKV5fGL8uEFfqrSigWKF3zLrn5COvRt/7RbRLiN8rp2
         n+8UfXyvBirZeKvpXMcxAT3tuLcLwwfgzIkzldcV8oBs++VnRnaolYAhBpV/r4otlv
         su7qtxXSadxNwRgTY7Mzlms3ZRdFiYMZ/SWfsAkc=
Date:   Mon, 23 Oct 2023 11:06:43 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        svens@linux.ibm.com, peterz@infradead.org,
        paul.walmsley@sifive.com, palmer@dabbelt.com, npiggin@gmail.com,
        mingo@redhat.com, hpa@zytor.com, herbert@gondor.apana.org.au,
        hca@linux.ibm.com, gor@linux.ibm.com, eric.devolder@oracle.com,
        davem@davemloft.net, dave.hansen@linux.intel.com, conor@kernel.org,
        christophe.leroy@csgroup.eu, bp@alien8.de,
        borntraeger@linux.ibm.com, ardb@kernel.org, aou@eecs.berkeley.edu,
        agordeev@linux.ibm.com, arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-fix-kexec_file-dependencies.patch added to mm-hotfixes-unstable branch
Message-Id: <20231023180643.B5357C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: fix KEXEC_FILE dependencies
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kexec-fix-kexec_file-dependencies.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-fix-kexec_file-dependencies.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: kexec: fix KEXEC_FILE dependencies
Date: Mon, 23 Oct 2023 13:01:54 +0200

The cleanup for the CONFIG_KEXEC Kconfig logic accidentally changed the
'depends on CRYPTO=y' dependency to a plain 'depends on CRYPTO', which
causes a link failure when all the crypto support is in a loadable module
and kexec_file support is built-in:

x86_64-linux-ld: vmlinux.o: in function `__x64_sys_kexec_file_load':
(.text+0x32e30a): undefined reference to `crypto_alloc_shash'
x86_64-linux-ld: (.text+0x32e58e): undefined reference to `crypto_shash_update'
x86_64-linux-ld: (.text+0x32e6ee): undefined reference to `crypto_shash_final'

Both s390 and x86 have this problem, while ppc64 and riscv have the
correct dependency already.  On riscv, the dependency is only used for the
purgatory, not for the kexec_file code itself, which may be a bit
surprising as it means that with CONFIG_CRYPTO=m, it is possible to enable
KEXEC_FILE but then the purgatory code is silently left out.

Move this into the common Kconfig.kexec file in a way that is correct
everywhere, using the dependency on CRYPTO_SHA256=y only when the
purgatory code is available.  This requires reversing the dependency
between ARCH_SUPPORTS_KEXEC_PURGATORY and KEXEC_FILE, but the effect
remains the same, other than making riscv behave like the other ones.

On s390, there is an additional dependency on CRYPTO_SHA256_S390, which
should technically not be required but gives better performance.  Remove
this dependency here, noting that it was not present in the initial
Kconfig code but was brought in without an explanation in commit
71406883fd357 ("s390/kexec_file: Add kexec_file_load system call").

Link: https://lkml.kernel.org/r/20231023110308.1202042-1-arnd@kernel.org
Fixes: 6af5138083005 ("x86/kexec: refactor for kernel/Kconfig.kexec")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Conor Dooley <conor@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric DeVolder <eric.devolder@oracle.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig |    4 ++--
 arch/riscv/Kconfig   |    4 +---
 arch/s390/Kconfig    |    4 ++--
 arch/x86/Kconfig     |    4 ++--
 kernel/Kconfig.kexec |    1 +
 5 files changed, 8 insertions(+), 9 deletions(-)

--- a/arch/powerpc/Kconfig~kexec-fix-kexec_file-dependencies
+++ a/arch/powerpc/Kconfig
@@ -607,10 +607,10 @@ config ARCH_SUPPORTS_KEXEC
 	def_bool PPC_BOOK3S || PPC_E500 || (44x && !SMP)
 
 config ARCH_SUPPORTS_KEXEC_FILE
-	def_bool PPC64 && CRYPTO=y && CRYPTO_SHA256=y
+	def_bool PPC64
 
 config ARCH_SUPPORTS_KEXEC_PURGATORY
-	def_bool KEXEC_FILE
+	def_bool y
 
 config ARCH_SELECTS_KEXEC_FILE
 	def_bool y
--- a/arch/riscv/Kconfig~kexec-fix-kexec_file-dependencies
+++ a/arch/riscv/Kconfig
@@ -687,9 +687,7 @@ config ARCH_SELECTS_KEXEC_FILE
 	select KEXEC_ELF
 
 config ARCH_SUPPORTS_KEXEC_PURGATORY
-	def_bool KEXEC_FILE
-	depends on CRYPTO=y
-	depends on CRYPTO_SHA256=y
+	def_bool y
 
 config ARCH_SUPPORTS_CRASH_DUMP
 	def_bool y
--- a/arch/s390/Kconfig~kexec-fix-kexec_file-dependencies
+++ a/arch/s390/Kconfig
@@ -252,13 +252,13 @@ config ARCH_SUPPORTS_KEXEC
 	def_bool y
 
 config ARCH_SUPPORTS_KEXEC_FILE
-	def_bool CRYPTO && CRYPTO_SHA256 && CRYPTO_SHA256_S390
+	def_bool y
 
 config ARCH_SUPPORTS_KEXEC_SIG
 	def_bool MODULE_SIG_FORMAT
 
 config ARCH_SUPPORTS_KEXEC_PURGATORY
-	def_bool KEXEC_FILE
+	def_bool y
 
 config ARCH_SUPPORTS_CRASH_DUMP
 	def_bool y
--- a/arch/x86/Kconfig~kexec-fix-kexec_file-dependencies
+++ a/arch/x86/Kconfig
@@ -2034,7 +2034,7 @@ config ARCH_SUPPORTS_KEXEC
 	def_bool y
 
 config ARCH_SUPPORTS_KEXEC_FILE
-	def_bool X86_64 && CRYPTO && CRYPTO_SHA256
+	def_bool X86_64
 
 config ARCH_SELECTS_KEXEC_FILE
 	def_bool y
@@ -2042,7 +2042,7 @@ config ARCH_SELECTS_KEXEC_FILE
 	select HAVE_IMA_KEXEC if IMA
 
 config ARCH_SUPPORTS_KEXEC_PURGATORY
-	def_bool KEXEC_FILE
+	def_bool y
 
 config ARCH_SUPPORTS_KEXEC_SIG
 	def_bool y
--- a/kernel/Kconfig.kexec~kexec-fix-kexec_file-dependencies
+++ a/kernel/Kconfig.kexec
@@ -36,6 +36,7 @@ config KEXEC
 config KEXEC_FILE
 	bool "Enable kexec file based system call"
 	depends on ARCH_SUPPORTS_KEXEC_FILE
+	depends on CRYPTO_SHA256=y || !ARCH_SUPPORTS_KEXEC_PURGATORY
 	select KEXEC_CORE
 	help
 	  This is new version of kexec system call. This system call is
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-fix-kexec_file-dependencies.patch
kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch
kexec-fix-kexec_file-dependencies-fix.patch


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5175495DA
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 21:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pXV0pwu+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F78C433C9;
	Wed, 20 Dec 2023 21:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703108830;
	bh=kH6RLyBW68X5bjl7hI2e0j6w+CyI5CRMroFGmrAk8NA=;
	h=Date:To:From:Subject:From;
	b=pXV0pwu+Y+c7zhWCPDmPoY308FAeoMDZ69mvkrkJQ+prc0ksCgkc2go930b//WVPM
	 Fz9psJGdEjI6cqp7bP2ROt5LxtXifImPD+uCe7ZRAL23YHR8sTWqTeqwseE3RZm2ob
	 nh+Ve5vcr/w+NahV0g1+9wbvOvn8Sfh9p7YBB8b4=
Date: Wed, 20 Dec 2023 13:47:09 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,svens@linux.ibm.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,mingo@redhat.com,hpa@zytor.com,herbert@gondor.apana.org.au,hca@linux.ibm.com,gor@linux.ibm.com,eric_devolder@yahoo.com,davem@davemloft.net,dave.hansen@linux.intel.com,conor@kernel.org,christophe.leroy@csgroup.eu,bp@alien8.de,borntraeger@linux.ibm.com,ardb@kernel.org,aou@eecs.berkeley.edu,agordeev@linux.ibm.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kexec-fix-kexec_file-dependencies.patch removed from -mm tree
Message-Id: <20231220214710.11F78C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec: fix KEXEC_FILE dependencies
has been removed from the -mm tree.  Its filename was
     kexec-fix-kexec_file-dependencies.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[arnd@arndb.de: fix riscv build]
  Link: https://lkml.kernel.org/r/67ddd260-d424-4229-a815-e3fcfb864a77@app.fastmail.com
Link: https://lkml.kernel.org/r/20231023110308.1202042-1-arnd@kernel.org
Fixes: 6af5138083005 ("x86/kexec: refactor for kernel/Kconfig.kexec")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Eric DeVolder <eric_devolder@yahoo.com>
Tested-by: Eric DeVolder <eric_devolder@yahoo.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Conor Dooley <conor@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
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
@@ -608,10 +608,10 @@ config ARCH_SUPPORTS_KEXEC
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
@@ -702,9 +702,7 @@ config ARCH_SELECTS_KEXEC_FILE
 	select KEXEC_ELF
 
 config ARCH_SUPPORTS_KEXEC_PURGATORY
-	def_bool KEXEC_FILE
-	depends on CRYPTO=y
-	depends on CRYPTO_SHA256=y
+	def_bool ARCH_SUPPORTS_KEXEC_FILE
 
 config ARCH_SUPPORTS_CRASH_DUMP
 	def_bool y
--- a/arch/s390/Kconfig~kexec-fix-kexec_file-dependencies
+++ a/arch/s390/Kconfig
@@ -254,13 +254,13 @@ config ARCH_SUPPORTS_KEXEC
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
@@ -2072,7 +2072,7 @@ config ARCH_SUPPORTS_KEXEC
 	def_bool y
 
 config ARCH_SUPPORTS_KEXEC_FILE
-	def_bool X86_64 && CRYPTO && CRYPTO_SHA256
+	def_bool X86_64
 
 config ARCH_SELECTS_KEXEC_FILE
 	def_bool y
@@ -2080,7 +2080,7 @@ config ARCH_SELECTS_KEXEC_FILE
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

mips-fix-r3k_cache_init-build-regression.patch
makefileextrawarn-turn-on-missing-prototypes-globally.patch


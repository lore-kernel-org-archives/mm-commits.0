From: akpm@linux-foundation.org
Subject: +
 atomic64-no-need-for-config_arch_has_atomic64_dec_if_positive.patch added
 to -mm tree
Date: Mon, 12 Sep 2016 14:58:25 -0700
Message-ID: <57d72501.SL7H+qdjhd0tO3Fv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51137 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752078AbcILV61 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2016 17:58:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Vineet.Gupta1@synopsys.com, ak@linux.intel.com, arnd@arndb.de, aryabinin@virtuozzo.com, benh@kernel.crashing.org, boqun.feng@gmail.com, bp@suse.de, catalin.marinas@arm.com, cmetcalf@mellanox.com, davem@davemloft.net, deller@gmx.de, geert@linux-m68k.org, glider@google.com, heiko.carstens@de.ibm.com, herbert@gondor.apana.org.au, hpa@zytor.com, ink@jurassic.park.msu.ru, jejb@parisc-linux.org, linus.walleij@linaro.org, linux@armlinux.org.uk, mattst88@gmail.com, ming.l@ssi.samsung.com, mingo@redhat.com, mpe@ellerman.id.au, paulus@samba.org, peterz@infradead.org, ralf@linux-mips.org, rth@twiddle.net, schwidefsky@de.ibm.com, tglx@linutronix.de, vgupta@synopsys.com, will.deacon@arm.com, zhaoxiu.zeng@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: atomic64: no need for CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
has been added to the -mm tree.  Its filename is
     atomic64-no-need-for-config_arch_has_atomic64_dec_if_positive.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/atomic64-no-need-for-config_arch_has_atomic64_dec_if_positive.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/atomic64-no-need-for-config_arch_has_atomic64_dec_if_positive.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: atomic64: no need for CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE

This came to light when implementing native 64-bit atomics for ARCv2.

The atomic64 self-test code uses CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
to check whether atomic64_dec_if_positive() is available.
It seems it was needed when not every arch defined it.
However as of current code the Kconfig option seems needless

- for CONFIG_GENERIC_ATOMIC64 it is auto-enabled in lib/Kconfig and a
  generic definition of API is present lib/atomic64.c
- arches with native 64-bit atomics select it in arch/*/Kconfig and
  define the API in their headers

So I see no point in keeping the Kconfig option

Compile tested for:
 - blackfin (CONFIG_GENERIC_ATOMIC64)
 - x86 (!CONFIG_GENERIC_ATOMIC64)
 - ia64

Link: http://lkml.kernel.org/r/1473703083-8625-3-git-send-email-vgupta@synopsys.com
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Zhaoxiu Zeng <zhaoxiu.zeng@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ming Lin <ming.l@ssi.samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig   |    1 -
 arch/arm/Kconfig     |    1 -
 arch/arm64/Kconfig   |    1 -
 arch/mips/Kconfig    |    1 -
 arch/parisc/Kconfig  |    1 -
 arch/powerpc/Kconfig |    1 -
 arch/s390/Kconfig    |    1 -
 arch/sparc/Kconfig   |    1 -
 arch/tile/Kconfig    |    1 -
 arch/x86/Kconfig     |    1 -
 lib/Kconfig          |    3 ---
 lib/atomic64_test.c  |    4 ----
 12 files changed, 17 deletions(-)

diff -puN arch/alpha/Kconfig~atomic64-no-need-for-config_arch_has_atomic64_dec_if_positive arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~atomic64-no-need-for-config_arch_has_atomic64_dec_if_positive
+++ a/arch/alpha/Kconfig
@@ -15,7 +15,6 @@ config ALPHA
 	select GENERIC_IRQ_SHOW
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
-	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select AUDIT_ARCH
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_SMP_IDLE_THREAD
diff -puN arch/arm/Kconfig~atomic64-no-need-for-config_arch_has_atomic64_dec_if_positive arch/arm/Kconfig
--- a/arch/arm/Kconfig~atomic64-no-need-for-config_arch_has_atomic64_dec_if_positive
+++ a/arch/arm/Kconfig
@@ -1,7 +1,6 @@
 config ARM
 	bool
 	default y
-	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select ARCH_HAS_DEVMEM_IS_ALLOWED
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
diff -puN arch/arm64/Kconfig~atomic64-no-need-for-config_arch_has_atomic64_dec_if_positive arch/arm64/Kconfig
--- a/arch/arm64/Kconfig~atomic64-no-need-for-config_arch_has_atomic64_dec_if_positive
+++ a/arch/arm64/Kconfig
@@ -6,7 +6,6 @@ config ARM64
 	select ACPI_MCFG if ACPI
 	select ARCH_HAS_DEVMEM_IS_ALLOWED
 	select ARCH_HAS_ACPI_TABLE_UPGRADE if ACPI
-	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_KCOV
diff -puN arch/mips/Kconfig~atomic64-no-need-for-config_arch_has_atomic64_dec_if_positive arch/mips/Kconfig
--- a/arch/mips/Kconfig~atomic64-no-need-for-config_arch_has_atomic64_dec_if_positive
+++ a/arch/mips/Kconfig
@@ -30,7 +30,6 @@ config MIPS
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE if CPU_SUPPORTS_HUGEPAGES && 64BIT
 	select RTC_LIB if !MACH_LOONGSON64
 	select GENERIC_ATOMIC64 if !64BIT
-	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select HAVE_DMA_CONTIGUOUS
 	select HAVE_DMA_API_DEBUG
 	select GENERIC_IRQ_PROBE
diff -puN arch/parisc/Kconfig~atomic64-no-need-for-config_arch_has_atomic64_dec_if_positive arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~atomic64-no-need-for-config_arch_has_atomic64_dec_if_positive
+++ a/arch/parisc/Kconfig
@@ -14,7 +14,6 @@ config PARISC
 	select BUILDTIME_EXTABLE_SORT
 	select HAVE_PERF_EVENTS
 	select GENERIC_ATOMIC64 if !64BIT
-	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select BROKEN_RODATA
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PCI_IOMAP
diff -puN arch/powerpc/Kconfig~atomic64-no-need-for-config_arch_has_atomic64_dec_if_positive arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~atomic64-no-need-for-config_arch_has_atomic64_dec_if_positive
+++ a/arch/powerpc/Kconfig
@@ -113,7 +113,6 @@ config PPC
 	select HAVE_DEBUG_KMEMLEAK
 	select ARCH_HAS_SG_CHAIN
 	select GENERIC_ATOMIC64 if PPC32
-	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select HAVE_PERF_EVENTS
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
diff -puN arch/s390/Kconfig~atomic64-no-need-for-config_arch_has_atomic64_dec_if_positive arch/s390/Kconfig
--- a/arch/s390/Kconfig~atomic64-no-need-for-config_arch_has_atomic64_dec_if_positive
+++ a/arch/s390/Kconfig
@@ -67,7 +67,6 @@ config DEBUG_RODATA
 
 config S390
 	def_bool y
-	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select ARCH_HAS_DEVMEM_IS_ALLOWED
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_GCOV_PROFILE_ALL
diff -puN arch/sparc/Kconfig~atomic64-no-need-for-config_arch_has_atomic64_dec_if_positive arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~atomic64-no-need-for-config_arch_has_atomic64_dec_if_positive
+++ a/arch/sparc/Kconfig
@@ -22,7 +22,6 @@ config SPARC
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_EXIT_THREAD
 	select SYSCTL_EXCEPTION_TRACE
-	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select RTC_CLASS
 	select RTC_DRV_M48T59
 	select RTC_SYSTOHC
diff -puN arch/tile/Kconfig~atomic64-no-need-for-config_arch_has_atomic64_dec_if_positive arch/tile/Kconfig
--- a/arch/tile/Kconfig~atomic64-no-need-for-config_arch_has_atomic64_dec_if_positive
+++ a/arch/tile/Kconfig
@@ -3,7 +3,6 @@
 
 config TILE
 	def_bool y
-	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select ARCH_HAS_DEVMEM_IS_ALLOWED
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select ARCH_WANT_FRAME_POINTERS
diff -puN arch/x86/Kconfig~atomic64-no-need-for-config_arch_has_atomic64_dec_if_positive arch/x86/Kconfig
--- a/arch/x86/Kconfig~atomic64-no-need-for-config_arch_has_atomic64_dec_if_positive
+++ a/arch/x86/Kconfig
@@ -23,7 +23,6 @@ config X86
 	select ARCH_CLOCKSOURCE_DATA
 	select ARCH_DISCARD_MEMBLOCK
 	select ARCH_HAS_ACPI_TABLE_UPGRADE if ACPI
-	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select ARCH_HAS_DEVMEM_IS_ALLOWED
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_FAST_MULTIPLIER
diff -puN lib/Kconfig~atomic64-no-need-for-config_arch_has_atomic64_dec_if_positive lib/Kconfig
--- a/lib/Kconfig~atomic64-no-need-for-config_arch_has_atomic64_dec_if_positive
+++ a/lib/Kconfig
@@ -457,9 +457,6 @@ config NLATTR
 config GENERIC_ATOMIC64
        bool
 
-config ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
-	def_bool y if GENERIC_ATOMIC64
-
 config LRU_CACHE
 	tristate
 
diff -puN lib/atomic64_test.c~atomic64-no-need-for-config_arch_has_atomic64_dec_if_positive lib/atomic64_test.c
--- a/lib/atomic64_test.c~atomic64-no-need-for-config_arch_has_atomic64_dec_if_positive
+++ a/lib/atomic64_test.c
@@ -213,7 +213,6 @@ static __init void test_atomic64(void)
 	r += one;
 	BUG_ON(v.counter != r);
 
-#ifdef CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	INIT(onestwos);
 	BUG_ON(atomic64_dec_if_positive(&v) != (onestwos - 1));
 	r -= one;
@@ -226,9 +225,6 @@ static __init void test_atomic64(void)
 	INIT(-one);
 	BUG_ON(atomic64_dec_if_positive(&v) != (-one - one));
 	BUG_ON(v.counter != r);
-#else
-#warning Please implement atomic64_dec_if_positive for your architecture and select the above Kconfig symbol
-#endif
 
 	INIT(onestwos);
 	BUG_ON(!atomic64_inc_not_zero(&v));
_

Patches currently in -mm which might be from Vineet.Gupta1@synopsys.com are

atomic64-no-need-for-config_arch_has_atomic64_dec_if_positive.patch


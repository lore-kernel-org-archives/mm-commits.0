From: akpm@linux-foundation.org
Subject: [merged] arm-mm-support-arch_mmap_rnd_bits.patch removed from -mm tree
Date: Fri, 15 Jan 2016 14:33:40 -0800
Message-ID: <569973c4.FOz/1icq044rfHXn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59436 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbcAOWdm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:33:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcashman@google.com, aarcange@redhat.com, arnd@arndb.de, benh@kernel.crashing.org, bp@suse.de, catalin.marinas@arm.com, corbet@lwn.net, dzickus@redhat.com, ebiederm@xmission.com, hecmargi@upv.es, heiko.carstens@de.ibm.com, hpa@zytor.com, jeffv@google.com, jpoimboe@redhat.com, keescook@chromium.org, kirill.shutemov@linux.intel.com, linux@arm.linux.org.uk, mgorman@suse.de, mingo@kernel.org, n-horiguchi@ah.jp.nec.com, nnk@google.com, ralf@linux-mips.org, rientjes@google.com, salyzyn@android.com, schwidefsky@de.ibm.com, tglx@linutronix.de, will.deacon@arm.com, xypron.glpk@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: arm: mm: support ARCH_MMAP_RND_BITS
has been removed from the -mm tree.  Its filename was
     arm-mm-support-arch_mmap_rnd_bits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Cashman <dcashman@google.com>
Subject: arm: mm: support ARCH_MMAP_RND_BITS

arm: arch_mmap_rnd() uses a hard-code value of 8 to generate the random
offset for the mmap base address.  This value represents a compromise
between increased ASLR effectiveness and avoiding address-space
fragmentation.  Replace it with a Kconfig option, which is sensibly
bounded, so that platform developers may choose where to place this
compromise.  Keep 8 as the minimum acceptable value.

[arnd@arndb.de: ARM: avoid ARCH_MMAP_RND_BITS for NOMMU]
Signed-off-by: Daniel Cashman <dcashman@google.com>
Cc: Russell King <linux@arm.linux.org.uk>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Mark Salyzyn <salyzyn@android.com>
Cc: Jeff Vander Stoep <jeffv@google.com>
Cc: Nick Kralevich <nnk@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hector Marco-Gisbert <hecmargi@upv.es>
Cc: Borislav Petkov <bp@suse.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig   |    9 +++++++++
 arch/arm/mm/mmap.c |    3 +--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff -puN arch/arm/Kconfig~arm-mm-support-arch_mmap_rnd_bits arch/arm/Kconfig
--- a/arch/arm/Kconfig~arm-mm-support-arch_mmap_rnd_bits
+++ a/arch/arm/Kconfig
@@ -37,6 +37,7 @@ config ARM
 	select HAVE_ARCH_BITREVERSE if (CPU_32v7M || CPU_32v7) && !CPU_32v6
 	select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL && !CPU_ENDIAN_BE32 && MMU
 	select HAVE_ARCH_KGDB if !CPU_ENDIAN_BE32 && MMU
+	select HAVE_ARCH_MMAP_RND_BITS if MMU
 	select HAVE_ARCH_SECCOMP_FILTER if (AEABI && !OABI_COMPAT)
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARM_SMCCC if CPU_V7
@@ -311,6 +312,14 @@ config MMU
 	  Select if you want MMU-based virtualised addressing space
 	  support by paged memory management. If unsure, say 'Y'.
 
+config ARCH_MMAP_RND_BITS_MIN
+	default 8
+
+config ARCH_MMAP_RND_BITS_MAX
+	default 14 if PAGE_OFFSET=0x40000000
+	default 15 if PAGE_OFFSET=0x80000000
+	default 16
+
 #
 # The "ARM system type" choice list is ordered alphabetically by option
 # text.  Please add new entries in the option alphabetic order.
diff -puN arch/arm/mm/mmap.c~arm-mm-support-arch_mmap_rnd_bits arch/arm/mm/mmap.c
--- a/arch/arm/mm/mmap.c~arm-mm-support-arch_mmap_rnd_bits
+++ a/arch/arm/mm/mmap.c
@@ -173,8 +173,7 @@ unsigned long arch_mmap_rnd(void)
 {
 	unsigned long rnd;
 
-	/* 8 bits of randomness in 20 address space bits */
-	rnd = (unsigned long)get_random_int() % (1 << 8);
+	rnd = (unsigned long)get_random_int() & ((1 << mmap_rnd_bits) - 1);
 
 	return rnd << PAGE_SHIFT;
 }
_

Patches currently in -mm which might be from dcashman@google.com are



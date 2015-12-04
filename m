From: akpm@linux-foundation.org
Subject: [folded-merged] x86-mm-support-arch_mmap_rnd_bits.patch removed
 from -mm tree
Date: Fri, 04 Dec 2015 15:19:44 -0800
Message-ID: <56621f90.5TOhOffISEaifw07%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48187 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477AbbLDXTq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Dec 2015 18:19:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcashman@google.com, aarcange@redhat.com, benh@kernel.crashing.org, bp@suse.de, catalin.marinas@arm.com, corbet@lwn.net, dzickus@redhat.com, ebiederm@xmission.com, hecmargi@upv.es, hpa@zytor.com, jeffv@google.com, jpoimboe@redhat.com, keescook@chromium.org, kirill.shutemov@linux.intel.com, linux@arm.linux.org.uk, mgorman@suse.de, mingo@kernel.org, n-horiguchi@ah.jp.nec.com, nnk@google.com, ralf@linux-mips.org, rientjes@google.com, salyzyn@android.com, tglx@linutronix.de, will.deacon@arm.com, xypron.glpk@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: mm: support ARCH_MMAP_RND_BITS
has been removed from the -mm tree.  Its filename was
     x86-mm-support-arch_mmap_rnd_bits.patch

This patch was dropped because it was folded into arm64-mm-support-arch_mmap_rnd_bits.patch

------------------------------------------------------
From: Daniel Cashman <dcashman@google.com>
Subject: x86: mm: support ARCH_MMAP_RND_BITS

x86: arch_mmap_rnd() uses hard-coded values, 8 for 32-bit and 28 for
64-bit, to generate the random offset for the mmap base address.  This
value represents a compromise between increased ASLR effectiveness and
avoiding address-space fragmentation.  Replace it with a Kconfig option,
which is sensibly bounded, so that platform developers may choose where to
place this compromise.  Keep default values as new minimums.

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
Cc; Heiko Carstens <heiko.carstens@de.ibm.com>
Cc; Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig   |   16 ++++++++++++++++
 arch/x86/mm/mmap.c |   12 ++++++------
 2 files changed, 22 insertions(+), 6 deletions(-)

diff -puN arch/x86/Kconfig~x86-mm-support-arch_mmap_rnd_bits arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-mm-support-arch_mmap_rnd_bits
+++ a/arch/x86/Kconfig
@@ -82,6 +82,8 @@ config X86
 	select HAVE_ARCH_KASAN			if X86_64 && SPARSEMEM_VMEMMAP
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_KMEMCHECK
+	select HAVE_ARCH_MMAP_RND_BITS
+	select HAVE_ARCH_MMAP_RND_COMPAT_BITS if COMPAT
 	select HAVE_ARCH_SECCOMP_FILTER
 	select HAVE_ARCH_SOFT_DIRTY		if X86_64
 	select HAVE_ARCH_TRACEHOOK
@@ -183,6 +185,20 @@ config HAVE_LATENCYTOP_SUPPORT
 config MMU
 	def_bool y
 
+config ARCH_MMAP_RND_BITS_MIN
+       default 28 if 64BIT
+       default 8
+
+config ARCH_MMAP_RND_BITS_MAX
+	default 32 if 64BIT
+	default 16
+
+config ARCH_MMAP_RND_COMPAT_BITS_MIN
+	default 8
+
+config ARCH_MMAP_RND_COMPAT_BITS_MAX
+	default 16
+
 config SBUS
 	bool
 
diff -puN arch/x86/mm/mmap.c~x86-mm-support-arch_mmap_rnd_bits arch/x86/mm/mmap.c
--- a/arch/x86/mm/mmap.c~x86-mm-support-arch_mmap_rnd_bits
+++ a/arch/x86/mm/mmap.c
@@ -69,14 +69,14 @@ unsigned long arch_mmap_rnd(void)
 {
 	unsigned long rnd;
 
-	/*
-	 *  8 bits of randomness in 32bit mmaps, 20 address space bits
-	 * 28 bits of randomness in 64bit mmaps, 40 address space bits
-	 */
 	if (mmap_is_ia32())
-		rnd = (unsigned long)get_random_int() % (1<<8);
+#ifdef CONFIG_COMPAT
+		rnd = (unsigned long)get_random_int() % (1 << mmap_rnd_compat_bits);
+#else
+		rnd = (unsigned long)get_random_int() % (1 << mmap_rnd_bits);
+#endif
 	else
-		rnd = (unsigned long)get_random_int() % (1<<28);
+		rnd = (unsigned long)get_random_int() % (1 << mmap_rnd_bits);
 
 	return rnd << PAGE_SHIFT;
 }
_

Patches currently in -mm which might be from dcashman@google.com are

mm-mmap-add-new-proc-tunable-for-mmap_base-aslr.patch
arm-mm-support-arch_mmap_rnd_bits.patch
arm64-mm-support-arch_mmap_rnd_bits.patch


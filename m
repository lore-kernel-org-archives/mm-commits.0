From: akpm@linux-foundation.org
Subject: + arm-mm-support-arch_mmap_rnd_bits.patch added to -mm tree
Date: Tue, 24 Nov 2015 16:40:11 -0800
Message-ID: <5655036b.NUt1oUvEofucOJv9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58253 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932226AbbKYAkN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Nov 2015 19:40:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcashman@google.com, aarcange@redhat.com, benh@kernel.crashing.org, bp@suse.de, catalin.marinas@arm.com, corbet@lwn.net, dzickus@redhat.com, ebiederm@xmission.com, hecmargi@upv.es, hpa@zytor.com, jeffv@google.com, jpoimboe@redhat.com, keescook@chromium.org, kirill.shutemov@linux.intel.com, linux@arm.linux.org.uk, mgorman@suse.de, mingo@kernel.org, n-horiguchi@ah.jp.nec.com, nnk@google.com, ralf@linux-mips.org, rientjes@google.com, salyzyn@android.com, tglx@linutronix.de, will.deacon@arm.com, xypron.glpk@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: arm: mm: support ARCH_MMAP_RND_BITS
has been added to the -mm tree.  Its filename is
     arm-mm-support-arch_mmap_rnd_bits.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-mm-support-arch_mmap_rnd_bits.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-mm-support-arch_mmap_rnd_bits.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Cashman <dcashman@google.com>
Subject: arm: mm: support ARCH_MMAP_RND_BITS

arm: arch_mmap_rnd() uses a hard-code value of 8 to generate the random
offset for the mmap base address.  This value represents a compromise
between increased ASLR effectiveness and avoiding address-space
fragmentation.  Replace it with a Kconfig option, which is sensibly
bounded, so that platform developers may choose where to place this
compromise.  Keep 8 as the minimum acceptable value.

Signed-off-by: Daniel Cashman <dcashman@google.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
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

 arch/arm/Kconfig   |   10 ++++++++++
 arch/arm/mm/mmap.c |    3 +--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff -puN arch/arm/Kconfig~arm-mm-support-arch_mmap_rnd_bits arch/arm/Kconfig
--- a/arch/arm/Kconfig~arm-mm-support-arch_mmap_rnd_bits
+++ a/arch/arm/Kconfig
@@ -35,6 +35,7 @@ config ARM
 	select HAVE_ARCH_BITREVERSE if (CPU_32v7M || CPU_32v7) && !CPU_32v6
 	select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL && !CPU_ENDIAN_BE32
 	select HAVE_ARCH_KGDB if !CPU_ENDIAN_BE32
+	select HAVE_ARCH_MMAP_RND_BITS
 	select HAVE_ARCH_SECCOMP_FILTER if (AEABI && !OABI_COMPAT)
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_BPF_JIT
@@ -306,6 +307,15 @@ config MMU
 	  Select if you want MMU-based virtualised addressing space
 	  support by paged memory management. If unsure, say 'Y'.
 
+config ARCH_MMAP_RND_BITS_MIN
+	default 8
+
+config ARCH_MMAP_RND_BITS_MAX
+	default 14 if MMU && PAGE_OFFSET=0x40000000
+	default 15 if MMU && PAGE_OFFSET=0x80000000
+	default 16 if MMU
+	default 8
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
+	rnd = (unsigned long)get_random_int() % (1 << mmap_rnd_bits);
 
 	return rnd << PAGE_SHIFT;
 }
_

Patches currently in -mm which might be from dcashman@google.com are

mm-mmap-add-new-proc-tunable-for-mmap_base-aslr.patch
arm-mm-support-arch_mmap_rnd_bits.patch
arm64-mm-support-arch_mmap_rnd_bits.patch
x86-mm-support-arch_mmap_rnd_bits.patch


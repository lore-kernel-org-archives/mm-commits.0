From: akpm@linux-foundation.org
Subject: + arm64-mm-support-arch_mmap_rnd_bits.patch added to -mm tree
Date: Tue, 24 Nov 2015 16:40:15 -0800
Message-ID: <5655036f./NIB8m55w3APX+w7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58272 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932646AbbKYAkQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Nov 2015 19:40:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcashman@google.com, aarcange@redhat.com, benh@kernel.crashing.org, bp@suse.de, catalin.marinas@arm.com, corbet@lwn.net, dzickus@redhat.com, ebiederm@xmission.com, hecmargi@upv.es, hpa@zytor.com, jeffv@google.com, jpoimboe@redhat.com, keescook@chromium.org, kirill.shutemov@linux.intel.com, linux@arm.linux.org.uk, mgorman@suse.de, mingo@kernel.org, n-horiguchi@ah.jp.nec.com, nnk@google.com, ralf@linux-mips.org, rientjes@google.com, salyzyn@android.com, tglx@linutronix.de, will.deacon@arm.com, xypron.glpk@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: mm: support ARCH_MMAP_RND_BITS
has been added to the -mm tree.  Its filename is
     arm64-mm-support-arch_mmap_rnd_bits.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm64-mm-support-arch_mmap_rnd_bits.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm64-mm-support-arch_mmap_rnd_bits.patch

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
Subject: arm64: mm: support ARCH_MMAP_RND_BITS

arm64: arch_mmap_rnd() uses STACK_RND_MASK to generate the random offset
for the mmap base address.  This value represents a compromise between
increased ASLR effectiveness and avoiding address-space fragmentation. 
Replace it with a Kconfig option, which is sensibly bounded, so that
platform developers may choose where to place this compromise.  Keep
default values as new minimums.

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

 arch/arm64/Kconfig   |   23 +++++++++++++++++++++++
 arch/arm64/mm/mmap.c |    6 ++++--
 2 files changed, 27 insertions(+), 2 deletions(-)

diff -puN arch/arm64/Kconfig~arm64-mm-support-arch_mmap_rnd_bits arch/arm64/Kconfig
--- a/arch/arm64/Kconfig~arm64-mm-support-arch_mmap_rnd_bits
+++ a/arch/arm64/Kconfig
@@ -51,6 +51,8 @@ config ARM64
 	select HAVE_ARCH_JUMP_LABEL
 	select HAVE_ARCH_KASAN if SPARSEMEM_VMEMMAP
 	select HAVE_ARCH_KGDB
+	select HAVE_ARCH_MMAP_RND_BITS
+	select HAVE_ARCH_MMAP_RND_COMPAT_BITS if COMPAT
 	select HAVE_ARCH_SECCOMP_FILTER
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_BPF_JIT
@@ -104,6 +106,27 @@ config ARCH_PHYS_ADDR_T_64BIT
 config MMU
 	def_bool y
 
+config ARCH_MMAP_RND_BITS_MIN
+       default 15 if ARM64_64K_PAGES
+       default 19
+
+config ARCH_MMAP_RND_BITS_MAX
+       default 20 if ARM64_64K_PAGES && ARCH_VA_BITS=39
+       default 24 if ARCH_VA_BITS=39
+       default 23 if ARM64_64K_PAGES && ARCH_VA_BITS=42
+       default 27 if ARCH_VA_BITS=42
+       default 29 if ARM64_64K_PAGES && ARCH_VA_BITS=48
+       default 33 if ARCH_VA_BITS=48
+       default 15 if ARM64_64K_PAGES
+       default 19
+
+config ARCH_MMAP_RND_COMPAT_BITS_MIN
+       default 7 if ARM64_64K_PAGES
+       default 11
+
+config ARCH_MMAP_RND_COMPAT_BITS_MAX
+       default 16
+
 config NO_IOPORT_MAP
 	def_bool y if !PCI
 
diff -puN arch/arm64/mm/mmap.c~arm64-mm-support-arch_mmap_rnd_bits arch/arm64/mm/mmap.c
--- a/arch/arm64/mm/mmap.c~arm64-mm-support-arch_mmap_rnd_bits
+++ a/arch/arm64/mm/mmap.c
@@ -51,8 +51,10 @@ unsigned long arch_mmap_rnd(void)
 {
 	unsigned long rnd;
 
-	rnd = (unsigned long)get_random_int() & STACK_RND_MASK;

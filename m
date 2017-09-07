From: akpm@linux-foundation.org
Subject: [merged]
 x86mpx-make-mpx-depend-on-x86-64-to-free-up-vma-flag.patch removed from -mm
 tree
Date: Thu, 07 Sep 2017 11:42:17 -0700
Message-ID: <20170907184217.AW29ZWzc0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58014 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755443AbdIGSmS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:42:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colm@allcosts.net, dave.hansen@intel.com, fweimer@redhat.com, hpa@zytor.com, keescook@chromium.org, kirill@shutemov.name, luto@amacapital.net, mike.kravetz@oracle.com, mingo@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com, tglx@linutronix.de, wad@chromium.org, willy@infradead.org


The patch titled
     Subject: x86,mpx: make mpx depend on x86-64 to free up VMA flag
has been removed from the -mm tree.  Its filename was
     x86mpx-make-mpx-depend-on-x86-64-to-free-up-vma-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: x86,mpx: make mpx depend on x86-64 to free up VMA flag

Patch series "mm,fork,security: introduce MADV_WIPEONFORK", v4.

If a child process accesses memory that was MADV_WIPEONFORK, it will get
zeroes.  The address ranges are still valid, they are just empty.

If a child process accesses memory that was MADV_DONTFORK, it will get a
segmentation fault, since those address ranges are no longer valid in the
child after fork.

Since MADV_DONTFORK also seems to be used to allow very large programs to
fork in systems with strict memory overcommit restrictions, changing the
semantics of MADV_DONTFORK might break existing programs.

The use case is libraries that store or cache information, and want to
know that they need to regenerate it in the child process after fork.

Examples of this would be:
- systemd/pulseaudio API checks (fail after fork)
  (replacing a getpid check, which is too slow without a PID cache)
- PKCS#11 API reinitialization check (mandated by specification)
- glibc's upcoming PRNG (reseed after fork)
- OpenSSL PRNG (reseed after fork)

The security benefits of a forking server having a re-inialized PRNG in
every child process are pretty obvious.  However, due to libraries having
all kinds of internal state, and programs getting compiled with many
different versions of each library, it is unreasonable to expect calling
programs to re-initialize everything manually after fork.

A further complication is the proliferation of clone flags, programs
bypassing glibc's functions to call clone directly, and programs calling
unshare, causing the glibc pthread_atfork hook to not get called.

It would be better to have the kernel take care of this automatically.

The patchset also adds MADV_KEEPONFORK, to undo the effects of a prior
MADV_WIPEONFORK.

This is similar to the OpenBSD minherit syscall with MAP_INHERIT_ZERO:

    https://man.openbsd.org/minherit.2



This patch (of 2):

MPX only seems to be available on 64 bit CPUs, starting with Skylake and
Goldmont.  Move VM_MPX into the 64 bit only portion of vma->vm_flags, in
order to free up a VMA flag.

Link: http://lkml.kernel.org/r/20170811212829.29186-2-riel@redhat.com
Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Will Drewry <wad@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Colm MacCártaigh <colm@allcosts.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig   |    4 +++-
 include/linux/mm.h |    8 ++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff -puN arch/x86/Kconfig~x86mpx-make-mpx-depend-on-x86-64-to-free-up-vma-flag arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86mpx-make-mpx-depend-on-x86-64-to-free-up-vma-flag
+++ a/arch/x86/Kconfig
@@ -1806,7 +1806,9 @@ config X86_SMAP
 config X86_INTEL_MPX
 	prompt "Intel MPX (Memory Protection Extensions)"
 	def_bool n
-	depends on CPU_SUP_INTEL
+	# Note: only available in 64-bit mode due to VMA flags shortage
+	depends on CPU_SUP_INTEL && X86_64
+	select ARCH_USES_HIGH_VMA_FLAGS
 	---help---
 	  MPX provides hardware features that can be used in
 	  conjunction with compiler-instrumented code to check
diff -puN include/linux/mm.h~x86mpx-make-mpx-depend-on-x86-64-to-free-up-vma-flag include/linux/mm.h
--- a/include/linux/mm.h~x86mpx-make-mpx-depend-on-x86-64-to-free-up-vma-flag
+++ a/include/linux/mm.h
@@ -208,10 +208,12 @@ extern unsigned int kobjsize(const void
 #define VM_HIGH_ARCH_BIT_1	33	/* bit only usable on 64-bit architectures */
 #define VM_HIGH_ARCH_BIT_2	34	/* bit only usable on 64-bit architectures */
 #define VM_HIGH_ARCH_BIT_3	35	/* bit only usable on 64-bit architectures */
+#define VM_HIGH_ARCH_BIT_4	36	/* bit only usable on 64-bit architectures */
 #define VM_HIGH_ARCH_0	BIT(VM_HIGH_ARCH_BIT_0)
 #define VM_HIGH_ARCH_1	BIT(VM_HIGH_ARCH_BIT_1)
 #define VM_HIGH_ARCH_2	BIT(VM_HIGH_ARCH_BIT_2)
 #define VM_HIGH_ARCH_3	BIT(VM_HIGH_ARCH_BIT_3)
+#define VM_HIGH_ARCH_4	BIT(VM_HIGH_ARCH_BIT_4)
 #endif /* CONFIG_ARCH_USES_HIGH_VMA_FLAGS */
 
 #if defined(CONFIG_X86)
@@ -235,9 +237,11 @@ extern unsigned int kobjsize(const void
 # define VM_MAPPED_COPY	VM_ARCH_1	/* T if mapped copy of data (nommu mmap) */
 #endif
 
-#if defined(CONFIG_X86)
+#if defined(CONFIG_X86_INTEL_MPX)
 /* MPX specific bounds table or bounds directory */
-# define VM_MPX		VM_ARCH_2
+# define VM_MPX		VM_HIGH_ARCH_BIT_4
+#else
+# define VM_MPX		VM_NONE
 #endif
 
 #ifndef VM_GROWSUP
_

Patches currently in -mm which might be from riel@redhat.com are



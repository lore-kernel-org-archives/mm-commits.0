From: akpm@linux-foundation.org
Subject: + kconfig-remove-have_latencytop_support.patch added to -mm tree
Date: Thu, 19 Nov 2015 15:14:16 -0800
Message-ID: <564e57c8.vH0s+LHykknquXC/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52343 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758294AbbKSXOR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Nov 2015 18:14:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: will.deacon@arm.com, davem@davemloft.net, deller@gmx.de, gxt@mprc.pku.edu.cn, heiko.carstens@de.ibm.com, james.hogan@imgtec.com, linux@arm.linux.org.uk, mingo@redhat.com, monstr@monstr.eu, mpe@ellerman.id.au, vgupta@synopsys.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Kconfig: remove HAVE_LATENCYTOP_SUPPORT
has been added to the -mm tree.  Its filename is
     kconfig-remove-have_latencytop_support.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kconfig-remove-have_latencytop_support.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kconfig-remove-have_latencytop_support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Will Deacon <will.deacon@arm.com>
Subject: Kconfig: remove HAVE_LATENCYTOP_SUPPORT

As illustrated by a3afe70b83fd ("[S390] latencytop s390 support."),
HAVE_LATENCYTOP_SUPPORT is defined by an architecture to advertise an
implementation of save_stack_trace_tsk.

However, as of 9212ddb5eada ("stacktrace: provide save_stack_trace_tsk()
weak alias") a dummy implementation is provided if STACKTRACE=y.  Given
that LATENCYTOP already depends on STACKTRACE_SUPPORT and selects
STACKTRACE, we can remove HAVE_LATENCYTOP_SUPPORT altogether.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Helge Deller <deller@gmx.de>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/Kconfig        |    3 ---
 arch/arm/Kconfig        |    5 -----
 arch/metag/Kconfig      |    3 ---
 arch/microblaze/Kconfig |    3 ---
 arch/parisc/Kconfig     |    3 ---
 arch/powerpc/Kconfig    |    3 ---
 arch/s390/Kconfig       |    3 ---
 arch/sh/Kconfig         |    3 ---
 arch/sparc/Kconfig      |    4 ----
 arch/unicore32/Kconfig  |    3 ---
 arch/x86/Kconfig        |    3 ---
 lib/Kconfig.debug       |    1 -
 12 files changed, 37 deletions(-)

diff -puN arch/arc/Kconfig~kconfig-remove-have_latencytop_support arch/arc/Kconfig
--- a/arch/arc/Kconfig~kconfig-remove-have_latencytop_support
+++ a/arch/arc/Kconfig
@@ -73,9 +73,6 @@ config STACKTRACE_SUPPORT
 	def_bool y
 	select STACKTRACE
 
-config HAVE_LATENCYTOP_SUPPORT
-	def_bool y
-
 config HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	def_bool y
 	depends on ARC_MMU_V4
diff -puN arch/arm/Kconfig~kconfig-remove-have_latencytop_support arch/arm/Kconfig
--- a/arch/arm/Kconfig~kconfig-remove-have_latencytop_support
+++ a/arch/arm/Kconfig
@@ -162,11 +162,6 @@ config STACKTRACE_SUPPORT
 	bool
 	default y
 
-config HAVE_LATENCYTOP_SUPPORT
-	bool
-	depends on !SMP
-	default y
-
 config LOCKDEP_SUPPORT
 	bool
 	default y
diff -puN arch/metag/Kconfig~kconfig-remove-have_latencytop_support arch/metag/Kconfig
--- a/arch/metag/Kconfig~kconfig-remove-have_latencytop_support
+++ a/arch/metag/Kconfig
@@ -36,9 +36,6 @@ config STACKTRACE_SUPPORT
 config LOCKDEP_SUPPORT
 	def_bool y
 
-config HAVE_LATENCYTOP_SUPPORT
-	def_bool y
-
 config RWSEM_GENERIC_SPINLOCK
 	def_bool y
 
diff -puN arch/microblaze/Kconfig~kconfig-remove-have_latencytop_support arch/microblaze/Kconfig
--- a/arch/microblaze/Kconfig~kconfig-remove-have_latencytop_support
+++ a/arch/microblaze/Kconfig
@@ -67,9 +67,6 @@ config STACKTRACE_SUPPORT
 config LOCKDEP_SUPPORT
 	def_bool y
 
-config HAVE_LATENCYTOP_SUPPORT
-	def_bool y
-
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"
diff -puN arch/parisc/Kconfig~kconfig-remove-have_latencytop_support arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~kconfig-remove-have_latencytop_support
+++ a/arch/parisc/Kconfig
@@ -79,9 +79,6 @@ config TIME_LOW_RES
 	depends on SMP
 	default y
 
-config HAVE_LATENCYTOP_SUPPORT
-        def_bool y
-
 # unless you want to implement ACPI on PA-RISC ... ;-)
 config PM
 	bool
diff -puN arch/powerpc/Kconfig~kconfig-remove-have_latencytop_support arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~kconfig-remove-have_latencytop_support
+++ a/arch/powerpc/Kconfig
@@ -47,9 +47,6 @@ config STACKTRACE_SUPPORT
 	bool
 	default y
 
-config HAVE_LATENCYTOP_SUPPORT
-	def_bool y
-
 config TRACE_IRQFLAGS_SUPPORT
 	bool
 	default y
diff -puN arch/s390/Kconfig~kconfig-remove-have_latencytop_support arch/s390/Kconfig
--- a/arch/s390/Kconfig~kconfig-remove-have_latencytop_support
+++ a/arch/s390/Kconfig
@@ -10,9 +10,6 @@ config LOCKDEP_SUPPORT
 config STACKTRACE_SUPPORT
 	def_bool y
 
-config HAVE_LATENCYTOP_SUPPORT
-	def_bool y
-
 config RWSEM_GENERIC_SPINLOCK
 	bool
 
diff -puN arch/sh/Kconfig~kconfig-remove-have_latencytop_support arch/sh/Kconfig
--- a/arch/sh/Kconfig~kconfig-remove-have_latencytop_support
+++ a/arch/sh/Kconfig
@@ -130,9 +130,6 @@ config STACKTRACE_SUPPORT
 config LOCKDEP_SUPPORT
 	def_bool y
 
-config HAVE_LATENCYTOP_SUPPORT
-	def_bool y
-
 config ARCH_HAS_ILOG2_U32
 	def_bool n
 
diff -puN arch/sparc/Kconfig~kconfig-remove-have_latencytop_support arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~kconfig-remove-have_latencytop_support
+++ a/arch/sparc/Kconfig
@@ -101,10 +101,6 @@ config LOCKDEP_SUPPORT
 	bool
 	default y if SPARC64
 
-config HAVE_LATENCYTOP_SUPPORT
-	bool
-	default y if SPARC64
-
 config ARCH_HIBERNATION_POSSIBLE
 	def_bool y if SPARC64
 
diff -puN arch/unicore32/Kconfig~kconfig-remove-have_latencytop_support arch/unicore32/Kconfig
--- a/arch/unicore32/Kconfig~kconfig-remove-have_latencytop_support
+++ a/arch/unicore32/Kconfig
@@ -33,9 +33,6 @@ config NO_IOPORT_MAP
 config STACKTRACE_SUPPORT
 	def_bool y
 
-config HAVE_LATENCYTOP_SUPPORT
-	def_bool y
-
 config LOCKDEP_SUPPORT
 	def_bool y
 
diff -puN arch/x86/Kconfig~kconfig-remove-have_latencytop_support arch/x86/Kconfig
--- a/arch/x86/Kconfig~kconfig-remove-have_latencytop_support
+++ a/arch/x86/Kconfig
@@ -177,9 +177,6 @@ config LOCKDEP_SUPPORT
 config STACKTRACE_SUPPORT
 	def_bool y
 
-config HAVE_LATENCYTOP_SUPPORT
-	def_bool y

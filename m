From: akpm@linux-foundation.org
Subject: + lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig.patch
 added to -mm tree
Date: Fri, 28 Mar 2014 15:11:06 -0700
Message-ID: <5335f37a.EV28FsgKvQVeemB9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53933 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaC1WLH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Mar 2014 18:11:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tony.luck@intel.com, tglx@linutronix.de, schwidefsky@de.ibm.com, paulus@samba.org, mingo@redhat.com, linux@arm.linux.org.uk, hpa@zytor.com, heiko.carstens@de.ibm.com, fenghua.yu@intel.com, benh@kernel.crashing.org, JBottomley@parallels.com, lauraa@codeaurora.org

Subject: + lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig.patch added to -mm tree
To: lauraa@codeaurora.org,JBottomley@parallels.com,benh@kernel.crashing.org,fenghua.yu@intel.com,heiko.carstens@de.ibm.com,hpa@zytor.com,linux@arm.linux.org.uk,mingo@redhat.com,paulus@samba.org,schwidefsky@de.ibm.com,tglx@linutronix.de,tony.luck@intel.com
From: akpm@linux-foundation.org
Date: Fri, 28 Mar 2014 15:11:06 -0700


The patch titled
     Subject: lib/scatterlist: make ARCH_HAS_SG_CHAIN an actual Kconfig
has been added to the -mm tree.  Its filename is
     lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Laura Abbott <lauraa@codeaurora.org>
Subject: lib/scatterlist: make ARCH_HAS_SG_CHAIN an actual Kconfig

Rather than have architectures #define ARCH_HAS_SG_CHAIN in an
architecture specific scatterlist.h, make it a proper Kconfig option and
use that instead.  At same time, remove the header files are are now
mostly useless and just include asm-generic/scatterlist.h.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>			[x86]
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>	[powerpc]
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig                       |    1 +
 arch/arm/include/asm/Kbuild            |    1 +
 arch/arm/include/asm/scatterlist.h     |   12 ------------
 arch/arm64/Kconfig                     |    1 +
 arch/ia64/Kconfig                      |    1 +
 arch/ia64/include/asm/Kbuild           |    1 +
 arch/ia64/include/asm/scatterlist.h    |    7 -------
 arch/powerpc/Kconfig                   |    1 +
 arch/powerpc/include/asm/Kbuild        |    1 +
 arch/powerpc/include/asm/scatterlist.h |   17 -----------------
 arch/s390/Kconfig                      |    1 +
 arch/s390/include/asm/Kbuild           |    1 +
 arch/s390/include/asm/scatterlist.h    |    3 ---
 arch/sparc/Kconfig                     |    1 +
 arch/sparc/include/asm/Kbuild          |    1 +
 arch/sparc/include/asm/scatterlist.h   |    8 --------
 arch/x86/Kconfig                       |    1 +
 arch/x86/include/asm/Kbuild            |    1 +
 arch/x86/include/asm/scatterlist.h     |    8 --------
 include/linux/scatterlist.h            |    2 +-
 include/scsi/scsi.h                    |    2 +-
 lib/Kconfig                            |    7 +++++++
 lib/scatterlist.c                      |    4 ++--
 23 files changed, 24 insertions(+), 59 deletions(-)

diff -puN arch/arm/Kconfig~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig arch/arm/Kconfig
--- a/arch/arm/Kconfig~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/arch/arm/Kconfig
@@ -82,6 +82,7 @@ config ARM
 	  <http://www.arm.linux.org.uk/>.
 
 config ARM_HAS_SG_CHAIN
+	select ARCH_HAS_SG_CHAIN
 	bool
 
 config NEED_SG_DMA_LENGTH
diff -puN arch/arm/include/asm/Kbuild~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig arch/arm/include/asm/Kbuild
--- a/arch/arm/include/asm/Kbuild~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/arch/arm/include/asm/Kbuild
@@ -18,6 +18,7 @@ generic-y += param.h
 generic-y += parport.h
 generic-y += poll.h
 generic-y += resource.h
+generic-y += scatterlist.h
 generic-y += sections.h
 generic-y += segment.h
 generic-y += sembuf.h
diff -puN arch/arm/include/asm/scatterlist.h~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig /dev/null
--- a/arch/arm/include/asm/scatterlist.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifndef _ASMARM_SCATTERLIST_H
-#define _ASMARM_SCATTERLIST_H
-
-#ifdef CONFIG_ARM_HAS_SG_CHAIN
-#define ARCH_HAS_SG_CHAIN
-#endif
-
-#include <asm/memory.h>
-#include <asm/types.h>
-#include <asm-generic/scatterlist.h>
-
-#endif /* _ASMARM_SCATTERLIST_H */
diff -puN arch/arm64/Kconfig~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig arch/arm64/Kconfig
--- a/arch/arm64/Kconfig~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/arch/arm64/Kconfig
@@ -2,6 +2,7 @@ config ARM64
 	def_bool y
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select ARCH_USE_CMPXCHG_LOCKREF
+	select ARCH_HAS_SG_CHAIN
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION
diff -puN arch/ia64/Kconfig~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/arch/ia64/Kconfig
@@ -45,6 +45,7 @@ config IA64
 	select HAVE_MOD_ARCH_SPECIFIC
 	select MODULES_USE_ELF_RELA
 	select ARCH_USE_CMPXCHG_LOCKREF
+	select ARCH_HAS_SG_CHAIN
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
diff -puN arch/ia64/include/asm/Kbuild~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig arch/ia64/include/asm/Kbuild
--- a/arch/ia64/include/asm/Kbuild~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/arch/ia64/include/asm/Kbuild
@@ -2,6 +2,7 @@
 generic-y += clkdev.h
 generic-y += exec.h
 generic-y += kvm_para.h
+generic-y += scatterlist.h
 generic-y += trace_clock.h
 generic-y += preempt.h
 generic-y += vtime.h
diff -puN arch/ia64/include/asm/scatterlist.h~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig /dev/null
--- a/arch/ia64/include/asm/scatterlist.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef _ASM_IA64_SCATTERLIST_H
-#define _ASM_IA64_SCATTERLIST_H
-
-#include <asm-generic/scatterlist.h>
-#define ARCH_HAS_SG_CHAIN
-
-#endif /* _ASM_IA64_SCATTERLIST_H */
diff -puN arch/powerpc/Kconfig~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/arch/powerpc/Kconfig
@@ -141,6 +141,7 @@ config PPC
 	select HAVE_DEBUG_STACKOVERFLOW
 	select HAVE_IRQ_EXIT_ON_IRQ_STACK
 	select ARCH_USE_CMPXCHG_LOCKREF if PPC64
+	select ARCH_HAS_SG_CHAIN
 
 config GENERIC_CSUM
 	def_bool CPU_LITTLE_ENDIAN
diff -puN arch/powerpc/include/asm/Kbuild~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig arch/powerpc/include/asm/Kbuild
--- a/arch/powerpc/include/asm/Kbuild~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/arch/powerpc/include/asm/Kbuild
@@ -1,6 +1,7 @@
 
 generic-y += clkdev.h
 generic-y += rwsem.h
+generic-y += scatterlist.h
 generic-y += trace_clock.h
 generic-y += preempt.h
 generic-y += vtime.h
diff -puN arch/powerpc/include/asm/scatterlist.h~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig /dev/null
--- a/arch/powerpc/include/asm/scatterlist.h
+++ /dev/null
@@ -1,17 +0,0 @@
-#ifndef _ASM_POWERPC_SCATTERLIST_H
-#define _ASM_POWERPC_SCATTERLIST_H
-/*
- * Copyright (C) 2001 PPC64 Team, IBM Corp
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#include <asm/dma.h>
-#include <asm-generic/scatterlist.h>
-
-#define ARCH_HAS_SG_CHAIN
-
-#endif /* _ASM_POWERPC_SCATTERLIST_H */
diff -puN arch/s390/Kconfig~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig arch/s390/Kconfig
--- a/arch/s390/Kconfig~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/arch/s390/Kconfig
@@ -142,6 +142,7 @@ config S390
 	select SYSCTL_EXCEPTION_TRACE
 	select VIRT_CPU_ACCOUNTING
 	select VIRT_TO_BUS
+	select ARCH_HAS_SG_CHAIN
 
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
diff -puN arch/s390/include/asm/Kbuild~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig arch/s390/include/asm/Kbuild
--- a/arch/s390/include/asm/Kbuild~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/arch/s390/include/asm/Kbuild
@@ -4,3 +4,4 @@ generic-y += clkdev.h
 generic-y += trace_clock.h
 generic-y += preempt.h
 generic-y += hash.h
+generic-y += scatterlist.h
diff -puN arch/s390/include/asm/scatterlist.h~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig /dev/null
--- a/arch/s390/include/asm/scatterlist.h
+++ /dev/null
@@ -1,3 +0,0 @@
-#include <asm-generic/scatterlist.h>
-
-#define ARCH_HAS_SG_CHAIN
diff -puN arch/sparc/Kconfig~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/arch/sparc/Kconfig
@@ -42,6 +42,7 @@ config SPARC
 	select MODULES_USE_ELF_RELA
 	select ODD_RT_SIGACTION
 	select OLD_SIGSUSPEND
+	select ARCH_HAS_SG_CHAIN
 
 config SPARC32
 	def_bool !64BIT
diff -puN arch/sparc/include/asm/Kbuild~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig arch/sparc/include/asm/Kbuild
--- a/arch/sparc/include/asm/Kbuild~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/arch/sparc/include/asm/Kbuild
@@ -18,3 +18,4 @@ generic-y += types.h
 generic-y += word-at-a-time.h
 generic-y += preempt.h
 generic-y += hash.h
+generic-y += scatterlist.h
diff -puN arch/sparc/include/asm/scatterlist.h~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig /dev/null
--- a/arch/sparc/include/asm/scatterlist.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef _SPARC_SCATTERLIST_H
-#define _SPARC_SCATTERLIST_H
-
-#include <asm-generic/scatterlist.h>
-
-#define ARCH_HAS_SG_CHAIN
-
-#endif /* !(_SPARC_SCATTERLIST_H) */
diff -puN arch/x86/Kconfig~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig arch/x86/Kconfig
--- a/arch/x86/Kconfig~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/arch/x86/Kconfig
@@ -127,6 +127,7 @@ config X86
 	select HAVE_DEBUG_STACKOVERFLOW
 	select HAVE_IRQ_EXIT_ON_IRQ_STACK if X86_64
 	select HAVE_CC_STACKPROTECTOR
+	select ARCH_HAS_SG_CHAIN
 
 config INSTRUCTION_DECODER
 	def_bool y
diff -puN arch/x86/include/asm/Kbuild~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig arch/x86/include/asm/Kbuild
--- a/arch/x86/include/asm/Kbuild~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/arch/x86/include/asm/Kbuild
@@ -5,3 +5,4 @@ genhdr-y += unistd_64.h
 genhdr-y += unistd_x32.h
 
 generic-y += clkdev.h
+generic-y += scatterlist.h
diff -puN arch/x86/include/asm/scatterlist.h~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig /dev/null
--- a/arch/x86/include/asm/scatterlist.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef _ASM_X86_SCATTERLIST_H
-#define _ASM_X86_SCATTERLIST_H
-
-#include <asm-generic/scatterlist.h>
-
-#define ARCH_HAS_SG_CHAIN
-
-#endif /* _ASM_X86_SCATTERLIST_H */
diff -puN include/linux/scatterlist.h~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig include/linux/scatterlist.h
--- a/include/linux/scatterlist.h~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/include/linux/scatterlist.h
@@ -136,7 +136,7 @@ static inline void sg_set_buf(struct sca
 static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
 			    struct scatterlist *sgl)
 {
-#ifndef ARCH_HAS_SG_CHAIN
+#ifndef CONFIG_ARCH_HAS_SG_CHAIN
 	BUG();
 #endif
 
diff -puN include/scsi/scsi.h~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig include/scsi/scsi.h
--- a/include/scsi/scsi.h~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/include/scsi/scsi.h
@@ -31,7 +31,7 @@ enum scsi_timeouts {
  * Like SCSI_MAX_SG_SEGMENTS, but for archs that have sg chaining. This limit
  * is totally arbitrary, a setting of 2048 will get you at least 8mb ios.
  */
-#ifdef ARCH_HAS_SG_CHAIN
+#ifdef CONFIG_ARCH_HAS_SG_CHAIN
 #define SCSI_MAX_SG_CHAIN_SEGMENTS	2048
 #else
 #define SCSI_MAX_SG_CHAIN_SEGMENTS	SCSI_MAX_SG_SEGMENTS
diff -puN lib/Kconfig~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig lib/Kconfig
--- a/lib/Kconfig~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/lib/Kconfig
@@ -458,4 +458,11 @@ config UCS2_STRING
 
 source "lib/fonts/Kconfig"
 
+#
+# sg chaining option
+#
+
+config ARCH_HAS_SG_CHAIN
+	def_bool n
+
 endmenu
diff -puN lib/scatterlist.c~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig lib/scatterlist.c
--- a/lib/scatterlist.c~lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig
+++ a/lib/scatterlist.c
@@ -73,7 +73,7 @@ EXPORT_SYMBOL(sg_nents);
  **/
 struct scatterlist *sg_last(struct scatterlist *sgl, unsigned int nents)
 {
-#ifndef ARCH_HAS_SG_CHAIN
+#ifndef CONFIG_ARCH_HAS_SG_CHAIN
 	struct scatterlist *ret = &sgl[nents - 1];
 #else
 	struct scatterlist *sg, *ret = NULL;
@@ -251,7 +251,7 @@ int __sg_alloc_table(struct sg_table *ta
 
 	if (nents == 0)
 		return -EINVAL;
-#ifndef ARCH_HAS_SG_CHAIN
+#ifndef CONFIG_ARCH_HAS_SG_CHAIN
 	if (WARN_ON_ONCE(nents > max_ents))
 		return -EINVAL;
 #endif
_

Patches currently in -mm which might be from lauraa@codeaurora.org are

mm-compactionc-isolate_freepages_block-small-tuneup.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig.patch
lib-scatterlist-clean-up-useless-architecture-versions-of-scatterlisth.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch


From: akpm@linux-foundation.org
Subject: + m32r-build-fix-of-arch-m32r-kernel-smpbootc.patch added to -mm tree
Date: Wed, 31 Oct 2007 14:16:10 -0700
Message-ID: <200710312116.l9VLGAKb028506@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35661 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760185AbXJaVRW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Oct 2007 17:17:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, takata@linux-m32r.org


The patch titled
     m32r: build fix of arch/m32r/kernel/smpboot.c
has been added to the -mm tree.  Its filename is
     m32r-build-fix-of-arch-m32r-kernel-smpbootc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: m32r: build fix of arch/m32r/kernel/smpboot.c
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

This patch is for Mathieu Desnoyers's include/asm-m32r/local.h.
Applying the new include/asm-m32r/local.h, inclusion of linux/sched.h
is needed to fix a build error of arch/m32r/kernel/smpboot.c.

<--  snip  -->
  ...
  CC      arch/m32r/kernel/smpboot.o
/project/m32r-linux/kernel/work/linux-2.6_dev.git/arch/m32r/kernel/smpboot.c: In function 'do_boot_cpu':
/project/m32r-linux/kernel/work/linux-2.6_dev.git/arch/m32r/kernel/smpboot.c:279: error: implicit declaration of function 'fork_idle'
/project/m32r-linux/kernel/work/linux-2.6_dev.git/arch/m32r/kernel/smpboot.c:279: warning: assignment makes pointer from integer without a cast
/project/m32r-linux/kernel/work/linux-2.6_dev.git/arch/m32r/kernel/smpboot.c:283: error: dereferencing pointer to incomplete type
/project/m32r-linux/kernel/work/linux-2.6_dev.git/arch/m32r/kernel/smpboot.c:289: error: dereferencing pointer to incomplete type
/project/m32r-linux/kernel/work/linux-2.6_dev.git/arch/m32r/kernel/smpboot.c:290: error: implicit declaration of function 'task_thread_info'
/project/m32r-linux/kernel/work/linux-2.6_dev.git/arch/m32r/kernel/smpboot.c:290: error: invalid type argument of '->'
/project/m32r-linux/kernel/work/linux-2.6_dev.git/arch/m32r/kernel/smpboot.c: In function 'start_secondary':
/project/m32r-linux/kernel/work/linux-2.6_dev.git/arch/m32r/kernel/smpboot.c:429: error: implicit declaration of function 'cpu_init'
make[2]: *** [arch/m32r/kernel/smpboot.o] Error 1
<--  snip  -->

Signed-off-by: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/kernel/smpboot.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/m32r/kernel/smpboot.c~m32r-build-fix-of-arch-m32r-kernel-smpbootc arch/m32r/kernel/smpboot.c
--- a/arch/m32r/kernel/smpboot.c~m32r-build-fix-of-arch-m32r-kernel-smpbootc
+++ a/arch/m32r/kernel/smpboot.c
@@ -43,6 +43,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/sched.h>
 #include <linux/err.h>
 #include <linux/irq.h>
 #include <linux/bootmem.h>
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

add-cmpxchg_local-to-asm-generic-for-per-cpu-atomic-operations.patch
fall-back-on-interrupt-disable-in-cmpxchg8b-on-80386-and-80486.patch
add-cmpxchg64-and-cmpxchg64_local-to-alpha.patch
add-cmpxchg64-and-cmpxchg64_local-to-mips.patch
add-cmpxchg64-and-cmpxchg64_local-to-powerpc.patch
add-cmpxchg64-and-cmpxchg64_local-to-x86_64.patch
add-cmpxchg_local-to-arm.patch
add-cmpxchg_local-to-avr32.patch
add-cmpxchg_local-to-blackfin-replace-__cmpxchg-by-generic-cmpxchg.patch
add-cmpxchg_local-to-cris.patch
add-cmpxchg_local-to-frv.patch
add-cmpxchg_local-to-h8300.patch
add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch
new-cmpxchg_local-optimized-for-up-case-for-m32r.patch
fix-m32r-__xchg.patch
m32r-build-fix-of-arch-m32r-kernel-smpbootc.patch
local_t-m32r-use-architecture-specific-cmpxchg_local.patch
add-cmpxchg_local-to-m86k.patch
add-cmpxchg_local-to-m68knommu.patch
add-cmpxchg_local-to-parisc.patch
add-cmpxchg_local-to-ppc.patch
add-cmpxchg_local-to-s390.patch
add-cmpxchg_local-to-sh-use-generic-cmpxchg-instead-of-cmpxchg_u32.patch
add-cmpxchg_local-to-sh64.patch
add-cmpxchg_local-to-sparc-move-__cmpxchg-to-systemh.patch
add-cmpxchg_local-to-sparc64.patch
add-cmpxchg_local-to-v850.patch
add-cmpxchg_local-to-xtensa.patch

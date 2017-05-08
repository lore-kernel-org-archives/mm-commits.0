From: akpm@linux-foundation.org
Subject: [patch 084/114] treewide: decouple cacheflush.h and
 set_memory.h
Date: Mon, 08 May 2017 15:58:47 -0700
Message-ID: <20170508225847.05SdLKhkU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47312 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751087AbdEHW6s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:58:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, catalin.marinas@arm.com, labbott@redhat.com, mark.rutland@arm.com, mm-commits@vger.kernel.org, sfr@canb.auug.org.au, torvalds@linux-foundation.org

From: Laura Abbott <labbott@redhat.com>
Subject: treewide: decouple cacheflush.h and set_memory.h

Now that all call sites, completely decouple cacheflush.h and
set_memory.h

[sfr@canb.auug.org.au: kprobes/x86: merge fix for set_memory.h decoupling]
  Link: http://lkml.kernel.org/r/20170418180903.10300fd3@canb.auug.org.au
Link: http://lkml.kernel.org/r/1488920133-27229-17-git-send-email-labbott@redhat.com
Signed-off-by: Laura Abbott <labbott@redhat.com>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/cacheflush.h   |    1 -
 arch/arm64/include/asm/cacheflush.h |    1 -
 arch/s390/include/asm/Kbuild        |    1 +
 arch/s390/include/asm/cacheflush.h  |    8 --------
 arch/x86/include/asm/cacheflush.h   |    1 -
 arch/x86/kernel/kprobes/core.c      |    1 +
 arch/x86/kernel/kprobes/opt.c       |    1 +
 7 files changed, 3 insertions(+), 11 deletions(-)

diff -puN arch/arm/include/asm/cacheflush.h~treewide-decouple-cacheflushh-and-set_memoryh arch/arm/include/asm/cacheflush.h
--- a/arch/arm/include/asm/cacheflush.h~treewide-decouple-cacheflushh-and-set_memoryh
+++ a/arch/arm/include/asm/cacheflush.h
@@ -16,7 +16,6 @@
 #include <asm/shmparam.h>
 #include <asm/cachetype.h>
 #include <asm/outercache.h>
-#include <asm/set_memory.h>
 
 #define CACHE_COLOUR(vaddr)	((vaddr & (SHMLBA - 1)) >> PAGE_SHIFT)
 
diff -puN arch/arm64/include/asm/cacheflush.h~treewide-decouple-cacheflushh-and-set_memoryh arch/arm64/include/asm/cacheflush.h
--- a/arch/arm64/include/asm/cacheflush.h~treewide-decouple-cacheflushh-and-set_memoryh
+++ a/arch/arm64/include/asm/cacheflush.h
@@ -20,7 +20,6 @@
 #define __ASM_CACHEFLUSH_H
 
 #include <linux/mm.h>
-#include <asm/set_memory.h>
 
 /*
  * This flag is used to indicate that the page pointed to by a pte is clean
diff -puN arch/s390/include/asm/Kbuild~treewide-decouple-cacheflushh-and-set_memoryh arch/s390/include/asm/Kbuild
--- a/arch/s390/include/asm/Kbuild~treewide-decouple-cacheflushh-and-set_memoryh
+++ a/arch/s390/include/asm/Kbuild
@@ -1,4 +1,5 @@
 generic-y += asm-offsets.h
+generic-y += cacheflush.h
 generic-y += clkdev.h
 generic-y += dma-contiguous.h
 generic-y += div64.h
diff -puN arch/s390/include/asm/cacheflush.h~treewide-decouple-cacheflushh-and-set_memoryh /dev/null
--- a/arch/s390/include/asm/cacheflush.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef _S390_CACHEFLUSH_H
-#define _S390_CACHEFLUSH_H
-
-/* Caches aren't brain-dead on the s390. */
-#include <asm-generic/cacheflush.h>
-#include <asm/set_memory.h>
-
-#endif /* _S390_CACHEFLUSH_H */
diff -puN arch/x86/include/asm/cacheflush.h~treewide-decouple-cacheflushh-and-set_memoryh arch/x86/include/asm/cacheflush.h
--- a/arch/x86/include/asm/cacheflush.h~treewide-decouple-cacheflushh-and-set_memoryh
+++ a/arch/x86/include/asm/cacheflush.h
@@ -4,7 +4,6 @@
 /* Caches aren't brain-dead on the intel. */
 #include <asm-generic/cacheflush.h>
 #include <asm/special_insns.h>
-#include <asm/set_memory.h>
 
 void clflush_cache_range(void *addr, unsigned int size);
 
diff -puN arch/x86/kernel/kprobes/core.c~treewide-decouple-cacheflushh-and-set_memoryh arch/x86/kernel/kprobes/core.c
--- a/arch/x86/kernel/kprobes/core.c~treewide-decouple-cacheflushh-and-set_memoryh
+++ a/arch/x86/kernel/kprobes/core.c
@@ -61,6 +61,7 @@
 #include <asm/alternative.h>
 #include <asm/insn.h>
 #include <asm/debugreg.h>
+#include <asm/set_memory.h>
 
 #include "common.h"
 
diff -puN arch/x86/kernel/kprobes/opt.c~treewide-decouple-cacheflushh-and-set_memoryh arch/x86/kernel/kprobes/opt.c
--- a/arch/x86/kernel/kprobes/opt.c~treewide-decouple-cacheflushh-and-set_memoryh
+++ a/arch/x86/kernel/kprobes/opt.c
@@ -37,6 +37,7 @@
 #include <asm/alternative.h>
 #include <asm/insn.h>
 #include <asm/debugreg.h>
+#include <asm/set_memory.h>
 
 #include "common.h"
 
_

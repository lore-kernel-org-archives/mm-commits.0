From: akpm@linux-foundation.org
Subject: + treewide-decouple-cacheflushh-and-set_memoryh.patch added to
 -mm tree
Date: Thu, 09 Mar 2017 13:39:09 -0800
Message-ID: <58c1cb7d.THg8UTzWlvzExRga%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37206 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752760AbdCIVpy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Mar 2017 16:45:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: labbott@redhat.com, catalin.marinas@arm.com, mark.rutland@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: treewide: decouple cacheflush.h and set_memory.h
has been added to the -mm tree.  Its filename is
     treewide-decouple-cacheflushh-and-set_memoryh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/treewide-decouple-cacheflushh-and-set_memoryh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/treewide-decouple-cacheflushh-and-set_memoryh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Laura Abbott <labbott@redhat.com>
Subject: treewide: decouple cacheflush.h and set_memory.h

Now that all call sites, completely decouple cacheflush.h and
set_memory.h

Link: http://lkml.kernel.org/r/1488920133-27229-17-git-send-email-labbott@redhat.com
Signed-off-by: Laura Abbott <labbott@redhat.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/cacheflush.h   |    1 -
 arch/arm64/include/asm/cacheflush.h |    1 -
 arch/s390/include/asm/Kbuild        |    1 +
 arch/s390/include/asm/cacheflush.h  |    8 --------
 arch/x86/include/asm/cacheflush.h   |    1 -
 5 files changed, 1 insertion(+), 11 deletions(-)

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
 generic-y += export.h
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
 
_

Patches currently in -mm which might be from labbott@redhat.com are

treewide-move-set_memory_-functions-away-from-cacheflushh.patch
arm-use-set_memoryh-header.patch
arm64-use-set_memoryh-header.patch
s390-use-set_memoryh-header.patch
x86-use-set_memoryh-header.patch
agp-use-set_memoryh-header.patch
drm-use-set_memoryh-header.patch
intel_th-use-set_memoryh-header.patch
watchdog-hpwdt-use-set_memoryh-header.patch
bpf-use-set_memoryh-header.patch
module-use-set_memoryh-header.patch
pm-hibernate-use-set_memoryh-header.patch
alsa-use-set_memoryh-header.patch
misc-sram-use-set_memoryh-header.patch
video-vermilion-use-set_memoryh-header.patch
treewide-decouple-cacheflushh-and-set_memoryh.patch


From: akpm@linux-foundation.org
Subject: + arch-xtensa-remove-duplicate-includes.patch added to -mm tree
Date: Mon, 05 Nov 2007 18:36:04 -0800
Message-ID: <200711060236.lA62a4xx032051@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42529 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755779AbXKFCgH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 21:36:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: woodzy@gmail.com, chris@zankel.net


The patch titled
     arch/xtensa: remove duplicate includes
has been added to the -mm tree.  Its filename is
     arch-xtensa-remove-duplicate-includes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: arch/xtensa: remove duplicate includes
From: Lucas Woods <woodzy@gmail.com>

Signed-off-by: Lucas Woods <woodzy@gmail.com>
Cc: Christian Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/kernel/asm-offsets.c   |    1 -
 arch/xtensa/kernel/syscall.c       |    1 -
 arch/xtensa/mm/cache.c             |    1 -
 arch/xtensa/platform-iss/network.c |    1 -
 4 files changed, 4 deletions(-)

diff -puN arch/xtensa/kernel/asm-offsets.c~arch-xtensa-remove-duplicate-includes arch/xtensa/kernel/asm-offsets.c
--- a/arch/xtensa/kernel/asm-offsets.c~arch-xtensa-remove-duplicate-includes
+++ a/arch/xtensa/kernel/asm-offsets.c
@@ -21,7 +21,6 @@
 #include <linux/mm.h>
 
 #include <asm/ptrace.h>
-#include <asm/processor.h>
 #include <asm/uaccess.h>
 
 #define DEFINE(sym, val) asm volatile("\n->" #sym " %0 " #val : : "i" (val))
diff -puN arch/xtensa/kernel/syscall.c~arch-xtensa-remove-duplicate-includes arch/xtensa/kernel/syscall.c
--- a/arch/xtensa/kernel/syscall.c~arch-xtensa-remove-duplicate-includes
+++ a/arch/xtensa/kernel/syscall.c
@@ -36,7 +36,6 @@ syscall_t sys_call_table[__NR_syscall_co
 #define __SYSCALL(nr,symbol,nargs) [ nr ] = (syscall_t)symbol,
 #undef _XTENSA_UNISTD_H
 #undef  __KERNEL_SYSCALLS__
-#include <asm/unistd.h>
 };
 
 /*
diff -puN arch/xtensa/mm/cache.c~arch-xtensa-remove-duplicate-includes arch/xtensa/mm/cache.c
--- a/arch/xtensa/mm/cache.c~arch-xtensa-remove-duplicate-includes
+++ a/arch/xtensa/mm/cache.c
@@ -25,7 +25,6 @@
 #include <linux/swap.h>
 #include <linux/pagemap.h>
 
-#include <asm/pgtable.h>
 #include <asm/bootparam.h>
 #include <asm/mmu_context.h>
 #include <asm/tlb.h>
diff -puN arch/xtensa/platform-iss/network.c~arch-xtensa-remove-duplicate-includes arch/xtensa/platform-iss/network.c
--- a/arch/xtensa/platform-iss/network.c~arch-xtensa-remove-duplicate-includes
+++ a/arch/xtensa/platform-iss/network.c
@@ -31,7 +31,6 @@
 #include <linux/bootmem.h>
 #include <linux/ethtool.h>
 #include <linux/rtnetlink.h>
-#include <linux/timer.h>
 #include <linux/platform_device.h>
 
 #include <asm/platform/simcall.h>
_

Patches currently in -mm which might be from woodzy@gmail.com are

arch-alpha-removed-duplicate-includes.patch
arch-arm-removed-duplicate-includes.patch
arch-ia64-remove-duplicate-includes.patch
arch-mips-remove-duplicate-includes.patch
arch-parisc-remove-duplicate-includes.patch
arch-powerpc-remove-duplicate-includes.patch
arch-ppc-remove-duplicate-includes.patch
arch-sparc-remove-duplicate-includes.patch
arch-um-remove-duplicate-includes.patch
arch-x86-remove-duplicate-includes.patch
arch-xtensa-remove-duplicate-includes.patch

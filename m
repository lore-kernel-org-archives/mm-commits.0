From: akpm@linux-foundation.org
Subject: - arch-xtensa-remove-duplicate-includes.patch removed from -mm tree
Date: Fri, 07 Dec 2007 14:49:19 -0800
Message-ID: <200712072249.lB7MnJsB007540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48826 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753005AbXLGWtx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2007 17:49:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: woodzy@gmail.com, chris@zankel.net, mm-commits@vger.kernel.org


The patch titled
     arch/xtensa: remove duplicate includes
has been removed from the -mm tree.  Its filename was
     arch-xtensa-remove-duplicate-includes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-arm.patch
arch-powerpc-remove-duplicate-includes.patch
arch-ppc-remove-duplicate-includes.patch
git-mips.patch
git-x86.patch
arch-xtensa-remove-duplicate-includes.patch
arch-alpha-removed-duplicate-includes.patch
arch-um-remove-duplicate-includes.patch

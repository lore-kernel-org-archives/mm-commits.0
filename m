From: akpm@linux-foundation.org
Subject: - arch-powerpc-remove-duplicate-includes.patch removed from -mm tree
Date: Thu, 20 Dec 2007 15:37:05 -0800
Message-ID: <200712202337.lBKNb5xW018860@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60195 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755813AbXLTXrs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 18:47:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: woodzy@gmail.com, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     arch/powerpc: remove duplicate includes
has been removed from the -mm tree.  Its filename was
     arch-powerpc-remove-duplicate-includes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: arch/powerpc: remove duplicate includes
From: Lucas Woods <woodzy@gmail.com>

Signed-off-by: Lucas Woods <woodzy@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/signal_32.c         |    3 +--
 arch/powerpc/platforms/powermac/setup.c |    1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN arch/powerpc/kernel/signal_32.c~arch-powerpc-remove-duplicate-includes arch/powerpc/kernel/signal_32.c
--- a/arch/powerpc/kernel/signal_32.c~arch-powerpc-remove-duplicate-includes
+++ a/arch/powerpc/kernel/signal_32.c
@@ -24,13 +24,12 @@
 #include <linux/signal.h>
 #include <linux/errno.h>
 #include <linux/elf.h>
+#include <linux/ptrace.h>
 #ifdef CONFIG_PPC64
 #include <linux/syscalls.h>
 #include <linux/compat.h>
-#include <linux/ptrace.h>
 #else
 #include <linux/wait.h>
-#include <linux/ptrace.h>
 #include <linux/unistd.h>
 #include <linux/stddef.h>
 #include <linux/tty.h>
diff -puN arch/powerpc/platforms/powermac/setup.c~arch-powerpc-remove-duplicate-includes arch/powerpc/platforms/powermac/setup.c
--- a/arch/powerpc/platforms/powermac/setup.c~arch-powerpc-remove-duplicate-includes
+++ a/arch/powerpc/platforms/powermac/setup.c
@@ -94,7 +94,6 @@ extern struct machdep_calls pmac_md;
 #define DEFAULT_ROOT_DEVICE Root_SDA1	/* sda1 - slightly silly choice */
 
 #ifdef CONFIG_PPC64
-#include <asm/udbg.h>
 int sccdbg;
 #endif
 
_

Patches currently in -mm which might be from woodzy@gmail.com are

git-arm.patch
git-powerpc.patch
git-mips.patch
git-x86.patch
git-xtensa.patch
arch-alpha-removed-duplicate-includes.patch
arch-um-remove-duplicate-includes.patch

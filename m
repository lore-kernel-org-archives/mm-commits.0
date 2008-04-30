From: akpm@linux-foundation.org
Subject: - m68k-m68kmmu-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:50:15 -0700
Message-ID: <200804300550.m3U5oFhI030097@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38957 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759159AbYD3FvF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:51:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, geert@linux-m68k.org, gerg@uclinux.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     m68k/m68kmmu: use kbuild.h instead of defining macros in asm-offsets.c
has been removed from the -mm tree.  Its filename was
     m68k-m68kmmu-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68k/m68kmmu: use kbuild.h instead of defining macros in asm-offsets.c
From: Christoph Lameter <clameter@sgi.com>

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/kernel/asm-offsets.c      |    4 +---
 arch/m68knommu/kernel/asm-offsets.c |    6 +-----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff -puN arch/m68k/kernel/asm-offsets.c~m68k-m68kmmu-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc arch/m68k/kernel/asm-offsets.c
--- a/arch/m68k/kernel/asm-offsets.c~m68k-m68kmmu-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc
+++ a/arch/m68k/kernel/asm-offsets.c
@@ -11,14 +11,12 @@
 #include <linux/stddef.h>
 #include <linux/sched.h>
 #include <linux/kernel_stat.h>
+#include <linux/kbuild.h>
 #include <asm/bootinfo.h>
 #include <asm/irq.h>
 #include <asm/amigahw.h>
 #include <linux/font.h>
 
-#define DEFINE(sym, val) \
-	asm volatile("\n->" #sym " %0 " #val : : "i" (val))
-
 int main(void)
 {
 	/* offsets into the task struct */
diff -puN arch/m68knommu/kernel/asm-offsets.c~m68k-m68kmmu-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc arch/m68knommu/kernel/asm-offsets.c
--- a/arch/m68knommu/kernel/asm-offsets.c~m68k-m68kmmu-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc
+++ a/arch/m68knommu/kernel/asm-offsets.c
@@ -13,15 +13,11 @@
 #include <linux/kernel_stat.h>
 #include <linux/ptrace.h>
 #include <linux/hardirq.h>
+#include <linux/kbuild.h>
 #include <asm/bootinfo.h>
 #include <asm/irq.h>
 #include <asm/thread_info.h>
 
-#define DEFINE(sym, val) \
-        asm volatile("\n->" #sym " %0 " #val : : "i" (val))
-
-#define BLANK() asm volatile("\n->" : : )

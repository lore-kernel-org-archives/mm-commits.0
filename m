From: akpm@linux-foundation.org
Subject: - ppc-powerpc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:50:21 -0700
Message-ID: <200804300550.m3U5oLrH030106@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46738 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758515AbYD3Fuy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:50:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     ppc/powerpc: use kbuild.h instead of defining macros in asm-offsets.c
has been removed from the -mm tree.  Its filename was
     ppc-powerpc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ppc/powerpc: use kbuild.h instead of defining macros in asm-offsets.c
From: Christoph Lameter <clameter@sgi.com>

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/asm-offsets.c |    6 +-----
 arch/ppc/kernel/asm-offsets.c     |    7 ++-----
 2 files changed, 3 insertions(+), 10 deletions(-)

diff -puN arch/powerpc/kernel/asm-offsets.c~ppc-powerpc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc arch/powerpc/kernel/asm-offsets.c
--- a/arch/powerpc/kernel/asm-offsets.c~ppc-powerpc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc
+++ a/arch/powerpc/kernel/asm-offsets.c
@@ -30,6 +30,7 @@
 #include <linux/time.h>
 #include <linux/hardirq.h>
 #endif
+#include <linux/kbuild.h>
 
 #include <asm/io.h>
 #include <asm/page.h>
@@ -51,11 +52,6 @@
 #include <asm/iseries/alpaca.h>
 #endif
 
-#define DEFINE(sym, val) \
-	asm volatile("\n->" #sym " %0 " #val : : "i" (val))
-
-#define BLANK() asm volatile("\n->" : : )
-
 int main(void)
 {
 	DEFINE(THREAD, offsetof(struct task_struct, thread));
diff -puN arch/ppc/kernel/asm-offsets.c~ppc-powerpc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc arch/ppc/kernel/asm-offsets.c
--- a/arch/ppc/kernel/asm-offsets.c~ppc-powerpc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc
+++ a/arch/ppc/kernel/asm-offsets.c
@@ -18,6 +18,8 @@
 #include <linux/suspend.h>
 #include <linux/mman.h>
 #include <linux/mm.h>
+#include <linux/kbuild.h>
+
 #include <asm/io.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
@@ -26,11 +28,6 @@
 #include <asm/thread_info.h>
 #include <asm/vdso_datapage.h>
 
-#define DEFINE(sym, val) \
-	asm volatile("\n->" #sym " %0 " #val : : "i" (val))
-
-#define BLANK() asm volatile("\n->" : : )

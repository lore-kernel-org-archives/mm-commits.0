From: akpm@linux-foundation.org
Subject: - x86-use-kbuildh.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:49:53 -0700
Message-ID: <200804300549.m3U5nr4H030038@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43266 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755278AbYD3GCb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:02:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mingo@elte.hu, sam@ravnborg.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: use kbuild.h
has been removed from the -mm tree.  Its filename was
     x86-use-kbuildh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: use kbuild.h
From: Christoph Lameter <clameter@sgi.com>

Drop the macro definitions in asm-offsets_*.c and use kbuild.h

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/asm-offsets_32.c |    9 +--------
 arch/x86/kernel/asm-offsets_64.c |    9 +--------
 2 files changed, 2 insertions(+), 16 deletions(-)

diff -puN arch/x86/kernel/asm-offsets_32.c~x86-use-kbuildh arch/x86/kernel/asm-offsets_32.c
--- a/arch/x86/kernel/asm-offsets_32.c~x86-use-kbuildh
+++ a/arch/x86/kernel/asm-offsets_32.c
@@ -9,6 +9,7 @@
 #include <linux/signal.h>
 #include <linux/personality.h>
 #include <linux/suspend.h>
+#include <linux/kbuild.h>
 #include <asm/ucontext.h>
 #include "sigframe.h"
 #include <asm/pgtable.h>
@@ -23,14 +24,6 @@
 #include <linux/lguest.h>
 #include "../../../drivers/lguest/lg.h"
 
-#define DEFINE(sym, val) \
-        asm volatile("\n->" #sym " %0 " #val : : "i" (val))
-
-#define BLANK() asm volatile("\n->" : : )
-
-#define OFFSET(sym, str, mem) \
-	DEFINE(sym, offsetof(struct str, mem));
-
 /* workaround for a warning with -Wmissing-prototypes */
 void foo(void);
 
diff -puN arch/x86/kernel/asm-offsets_64.c~x86-use-kbuildh arch/x86/kernel/asm-offsets_64.c
--- a/arch/x86/kernel/asm-offsets_64.c~x86-use-kbuildh
+++ a/arch/x86/kernel/asm-offsets_64.c
@@ -10,6 +10,7 @@
 #include <linux/errno.h> 
 #include <linux/hardirq.h>
 #include <linux/suspend.h>
+#include <linux/kbuild.h>
 #include <asm/pda.h>
 #include <asm/processor.h>
 #include <asm/segment.h>
@@ -17,14 +18,6 @@
 #include <asm/ia32.h>
 #include <asm/bootparam.h>
 
-#define DEFINE(sym, val) \
-        asm volatile("\n->" #sym " %0 " #val : : "i" (val))
-
-#define BLANK() asm volatile("\n->" : : )
-
-#define OFFSET(sym, str, mem) \
-	DEFINE(sym, offsetof(struct str, mem))

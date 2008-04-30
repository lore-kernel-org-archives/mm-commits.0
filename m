From: akpm@linux-foundation.org
Subject: - frv-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:50:11 -0700
Message-ID: <200804300550.m3U5oBAg030091@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39741 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759200AbYD3Fu4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:50:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     frv: use kbuild.h instead of defining macros in asm-offsets.c
has been removed from the -mm tree.  Its filename was
     frv-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: frv: use kbuild.h instead of defining macros in asm-offsets.c
From: Christoph Lameter <clameter@sgi.com>

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/asm-offsets.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff -puN arch/frv/kernel/asm-offsets.c~frv-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc arch/frv/kernel/asm-offsets.c
--- a/arch/frv/kernel/asm-offsets.c~frv-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc
+++ a/arch/frv/kernel/asm-offsets.c
@@ -7,15 +7,13 @@
 #include <linux/sched.h>
 #include <linux/signal.h>
 #include <linux/personality.h>
+#include <linux/kbuild.h>
 #include <asm/registers.h>
 #include <asm/ucontext.h>
 #include <asm/processor.h>
 #include <asm/thread_info.h>
 #include <asm/gdb-stub.h>
 
-#define DEFINE(sym, val) \
-        asm volatile("\n->" #sym " %0 " #val : : "i" (val))
-
 #define DEF_PTREG(sym, reg) \
         asm volatile("\n->" #sym " %0 offsetof(struct pt_regs, " #reg ")" \
 		     : : "i" (offsetof(struct pt_regs, reg)))
@@ -32,11 +30,6 @@
         asm volatile("\n->" #sym " %0 offsetof(struct frv_frame0, " #reg ")" \
 		     : : "i" (offsetof(struct frv_frame0, reg)))
 
-#define BLANK() asm volatile("\n->" : : )
-
-#define OFFSET(sym, str, mem) \
-	DEFINE(sym, offsetof(struct str, mem));

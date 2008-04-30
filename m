From: akpm@linux-foundation.org
Subject: - parisc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:50:19 -0700
Message-ID: <200804300550.m3U5oJaB030103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756839AbYD3GBr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:01:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, grundler@parisc-linux.org, kyle@mcmartin.ca, matthew@wil.cx, mm-commits@vger.kernel.org


The patch titled
     parisc: use kbuild.h instead of defining macros in asm-offsets.c
has been removed from the -mm tree.  Its filename was
     parisc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: parisc: use kbuild.h instead of defining macros in asm-offsets.c
From: Christoph Lameter <clameter@sgi.com>

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/asm-offsets.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN arch/parisc/kernel/asm-offsets.c~parisc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc arch/parisc/kernel/asm-offsets.c
--- a/arch/parisc/kernel/asm-offsets.c~parisc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc
+++ a/arch/parisc/kernel/asm-offsets.c
@@ -32,6 +32,7 @@
 #include <linux/thread_info.h>
 #include <linux/ptrace.h>
 #include <linux/hardirq.h>
+#include <linux/kbuild.h>
 
 #include <asm/pgtable.h>
 #include <asm/ptrace.h>
@@ -39,11 +40,6 @@
 #include <asm/pdc.h>
 #include <asm/uaccess.h>
 
-#define DEFINE(sym, val) \
-	asm volatile("\n->" #sym " %0 " #val : : "i" (val))
-
-#define BLANK() asm volatile("\n->" : : )

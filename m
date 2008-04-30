From: akpm@linux-foundation.org
Subject: - v850-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:50:34 -0700
Message-ID: <200804300550.m3U5oYt0030128@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759023AbYD3Fuj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:50:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, miles@gnu.org, mm-commits@vger.kernel.org


The patch titled
     v850: use kbuild.h instead of defining macros in asm-offsets.c
has been removed from the -mm tree.  Its filename was
     v850-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: v850: use kbuild.h instead of defining macros in asm-offsets.c
From: Christoph Lameter <clameter@sgi.com>

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Miles Bader <miles@gnu.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/v850/kernel/asm-offsets.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN arch/v850/kernel/asm-offsets.c~v850-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc arch/v850/kernel/asm-offsets.c
--- a/arch/v850/kernel/asm-offsets.c~v850-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc
+++ a/arch/v850/kernel/asm-offsets.c
@@ -13,14 +13,11 @@
 #include <linux/kernel_stat.h>
 #include <linux/ptrace.h>
 #include <linux/hardirq.h>
+#include <linux/kbuild.h>
+
 #include <asm/irq.h>
 #include <asm/errno.h>
 
-#define DEFINE(sym, val) \
-	asm volatile("\n->" #sym " %0 " #val : : "i" (val))
-
-#define BLANK() asm volatile("\n->" : : )

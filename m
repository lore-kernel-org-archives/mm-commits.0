From: akpm@linux-foundation.org
Subject: - xtensa-use-kbuildh-macros-instead-of-defining-them-in-asm-offsetsc.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:50:03 -0700
Message-ID: <200804300550.m3U5o3Gn030059@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45889 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758998AbYD3Fuf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:50:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, chris@zankel.net, mm-commits@vger.kernel.org


The patch titled
     xtensa: use kbuild.h macros instead of defining them in asm-offsets.c
has been removed from the -mm tree.  Its filename was
     xtensa-use-kbuildh-macros-instead-of-defining-them-in-asm-offsetsc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xtensa: use kbuild.h macros instead of defining them in asm-offsets.c
From: Christoph Lameter <clameter@sgi.com>

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/kernel/asm-offsets.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/xtensa/kernel/asm-offsets.c~xtensa-use-kbuildh-macros-instead-of-defining-them-in-asm-offsetsc arch/xtensa/kernel/asm-offsets.c
--- a/arch/xtensa/kernel/asm-offsets.c~xtensa-use-kbuildh-macros-instead-of-defining-them-in-asm-offsetsc
+++ a/arch/xtensa/kernel/asm-offsets.c
@@ -19,12 +19,11 @@
 #include <linux/thread_info.h>
 #include <linux/ptrace.h>
 #include <linux/mm.h>
+#include <linux/kbuild.h>
 
 #include <asm/ptrace.h>
 #include <asm/uaccess.h>
 
-#define DEFINE(sym, val) asm volatile("\n->" #sym " %0 " #val : : "i" (val))

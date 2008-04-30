From: akpm@linux-foundation.org
Subject: - sparc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:50:05 -0700
Message-ID: <200804300550.m3U5o5Yw030082@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54533 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755953AbYD3GBT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:01:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     sparc: use kbuild.h instead of defining macros in asm-offsets.c
has been removed from the -mm tree.  Its filename was
     sparc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sparc: use kbuild.h instead of defining macros in asm-offsets.c
From: Christoph Lameter <clameter@sgi.com>

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/asm-offsets.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN arch/sparc/kernel/asm-offsets.c~sparc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc arch/sparc/kernel/asm-offsets.c
--- a/arch/sparc/kernel/asm-offsets.c~sparc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc
+++ a/arch/sparc/kernel/asm-offsets.c
@@ -12,11 +12,7 @@
 
 #include <linux/sched.h>
 // #include <linux/mm.h>
-
-#define DEFINE(sym, val) \
-	asm volatile("\n->" #sym " %0 " #val : : "i" (val))
-
-#define BLANK() asm volatile("\n->" : : )
+#include <linux/kbuild.h>
 
 int foo(void)
 {
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
git-unionfs.patch
git-slub.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
mm-verify-the-page-links-and-memory-model.patch
mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch
mm-print-out-the-zonelists-on-request-for-manual-verification.patch
mm-add-nr_writeback_temp-counter.patch
remove-div_long_long_rem.patch
slab-add-a-flag-to-prevent-debug_free-checks-on-a-kmem_cache.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
x86-ioremap-add-checks-for-virtual-addresses.patch
x86-ioremap-add-checks-for-virtual-addresses-fix.patch


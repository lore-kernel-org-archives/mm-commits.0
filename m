From: akpm@linux-foundation.org
Subject: - ia64-use-kbuildh-macros-instead-of-defining-macros-in-asm-offsetsc.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:49:59 -0700
Message-ID: <200804300549.m3U5nx6G030047@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48986 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759007AbYD3Fuc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:50:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: use kbuild.h macros instead of defining macros in asm-offsets.c
has been removed from the -mm tree.  Its filename was
     ia64-use-kbuildh-macros-instead-of-defining-macros-in-asm-offsetsc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ia64: use kbuild.h macros instead of defining macros in asm-offsets.c
From: Christoph Lameter <clameter@sgi.com>

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/asm-offsets.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN arch/ia64/kernel/asm-offsets.c~ia64-use-kbuildh-macros-instead-of-defining-macros-in-asm-offsetsc arch/ia64/kernel/asm-offsets.c
--- a/arch/ia64/kernel/asm-offsets.c~ia64-use-kbuildh-macros-instead-of-defining-macros-in-asm-offsetsc
+++ a/arch/ia64/kernel/asm-offsets.c
@@ -9,7 +9,7 @@
 #include <linux/sched.h>
 #include <linux/pid.h>
 #include <linux/clocksource.h>
-
+#include <linux/kbuild.h>
 #include <asm-ia64/processor.h>
 #include <asm-ia64/ptrace.h>
 #include <asm-ia64/siginfo.h>
@@ -19,11 +19,6 @@
 #include "../kernel/sigframe.h"
 #include "../kernel/fsyscall_gtod_data.h"
 
-#define DEFINE(sym, val) \
-        asm volatile("\n->" #sym " %0 " #val : : "i" (val))
-
-#define BLANK() asm volatile("\n->" : : )

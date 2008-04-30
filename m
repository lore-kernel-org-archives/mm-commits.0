From: akpm@linux-foundation.org
Subject: - mn10300-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:50:17 -0700
Message-ID: <200804300550.m3U5oHC2030100@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51733 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759193AbYD3Fuz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:50:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mn10300: use kbuild.h instead of defining macros in asm-offsets.c
has been removed from the -mm tree.  Its filename was
     mn10300-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mn10300: use kbuild.h instead of defining macros in asm-offsets.c
From: Christoph Lameter <clameter@sgi.com>

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/kernel/asm-offsets.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff -puN arch/mn10300/kernel/asm-offsets.c~mn10300-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc arch/mn10300/kernel/asm-offsets.c
--- a/arch/mn10300/kernel/asm-offsets.c~mn10300-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc
+++ a/arch/mn10300/kernel/asm-offsets.c
@@ -7,6 +7,7 @@
 #include <linux/sched.h>
 #include <linux/signal.h>
 #include <linux/personality.h>
+#include <linux/kbuild.h>
 #include <asm/ucontext.h>
 #include <asm/processor.h>
 #include <asm/thread_info.h>
@@ -14,14 +15,6 @@
 #include "sigframe.h"
 #include "mn10300-serial.h"
 
-#define DEFINE(sym, val) \
-	asm volatile("\n->" #sym " %0 " #val : : "i" (val))
-
-#define BLANK() asm volatile("\n->")
-
-#define OFFSET(sym, str, mem) \
-	DEFINE(sym, offsetof(struct str, mem));

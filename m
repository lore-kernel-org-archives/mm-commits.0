From: akpm@linux-foundation.org
Subject: - vdso-print-fatal-signals-fix.patch removed from -mm tree
Date: Thu, 24 May 2007 09:25:29 -0700
Message-ID: <200705241625.l4OGPS0I029964@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:45502 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750714AbXEXQZr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 May 2007 12:25:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: righiandr@users.sourceforge.net, a.righi@cineca.it, mm-commits@vger.kernel.org


The patch titled
     limit print_fatal_signal() rate
has been removed from the -mm tree.  Its filename was
     vdso-print-fatal-signals-fix.patch

This patch was dropped because it reduces the usefulness, and it's a root-opt-in thing anyway

------------------------------------------------------
Subject: limit print_fatal_signal() rate
From: Andrea Righi <righiandr@users.sourceforge.net>

Limit the rate of print_fatal_signal() to avoid potential denial-of-service
attacks.

Signed-off-by: Andrea Righi <a.righi@cineca.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN kernel/signal.c~vdso-print-fatal-signals-fix kernel/signal.c
--- a/kernel/signal.c~vdso-print-fatal-signals-fix
+++ a/kernel/signal.c
@@ -709,7 +709,10 @@ int print_fatal_signals = 0;
 
 static void print_fatal_signal(struct pt_regs *regs, int signr)
 {
-	printk("%s/%d: potentially unexpected fatal signal %d.\n",
+	if (unlikely(!printk_ratelimit()))
+		return;
+
+	printk(KERN_WARNING "%s/%d: potentially unexpected fatal signal %d.\n",
 		current->comm, current->pid, signr);
 
 #ifdef __i386__
_

Patches currently in -mm which might be from righiandr@users.sourceforge.net are

avr32-ratelimit-segfault-reporting-rate.patch
bug-in-i386-mtrr-initialization.patch
x86_64-ratelimit-segfault-reporting-rate.patch
vdso-print-fatal-signals-fix.patch

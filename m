From: akpm@linux-foundation.org
Subject: + vdso-print-fatal-signals-fix.patch added to -mm tree
Date: Sun, 20 May 2007 20:30:26 -0700
Message-ID: <200705210330.l4L3UPFg001574@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60103 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752864AbXEUDcW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 20 May 2007 23:32:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: righiandr@users.sourceforge.net, a.righi@cineca.it


The patch titled
     limit print_fatal_signal() rate
has been added to the -mm tree.  Its filename is
     vdso-print-fatal-signals-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

vdso-print-fatal-signals-fix.patch

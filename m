From: akpm@osdl.org
Subject: + minor-patch-for-compilation-warning-in-x86_64-signal-code.patch added to -mm tree
Date: Wed, 24 Jan 2007 23:39:55 -0800
Message-ID: <200701250739.l0P7dt3M009356@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52271 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965676AbXAYHkH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 02:40:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnpol@2ka.mipt.ru, ak@suse.de


The patch titled
     Minor patch for compilation warning in x86_64 signal code
has been added to the -mm tree.  Its filename is
     minor-patch-for-compilation-warning-in-x86_64-signal-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Minor patch for compilation warning in x86_64 signal code
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

If DEBUG_SIG is enbaled in source code, ia32_signal.c compiles with warning
due to wrong format string.  Attached patch fixes that.  It is quite minor
update, since by default DEBUG_SIG is not enabled and can not be turned on
without code modification.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/ia32/ia32_signal.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86_64/ia32/ia32_signal.c~minor-patch-for-compilation-warning-in-x86_64-signal-code arch/x86_64/ia32/ia32_signal.c
--- a/arch/x86_64/ia32/ia32_signal.c~minor-patch-for-compilation-warning-in-x86_64-signal-code
+++ a/arch/x86_64/ia32/ia32_signal.c
@@ -495,7 +495,7 @@ int ia32_setup_frame(int sig, struct k_s
 		ptrace_notify(SIGTRAP);
 
 #if DEBUG_SIG
-	printk("SIG deliver (%s:%d): sp=%p pc=%p ra=%p\n",
+	printk("SIG deliver (%s:%d): sp=%p pc=%lx ra=%u\n",
 		current->comm, current->pid, frame, regs->rip, frame->pretcode);
 #endif
 
@@ -601,7 +601,7 @@ int ia32_setup_rt_frame(int sig, struct 
 		ptrace_notify(SIGTRAP);
 
 #if DEBUG_SIG
-	printk("SIG deliver (%s:%d): sp=%p pc=%p ra=%p\n",
+	printk("SIG deliver (%s:%d): sp=%p pc=%lx ra=%u\n",
 		current->comm, current->pid, frame, regs->rip, frame->pretcode);
 #endif
 
_

Patches currently in -mm which might be from johnpol@2ka.mipt.ru are

minor-patch-for-compilation-warning-in-x86_64-signal-code.patch

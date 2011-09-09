From: akpm@linux-foundation.org
Subject: + arch-x86-kernel-ptracec-quiet-sparse-noise.patch added to -mm tree
Date: Fri, 09 Sep 2011 15:20:19 -0700
Message-ID: <201109092220.p89MKJnH010109@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36804 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759017Ab1IIWUU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2011 18:20:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, hsweeten@visionengravers.com


The patch titled
     arch/x86/kernel/ptrace.c: quiet sparse noise
has been added to the -mm tree.  Its filename is
     arch-x86-kernel-ptracec-quiet-sparse-noise.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/x86/kernel/ptrace.c: quiet sparse noise
From: H Hartley Sweeten <hartleys@visionengravers.com>

ptrace_set_debugreg() is only used in this file and should be static. 
This quiets the following sparse warning:

warning: symbol 'ptrace_set_debugreg' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/ptrace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/x86/kernel/ptrace.c~arch-x86-kernel-ptracec-quiet-sparse-noise arch/x86/kernel/ptrace.c
--- a/arch/x86/kernel/ptrace.c~arch-x86-kernel-ptracec-quiet-sparse-noise
+++ a/arch/x86/kernel/ptrace.c
@@ -749,7 +749,8 @@ put:
 /*
  * Handle PTRACE_POKEUSR calls for the debug register area.
  */
-int ptrace_set_debugreg(struct task_struct *tsk, int n, unsigned long val)
+static int ptrace_set_debugreg(struct task_struct *tsk, int n,
+			       unsigned long val)
 {
 	struct thread_struct *thread = &(tsk->thread);
 	int rc = 0;
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

arch-x86-kernel-e820c-quiet-sparse-noise-about-plain-integer-as-null-pointer.patch
arch-x86-kernel-ptracec-quiet-sparse-noise.patch
lib-bitmapc-quiet-sparse-noise-about-address-space.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
vt-suspend-cleanup-if-defined-uglyness-and-fix-compile-error.patch


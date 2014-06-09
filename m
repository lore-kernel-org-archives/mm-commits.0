From: akpm@linux-foundation.org
Subject: [merged] signals-kill-sigfindinword.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:33:37 -0700
Message-ID: <53960c11.4FnMJUIAts6FdMfW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53989 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaFITdi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:33:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk, tj@kernel.org, rostedt@goodmis.org, richard@nod.at, peterz@infradead.org, mingo@kernel.org, mathieu.desnoyers@efficios.com, geert@linux-m68k.org, fweisbec@gmail.com, dwmw2@infradead.org, oleg@redhat.com

Subject: [merged] signals-kill-sigfindinword.patch removed from -mm tree
To: oleg@redhat.com,dwmw2@infradead.org,fweisbec@gmail.com,geert@linux-m68k.org,mathieu.desnoyers@efficios.com,mingo@kernel.org,peterz@infradead.org,richard@nod.at,rostedt@goodmis.org,tj@kernel.org,viro@ZenIV.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:33:37 -0700


The patch titled
     Subject: signals: kill sigfindinword()
has been removed from the -mm tree.  Its filename was
     signals-kill-sigfindinword.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: signals: kill sigfindinword()

It has no users and it doesn't look useful.  I do not know why/when it was
introduced, I can't even find any user in the git history.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/signal.h |    9 ---------
 arch/x86/include/asm/signal.h  |    6 ------
 include/linux/signal.h         |    5 -----
 3 files changed, 20 deletions(-)

diff -puN arch/m68k/include/asm/signal.h~signals-kill-sigfindinword arch/m68k/include/asm/signal.h
--- a/arch/m68k/include/asm/signal.h~signals-kill-sigfindinword
+++ a/arch/m68k/include/asm/signal.h
@@ -60,15 +60,6 @@ static inline int __gen_sigismember(sigs
 	 __const_sigismember(set,sig) :		\
 	 __gen_sigismember(set,sig))
 
-static inline int sigfindinword(unsigned long word)
-{
-	asm ("bfffo %1{#0,#0},%0"
-		: "=d" (word)
-		: "d" (word & -word)
-		: "cc");
-	return word ^ 31;
-}
-
 #endif /* !CONFIG_CPU_HAS_NO_BITFIELDS */
 
 #ifndef __uClinux__
diff -puN arch/x86/include/asm/signal.h~signals-kill-sigfindinword arch/x86/include/asm/signal.h
--- a/arch/x86/include/asm/signal.h~signals-kill-sigfindinword
+++ a/arch/x86/include/asm/signal.h
@@ -92,12 +92,6 @@ static inline int __gen_sigismember(sigs
 	 ? __const_sigismember((set), (sig))	\
 	 : __gen_sigismember((set), (sig)))
 
-static inline int sigfindinword(unsigned long word)
-{
-	asm("bsfl %1,%0" : "=r"(word) : "rm"(word) : "cc");
-	return word;
-}
-
 struct pt_regs;
 
 #else /* __i386__ */
diff -puN include/linux/signal.h~signals-kill-sigfindinword include/linux/signal.h
--- a/include/linux/signal.h~signals-kill-sigfindinword
+++ a/include/linux/signal.h
@@ -63,11 +63,6 @@ static inline int sigismember(sigset_t *
 		return 1 & (set->sig[sig / _NSIG_BPW] >> (sig % _NSIG_BPW));
 }
 
-static inline int sigfindinword(unsigned long word)
-{
-	return ffz(~word);
-}

From: akpm@linux-foundation.org
Subject: + ptrace-unify-show_regs-prototype-fix.patch added to -mm tree
Date: Tue, 07 Jun 2011 13:34:15 -0700
Message-ID: <201106072034.p57KYFCL025347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756564Ab1FGUet (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2011 16:34:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, tj@kernel.org, vapier@gentoo.org


The patch titled
     ptrace-unify-show_regs-prototype-fix
has been added to the -mm tree.  Its filename is
     ptrace-unify-show_regs-prototype-fix.patch

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
Subject: ptrace-unify-show_regs-prototype-fix
From: Oleg Nesterov <oleg@redhat.com>

No need to declare show_regs() in ptrace.h, sched.h does this.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ptrace.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/ptrace.h~ptrace-unify-show_regs-prototype-fix include/linux/ptrace.h
--- a/include/linux/ptrace.h~ptrace-unify-show_regs-prototype-fix
+++ a/include/linux/ptrace.h
@@ -100,7 +100,6 @@
 #include <linux/sched.h>		/* For struct task_struct.  */
 
 
-extern void show_regs(struct pt_regs *);
 extern long arch_ptrace(struct task_struct *child, long request,
 			unsigned long addr, unsigned long data);
 extern int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len);
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
ptrace-unify-show_regs-prototype.patch
ptrace-unify-show_regs-prototype-fix.patch


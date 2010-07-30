From: akpm@linux-foundation.org
Subject: + arch-um-kernel-ptracec-remove-dead-proc_mm.patch added to -mm tree
Date: Fri, 30 Jul 2010 14:06:37 -0700
Message-ID: <201007302106.o6UL6bUh032708@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752211Ab0G3VHR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jul 2010 17:07:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: siccegge@cs.fau.de, jdike@addtoit.com


The patch titled
     arch/um/kernel/ptrace.c: remove dead PROC_MM
has been added to the -mm tree.  Its filename is
     arch-um-kernel-ptracec-remove-dead-proc_mm.patch

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
Subject: arch/um/kernel/ptrace.c: remove dead PROC_MM
From: Christoph Egger <siccegge@cs.fau.de>

PROC_MM doesn't exist in Kconfig.  Looking around it looks like a
left-over from 2.6.0 or even 2.4 times, last mentioned in a fedora patch
for 2.6.10.  I believe it's time to get rid of that last tiny parts here
that are still around.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/ptrace.c |   21 ---------------------
 1 file changed, 21 deletions(-)

diff -puN arch/um/kernel/ptrace.c~arch-um-kernel-ptracec-remove-dead-proc_mm arch/um/kernel/ptrace.c
--- a/arch/um/kernel/ptrace.c~arch-um-kernel-ptracec-remove-dead-proc_mm
+++ a/arch/um/kernel/ptrace.c
@@ -7,9 +7,6 @@
 #include "linux/ptrace.h"
 #include "linux/sched.h"
 #include "asm/uaccess.h"
-#ifdef CONFIG_PROC_MM
-#include "proc_mm.h"
-#endif
 #include "skas_ptrace.h"
 
 
@@ -158,24 +155,6 @@ long arch_ptrace(struct task_struct *chi
 		break;
 	}
 #endif
-#ifdef CONFIG_PROC_MM
-	case PTRACE_SWITCH_MM: {
-		struct mm_struct *old = child->mm;
-		struct mm_struct *new = proc_mm_get_mm(data);
-
-		if (IS_ERR(new)) {
-			ret = PTR_ERR(new);
-			break;
-		}

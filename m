From: akpm@linux-foundation.org
Subject: + frv-delete-incorrect-task-prototypes-causing-compile-fail.patch added to -mm tree
Date: Thu, 17 May 2012 16:12:48 -0700
Message-ID: <20120517231248.AF6D3A02FF@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:50467 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759182Ab2EQXMv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2012 19:12:51 -0400
Received: by lagr15 with SMTP id r15so119850lag.1
        for <mm-commits@vger.kernel.org>; Thu, 17 May 2012 16:12:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paul.gortmaker@windriver.com, dhowells@redhat.com, tglx@linutronix.de


The patch titled
     Subject: frv: delete incorrect task prototypes causing compile fail
has been added to the -mm tree.  Its filename is
     frv-delete-incorrect-task-prototypes-causing-compile-fail.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: frv: delete incorrect task prototypes causing compile fail

Commit 41101809 ("fork: Provide weak
arch_release_[task_struct|thread_info] functions") highlights a problem in
the frv arch, where it has needles prototypes for alloc_task_struct_node
and free_task_struct.  This now shows up as:

kernel/fork.c:120:66: error: static declaration of 'alloc_task_struct_node' follows non-static declaration
kernel/fork.c:127:51: error: static declaration of 'free_task_struct' follows non-static declaration

since 41101809 turned them into real functions.  Since arch/frv does does
not define define __HAVE_ARCH_TASK_STRUCT_ALLOCATOR (i.e.  it just uses
the generic ones) it shouldn't list these at all.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/include/asm/processor.h |    4 ----
 1 file changed, 4 deletions(-)

diff -puN arch/frv/include/asm/processor.h~frv-delete-incorrect-task-prototypes-causing-compile-fail arch/frv/include/asm/processor.h
--- a/arch/frv/include/asm/processor.h~frv-delete-incorrect-task-prototypes-causing-compile-fail
+++ a/arch/frv/include/asm/processor.h
@@ -135,10 +135,6 @@ unsigned long get_wchan(struct task_stru
 #define	KSTK_EIP(tsk)	((tsk)->thread.frame0->pc)
 #define	KSTK_ESP(tsk)	((tsk)->thread.frame0->sp)
 
-/* Allocation and freeing of basic task resources. */
-extern struct task_struct *alloc_task_struct_node(int node);
-extern void free_task_struct(struct task_struct *p);

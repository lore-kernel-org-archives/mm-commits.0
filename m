From: akpm@linux-foundation.org
Subject: [merged] frv-delete-incorrect-task-prototypes-causing-compile-fail.patch removed from -mm tree
Date: Wed, 23 May 2012 12:51:11 -0700
Message-ID: <20120523195111.6EE70A0210@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:40430 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932897Ab2EWTvM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 May 2012 15:51:12 -0400
Received: by vcbfl13 with SMTP id fl13so225926vcb.1
        for <mm-commits@vger.kernel.org>; Wed, 23 May 2012 12:51:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paul.gortmaker@windriver.com, dhowells@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: frv: delete incorrect task prototypes causing compile fail
has been removed from the -mm tree.  Its filename was
     frv-delete-incorrect-task-prototypes-causing-compile-fail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

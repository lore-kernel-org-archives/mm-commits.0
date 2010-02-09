From: akpm@linux-foundation.org
Subject: + fs-execc-restrict-initial-stack-space-expansion-to-rlimit.patch added to -mm tree
Date: Tue, 09 Feb 2010 13:21:48 -0800
Message-ID: <201002092121.o19LLmE9002521@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46351 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751169Ab0BIVXZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Feb 2010 16:23:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mikey@neuling.org, anton@samba.org, benh@kernel.crashing.org, jmorris@namei.org, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, oleg@redhat.com, serue@us.ibm.com, stable@kernel.org, xiyou.wangcong@gmail.com


The patch titled
     fs/exec.c: restrict initial stack space expansion to rlimit
has been added to the -mm tree.  Its filename is
     fs-execc-restrict-initial-stack-space-expansion-to-rlimit.patch

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
Subject: fs/exec.c: restrict initial stack space expansion to rlimit
From: Michael Neuling <mikey@neuling.org>

When reserving stack space for a new process, make sure we're not
attempting to expand the stack by more than rlimit allows.

This fixes a bug caused by b6a2fea39318e43fee84fa7b0b90d68bed92d2ba ("mm:
variable length argument support") and unmasked by
fc63cf237078c86214abcb2ee9926d8ad289da9b ("exec: setup_arg_pages() fails
to return errors").

This bug means that when limiting the stack to less the 20*PAGE_SIZE (eg. 
80K on 4K pages or 'ulimit -s 79') all processes will be killed before
they start.  This is particularly bad with 64K pages, where a ulimit below
1280K will kill every process.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Americo Wang <xiyou.wangcong@gmail.com>
Cc: Anton Blanchard <anton@samba.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff -puN fs/exec.c~fs-execc-restrict-initial-stack-space-expansion-to-rlimit fs/exec.c
--- a/fs/exec.c~fs-execc-restrict-initial-stack-space-expansion-to-rlimit
+++ a/fs/exec.c
@@ -555,6 +555,7 @@ static int shift_arg_pages(struct vm_are
 }
 
 #define EXTRA_STACK_VM_PAGES	20	/* random */
+#define ALIGN_DOWN(addr,size)	((addr)&(~((size)-1)))
 
 /*
  * Finalizes the stack vm_area_struct. The flags and permissions are updated,
@@ -570,7 +571,7 @@ int setup_arg_pages(struct linux_binprm 
 	struct vm_area_struct *vma = bprm->vma;
 	struct vm_area_struct *prev = NULL;
 	unsigned long vm_flags;
-	unsigned long stack_base;
+	unsigned long stack_base, stack_expand, stack_expand_lim, stack_size;
 
 #ifdef CONFIG_STACK_GROWSUP
 	/* Limit stack size to 1GB */
@@ -627,10 +628,24 @@ int setup_arg_pages(struct linux_binprm 
 			goto out_unlock;
 	}
 
+	stack_expand = EXTRA_STACK_VM_PAGES * PAGE_SIZE;
+	stack_size = vma->vm_end - vma->vm_start;
+	if (rlimit(RLIMIT_STACK) < stack_size)
+		stack_expand_lim = 0; /* don't shrick the stack */
+	else
+		/*
+		 * Align this down to a page boundary as expand_stack
+		 * will align it up.
+		 */
+		stack_expand_lim = ALIGN_DOWN(rlimit(RLIMIT_STACK) - stack_size,
+					      PAGE_SIZE);
+	/* Initial stack must not cause stack overflow. */
+	if (stack_expand > stack_expand_lim)
+		stack_expand = stack_expand_lim;
 #ifdef CONFIG_STACK_GROWSUP
-	stack_base = vma->vm_end + EXTRA_STACK_VM_PAGES * PAGE_SIZE;
+	stack_base = vma->vm_end + stack_expand;
 #else
-	stack_base = vma->vm_start - EXTRA_STACK_VM_PAGES * PAGE_SIZE;
+	stack_base = vma->vm_start - stack_expand;
 #endif
 	ret = expand_stack(vma, stack_base);
 	if (ret)
_

Patches currently in -mm which might be from mikey@neuling.org are

linux-next.patch
fs-execc-restrict-initial-stack-space-expansion-to-rlimit.patch


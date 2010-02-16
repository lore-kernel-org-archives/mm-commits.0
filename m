From: akpm@linux-foundation.org
Subject: + exec-fs-fix-initial-stack-reservation.patch added to -mm tree
Date: Tue, 16 Feb 2010 14:28:49 -0800
Message-ID: <201002162228.o1GMSnVQ008829@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933126Ab0BPWaP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Feb 2010 17:30:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mikey@neuling.org, anton@samba.org, benh@kernel.crashing.org, j@w1.fi, jmorris@namei.org, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, serue@us.ibm.com, stable@kernel.org, xiyou.wangcong@gmail.com


The patch titled
     fs/exec.c: fix initial stack reservation
has been added to the -mm tree.  Its filename is
     exec-fs-fix-initial-stack-reservation.patch

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
Subject: fs/exec.c: fix initial stack reservation
From: Michael Neuling <mikey@neuling.org>

803bf5ec259941936262d10ecc84511b76a20921 ("fs/exec.c: restrict initial
stack space expansion to rlimit") attempts to limit the initial stack to
20*PAGE_SIZE.  Unfortunately, in attempting ensure the stack is not
reduced in size, we ended up not changing the stack at all.

This size reduction check is not necessary as the expand_stack call does
this already.

This caused a regression in UML resulting in most guest processes being
killed.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Anton Blanchard <anton@samba.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jouni Malinen <j@w1.fi>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/exec.c~exec-fs-fix-initial-stack-reservation fs/exec.c
--- a/fs/exec.c~exec-fs-fix-initial-stack-reservation
+++ a/fs/exec.c
@@ -637,7 +637,6 @@ int setup_arg_pages(struct linux_binprm 
 	 * will align it up.
 	 */
 	rlim_stack = rlimit(RLIMIT_STACK) & PAGE_MASK;
-	rlim_stack = min(rlim_stack, stack_size);
 #ifdef CONFIG_STACK_GROWSUP
 	if (stack_size + stack_expand > rlim_stack)
 		stack_base = vma->vm_start + rlim_stack;
_

Patches currently in -mm which might be from mikey@neuling.org are

linux-next.patch
exec-fs-fix-initial-stack-reservation.patch
exec-create-initial-stack-independent-of-page_size.patch


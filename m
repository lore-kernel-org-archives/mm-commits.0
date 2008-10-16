From: akpm@linux-foundation.org
Subject: + uml-fix-a-compile-error.patch added to -mm tree
Date: Thu, 16 Oct 2008 16:16:01 -0700
Message-ID: <200810162316.m9GNG1G3004404@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35717 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757963AbYJPXQl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 19:16:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wangcong@zeuux.org, jdike@addtoit.com, stable@kernel.org


The patch titled
     uml: fix a compile error
has been added to the -mm tree.  Its filename is
     uml-fix-a-compile-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: fix a compile error
From: WANG Cong <wangcong@zeuux.org>

Fix

arch/um/sys-i386/signal.c: In function 'copy_sc_from_user':
arch/um/sys-i386/signal.c:182: warning: dereferencing 'void *' pointer
arch/um/sys-i386/signal.c:182: error: request for member '_fxsr_env' in something not a structure or union

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/sys-i386/signal.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/um/sys-i386/signal.c~uml-fix-a-compile-error arch/um/sys-i386/signal.c
--- a/arch/um/sys-i386/signal.c~uml-fix-a-compile-error
+++ a/arch/um/sys-i386/signal.c
@@ -179,7 +179,8 @@ static int copy_sc_from_user(struct pt_r
 	if (have_fpx_regs) {
 		struct user_fxsr_struct fpx;
 
-		err = copy_from_user(&fpx, &sc.fpstate->_fxsr_env[0],
+		err = copy_from_user(&fpx,
+			&((struct _fpstate __user *)sc.fpstate)->_fxsr_env[0],
 				     sizeof(struct user_fxsr_struct));
 		if (err)
 			return 1;
_

Patches currently in -mm which might be from wangcong@zeuux.org are

kernel-kallsymsc-fix-double-return.patch
uml-fix-a-compile-error.patch

